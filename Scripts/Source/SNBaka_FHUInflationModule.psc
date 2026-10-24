Scriptname SNBaka_FHUInflationModule
; REV-96 Task 2: FHU-inflation module (recordless detection class -- module contract
; point 3, fomod.md section architecture). Extracted BEHAVIOR-PRESERVING from the
; REV-63/65 detection-triggers section of SkyrimNet_BakaIntegration.psc (the §64
; class: signatures and sentinels moved verbatim; only the call shape changed).
; The FHU HEARTBEAT SELF-HEAL pattern (REV-65: the poll arms from Setup() AND the
; OnUpdateGameTime heartbeat because the MCM reload chain was stale at save-load) is
; PRESERVED IN FULL: the arming points (Setup + heartbeat), the idempotent arming
; guard, and the multiplexed real-time tick all remain on the motherboard -- a
; recordless script cannot own an OnUpdate chain. This module owns the poll BODY and
; the cue logic only.
;
; REV-149 (FHU v2 session 1) ADDS, per the REV-136 rulings + the mid-REV-149 user
; rulings (hook choice + orifice-aware inflate):
;   (a) ENTRY-AROUSAL CAPTURE: HandleSceneStartSL stashes per-actor arousal tier at
;       SL scene start (HookAnimationStart, user-ruled capture point; the REV-82
;       chain via the motherboard's _DaemonArousalTier) + consent context (thread
;       IsAggressive / VictimRef), cleared at scene end (HookAnimationEnd). The
;       INSTANT inflate cue's arousal branch reads the STASHED tier, never the live
;       post-collapse read.
;   (b) CONSENT-CONTEXT PRIMARY: the inflate cue branches on the stashed consent
;       context FIRST (1 consensual / 2 non-consensual / absent = agnostic per the
;       sec.81 1c precedent), arousal tier secondary.
;   (c) DEFLATE/AMBIENT KEEP THE LIVE READ: no capture machinery on those paths;
;       wording treats the post-collapse state as the state.
;   (d) CREATURE-CUM AMBIENT CUE: poll-tick ambient (one shot per inflation
;       episode, sentinel'd skips for human/unsupported injectors) when the
;       inflation source resolves to a non-human creature; {{creature}} resolves to
;       the race EDITOR ID via the injector formlists + MiscUtil.GetRaceEditorID
;       (pre-check 3.2 verdict: a real race name, not just a race class); canned
;       one-liners per creature class keyed to the FHU per-race cum-effect
;       FormLists (the enumeration source), generic fallback for the rest.
;       Template fixed fields USER-QUOTED (REV-136 ruling (d)), register-cited;
;       canned lines are sec.7 DRAFTs (rev-149, approval pending).
;   (e) PER-ORIFICE DEFLATE: sdb_fhu_deflate_vaginal / _anal / _oral fired per the
;       three-literal discriminator (which sr.inflater.cum.* float dropped); the
;       generic sdb_fhu_deflate is RETIRED with them (retire-and-replace).
;   NEW (mid-REV-149 user ruling): the INSTANT inflate cue is ORIFICE-AWARE -- the
;       wording branches on the dominant cum.* delta at inflate time.
;
;   HONEST PREMISE CORRECTION (REV-149 pre-check 3.3, evidence-cited): the v1
;   PollLevels walked ONLY sr.inflater.amount; the three per-orifice floats were
;   never read. This revision EXTENDS the poll with per-orifice caches
;   (SNBaka.FHULast.V/.A/.O.<formid>) -- the discriminator is sound, the "v1 poll
;   walks them already" premise was false.
;
;   OStim parity (mid-REV-149 user ruling): the OStim capture listener is NOT
;   BUILT -- the SL FHU Baka Ostim 0.18 bridge is DISABLED in the active Ultra
;   profile (modlist.txt) and the enabled FHU 2.11 Beta has zero OStim
;   registrations (SexLab hooks only, sr_inflateQuest L383-385); OStim-driven
;   fills do not occur in-profile. STOP-and-report honored; capture is
;   SL-scenes-only; absent stash = context-agnostic fallback, sentinel'd.
;
;   REV-154 (FHU v2 final lane) ADDS: the AMBIENT BYSTANDER REACTION CUE (the
;   planner's 30%/60% expose bands, the cum-ambient REV-122/127/133c/134a/134f
;   pattern applied to FHU; the user's 2026-10-24 shape: prompt-directed cue to
;   the reacting actor + MCM-gated direct narration follow-up):
;   (a) while an actor's inflation amount sits at/above the NOTICEABLE band
;       (default 30% of FHU maxInflation -- the MCM slider is the user valve
;       per the C5 ruling; FHU's own percentage math is amount/maxInflation*100,
;       sr_inflateQuest L3394, maxInflationDefault 6.0 = sr_inflateConfig L60),
;       a per-actor ambient reaction cue fires every 60s real time: ONE
;       RegisterEvent("sdb_fhu_ambient", desc, akActor, None) -- the cum-ambient
;       entry-19 subjectless/gamemaster shape ("Nearby characters notice ..."),
;       P2 trigger-bus semantics per the REV-134a restore (RegisterEvent IS the
;       load-bearing emission; NO cue yaml -- same as sdb_cum_ambient).
;   (b) wording branches by BAND (noticeable = curious stares / suggestive
;       comments; heavy = scandalized whispers -- the planner rows) and by
;       SOURCE (creature-sourced reads the creature class; human-sourced reads
;       generic; indeterminate source SKIPS cleanly, sentinel'd). Band + source
;       wordings are sec.7 DRAFTs (rev-154, register entry 34).
;   (c) LIFECYCLE: anchor at first band crossing -- the first ambient fires one
;       cadence AFTER state-start (the instant cue owns the fresh-inflation
;       moment; no catch-up per the REV-127 rule); keys clear when the amount
;       drops below the noticeable band (deflate / the module's clear paths);
;       a 7200s-RT failsafe-class lifetime guard exhausts the episode so a
;       stuck state cannot fire forever.
;   (d) MCM-GATED NARRATION FOLLOW-UP (the second surface, the 153/134f
;       pattern): bFHUAmbientNarration (Fill Her Up MCM "Ambient Narration",
;       DEFAULT OFF) gates sdb_fhu_ambient_narr -- the yaml
;       sdb_fhu_ambient_narr.yaml (eventType-only, direct_narration, guidance
;       = sec.7 DRAFT, register entry 34) matches that event type ONLY.
;
; State: NONE of its own beyond StorageUtil (all keys None-keyed with the actor
; formid embedded, same convention as the v1 FHULast cache). The
; bFHUInflationEnabled toggle remains the motherboard's Auto property (read
; through akHost). Keys:
;   SNBaka.FHULast.<formid>          amount cache (v1, unchanged)
;   SNBaka.FHULast.V/A/O.<formid>    per-orifice cum caches (REV-149)
;   SNBaka.FHU.EntryTier.<formid>    captured arousal tier 1/2/3 (absent = no capture)
;   SNBaka.FHU.EntryContext.<formid> 1 consensual / 2 non-consensual (absent = agnostic)
;   SNBaka.FHUCreatureFired.<formid> creature-ambient episode flag
;   SNBaka.FHU.AmbNext.<formid>    ambient-expose next-fire RT stamp (0/absent = not anchored)
;   SNBaka.FHU.AmbStart.<formid>   ambient-expose episode start RT (lifetime guard)
;   SNBaka.FHU.AmbDone.<formid>    ambient-expose failsafe-exhausted flag (REV-154)
;
; Logging: every sentinel goes through akHost._Log() -- identical strings, identical
; bDebugLog gating (sentinel parity per sec.67; the [SNBaka] tag preserved
; verbatim). RegisterEvent desc strings are ASCII (REV-146a rider) and
; sec.7-DRAFT-flagged.

; ---- Presence probe (cached; absence cached on the None key once -- the
; SNBakaSL.Absent-cache lesson). MOVED VERBATIM from the motherboard's _FHUInstalled.
; sr_inflateQuest QUST 0x000D63 in sr_FillHerUp.esp (formID parsed from the plugin
; binary; identical in BOTH installed variants -- the base hotfix esp and the
; "SL FHU Baka Ostim 0.18" patch esp). ----
Bool Function Installed() Global
    If StorageUtil.GetIntValue(None, "SNBaka.FHUAbsent", 0) == 1
        Return False
    EndIf
    If Game.GetFormFromFile(0x000D63, "sr_FillHerUp.esp") != None
        Return True
    EndIf
    StorageUtil.SetIntValue(None, "SNBaka.FHUAbsent", 1)
    Return False
EndFunction

; ---- FHU INFLATION AWARENESS (Task 3b: fallback poll design) ----
; What FHU's external stack actually exposes (as-read): sr_InfEventManager's
; broadcast system exists to register REFERENCE-ALIAS event scripts -- joining needs
; esp records in sr_FillHerUp.esp, which is out of the Papyrus-only scope, so the
; formal handshake is NOT joined (flagged, not improvised).
; FHU's ModEvents carry no per-actor level payload (sr.inflater.start/.absorb are
; parameterless broadcasts; fhu.playerInflated / fhu.playerCumUpdate are player-only).
; The per-actor level surface is StorageUtil:
;   sr.inflater.amount (float, per actor) -- the level scale behind the 10 stage armors
;   sr.inflater.cum.vaginal/.anal/.oral (floats, per actor) -- per-orifice loads
;   sr.inflater.injector / .analinjector (formlists, per inflated actor) -- who injected
;   sr.inflater.Actors (formlist, keyed on the sr_inflateQuest form 0x000D63)
; Level changes forward as sdb_fhu_inflate (increase) / per-orifice deflate types
; (decrease, REV-149). sr.inflater.start is used ONLY as an immediate-poll nudge.
;
; REV-96: MOVED BODY of the motherboard's OnFHUStartSignal event (zero-arg handler --
; sr.inflater.start is a parameterless broadcast; the rev-63 4-slot shape is retired).
Function HandleFHUStartSignal(SkyrimNet_BakaIntegration akHost) Global
    If akHost.bEnabled && akHost.bFHUInflationEnabled && Installed()
        akHost._Log("[SNBaka] OnFHUStartSignal: sr.inflater.start received -- immediate level poll")
        PollLevels(akHost)
    EndIf
EndFunction

; ---- REV-149 (a)/(b): ENTRY CAPTURE at SL scene start ----
; Armed on the motherboard as OnSLAnimationStart (HookAnimationStart -- user-ruled
; capture point mid-REV-149: fires once at true scene start; payload 2-push
; PushInt(thread_id), PushBool(HasPlayer), same shape as the proven HookStageEnd).
; Capture-only: this module NEVER drives FHU inflation.
Function HandleSceneStartSL(SkyrimNet_BakaIntegration akHost, Int aiThreadID) Global
    If !(akHost.bEnabled && akHost.bFHUInflationEnabled && Installed())
        Return
    EndIf
    SexLabFramework sl = SkyrimNet_BakaSL._SL()
    If !sl
        akHost._Log("[SNBaka] FHU entry-capture: SexLab accessor None -- no capture for thread " + aiThreadID)
        Return
    EndIf
    sslThreadController tc = sl.GetController(aiThreadID)
    If !tc
        akHost._Log("[SNBaka] FHU entry-capture: no controller for thread " + aiThreadID + " -- no capture")
        Return
    EndIf
    Bool bAggressive = tc.IsAggressive
    Int i = 0
    While i < tc.Positions.Length
        Actor a = tc.Positions[i]
        If a
            Int tier = akHost._DaemonArousalTier(a)
            Int ctx = 1
            If bAggressive && a == tc.VictimRef
                ctx = 2
            EndIf
            String sCtx = "consensual"
            If ctx == 2
                sCtx = "non-consensual"
            EndIf
            StorageUtil.SetIntValue(None, "SNBaka.FHU.EntryTier." + a.GetFormID(), tier)
            StorageUtil.SetIntValue(None, "SNBaka.FHU.EntryContext." + a.GetFormID(), ctx)
            akHost._Log("[SNBaka] FHU entry-capture: " + a.GetDisplayName() + " arousal tier " + tier + " context " + sCtx + " (thread " + aiThreadID + ")")
        EndIf
        i += 1
    EndWhile
EndFunction

; ---- REV-149 (a): CAPTURE CLEARED at SL scene end ----
; Armed as OnSLAnimationEnd (HookAnimationEnd -- the capture/clear bracket ruling).
Function HandleSceneEndSL(SkyrimNet_BakaIntegration akHost, Int aiThreadID) Global
    If !(akHost.bEnabled && akHost.bFHUInflationEnabled && Installed())
        Return
    EndIf
    SexLabFramework sl = SkyrimNet_BakaSL._SL()
    If !sl
        Return
    EndIf
    sslThreadController tc = sl.GetController(aiThreadID)
    If !tc
        Return
    EndIf
    Int i = 0
    While i < tc.Positions.Length
        Actor a = tc.Positions[i]
        If a
            StorageUtil.UnsetIntValue(None, "SNBaka.FHU.EntryTier." + a.GetFormID())
            StorageUtil.UnsetIntValue(None, "SNBaka.FHU.EntryContext." + a.GetFormID())
            akHost._Log("[SNBaka] FHU entry-capture cleared at scene end: " + a.GetDisplayName() + " (thread " + aiThreadID + ")")
        EndIf
        i += 1
    EndWhile
EndFunction

; REV-96: MOVED VERBATIM from the motherboard's _PollFHULevels (called by the
; motherboard's multiplexed OnUpdate tick and the seed pass in its _FHUStartPoll).
; REV-149: body EXTENDED -- per-orifice caches + the creature-ambient pass ride
; the same 10s poll (no new timer class; accept-the-mechanic per ruling (c)).
Function PollLevels(SkyrimNet_BakaIntegration akHost) Global
    Form fhq = Game.GetFormFromFile(0x000D63, "sr_FillHerUp.esp")
    If !fhq
        Return
    EndIf
    Int n = StorageUtil.FormListCount(fhq, "sr.inflater.Actors")
    Int i = 0
    While i < n
        Actor a = StorageUtil.FormListGet(fhq, "sr.inflater.Actors", i) as Actor
        If a
            Float cur = StorageUtil.GetFloatValue(a, "sr.inflater.amount", 0.0)
            Float curV = StorageUtil.GetFloatValue(a, "sr.inflater.cum.vaginal", 0.0)
            Float curA = StorageUtil.GetFloatValue(a, "sr.inflater.cum.anal", 0.0)
            Float curO = StorageUtil.GetFloatValue(a, "sr.inflater.cum.oral", 0.0)
            String sId = a.GetFormID()
            Float last = StorageUtil.GetFloatValue(None, "SNBaka.FHULast." + sId, -1.0)
            Float lastV = StorageUtil.GetFloatValue(None, "SNBaka.FHULast.V." + sId, -1.0)
            Float lastA = StorageUtil.GetFloatValue(None, "SNBaka.FHULast.A." + sId, -1.0)
            Float lastO = StorageUtil.GetFloatValue(None, "SNBaka.FHULast.O." + sId, -1.0)
            If last >= 0.0 && Math.Abs(cur - last) > 0.001
                _FireChange(akHost, a, last, cur, lastV, curV, lastA, curA, lastO, curO)
            EndIf
            StorageUtil.SetFloatValue(None, "SNBaka.FHULast." + sId, cur)
            If lastV >= 0.0
                StorageUtil.SetFloatValue(None, "SNBaka.FHULast.V." + sId, curV)
                StorageUtil.SetFloatValue(None, "SNBaka.FHULast.A." + sId, curA)
                StorageUtil.SetFloatValue(None, "SNBaka.FHULast.O." + sId, curO)
            EndIf
            _CheckCreatureAmbient(akHost, a, cur, curV, curA, curO)
            _CheckAmbientExpose(akHost, a, cur)   ; REV-154: bystander reaction pass (30%/60% bands)
        EndIf
        i += 1
    EndWhile
EndFunction

; REV-96: MOVED VERBATIM from the motherboard's _FireFHUChange.
; REV-149: REWRITTEN -- orifice-aware instant inflate (context primary, captured
; arousal secondary) + per-orifice deflate split (rulings (a)/(b)/(e) + the mid-rev
; orifice-aware inflate ruling). DRAFT cue texts: sec.7 approval pending; wording
; rule 3b-ii stands (never assert WHY -- no framework, source, or mechanism named).
Function _FireChange(SkyrimNet_BakaIntegration akHost, Actor akActor, Float afLast, Float afCur, \
        Float afLastV, Float afCurV, Float afLastA, Float afCurA, Float afLastO, Float afCurO) Global
    String sId = akActor.GetFormID()
    If afCur > afLast
        ; ---- INSTANT INFLATE: orifice = dominant cum.* delta ----
        Float dV = afCurV - afLastV
        Float dA = afCurA - afLastA
        Float dO = afCurO - afLastO
        Int orifice = 0
        If dV >= dA && dV >= dO && dV > 0.0
            orifice = 1
        ElseIf dA >= dO && dA > 0.0
            orifice = 2
        ElseIf dO > 0.0
            orifice = 3
        EndIf
        String sOrifice = "none"
        String sContainer = "belly"
        If orifice == 1
            sOrifice = "vaginal"
            sContainer = "womb"
        ElseIf orifice == 2
            sOrifice = "anal"
            sContainer = "bowels"
        ElseIf orifice == 3
            sOrifice = "oral"
            sContainer = "stomach"
        EndIf
        Int ctx = StorageUtil.GetIntValue(None, "SNBaka.FHU.EntryContext." + sId, 0)
        Int tier = StorageUtil.GetIntValue(None, "SNBaka.FHU.EntryTier." + sId, 0)
        String sCtx = "agnostic"
        String desc = akActor.GetDisplayName() + "'s " + sContainer + " is noticeably fuller now, swelling with warmth."
        If ctx == 2
            sCtx = "non-consensual"
            desc = akActor.GetDisplayName() + "'s " + sContainer + " swells fuller, heavy and unwanted."
        ElseIf ctx == 1
            sCtx = "consensual"
            desc = akActor.GetDisplayName() + "'s " + sContainer + " is noticeably fuller now, warm and welcome."
        EndIf
        If tier == 3
            desc = desc + " A flush of heat rides them."
        ElseIf tier == 1
            desc = desc + " A shiver of unease runs through them."
        EndIf
        akHost._Log("[SNBaka] _FireFHUChange: " + akActor.GetDisplayName() + " amount " + afLast + " -> " + afCur + " -> sdb_fhu_inflate orifice " + sOrifice + " context " + sCtx + " arousal tier " + tier)
        SkyrimNetApi.RegisterEvent("sdb_fhu_inflate", desc, akActor, None)
        ; REV-153 (Follow-up Prompt pattern, the REV-134f shape): the direct
        ; narration is a SEPARATE, MCM-gated surface. The narration yaml
        ; (sdb_fhu_inflate_narr.yaml, sec.7 DRAFT = register entry 33) matches
        ; the sdb_fhu_inflate_narr event type ONLY, so the cue (mandatory,
        ; above) and the narration (optional, Fill Her Up MCM "Follow-up
        ; Prompt") are fully separable. Default OFF = cue-only. The follow-up
        ; event's own desc is a plain marker (the rendered text lives in the
        ; yaml); no template variables per the D8/sec.137 binding rule.
        If akHost.bFHUInflateNarration
            akHost._Log("[SNBaka] FHU inflate: follow-up prompt ON -- narration event fired (REV-153)")
            SkyrimNetApi.RegisterEvent("sdb_fhu_inflate_narr", "[sdb_fhu_inflate_narr] Follow-up narration moment for the inflation cue.", akActor, None)
        Else
            akHost._Log("[SNBaka] FHU inflate: follow-up prompt OFF -- narration skipped (REV-153)")
        EndIf
    Else
        ; ---- DEFLATE: per-orifice split (which cum.* float dropped) ----
        Float dropV = afLastV - afCurV
        Float dropA = afLastA - afCurA
        Float dropO = afLastO - afCurO
        Int orifice = 0
        If dropV >= dropA && dropV >= dropO && dropV > 0.001
            orifice = 1
        ElseIf dropA >= dropO && dropA > 0.001
            orifice = 2
        ElseIf dropO > 0.001
            orifice = 3
        EndIf
        If orifice == 0
            ; No per-orifice delta above threshold: amount dropped, so something
            ; left -- attribute to the dominant CURRENT load; if every orifice
            ; reads zero this is an amount-only edge: silent skip, sentinel'd
            ; (the generic deflate type is retired and never fires).
            If afCurV <= 0.001 && afCurA <= 0.001 && afCurO <= 0.001
                akHost._Log("[SNBaka] _FireFHUChange: " + akActor.GetDisplayName() + " amount " + afLast + " -> " + afCur + " -- deflate with no per-orifice signal, no cue (generic type retired)")
                Return
            EndIf
            If afCurV >= afCurA && afCurV >= afCurO
                orifice = 1
            ElseIf afCurA >= afCurO
                orifice = 2
            Else
                orifice = 3
            EndIf
            akHost._Log("[SNBaka] _FireFHUChange: deflate with no per-orifice delta above threshold -- attributed to dominant current orifice " + orifice)
        EndIf
        String evType
        String desc
        If orifice == 1
            evType = "sdb_fhu_deflate_vaginal"
            desc = akActor.GetDisplayName() + " is suddenly hit by an undeniable need to evacuate -- with legs squeezed together, the pressure pours out of them, leaving their womb lighter."
        ElseIf orifice == 2
            evType = "sdb_fhu_deflate_anal"
            desc = akActor.GetDisplayName() + " can no longer hold it in -- they clench and helplessly let it out of their backside, relief and embarrassment mingling."
        Else
            evType = "sdb_fhu_deflate_oral"
            desc = akActor.GetDisplayName() + " doubles over and brings up what was forced down their throat, eyes watering."
        EndIf
        akHost._Log("[SNBaka] _FireFHUChange: " + akActor.GetDisplayName() + " amount " + afLast + " -> " + afCur + " -> " + evType)
        SkyrimNetApi.RegisterEvent(evType, desc, akActor, None)
    EndIf
EndFunction

; ---- REV-149 (d): CREATURE-CUM AMBIENT CUE ----
; Poll-tick ambient, one shot per inflation episode (flag set on the first
; evaluation of a non-zero episode, cleared when amount returns to zero). SKIP
; human/unsupported (silent to the cue stream, sentinel'd). {{creature}}
; resolves to the race EDITOR ID via the injector formlists +
; MiscUtil.GetRaceEditorID (pre-check 3.2 verdict: a real race name, not just a
; race class; the editor ID ships as-is -- a pretty-name pass is sec.7 polish,
; gap named). The canned line keys on the FHU per-race cum-effect FormLists'
; creature classes (Dragon/Spider/Troll/Draugr/Chaurus/Bear --
; sr_inflateConfig L1769-1789) with a generic fallback for the remaining
; creature races (the ~38 CREATURERACE_CUM_AMOUNT classes without effect lists
; -- gaps named in the register); the container word keys on the dominant
; cum.* type (womb/bowels/stomach per the user-quoted template). Template
; fixed fields are USER-QUOTED (REV-136 ruling (d)): register-cited, no
; approval loop on them; the canned lines are sec.7 DRAFTs (rev-149).
Function _CheckCreatureAmbient(SkyrimNet_BakaIntegration akHost, Actor akActor, Float afCur, Float afCurV, Float afCurA, Float afCurO) Global
    String kFlag = "SNBaka.FHUCreatureFired." + akActor.GetFormID()
    If afCur <= 0.001
        If StorageUtil.GetIntValue(None, kFlag, 0) != 0
            StorageUtil.UnsetIntValue(None, kFlag)
            akHost._Log("[SNBaka] FHU creature ambient: episode ended for " + akActor.GetDisplayName() + " -- flag cleared")
        EndIf
        Return
    EndIf
    If StorageUtil.GetIntValue(None, kFlag, 0) != 0
        Return
    EndIf
    StorageUtil.SetIntValue(None, kFlag, 1)
    Actor inj = None
    Int nInj = StorageUtil.FormListCount(akActor, "sr.inflater.injector")
    If nInj > 0
        inj = StorageUtil.FormListGet(akActor, "sr.inflater.injector", 0) as Actor
    EndIf
    If !inj
        nInj = StorageUtil.FormListCount(akActor, "sr.inflater.analinjector")
        If nInj > 0
            inj = StorageUtil.FormListGet(akActor, "sr.inflater.analinjector", 0) as Actor
        EndIf
    EndIf
    If !inj
        akHost._Log("[SNBaka] FHU creature ambient: no injector recorded for " + akActor.GetDisplayName() + " -- skip (unsupported)")
        Return
    EndIf
    Race r = inj.GetLeveledActorBase().GetRace()
    If !r
        akHost._Log("[SNBaka] FHU creature ambient: injector " + inj.GetDisplayName() + " has no race -- skip (unsupported)")
        Return
    EndIf
    If StorageUtil.FormListCount(r, "sr.inflater.race.cum.effects") > 0
        akHost._Log("[SNBaka] FHU creature ambient: injector " + inj.GetDisplayName() + " is humanoid -- skip (human)")
        Return
    EndIf
    String sRace = MiscUtil.GetRaceEditorID(r)
    If sRace == ""
        akHost._Log("[SNBaka] FHU creature ambient: injector race editor ID unresolved -- skip (unsupported)")
        Return
    EndIf
    String sContainer = "belly"
    If afCurV >= afCurA && afCurV >= afCurO && afCurV > 0.0
        sContainer = "womb"
    ElseIf afCurA >= afCurO && afCurA > 0.0
        sContainer = "bowels"
    ElseIf afCurO > 0.0
        sContainer = "stomach"
    EndIf
    String desc = akActor.GetDisplayName() + " feels the " + sRace + " cum sloshing around in their " + sContainer + ". They feel " + _CreatureClassLine(sRace) + "."
    akHost._Log("[SNBaka] FHU creature ambient: firing sdb_fhu_creature_cum for " + akActor.GetDisplayName() + " (injector race " + sRace + ", container " + sContainer + ")")
    SkyrimNetApi.RegisterEvent("sdb_fhu_creature_cum", desc, akActor, None)
EndFunction

; REV-149: canned-description map (sec.7 DRAFT, rev-149, approval pending);
; class patterns mirror FHU's own GetRaceIndex approach (sr_inflateQuest L935+
; substring matching) against the creature classes that carry
; CREATURERACE_CUM_EFFECTS entries (the FormList enumeration source,
; sr_inflateConfig L1769-1789). Generic fallback covers the remaining creature
; races (wolves/horses/etc. -- CREATURERACE_CUM_AMOUNT classes without effect
; lists); those gaps are named in the register.
String Function _CreatureClassLine(String asRace) Global
    If StringUtil.Find(asRace, "Dragon") >= 0 || StringUtil.Find(asRace, "Alduin") >= 0
        Return "a searing, immense heat spread deep inside them"
    ElseIf StringUtil.Find(asRace, "Spider") >= 0
        Return "a thick, clinging weight shift inside them with every step"
    ElseIf StringUtil.Find(asRace, "Troll") >= 0
        Return "a heavy, musky fullness that will not settle"
    ElseIf StringUtil.Find(asRace, "Draugr") >= 0 || StringUtil.Find(asRace, "AshSpawn") >= 0
        Return "a cold, grave-dank heaviness deep in their core"
    ElseIf StringUtil.Find(asRace, "Chaurus") >= 0
        Return "a slick, tingling residue that numbs as it sits"
    ElseIf StringUtil.Find(asRace, "Bear") >= 0
        Return "a dense, animal warmth packed tight inside them"
    EndIf
    Return "a strange, foreign warmth shifting inside them"
EndFunction

; ---- REV-154: FHU AMBIENT BYSTANDER REACTION CUE (the planner's 30%/60% expose
; bands; the cum-ambient pattern applied to FHU). Poll-tick ambient: the 10s RT
; level poll (motherboard _RT_POLL_INTERVAL 10.0) walks every inflated actor
; already -- the per-actor next-fire RT stamp rides it (the ObservationPass
; per-actor-cooldown pattern, REV-74 rider; NOT a DeDService timer rule: FHU
; has no DeDService state family and no compiled sr_* reference is possible --
; fork Scripts\Source carries zero sr_*.psc stubs). Cadence 60s RT per actor,
; anchored at FIRST band crossing (first ambient = state-start + one cadence;
; the instant cue owns the fresh-inflation moment; no catch-up per REV-127).
; Band floors = PERCENT of FHU maxInflation via the MCM sliders (C5 ruling:
; planner values 30/60 are the defaults, the MCM is the user valve). Band +
; source wordings are sec.7 DRAFTs (rev-154, register entry 34). All
; RegisterEvent descs ASCII (REV-146a rider).
Float Function _FHUMaxInflation() Global
    ; FHU's vaginal/anal capacity default (sr_inflateConfig.psc L60
    ; maxInflationDefault = 6.0, assigned at config load L364). No Papyrus
    ; surface against FHU scripts exists in-tree (no stubs), so the percent
    ; mapping rides the 6.0 default constant -- NAMED GAP: if the user raises
    ; maxInflation in FHU's own MCM, these bands still scale to the default
    ; 6.0 (surfaced at the REV-154 gate report; a live-read pass would need an
    ; sr_inflateQuest stub, out of Papyrus-only scope).
    Return 6.0
EndFunction

Function _CheckAmbientExpose(SkyrimNet_BakaIntegration akHost, Actor akActor, Float afCur) Global
    String sId = akActor.GetFormID()
    String kNext  = "SNBaka.FHU.AmbNext." + sId
    String kStart = "SNBaka.FHU.AmbStart." + sId
    String kDone  = "SNBaka.FHU.AmbDone." + sId
    Float fNotice = _FHUMaxInflation() * (akHost.iFHUAmbientNoticeBand as Float) / 100.0
    Float fHeavy  = _FHUMaxInflation() * (akHost.iFHUAmbientHeavyBand as Float) / 100.0
    If fHeavy < fNotice
        fHeavy = fNotice    ; clamp: the heavy band can never sit below noticeable
    EndIf
    Float now = Utility.GetCurrentRealTime()
    If afCur < fNotice
        ; Lifecycle end: state cleared below the band (deflate / module clear
        ; paths) -- drop every episode key so the next episode re-anchors fresh.
        If StorageUtil.GetFloatValue(None, kNext, 0.0) != 0.0 || StorageUtil.GetIntValue(None, kDone, 0) != 0
            StorageUtil.UnsetFloatValue(None, kNext)
            StorageUtil.UnsetFloatValue(None, kStart)
            StorageUtil.UnsetIntValue(None, kDone)
            akHost._Log("[SNBaka] FHU ambient expose: " + akActor.GetDisplayName() + " dropped below the noticeable band -- episode keys cleared (REV-154)")
        EndIf
        Return
    EndIf
    If StorageUtil.GetIntValue(None, kDone, 0) != 0
        Return    ; failsafe-exhausted episode: silent until the state clears
    EndIf
    Float nextAt = StorageUtil.GetFloatValue(None, kNext, 0.0)
    If nextAt == 0.0
        ; Band entry: anchor the episode. The FIRST ambient fires one cadence
        ; after state-start -- the instant inflate cue owns the fresh moment,
        ; and a re-crossing never catches up on missed ticks (REV-127 rule).
        StorageUtil.SetFloatValue(None, kStart, now)
        StorageUtil.SetFloatValue(None, kNext, now + 60.0)
        akHost._Log("[SNBaka] FHU ambient expose: band entered for " + akActor.GetDisplayName() + " (amount " + afCur + " >= noticeable " + fNotice + ") -- first ambient anchored at +60s (REV-154)")
        Return
    EndIf
    If now < nextAt
        Return
    EndIf
    ; Failsafe-class lifetime guard (the REV-122 600s class, scaled to a
    ; state that can persist): 7200s RT of continuous firing exhausts the
    ; episode -- a stuck state cannot fire forever.
    If now - StorageUtil.GetFloatValue(None, kStart, now) > 7200.0
        StorageUtil.SetIntValue(None, kDone, 1)
        StorageUtil.UnsetFloatValue(None, kNext)
        akHost._Log("[SNBaka] FHU ambient expose: lifetime guard tripped for " + akActor.GetDisplayName() + " (episode past 7200s RT) -- ambient exhausted until the state clears (REV-154)")
        Return
    EndIf
    _AmbientFire(akHost, akActor, afCur, fHeavy, now, kNext)
EndFunction

; REV-154: the per-fire composition + emission (band x source), split out of
; _CheckAmbientExpose for readability. Subjectless entry-19 shape; the actor
; args bind to the inflated actor so the reaction lands in nearby NPCs'
; conversation (P2 trigger-bus semantics per the REV-134a restore --
; RegisterEvent is the load-bearing emission, NO cue yaml, same as
; sdb_cum_ambient).
Function _AmbientFire(SkyrimNet_BakaIntegration akHost, Actor akActor, Float afCur, Float afHeavyFloor, Float afNow, String asNextKey) Global
    ; Source resolution (the REV-149 creature-ambient resolver, reused):
    ; 0 indeterminate / 1 human / 2 creature. Indeterminate SKIPS cleanly.
    Int iSource = 0
    Actor inj = None
    Int nInj = StorageUtil.FormListCount(akActor, "sr.inflater.injector")
    If nInj > 0
        inj = StorageUtil.FormListGet(akActor, "sr.inflater.injector", 0) as Actor
    EndIf
    If !inj
        nInj = StorageUtil.FormListCount(akActor, "sr.inflater.analinjector")
        If nInj > 0
            inj = StorageUtil.FormListGet(akActor, "sr.inflater.analinjector", 0) as Actor
        EndIf
    EndIf
    If !inj
        akHost._Log("[SNBaka] FHU ambient expose: no injector recorded for " + akActor.GetDisplayName() + " -- skip (source indeterminate, REV-154)")
    Else
        Race r = inj.GetLeveledActorBase().GetRace()
        If !r
            akHost._Log("[SNBaka] FHU ambient expose: injector " + inj.GetDisplayName() + " has no race -- skip (source indeterminate, REV-154)")
        ElseIf StorageUtil.FormListCount(r, "sr.inflater.race.cum.effects") > 0
            iSource = 1    ; humanoid injector (the REV-149 humanoid test)
        Else
            iSource = 2    ; creature injector reads the creature class
        EndIf
    EndIf
    If iSource == 0
        StorageUtil.SetFloatValue(None, asNextKey, afNow + 60.0)
        Return
    EndIf
    ; Cue composition: band x source (sec.7 DRAFTs, register entry 34).
    Bool bHeavy = afCur >= afHeavyFloor
    String sBand = "noticeable"
    String sSrc = "human"
    If bHeavy
        sBand = "heavy"
    EndIf
    String desc
    If iSource == 2
        sSrc = "creature"
        If bHeavy
            desc = "Nearby characters cannot help staring at " + akActor.GetDisplayName() + "'s heavily distended belly; scandalized whispers spread that some beast has pumped them full."
        Else
            desc = "Nearby characters notice that " + akActor.GetDisplayName() + "'s belly is noticeably swollen and trade curious stares; a few mutter that some beast has left them stuffed."
        EndIf
    Else
        If bHeavy
            desc = "Nearby characters cannot help staring at " + akActor.GetDisplayName() + "'s heavily distended belly; scandalized whispers follow them wherever they move."
        Else
            desc = "Nearby characters notice that " + akActor.GetDisplayName() + "'s belly is noticeably swollen and trade curious stares; a few dare low, suggestive comments."
        EndIf
    EndIf
    akHost._Log("[SNBaka] FHU ambient expose: firing sdb_fhu_ambient for " + akActor.GetDisplayName() + " (amount " + afCur + ", band " + sBand + ", source " + sSrc + ")")
    SkyrimNetApi.RegisterEvent("sdb_fhu_ambient", desc, akActor, None)
    StorageUtil.SetFloatValue(None, asNextKey, afNow + 60.0)
    ; REV-154 (the 153/134f Follow-up Prompt pattern): the direct narration is
    ; a SEPARATE, MCM-gated surface -- sdb_fhu_ambient_narr.yaml matches the
    ; sdb_fhu_ambient_narr event type ONLY (guidance = sec.7 DRAFT, register
    ; entry 34). The gated event's own desc is a plain marker (the rendered
    ; text lives in the yaml); no template variables per the D8/sec.137 rule.
    If akHost.bFHUAmbientNarration
        akHost._Log("[SNBaka] FHU ambient expose: ambient narration ON -- narration event fired (REV-154)")
        SkyrimNetApi.RegisterEvent("sdb_fhu_ambient_narr", "[sdb_fhu_ambient_narr] Follow-up narration moment for the ambient bystander cue.", akActor, None)
    Else
        akHost._Log("[SNBaka] FHU ambient expose: ambient narration OFF -- narration skipped (REV-154)")
    EndIf
EndFunction

; ---- FHU INFLATION AWARENESS (Task 3b: fallback poll design) ----
; [REV-149] The v1 comment block + the REV-96-moved HandleFHUStartSignal /
; PollLevels / _FireChange bodies that lived HERE are RETIRED -- the REV-149
; rewrites (chunks 1-4, above) supersede them. History: sr_InfEventManager's
; broadcast system exists to register REFERENCE-ALIAS event scripts (esp records
; in sr_FillHerUp.esp -- out of Papyrus-only scope; flagged, not improvised);
; FHU's ModEvents carry no per-actor payload (sr.inflater.start/.absorb are
; parameterless; fhu.playerInflated / fhu.playerCumUpdate are player-only); the
; per-actor surface is StorageUtil (sr.inflater.amount + REV-149's per-orifice
; cum.vaginal/.anal/.oral reads). Deflation detection stays poll-delta based
; (the SpermOut ability path exposes no event); sr.inflater.start is used ONLY
; as an immediate-poll nudge (now via HandleFHUStartSignal, above).

