Scriptname SNBaka_CumDetectionModule
; REV-96 Task 2: cum-detection module (recordless detection class -- module contract
; point 3, fomod.md section architecture). Extracted BEHAVIOR-PRESERVING from the
; REV-63/65 detection-triggers section of SkyrimNet_BakaIntegration.psc (the §64
; class: every handler signature and sentinel moved verbatim; only the call shape
; changed -- the motherboard's ModEvent handlers forward here, because ModEvents are
; Form-members and a recordless script can never receive a ModEvent dispatch).
; NO foreign types beyond what the moved code already used: SkyrimNet_BakaSL (our own
; SexLab bridge, compile-stubbed in tools\compile\local) and SkyrimNetApi.
;
; REV-117 CUM-V2 STATE LAYER (REV-115 Task 3, unblocked by the §127 re-dogfood):
; DeDService.* state-family writes ride EVERY cum application signal, gated on
; DeD_ServicePresent() (SKSE.GetPluginVersion probe; the wiring is inert without the
; DLL -- no error, no orphan writes, v1 behavior exactly). State family (module
; "cum", keys per service-dll.md §5):
;   cum.present          Bool, actor-keyed     -- TRUE while a cum effect persists
;   cum.last_location    String, actor-keyed   -- location literal (OCum Area domain
;                                                 or SL FX domain mouth/vagina/rectum)
;   cum.last_source      String, actor-keyed   -- "ocum" | "sexlab_pplus" | "sexlab_vanilla" | "sl_proxy"
;   cum.last_applied_rt  Float, actor-keyed    -- Utility.GetCurrentRealTime() at write
; Ambient timer rule (module "cum", rule "ambient"): cadence 120s, predicate class 1
; (STATE_BOOL_TRUE) on cum.present, failsafe 600s, callback "sdb_cum_ambient_due".
; Timer events arrive as the standard 4-slot ModEvent shape (EventPump.cpp):
; (eventName, strArg, numArg, sender) -- numArg 1 = expired (failsafe), 0 = due tick.
; VERBATIM-NARRATION GUARDRAIL (REV-117, in every touched cue): event text is written
; for the LLM to narrate VERBATIM -- never summarize, never paraphrase, never fold
; into other narration; the event text IS the narration.
;
; State: NONE of its own. All toggles (bEnabled, bCumDetectionEnabled, bSLProxyEnabled,
; iCumCueMode) remain the MOTHERBOARD'S Auto properties (the MCM reads them as
; Main.* -- moving them would be a structural MCM change, explicitly out of scope);
; they are read through the akHost parameter. The shared 15s cum-cue cooldown key
; (SNBaka.LastCumCueRT, None-keyed) is unchanged -- same key, same window, so the
; cooldown still spans the OCum events AND the SL proxy exactly as before.
;
; Logging: every sentinel goes through akHost._Log() -- identical strings, identical
; bDebugLog gating (sentinel parity per §67; the [SNBaka] tag is preserved verbatim
; so existing log greps keep working).

; ---- Presence probe (cached: GetFormFromFile on an ABSENT esp logs a hard Papyrus
; error, not a silent None -- the SNBakaSL.Absent-cache lesson). Absence is cached
; on the None key once. MOVED VERBATIM from the motherboard's _OCumInstalled. ----
Bool Function Installed() Global
    If StorageUtil.GetIntValue(None, "SNBaka.OCumAbsent", 0) == 1
        Return False
    EndIf
    If Game.GetFormFromFile(0x000800, "OCum.esp") != None
        Return True
    EndIf
    StorageUtil.SetIntValue(None, "SNBaka.OCumAbsent", 1)
    Return False
EndFunction

; ---- REV-117: DeDService presence probe + cum.* state family ----
; DLL presence via SKSE.GetPluginVersion (SKSE.psc global native: "get a plugins
; version number, -1 if the plugin is not loaded"; in the island import set).
; REV-120 D1 FIX: the probe string is the plugin's DECLARED name -- "DeDService"
; (SKSEPluginDeclaration .Name, dll-source-ded __DeDServicePlugin.cpp L6), which
; is the name SKSE itself registers and logs (skse64.log: `loading plugin
; "DeDService"` / `plugin DeDService.dll (00000001 DeDService 01000000) loaded
; correctly`). REV-118 shipped "DeDService.dll", which GetPluginVersion can never
; resolve -> the state layer stayed inert both dogfood loads (§130 D1 receipts).
; Never cached: cheap, and a mid-session DLL state change (impossible in
; practice) stays honest. Returns -1 when absent; > 0 requires a real version.
Bool Function DeD_ServicePresent() Global
    Return SKSE.GetPluginVersion("DeDService") > 0
EndFunction

; Registers the cum.* state family + the ambient timer rule (module "cum").
; Idempotent (the DLL treats re-registration as update); called from the
; motherboard's _ArmModules() so it rides every arm/re-arm pass.
Function ArmStateLayer(SkyrimNet_BakaIntegration akHost) Global
    If !DeD_ServicePresent()
        akHost._Log("[SNBaka] cum-v2 state layer: DeDService absent -- wiring inert (v1 behavior)")
        Return
    EndIf
    ; value types per DeDService.psc: 0=Int, 1=Float, 2=String, 3=Bool, 4=FormID
    DeDService.RegisterState("cum", "present", 3, True, "false")
    DeDService.RegisterState("cum", "last_location", 2, True, "")
    DeDService.RegisterState("cum", "last_source", 2, True, "")
    DeDService.RegisterState("cum", "last_applied_rt", 1, True, "0.0")
    ; ambient: cadence 120s, class-1 (STATE_BOOL_TRUE on cum.present),
    ; failsafe 600s, callback sdb_cum_ambient_due (4-slot ModEvent shape).
    DeDService.AddTimerRule("cum", "ambient", 120.0, 1, None, "cum.present", 600.0, "sdb_cum_ambient_due")
    akHost._Log("[SNBaka] cum-v2 state layer armed: cum.* registered + ambient rule (120s/class-1/600s failsafe)")
EndFunction

; Single write point for every cum application signal (OCum events, P+ listener,
; vanilla keyword reconciliation, SL proxy). asLocation "" = unknown -> state
; records the source but leaves last_location empty.
Function _WriteCumState(Actor akTarget, String asLocation, String asSource) Global
    If !akTarget || !DeD_ServicePresent()
        Return
    EndIf
    DeDService.SetStateBool(akTarget, "cum.present", True)
    DeDService.SetStateString(akTarget, "cum.last_location", asLocation)
    DeDService.SetStateString(akTarget, "cum.last_source", asSource)
    DeDService.SetStateFloat(akTarget, "cum.last_applied_rt", Utility.GetCurrentRealTime())
EndFunction

; ---- CUM DETECTION (OCum / OStim side) ----
; REV-65: handler signatures derived from the senders' ACTUAL ModEvent push
; sequences (statically re-confirmed from the installed trees, per the rev-64 root
; cause of record):
;   ocum_applied_cum (OCumMaleScript.psc L689-695, [035.00002] tree):
;     PushForm(Orgasmer), PushForm(Target), PushFloat(AmountML),
;     PushString(Area), PushString(SceneID)                 -- 5 args
;   ocum_applied_cum_npc_scene (same file, L697-704):
;     Form Orgasmer, Form Target, Int ThreadID, Float AmountML,
;     String Area, String SceneID                           -- 6 args
; The rev-63 4-slot (eventName, strArg, numArg, sender) shape was RETIRED.
; REV-65 bonus (user ruling): the TARGET (second Form push) is now recoverable --
; named-partner cue wording is PRIMARY; the rev-63 unnamed wording is the fallback
; only (Target == None guard).
; REV-96: this is the MOVED BODY of the motherboard's OnOCumApplied event (signature
; verbatim; the motherboard forwards Self + the event args).
Function HandleOCumApplied(SkyrimNet_BakaIntegration akHost, Form akOrgasmer, Form akTarget, Float afAmountML, String asArea, String asSceneID) Global
    If !akHost.bEnabled || !akHost.bCumDetectionEnabled || !Installed()
        Return
    EndIf
    Actor orgasmer = akOrgasmer as Actor
    If !orgasmer || orgasmer.IsDead()
        Return
    EndIf
    Actor target = akTarget as Actor
    ; REV-65 full-payload sentinel: reception verified at the ARGUMENT level.
    akHost._Log("[SNBaka] OnOCumApplied: orgasmer=" + orgasmer.GetDisplayName() + " target=" + (target as Form) + " amount=" + afAmountML + "ml area=" + asArea + " sceneID=" + asSceneID)
    ; REV-112: the Area string now reaches the fire path (location-variant
    ; dispatch, cum-effects v2 item 2 -- it was dropped here in v1).
    ; REV-117: state write BEFORE the cue (survives the 15s cooldown suppress).
    _WriteCumState(target, asArea, "ocum")
    _FireCumCue(akHost, orgasmer, target, asArea)
EndFunction

; REV-65: the npc_scene variant carries ThreadID as a 3rd (Int) push, so it needs its
; own 6-arg handler. Identical gating/cue logic; thread id is logged in the sentinel.
; REV-96: MOVED BODY of the motherboard's OnOCumAppliedNPCScene event.
Function HandleOCumAppliedNPCScene(SkyrimNet_BakaIntegration akHost, Form akOrgasmer, Form akTarget, Int aiThreadID, Float afAmountML, String asArea, String asSceneID) Global
    If !akHost.bEnabled || !akHost.bCumDetectionEnabled || !Installed()
        Return
    EndIf
    Actor orgasmer = akOrgasmer as Actor
    If !orgasmer || orgasmer.IsDead()
        Return
    EndIf
    Actor target = akTarget as Actor
    akHost._Log("[SNBaka] OnOCumApplied [npc-scene]: orgasmer=" + orgasmer.GetDisplayName() + " target=" + (target as Form) + " thread=" + aiThreadID + " amount=" + afAmountML + "ml area=" + asArea + " sceneID=" + asSceneID)
    ; REV-112: Area reaches the fire path here too (location-variant dispatch).
    ; REV-117: state write before the cue (same as the 5-arg handler).
    _WriteCumState(target, asArea, "ocum")
    _FireCumCue(akHost, orgasmer, target, asArea)
EndFunction

; REV-112: location-variant dispatch (cum-effects v2 item 2, in-script Area
; dispatch per the REV-110 scout shape). One phrase per OCum Area literal --
; the OCumMaleScript.psc ApplyCum dispatch class (L323-343, [035.00002]):
; 11 literals (belly/butt/chest/face/feet/hands/mouth/rectum/thighs/throat/
; vagina). REV-118: phrases are the USER-EDITED WORDING OF RECORD (register
; entry 18 CLOSED at REV-118 -- user edits applied verbatim in the fork
; register copy, provenance: fork docs/pending-approvals.md L442-453,
; 2026-10-16 15:52).
; Returns "" for unknown/empty Area -> the caller falls back to the v1 wording.
; SL LEG LIMIT (stated): the StageEnd proxy has no Area signal and passes ""
; -- location-agnostic until the v2 state layer exists.
String Function _LocationPhrase(String asArea) Global
    If asArea == "belly"
        Return "the cum splatters across their belly in thick ropes"
    ElseIf asArea == "butt"
        Return "the cum pumps across their backside, basting them with thick globules"
    ElseIf asArea == "chest"
        Return "the cum pumps across their chest, trickling sluggishly down their breasts"
    ElseIf asArea == "face"
        Return "the cum sprays across their face in thick ropes"
    ElseIf asArea == "feet"
        Return "the cum gushes over their feet"
    ElseIf asArea == "hands"
        Return "the cum pumps out all over their hands"
    ElseIf asArea == "mouth"
        Return "their mouth floods with jets of hot cum"
    ElseIf asArea == "rectum"
        Return "load after load of cum pumps deep into their ass"
    ElseIf asArea == "thighs"
        Return "the mess settling across their thighs"
    ElseIf asArea == "throat"
        Return "gouts of hot cum pump deep into their throat"
    ElseIf asArea == "vagina"
        Return "hot, thick cum is pumped deep into their pussy"
    EndIf
    Return ""
EndFunction

; REV-65: shared outbound leg for both OCum events (was inline in the rev-63 handler).
; Shared 15s cum-cue cooldown (with the SL proxy) -- HJ/FJ scenes loop over multiple
; givers and multi-fire; one narrator cue per 15s. Cooldown behavior is IDENTICAL to
; rev-63 (same key, same window, same write point) -- only the call shape changed.
; REV-96: MOVED VERBATIM from the motherboard's _FireCumCue.
; REV-112: asArea param added (location-variant wording; "" = fallback). The
; v1 dedupe/cooldown is UNTOUCHED; unknown areas and the no-target legs keep
; the v1 wording verbatim.
Function _FireCumCue(SkyrimNet_BakaIntegration akHost, Actor orgasmer, Actor target, String asArea = "") Global
    ; REV-118 SOURCE-VALIDATION (register entry 19 note of record, user-edited:
    ; the location wordings "only make sense for male or futa characters
    ; cumming with/in/on a partner"). Interim actor-model rule: the SOURCE of a
    ; cum cue must be male (_SexOf==0, the repo's leveled-safe ActorBase ->
    ; GetSex precedent, motherboard L727). FUTA HONESTY (v1 limit): SexLab's
    ; futa signal (_sex==4) lives inside SL's internal gender model and is not
    ; recoverable from a plain ActorBase GetSex() here; OCum/P+ female sources
    ; are skipped. Futa handling = polish note (cum-effects.md REV-118).
    ; The cue is NOT fired as-worded on an invalid source; the state write has
    ; ALREADY happened in the caller (the world happened even if the wording
    ; does not fit).
    If !orgasmer || SkyrimNet_BakaIntegration._SexOf(orgasmer) != 0
        akHost._Log("[SNBaka] _FireCumCue: source-invalid (female non-futa), cue skipped (REV-118)")
        Return
    EndIf
    Float nowRT = Utility.GetCurrentRealTime()
    If nowRT - StorageUtil.GetFloatValue(None, "SNBaka.LastCumCueRT", -999.0) < 15.0
        akHost._Log("[SNBaka] _FireCumCue: cue suppressed (shared 15s cum-cue cooldown)")
        Return
    EndIf
    StorageUtil.SetFloatValue(None, "SNBaka.LastCumCueRT", nowRT)
    String locPhrase = _LocationPhrase(asArea)
    If locPhrase
        akHost._Log("[SNBaka] _FireCumCue: location variant area=" + asArea)
    EndIf
    String desc
    If akHost.iCumCueMode == 1
        ; per-source (OStim/OCum) wording -- DRAFT, §7 approval pending
        If target
            If locPhrase
                ; REV-112 location variant -- DRAFT, §7 register 18, ruling pending
                desc = orgasmer.GetDisplayName() + " just came; OCum applies the result to " + target.GetDisplayName() + ", " + locPhrase + "."
            Else
                desc = orgasmer.GetDisplayName() + " just came inside " + target.GetDisplayName() + "; OCum applies the result."
            EndIf
        Else
            desc = orgasmer.GetDisplayName() + " just came inside an OStim scene; OCum applies the result."
        EndIf
    Else
        ; unified (framework-neutral) wording -- DRAFT, §7 approval pending
        If target
            If locPhrase
                ; REV-112 location variant -- DRAFT, §7 register 18, ruling pending
                desc = orgasmer.GetDisplayName() + " just came, finishing all over " + target.GetDisplayName() + ", " + locPhrase + "."
            Else
                desc = orgasmer.GetDisplayName() + " just came, finishing all over " + target.GetDisplayName() + "."
            EndIf
        Else
            desc = orgasmer.GetDisplayName() + " just came, finishing all over their partner."
        EndIf
    EndIf
    SkyrimNetApi.RegisterEvent("sdb_cum_applied", desc, orgasmer, target)
EndFunction

; ---- SEXLAB ORGASM-HOOK PROXY (amendment 2a-ii; verdict of record: PROXY) ----
; SexLab has NO dedicated cum-state API (no event/faction/spell surface; its cum
; overlays are mesh/particle only). sslThreadModel.SendThreadEvent broadcasts
; "Hook<Name>" ModEvents carrying (thread_id, HasPlayer) for the stage/animation
; lifecycle; StageEnd covers stage completions including the orgasm stage. Evidence
; supports the PROXY case: the cue rides "a SexLab scene reached release" and NEVER
; claims overlay application. numArg = thread_id (first numeric push).
; REV-65: signature derived from the sender's ACTUAL pushes (sslThreadModel
; PPLUS V2.18.1, SetupThreadEvent: PushInt(thread_id), PushBool(HasPlayer) -- 2 args).
; REV-96: MOVED BODY of the motherboard's OnSLStageEnd event.
Function HandleSLStageEnd(SkyrimNet_BakaIntegration akHost, Int aiThreadID, Bool abHasPlayer) Global
    ; REV-116 instrumentation (report-only; PROJECT_STATE 125 open item):
    ; entry receipt BEFORE the gate chain + a named per-gate trace, so
    ; "HookStageEnd never delivered" is distinguishable from "delivered but
    ; gated off" and from "gated off by WHICH gate". Log-only; zero behavior
    ; change -- any behavior fix this evidence motivates is REPORTED, not
    ; shipped (session STOP rule).
    akHost._Log("[SNBaka] OnSLStageEnd: event RECEIVED thread=" + aiThreadID + " hasPlayer=" + abHasPlayer + " (REV-116 instrument)")
    If !akHost.bEnabled
        akHost._Log("[SNBaka] OnSLStageEnd: returned at gate -- bEnabled=false (REV-116 instrument)")
        Return
    EndIf
    If !akHost.bCumDetectionEnabled
        akHost._Log("[SNBaka] OnSLStageEnd: returned at gate -- bCumDetectionEnabled=false (REV-116 instrument)")
        Return
    EndIf
    If !akHost.bSLProxyEnabled
        akHost._Log("[SNBaka] OnSLStageEnd: returned at gate -- bSLProxyEnabled=false (REV-116 instrument)")
        Return
    EndIf
    If !SkyrimNet_BakaSL.Installed()
        akHost._Log("[SNBaka] OnSLStageEnd: returned at gate -- BakaSL.Installed()=false (REV-116 instrument)")
        Return
    EndIf
    Int threadID = aiThreadID
    If threadID < 0
        akHost._Log("[SNBaka] OnSLStageEnd: returned -- threadID=" + threadID + " negative (REV-116 instrument)")
        Return
    EndIf
    Actor[] positions = SkyrimNet_BakaSL.SLThreadPositions(threadID)
    If !positions || positions.Length == 0
        akHost._Log("[SNBaka] OnSLStageEnd: thread=" + threadID + " hasPlayer=" + abHasPlayer + " -- no positions resolved, skipping")
        Return
    EndIf
    Actor lead = positions[0]
    ; REV-117 cum-v2 PROXY DEMOTION (v2-map of record, cum-effects.md REV-114):
    ; before the fallback wording, try keyword reconciliation per-position -- the
    ; vanilla-SL location signal (AddCum combo-spell keywords readable post-hoc).
    ; First position with a location wins (V > A > O priority inside the check);
    ; a hit fires the LOCATION-variant cue + per-target state write, and the
    ; proxy wording is skipped. Reconciliation runs ONLY when the P+ listener
    ; did not already cover this orgasm (P+ fires SexLabApplyCumFX directly;
    ; on P+ the keywords are also readable, but double-cueing is avoided by the
    ; shared 15s cooldown and the direct listener's earlier write -- so the
    ; reconciliation pass runs to fill the state layer when the cue was
    ; suppressed, not to double-fire narration).
    ; REV-120 D2 FIX: the reconciliation leg's SOURCE is the thread's actual
    ; source actor, NOT the lead. REV-118 passed lead = positions[0] = the
    ; female WEARER (Hroki) while the actual source (Hadrian, P+ payload-proven)
    ; went unexamined -> every reconciled cue hit source-invalid (§130 D2
    ; receipts, 5 across both loads). Resolution path: the P+ listener carries
    ; the payload's source directly (it fires first and its state write precedes
    ; this pass); this pass resolves the source from the thread itself per the
    ; interim actor-model rule -- the first male position (_SexOf==0), else None
    ; (honest skip inside _FireCumCue: the state write above stands, the cue is
    ; simply not misattributed to the wearer).
    Actor srcActor = _ResolveThreadSource(positions)
    Int p = 0
    While p < positions.Length
        Actor pos = positions[p]
        If pos
            String kloc = _SLKeywordLocation(pos)
            If kloc
                _WriteCumState(pos, kloc, "sexlab_vanilla")
                ; cue: location-variant via the shared fire path (15s cooldown applies)
                _FireCumCue(akHost, srcActor, pos, kloc)
                akHost._Log("[SNBaka] OnSLStageEnd: thread=" + threadID + " position=" + pos.GetDisplayName() + " keyword-reconciled location=" + kloc + " (proxy wording skipped)")
                Return
            EndIf
        EndIf
        p += 1
    EndWhile
    ; REV-120 D3 FIX: the cooldown stamp is FIRE-ONLY on this path too. REV-118
    ; stamped SNBaka.LastCumCueRT BEFORE the source check, so keywordless
    ; mid-scene stage-ends ate the shared 15s window and both legitimate P+
    ; cues died on "cue suppressed" (§130 D3 receipts). Order is now:
    ; source-validation -> cooldown gate -> stamp -> fire. Suppressed/skipped
    ; stage-end passes never touch the window. (Verified same-order in
    ; _FireCumCue: both returns precede its stamp.)
    ; REV-118 source-validation (same interim actor-model rule as _FireCumCue):
    ; the proxy's lead actor is the source; female non-futa lead -> cue skipped.
    If !lead || SkyrimNet_BakaIntegration._SexOf(lead) != 0
        akHost._Log("[SNBaka] OnSLStageEnd: source-invalid (female non-futa), cue skipped (REV-118)")
        Return
    EndIf
    ; Shared 15s cum-cue cooldown (see _FireCumCue).
    Float nowRT = Utility.GetCurrentRealTime()
    If nowRT - StorageUtil.GetFloatValue(None, "SNBaka.LastCumCueRT", -999.0) < 15.0
        Return
    EndIf
    StorageUtil.SetFloatValue(None, "SNBaka.LastCumCueRT", nowRT)
    String desc
    If akHost.iCumCueMode == 1
        ; per-source (SexLab) wording -- DRAFT, §7 approval pending; proxy rule:
        ; "release" only, never overlay application.
        desc = lead.GetDisplayName() + "'s SexLab scene just reached its release."
    Else
        ; unified (framework-neutral) wording -- DRAFT, §7 approval pending
        desc = lead.GetDisplayName() + " just came, finishing all over their partner."
    EndIf
    akHost._Log("[SNBaka] OnSLStageEnd: thread=" + threadID + " lead=" + lead.GetDisplayName() + " -> sdb_cum_applied (SL proxy)")
    SkyrimNetApi.RegisterEvent("sdb_cum_applied", desc, lead, None)
EndFunction

; REV-120 D2: source resolution for the keyword-reconciliation leg (caller
; HandleSLStageEnd). Interim actor-model rule of record: the SOURCE is the
; first male position in the thread (_SexOf==0, the motherboard L727 leveled-
; safe ActorBase -> GetSex precedent). No male position -> None -> the cue is
; skipped honestly inside _FireCumCue (the per-target state write above the
; call still stands); the cue is never misattributed to the wearer/lead.
Actor Function _ResolveThreadSource(Actor[] akPositions) Global
    Int i = 0
    While i < akPositions.Length
        Actor a = akPositions[i]
        If a && SkyrimNet_BakaIntegration._SexOf(a) == 0
            Return a
        EndIf
        i += 1
    EndWhile
    Return None
EndFunction

; ---- REV-117: SL-SIDE LOCATION SIGNALS (cum-v2 wiring, REV-114 v2-map rows) ----
; Two flavors, both now location-capable (the v1 "location-agnostic SL" note is
; superseded -- REV-113b/REV-114 v2-map of record):
;   P+ (version >= 20000, BakaSL._PplusDetected==1): push-time signal -- the
;     SexLabApplyCumFX ModEvent (sslThreadModel.psc L2234-2238, PPLUS V2.18.1:
;     PushForm(TargetRef), PushForm(SourceRef), PushInt(aiType)). aiType from
;     sslActorLibrary: FX_VAGINAL=0, FX_ANAL=1, FX_ORAL=2. Vanilla 1.66b never
;     sends this event (0 ApplyCumFX hits in its tree -- listener idles there).
;   vanilla SL (base AE): KEYWORD-RECONCILIATION signal -- the AddCum combo
;     spells carry Cum{Vaginal,Oral,Anal}Keyword MagicEffect keywords on the
;     TARGET (readable post-hoc via HasMagicEffectWithKeyword), checked at cue
;     time from the stage-end proxy. Keywords resolve through SexLabFramework
;     .Config (sslSystemConfig) -- present on BOTH flavors (v166b L102-104,
;     PPLUS L2023-2033).
; The stage-end proxy DEMOTES to last-resort fallback: HandleSLStageEnd now
; tries, in order, P+/vanilla reconciliation (location-capable cue + state
; write per-position); the proxy wording fires only when reconciliation yields
; nothing (or is disabled -- bSLProxyEnabled still gates the whole SL leg).

; P+ listener: HandleSLApplyCumFX receives (TargetRef, SourceRef, aiType).
; Gated like every detection handler; idles harmlessly on vanilla SL.
Function HandleSLApplyCumFX(SkyrimNet_BakaIntegration akHost, Form akTarget, Form akSource, Int aiType) Global
    If !akHost.bEnabled || !akHost.bCumDetectionEnabled || !SkyrimNet_BakaSL.Installed()
        Return
    EndIf
    If SkyrimNet_BakaSL._PplusDetected() != 1
        Return    ; vanilla never sends it; a stray delivery on vanilla is ignored
    EndIf
    Actor target = akTarget as Actor
    Actor source = akSource as Actor
    If !target || !source
        Return
    EndIf
    String loc = ""
    If aiType == 0
        loc = "vagina"
    ElseIf aiType == 1
        loc = "rectum"
    ElseIf aiType == 2
        loc = "mouth"
    EndIf
    akHost._Log("[SNBaka] OnSLApplyCumFX [P+]: source=" + source.GetDisplayName() + " target=" + target.GetDisplayName() + " aiType=" + aiType + " -> " + loc)
    _WriteCumState(target, loc, "sexlab_pplus")
    _FireCumCue(akHost, source, target, loc)
EndFunction

; Vanilla keyword reconciliation: returns the SL FX-domain location literal for
; akTarget if a Cum keyword effect is present, "" otherwise. Priority V > A > O
; mirrors sslActorLibrary.ApplyCumFX's own dispatch priority.
String Function _SLKeywordLocation(Actor akTarget) Global
    SexLabFramework sl = SkyrimNet_BakaSL._SL()
    If !sl || !sl.Config || !akTarget
        Return ""
    EndIf
    If sl.Config.CumVaginalKeyword && akTarget.HasMagicEffectWithKeyword(sl.Config.CumVaginalKeyword)
        Return "vagina"
    EndIf
    If sl.Config.CumAnalKeyword && akTarget.HasMagicEffectWithKeyword(sl.Config.CumAnalKeyword)
        Return "rectum"
    EndIf
    If sl.Config.CumOralKeyword && akTarget.HasMagicEffectWithKeyword(sl.Config.CumOralKeyword)
        Return "mouth"
    EndIf
    Return ""
EndFunction

; Ambient timer handler: sdb_cum_ambient_due arrives as the standard 4-slot
; ModEvent shape (eventName, strArg, numArg, sender) -- numArg 1 = failsafe
; expired, 0 = due tick. Scheduler.cpp emits with sender=None (rule ticks are
; not actor-addressed), so the ambient cue is deliberately subjectless -- the
; narrator applies it to whoever the moment fits.
Function HandleCumAmbientDue(SkyrimNet_BakaIntegration akHost, Float afNumArg, Form akSender) Global
    If !akHost.bEnabled || !akHost.bCumDetectionEnabled || !DeD_ServicePresent()
        Return
    EndIf
    If afNumArg >= 1.0
        akHost._Log("[SNBaka] sdb_cum_ambient_due: failsafe-expired tick (numArg=" + afNumArg + ") -- skipped")
        Return
    EndIf
    Actor narrTarget = akSender as Actor
    String desc = "The lingering aftermath of their last encounter is impossible to ignore."    ; DRAFT, §7 approval pending
    akHost._Log("[SNBaka] sdb_cum_ambient_due: ambient cue fired (sender=" + akSender + ")")
    SkyrimNetApi.RegisterEvent("sdb_cum_ambient", desc, narrTarget, None)
EndFunction
