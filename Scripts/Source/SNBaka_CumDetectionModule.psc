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
; Ambient timer rule (module "cum", rule "ambient"): cadence 60s (REV-122: was 120s --
; the first maintenance/expiry tick must land at 60s; maintenance recast, expiry
; and the ambient cue all ride this ONE clock), predicate class 1 (STATE_BOOL_TRUE)
; on cum.present, failsafe 600s, callback "sdb_cum_ambient_due".
; Timer events arrive as the standard 4-slot ModEvent shape (EventPump.cpp):
; (eventName, strArg, numArg, sender) -- numArg 1 = expired (failsafe), 0 = due tick.
; VERBATIM-NARRATION GUARDRAIL (REV-117, in every touched cue): event text is written
; for the LLM to narrate VERBATIM -- never summarize, never paraphrase, never fold
; into other narration; the event text IS the narration.
;
;
; REV-122 CUM APPLIANCE AUTHORITY (matrix of record, cum-effects.md REV-122): WE
; apply/maintain the cum visual for the state's duration. Tier routing:
;   OCum present (OStim+OCum or SL+OCum) -> OCum DRIVE: call OCumMaleScript.
;     ApplyCum(target, target, area, 1, 1.0, "", 0) -- the GENERIC entry; the
;     location is a plain String ARGUMENT dispatched to per-area functions
;     (OCumMaleScript.psc L304-345, [035.00002] tree; ThreadID=0 = the
;     out-of-scene path). FINAL 0.b ANSWER: the visual is NOT spell-carried --
;     OCumSpell -> OCumEffect is ONLY a cleanup timer (OnEffectFinish cleans
;     out-of-scene, re-casts in-scene, OCumEffect.psc L7-13); the overlay itself
;     is applied by CumOntoArea -> ReadyOverlay (OCumMaleScript.psc L510-536),
;     so a bare Cast of their spell can NEVER produce a location-correct
;     visual. The drive point is the SCRIPT call, not the spell form. Quest
;     resolution: QUST EDIDs in OCum.esp -- "OCumQuest" carries OCumScript,
;     "OCumMaleQuest" carries OCumMaleScript (esp byte-census 2026-10-17);
;     Quest.GetQuest needs no hardcoded formIDs.
;   SL only (SLACS)  -> SexLab's own combo-spell overlays stand (sslActorLibrary
;     AddCum PPLUS L805 / ClearCum L834; persist-until-dispelled). When OCum is
;     present we REPLACE them (ClearCum first -- replace-not-stack, the
;     double-visual guard; also note SL AddCum re-called on an already-cummed
;     actor ESCALATES the texture tier 1->2, so we never re-AddCum).
;   neither         -> state-only (documented degradation).
;   SL proxy (no location) -> never claims overlay application (proxy rule of
;     record); state-only, no drive call.
; MAINTENANCE: ambient ticks are sender-None FOREVER (Scheduler.cpp L124/L149 --
; EventPump::Emit(rule.callbackEvent, nullptr, ...); rule/ambient ticks are not
; actor-addressed), so the wearer is CACHED at application: DeDService type-4
; "cum.wearer" state row (the native FormID slot) + a StorageUtil form pointer
; (None-keyed; PapyrusUtil cosave-persisted, StorageUtil.psc L80/L115) for the
; sender-None tick to find them. Lifetime N=10min (named constant, all expiry
; sites read it). Expiry (tick clock) and the 600s failsafe BOTH clear the
; visual AND the state (REV-117/120 shipped the failsafe as skip-only). Refresh:
; OCum tier recasts OCumSpell on the wearer each maintenance tick -- their own
; cleanup timer (MCM default 5min, OCumMCMScript L342) is SHORTER than our
; lifetime, and the recast resets its duration so OnEffectFinish never cleans
; before our expiry (their own in-scene re-cast pattern, OCumEffect.psc L12).
; OCum re-entry is INTENDED: our SL-leg drive calls their ApplyCum, which
; re-emits ocum_applied_cum (SendCumAppliedEvents, OCumMaleScript.psc L316) ->
; our handler re-writes state source as "ocum" (the visual IS OCum's now --
; correct tier for maintenance) and the cue double-fire is eaten by the shared
; 15s window.
; D5 STALE-STAMP CLAMP: SNBaka.LastCumCueRT is a GetCurrentRealTime float that
; PERSISTS in the cosave, and GetCurrentRealTime resets each launch -- a stamp
; from a longer-prior session reads as "future", so now - stamp < 15.0 locks
; the shared cum-cue window until the NEW session's clock passes the OLD
; session's stamp (up to hours). Same class as the rev-17 muse-stamp clamp
; (SkyrimNet_AnimationsGS.psc L1021, read-time clamp precedent). REV-122 clamps
; at every OnPlayerLoadGame (motherboard), BEFORE Setup() re-arms anything,
; plus the same-class player-keyed deadline stamps (class sweep, see
; ClampStaleRTStamps). NPC-keyed instances of the class cannot be enumerated
; at load (StorageUtil has no key walk) -- documented degradation, polish note.
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

; ---- REV-122 D5: stale cosave real-time stamp clamp (load-time) ----
; GetCurrentRealTime() resets each launch, but StorageUtil stamps persist in
; the cosave -- a stamp written late in a LONGER prior session reads as
; "future" here, and every `now - stamp < window` check locks until the new
; session's clock passes the old stamp (up to hours). Same class as the rev-17
; muse-stamp clamp (SkyrimNet_AnimationsGS.psc L108-116/L1021 -- the precedent
; clamps at read; REV-122 clamps ONCE at load, BEFORE Setup() re-arms anything,
; which covers every read in the session at a single site). Called from the
; motherboard's OnPlayerLoadGame. CLASS SWEEP (fork Sources, 2026-10-17): the
; None-keyed LastCumCueRT is clamped directly; the same-class PLAYER-keyed
; deadline stamps (SNBaka.AutoGetUpDeadlineRT / SNBaka.DefeatGraceUntilRT /
; SNBaka.LastCreatureAttemptRT / SNBaka.LastHitRT / SNAcheron.FreshDownRT /
; SNAcheron.LastDefeatedRT) are clamped on PlayerRef. NPC-keyed instances of
; the class exist (Acheron/Baka downed flows stamp akVictim/akA1/akA2) but
; StorageUtil has no key walk -- they CANNOT be enumerated at load; their
; stale reads self-heal as the new session's clock advances past the old
; stamp, and the load-time latch resets already clear the owning flows.
; Documented degradation; polish note in cum-effects.md REV-122.
Function ClampStaleRTStamps(SkyrimNet_BakaIntegration akHost) Global
    Float nowRT = Utility.GetCurrentRealTime()
    Int clamped = 0
    ; None-keyed shared cum-cue cooldown stamp (the two read sites: _FireCumCue
    ; and HandleSLStageEnd).
    Float stamp = StorageUtil.GetFloatValue(None, "SNBaka.LastCumCueRT", -999.0)
    If stamp > nowRT
        StorageUtil.SetFloatValue(None, "SNBaka.LastCumCueRT", 0.0)
        clamped += 1
        akHost._Log("[SNBaka] cum cue stamp clamped (stale cosave value): " + stamp + " > now=" + nowRT + " (REV-122 D5)")
    EndIf
    ; Player-keyed deadline stamps of the same class (sweep set; see header).
    Actor player = Game.GetPlayer()
    If player
        Int i = 0
        String[] sweep = New String[6]
        sweep[0] = "SNBaka.AutoGetUpDeadlineRT"
        sweep[1] = "SNBaka.DefeatGraceUntilRT"
        sweep[2] = "SNBaka.LastCreatureAttemptRT"
        sweep[3] = "SNBaka.LastHitRT"
        sweep[4] = "SNAcheron.FreshDownRT"
        sweep[5] = "SNAcheron.LastDefeatedRT"
        While i < sweep.Length
            Float pStamp = StorageUtil.GetFloatValue(player, sweep[i], -999.0)
            If pStamp > nowRT
                StorageUtil.SetFloatValue(player, sweep[i], 0.0)
                clamped += 1
                akHost._Log("[SNBaka] stale cosave stamp clamped (stale cosave value): key=" + sweep[i] + " " + pStamp + " > now=" + nowRT + " (REV-122 D5)")
            EndIf
            i += 1
        EndWhile
    EndIf
    If clamped > 0
        akHost._Log("[SNBaka] stale RT stamp clamp: " + clamped + " key(s) clamped at load (REV-122 D5)")
    EndIf
EndFunction

; REV-122: cum visual/state lifetime, seconds (10 min, matrix of record).
; Named constant -- every expiry site reads this one function.
Float Function _CumLifetimeSec() Global
    Return 600.0
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
    ; REV-122: expiry clock + wearer cache. cum.expires_rt is the state
    ; lifetime deadline (now + _CumLifetimeSec()); cum.wearer is type 4
    ; (FormID slot, DeDService.psc L8) so the sender-None ambient tick can
    ; address the wearer (Scheduler.cpp L124/L149 -- rule ticks are never
    ; actor-addressed). The StorageUtil form pointer mirrors it for the
    ; sender-None callback leg.
    DeDService.RegisterState("cum", "expires_rt", 1, True, "0.0")
    DeDService.RegisterState("cum", "wearer", 4, True, "")
    ; ambient: cadence 60s (REV-122; was 120s -- first maintenance/expiry tick
    ; lands at 60s), class-1 (STATE_BOOL_TRUE on cum.present),
    ; failsafe 600s, callback sdb_cum_ambient_due (4-slot ModEvent shape).
    DeDService.AddTimerRule("cum", "ambient", 60.0, 1, None, "cum.present", 600.0, "sdb_cum_ambient_due")
    akHost._Log("[SNBaka] cum-v2 state layer armed: cum.* registered + ambient rule (60s/class-1/600s failsafe; REV-122)")
EndFunction

; Single write point for every cum application signal (OCum events, P+ listener,
; vanilla keyword reconciliation, SL proxy). asLocation "" = unknown -> state
; records the source but leaves last_location empty.
; REV-122: also (re)arms the lifetime deadline and caches the wearer (type-4
; state row + None-keyed StorageUtil form pointer) for the sender-None ambient
; tick, and re-applies/maintains the visual per the tier matrix (_ApplyCumVisual)
; EXCEPT when asSource == "ocum" -- the OCum legs ADOPT the visual their own
; ApplyCum already applied (drive call only on SL legs; a second call would
; re-stack their overlays). The ocum_applied_cum re-entry from our own drive
; call re-lands here with source "ocum" -- that rewrite is the correct
; maintenance tier, and the shared 15s cue window eats the cue double-fire.
Function _WriteCumState(Actor akTarget, String asLocation, String asSource) Global
    If !akTarget || !DeD_ServicePresent()
        Return
    EndIf
    DeDService.SetStateBool(akTarget, "cum.present", True)
    DeDService.SetStateString(akTarget, "cum.last_location", asLocation)
    DeDService.SetStateString(akTarget, "cum.last_source", asSource)
    DeDService.SetStateFloat(akTarget, "cum.last_applied_rt", Utility.GetCurrentRealTime())
    ; REV-122: expiry + wearer cache. Every application signal REFRESHES the
    ; deadline (latest-write-wins, matching how OCum re-entries extend the
    ; visual), and re-points the cache at the latest wearer.
    Float expiresRT = Utility.GetCurrentRealTime() + _CumLifetimeSec()
    DeDService.SetStateFloat(akTarget, "cum.expires_rt", expiresRT)
    DeDService.SetStateFormID(akTarget, "cum.wearer", akTarget)
    StorageUtil.SetFormValue(None, "SNBaka.CumWearer", akTarget)
    ; REV-122: visual drive per tier matrix. "ocum" = their ApplyCum already
    ; applied the overlay (adopt); every other source drives/replaces.
    If asSource != "ocum"
        _ApplyCumVisual(akTarget, asLocation)
    EndIf
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
    ; REV-126 EVENT-LEVEL SOURCE ENFORCEMENT (ownership ruling of record): the
    ; OCum Orgasmer payload is PER-EVENT (OCumMaleScript.psc L689-695/L697-704,
    ; PushForm(Orgasmer) first, one event per application), and a female
    ; non-futa source does not own our cues OR our state -- her application is
    ; SN-SexLab's lane entirely. Validated BEFORE the state write (REV-117's
    ; write-before-cue order is superseded here: her event writes nothing).
    If !_EventSourceOwnsCum(akHost, orgasmer)
        Return
    EndIf
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
    ; REV-126: event-level source enforcement BEFORE the state write (same as
    ; the 5-arg handler -- the 6-arg payload is likewise per-event Orgasmer).
    If !_EventSourceOwnsCum(akHost, orgasmer)
        Return
    EndIf
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

; REV-126: shared event-level source enforcement (ownership ruling of record:
; our lane = male/futa-source applications; SN-SexLab keeps female-source ones
; entirely -- no cue, no state write, no ambient debt). Validated against the
; EVENT'S OWN payload source (P+ SourceRef / OCum Orgasmer -- both per-event,
; verified against the senders), not the thread's resolved male. Interim
; actor-model rule unchanged from REV-118: male = _SexOf==0 (leveled-safe
; ActorBase->GetSex, motherboard L727); the SL futa signal (_sex==4) stays
; unrecoverable from a plain ActorBase here (futa honesty limit, REV-118).
; Returns True (no log) on a valid source; False with the ownership sentinel
; on a female non-futa source. None sources return False silently (the
; reconciliation leg's honest-skip case -- handled by its own logging).
Bool Function _EventSourceOwnsCum(SkyrimNet_BakaIntegration akHost, Actor akSource) Global
    If akSource && SkyrimNet_BakaIntegration._SexOf(akSource) == 0
        Return True
    EndIf
    If akSource
        akHost._Log("[SNBaka] female-source event declined (SN-SL lane) (REV-126): source=" + akSource.GetDisplayName())
    EndIf
    Return False
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
    ; REV-126: BACKSTOP ONLY -- every caller now validates the event's own
    ; source BEFORE its state write (entry-point enforcement), so a decline
    ; here means a path was missed (or the reconciliation leg's honest None).
    ; The sentinel is the REV-126 ownership wording (state: declined events
    ; write nothing upstream).
    If !orgasmer || SkyrimNet_BakaIntegration._SexOf(orgasmer) != 0
        akHost._Log("[SNBaka] _FireCumCue: female-source event declined (SN-SL lane) (REV-126 backstop)")
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
    ; REV-126 note: the per-target state write on this leg is legitimate under
    ; the ownership ruling even when the resolved source is None -- SL's own
    ; ApplyCumFX gating (sslActorAlias.psc L921-923, male/futa sources only)
    ; means a Cum keyword present on a position PROVES a male/futa-source
    ; application; the None case is a resolution miss, not a female-source event.
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
    ; REV-118 source-validation, REV-126 wording: the proxy's lead actor is the
    ; resolved source; female non-futa lead -> declined (SN-SL lane -- no cue;
    ; no state was written on this fallback path).
    If !lead || SkyrimNet_BakaIntegration._SexOf(lead) != 0
        akHost._Log("[SNBaka] OnSLStageEnd: female-source event declined (SN-SL lane) (REV-126)")
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
    ; REV-126 EVENT-LEVEL SOURCE ENFORCEMENT: validate the EVENT'S OWN SourceRef
    ; (the ModEvent payload, sslThreadModel.psc L2234-2238 -- not the thread's
    ; resolved male). SL itself only fires ApplyCumFX for male/futa sources
    ; (sslActorAlias.psc L921-923, _sex != 1 && _sex != 4), so this is
    ; defense-in-depth against a stray/foreign delivery -- but a female-source
    ; event is declined here too: cue AND state write (SN-SL lane).
    If !_EventSourceOwnsCum(akHost, source)
        Return
    EndIf
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

; ---- REV-122: CUM APPLIANCE AUTHORITY (visual drive + maintenance) ----
; Tier matrix of record (header + cum-effects.md REV-122). asLocation is our
; FX-domain literal ("vagina"|"rectum"|"mouth"). No drive call when the
; location is unknown or the source is the SL proxy (proxy never claims
; overlay application) -- state-only, documented degradation.
Function _ApplyCumVisual(Actor akTarget, String asLocation) Global
    If !akTarget || !asLocation
        Return    ; state-only degradation (no location -> no overlay claim)
    EndIf
    ; ---- Tier 1: OCum drive (preferred whenever OCum is installed) ----
    If Installed()
        OCumMaleScript male = _OCumMale()
        SexLabFramework sl = None
        If SkyrimNet_BakaSL.Installed()
            sl = SkyrimNet_BakaSL._SL()
        EndIf
        ; Replace-not-stack: if SLACS overlays are already on the wearer (SL+
        ; OCum stack case), drop them first -- OCum becomes the sole visual
        ; authority. Note: we never RE-call SLACS AddCum as maintenance (it
        ; ESCALATES the texture tier 1->2 on an already-cummed actor).
        If sl && sl.ActorLib
            sl.ActorLib.ClearCum(akTarget)
        EndIf
        If male
            ; OCumMaleScript.psc L303-345 (GPL -- cited, not copied): the
            ; generic entry; Area is a String argument dispatched to
            ; per-area overlay application (CumOntoArea L523-536).
            ; ThreadID=0 = the out-of-scene path (our case: we drive
            ; post-scene). Re-emits ocum_applied_cum (L316) -> our own
            ; handler re-writes state source as "ocum" (correct maintenance
            ; tier) and the cue double-fire is eaten by the shared 15s window.
            male.ApplyCum(akTarget, akTarget, asLocation, 1, 1.0, "", 0)
            Return
        EndIf
        ; OCum installed but the male quest unresolvable: fall through to
        ; SLACS (next tier) -- documented degradation.
    EndIf
    ; ---- Tier 2: SLACS (SL-only: SexLab's own combo-spell overlays) ----
    If SkyrimNet_BakaSL.Installed()
        SexLabFramework sl = SkyrimNet_BakaSL._SL()
        If sl && sl.ActorLib
            ; sslActorLibrary PPLUS L805/L834: AddCum(Actor, Vaginal, Oral,
            ; Anal) -- bool flags per area, spells persist-until-dispelled.
            sl.ActorLib.AddCum(akTarget, asLocation == "vagina", asLocation == "mouth", asLocation == "rectum")
        EndIf
        ; SL present but ActorLib unresolvable: state-only degradation.
        Return
    EndIf
    ; ---- Tier 3: neither framework -> state-only (documented degradation) ----
EndFunction

; Tier removal: clears BOTH systems' visuals. Used by expiry and the 600s
; failsafe (the failsafe must not orphan the visual past lifetime).
Function _ClearCumVisual(Actor akTarget) Global
    If !akTarget
        Return
    EndIf
    If Installed()
        OCumScript main = _OCumMain()
        If main
            main.CleanCumTexturesFromActor(akTarget)    ; OCumScript.psc (cited)
        EndIf
    EndIf
    If SkyrimNet_BakaSL.Installed()
        SexLabFramework sl = SkyrimNet_BakaSL._SL()
        If sl && sl.ActorLib
            sl.ActorLib.ClearCum(akTarget)
        EndIf
    EndIf
EndFunction

; Runtime quest resolvers -- QUST EDIDs byte-confirmed in OCum.esp; no
; hardcoded formIDs (Quest.GetQuest is the EDID path).
OCumScript Function _OCumMain() Global
    Return Quest.GetQuest("OCumQuest") as OCumScript
EndFunction

OCumMaleScript Function _OCumMale() Global
    Return Quest.GetQuest("OCumMaleQuest") as OCumMaleScript
EndFunction

; Ambient timer handler: sdb_cum_ambient_due arrives as the standard 4-slot
; ModEvent shape (eventName, strArg, numArg, sender) -- numArg 1 = failsafe
; expired, 0 = due tick. Scheduler.cpp emits with sender=None (rule ticks are
; not actor-addressed, L124/L149), so the wearer is recovered from the
; REV-122 cache (None-keyed StorageUtil form pointer, mirrored by the
; DeDService type-4 "cum.wearer" row) and the ambient cue stays subjectless.
; REV-122 REWRITE: the tick is now (in order) failsafe-clear -> expiry-clear
; -> maintenance refresh -> ambient cue. The failsafe used to be skip-only
; (REV-117/120) which orphaned the visual past lifetime.
Function HandleCumAmbientDue(SkyrimNet_BakaIntegration akHost, Float afNumArg, Form akSender) Global
    If !akHost.bEnabled || !akHost.bCumDetectionEnabled || !DeD_ServicePresent()
        Return
    EndIf
    Actor wearer = StorageUtil.GetFormValue(None, "SNBaka.CumWearer", None) as Actor
    If afNumArg >= 1.0
        ; 600s failsafe: rule starved/misarmed past its window -- clear BOTH
        ; the visual and the state (REV-122; was skip-only).
        akHost._Log("[SNBaka] sdb_cum_ambient_due: failsafe-expired tick (numArg=" + afNumArg + ") -- clearing visual + state (REV-122)")
        If wearer
            _ClearCumVisual(wearer)
            DeDService.ClearActorState(wearer, "cum")
        EndIf
        StorageUtil.UnsetFormValue(None, "SNBaka.CumWearer")
        Return
    EndIf
    If !wearer
        Return    ; nothing cached: no state to maintain (or pre-REV-122 state)
    EndIf
    ; Expiry: lifetime clock (cum.expires_rt, refreshed by every application
    ; signal) -- clear BOTH systems' visuals + the state, drop the cache.
    If Utility.GetCurrentRealTime() >= DeDService.GetStateFloat(wearer, "cum.expires_rt", 0.0)
        akHost._Log("[SNBaka] sdb_cum_ambient_due: cum lifetime expired (wearer=" + wearer.GetDisplayName() + ") -- clearing visual + state (REV-122)")
        _ClearCumVisual(wearer)
        DeDService.ClearActorState(wearer, "cum")
        StorageUtil.UnsetFormValue(None, "SNBaka.CumWearer")
        Return
    EndIf
    ; Maintenance refresh: keep the visual authoritative for the remaining
    ; lifetime. OCum tier: recast OCumSpell on the wearer -- their own cleanup
    ; timer (MCM default 5min) is SHORTER than our 10-min lifetime; the recast
    ; resets its duration so OnEffectFinish never cleans early (their own
    ; in-scene re-cast pattern, OCumEffect.psc L12). SLACS tier: nothing to do
    ; (persist-until-dispelled; re-calling AddCum would ESCALATE the texture
    ; tier -- never done). State-only tier: nothing to do.
    String src = DeDService.GetStateString(wearer, "cum.last_source", "")
    If src == "ocum" && Installed()
        OCumMaleScript male = _OCumMale()
        If male && male.OCumSpell
            male.OCumSpell.Cast(wearer)
        Else
            OCumScript main = _OCumMain()
            If main && main.OCumSpell
                main.OCumSpell.Cast(wearer)
            EndIf
        EndIf
    EndIf
    ; Ambient cue (unchanged REV-117 behavior): sender=None -> subjectless;
    ; the narrator applies it to whoever the moment fits.
    Actor narrTarget = akSender as Actor
    String desc = "Notices that they are still covered in cum from a recent sexual encounter."    ; REV-125: user-edited wording of record (register entry 19, edited 2026-10-17)
    akHost._Log("[SNBaka] sdb_cum_ambient_due: ambient cue fired (sender=" + akSender + "; maintenance pass done, src=" + src + ")")
    SkyrimNetApi.RegisterEvent("sdb_cum_ambient", desc, narrTarget, None)
EndFunction
