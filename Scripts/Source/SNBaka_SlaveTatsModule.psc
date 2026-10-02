Scriptname SNBaka_SlaveTatsModule
; REV-72 SlaveTats module (recordless observer/detection class — module contract point 3,
; fomod.md §architecture). NO SexLab/OStim/etc types here; the only foreign API surface is
; SlaveTats itself (compile-stubbed in tools\compile\local; runtime resolved from whichever
; SlaveTats install wins MO2 priority — currently SlaveTatsNG 0.8.2, a strict superset of
; legacy SE per the REV-72 research, so this module's calls are safe under either).

; ------------------------------------------------------------------
; STATE (StorageUtil, "SNBaka.ST." prefix; player-keyed)
; ------------------------------------------------------------------
;   SNBaka.ST.Enabled        Int   1 = module active (default 1)
;   SNBaka.ST.ApplyOnSpank   Int   apply chosen set when spank heat rises (default 1)
;   SNBaka.ST.ApplyOnDefeat  Int   apply chosen set on defeat/downed (default 1)
;   SNBaka.ST.ApplyOnEscalation Int apply chosen set at escalation handoff (default 0)
;   SNBaka.ST.SpankSetSection / .SpankSetName   String  user-chosen degradation set (spank)
;   SNBaka.ST.DefeatSetSection / .DefeatSetName String  (defeat)
;   SNBaka.ST.EscalationSetSection / .EscalationSetName String (escalation)
;   SNBaka.ST.RefreshCount  Int   times RefreshPacks was invoked (diagnostic counter)
;   SNBaka.ST.SectionCount  Int   sections found in the last discovery pass (diagnostic)
;   SNBaka.ST.DiscoveredAt  Float game-time stamp of the last discovery pass
;   SNBaka.ST.Applied       StringList (actor-keyed) "section|name" entries this module applied
; ------------------------------------------------------------------

Bool Function Installed() Global
    ; Framework presence = the SlaveTats quest record loads from the esp (legacy SE esp, or
    ; the NG overwrite — NG's runtime SlaveTats.pex shadows SE's by MO2 priority, but both
    ; installs carry SlaveTats.esp; the record resolves either way).
    Return Game.GetFormFromFile(0x800, "SlaveTats.esp") != None
EndFunction

; SlaveTatsNG detection (REV-72 research 1d): NG's runtime SlaveTats.VERSION() returns
; SlaveTatsNG.VERSION() (e.g. "0.8.2"); legacy SE returns "1.0.0" (data-structure version).
; Rather than parsing version strings, probe the NG SKSE plugin directly (zero => absent).
Bool Function NGDetected() Global
    Return SKSE.GetPluginVersion("SlaveTatsNG") > 0
EndFunction

; ------------------------------------------------------------------
; DISCOVERY (REV-72 research 1a/1c)
; ------------------------------------------------------------------
; SlaveTats discovers packs purely from the filesystem: compile_cache() JContainers-scans
; Data\Textures\Actors\Character\slavetats\*.json into the JDB cache at .SlaveTats.cache.
; Under MO2, a DISABLED pack is entirely absent from the virtual Data tree — so the
; discovered list reflects MO2-ENABLED packs only. Enabling a pack in MO2 (with MO2 closed
; or before launch) + Refresh in the MCM picks it up WITHOUT a game restart.
; ------------------------------------------------------------------

; Rebuild the SlaveTats cache from disk. Picks up newly MO2-enabled packs mid-session.
; compile_cache() pools everything it allocates and stores the result in the JDB global;
; release_cache() drops the old in-memory copy first so no stale entries linger.
Function RefreshPacks() Global
    If !Installed()
        Return
    EndIf
    SlaveTats.release_cache()
    Int cache = SlaveTats.compile_cache()
    Actor p = Game.GetPlayer()
    StorageUtil.SetIntValue(p, "SNBaka.ST.RefreshCount", StorageUtil.GetIntValue(p, "SNBaka.ST.RefreshCount", 0) + 1)
    If cache != 0
        Int sectionCount = _EnumerateSections(cache)
        StorageUtil.SetIntValue(p, "SNBaka.ST.SectionCount", sectionCount)
        StorageUtil.SetFloatValue(p, "SNBaka.ST.DiscoveredAt", Utility.GetCurrentGameTime())
        Debug.Trace("[SNBaka.ST] RefreshPacks: rebuilt cache — " + sectionCount + " sections discovered")
    Else
        Debug.Trace("[SNBaka.ST] RefreshPacks: compile_cache() returned 0 — no packs visible (are any enabled in MO2?)")
    EndIf
EndFunction

; Walk cache -> domain "default" -> areas -> sections; return the number of sections.
; Read-only on the framework-owned cache; retains nothing.
Int Function _EnumerateSections(Int cache) Global
    If cache == 0
        Return 0
    EndIf
    Int dom = JMap.getObj(cache, "default")
    If dom == 0
        Return 0
    EndIf
    String[] areas = JMap.allKeysPArray(dom)
    Int n = 0
    Int i = 0
    While i < areas.Length
        Int area = JMap.getObj(dom, areas[i])
        If area != 0
            n += JMap.count(area)
        EndIf
        i += 1
    EndWhile
    Return n
EndFunction

; ------------------------------------------------------------------
; APPLY / REMOVE (Baka's exact call convention: cf. ApplySpankMark L9143)
; ------------------------------------------------------------------

; Apply one tattoo entry. Returns true if SlaveTats accepted the call.
Bool Function ApplyTattoo(Actor akTarget, String asSection, String asName, Bool abSilent = True) Global
    If !akTarget || !Installed()
        Return False
    EndIf
    Return SlaveTats.simple_add_tattoo(akTarget, asSection, asName, 0, True, abSilent, 1.0)
EndFunction

; Remove one tattoo entry.
Bool Function RemoveTattoo(Actor akTarget, String asSection, String asName, Bool abSilent = True) Global
    If !akTarget || !Installed()
        Return False
    EndIf
    Return SlaveTats.simple_remove_tattoo(akTarget, asSection, asName, True, abSilent)
EndFunction

; Remove every entry the module applied to this actor (own bookkeeping list; never touches
; the framework's "SkyrimNet Spank" section entries applied by Baka's spank system).
Function RemoveAllFromActor(Actor akTarget) Global
    If !akTarget
        Return
    EndIf
    Int cnt = StorageUtil.StringListCount(akTarget, "SNBaka.ST.Applied")
    Int i = cnt
    While i > 0
        i -= 1
        String entry = StorageUtil.StringListGet(akTarget, "SNBaka.ST.Applied", i)
        Int sep = StringUtil.Find(entry, "|")
        If sep > 0
            RemoveTattoo(akTarget, StringUtil.Substring(entry, 0, sep), StringUtil.Substring(entry, sep + 1))
        EndIf
    EndWhile
    StorageUtil.StringListClear(akTarget, "SNBaka.ST.Applied")
EndFunction

; ------------------------------------------------------------------
; EVENT HOOKS (motherboard-called; per-event toggles gate them)
; ------------------------------------------------------------------
; These EXTEND Baka's spank-mark system (approved 2b design): the existing "SkyrimNet
; Spank" heat-stage marks are untouched; a user-chosen set from a discovered pack is
; applied ALONGSIDE when the event fires and the toggle is on.
; ------------------------------------------------------------------

; Spank-heat event: called from ApplySpankMark after Baka's own marks.
Function OnSpankHeat(Actor akTarget) Global
    Actor p = Game.GetPlayer()
    If !akTarget || StorageUtil.GetIntValue(p, "SNBaka.ST.Enabled", 1) != 1
        Return
    EndIf
    If StorageUtil.GetIntValue(p, "SNBaka.ST.ApplyOnSpank", 1) != 1
        Return
    EndIf
    String section = StorageUtil.GetStringValue(p, "SNBaka.ST.SpankSetSection", "")
    String name = StorageUtil.GetStringValue(p, "SNBaka.ST.SpankSetName", "")
    If section == "" || name == ""
        Return    ; no set chosen yet — nothing to extend with
    EndIf
    If ApplyTattoo(akTarget, section, name)
        StorageUtil.StringListAdd(akTarget, "SNBaka.ST.Applied", section + "|" + name, True)
        Debug.Trace("[SNBaka.ST] OnSpankHeat: applied '" + name + "' (" + section + ") to " + akTarget.GetDisplayName())
    EndIf
EndFunction

; Defeat/downed event: called from the motherboard's defeat path.
Function OnDefeat(Actor akVictim) Global
    Actor p = Game.GetPlayer()
    If !akVictim || StorageUtil.GetIntValue(p, "SNBaka.ST.Enabled", 1) != 1
        Return
    EndIf
    If StorageUtil.GetIntValue(p, "SNBaka.ST.ApplyOnDefeat", 1) != 1
        Return
    EndIf
    String section = StorageUtil.GetStringValue(p, "SNBaka.ST.DefeatSetSection", "")
    String name = StorageUtil.GetStringValue(p, "SNBaka.ST.DefeatSetName", "")
    If section == "" || name == ""
        Return
    EndIf
    If ApplyTattoo(akVictim, section, name)
        StorageUtil.StringListAdd(akVictim, "SNBaka.ST.Applied", section + "|" + name, True)
        Debug.Trace("[SNBaka.ST] OnDefeat: applied '" + name + "' (" + section + ") to " + akVictim.GetDisplayName())
    EndIf
EndFunction

; Escalation handoff event: called from the motherboard's escalation path.
Function OnEscalation(Actor akVictim) Global
    Actor p = Game.GetPlayer()
    If !akVictim || StorageUtil.GetIntValue(p, "SNBaka.ST.Enabled", 1) != 1
        Return
    EndIf
    If StorageUtil.GetIntValue(p, "SNBaka.ST.ApplyOnEscalation", 0) != 1
        Return
    EndIf
    String section = StorageUtil.GetStringValue(p, "SNBaka.ST.EscalationSetSection", "")
    String name = StorageUtil.GetStringValue(p, "SNBaka.ST.EscalationSetName", "")
    If section == "" || name == ""
        Return
    EndIf
    If ApplyTattoo(akVictim, section, name)
        StorageUtil.StringListAdd(akVictim, "SNBaka.ST.Applied", section + "|" + name, True)
        Debug.Trace("[SNBaka.ST] OnEscalation: applied '" + name + "' (" + section + ") to " + akVictim.GetDisplayName())
    EndIf
EndFunction

; ------------------------------------------------------------------
; FADING (NG-gated) — v1 SCOPE DECISION, RECORDED (user ruling, this rev):
; minimal-LLM-context v1 ships hard on/off for module-applied sets; the NG alpha-step
; fade curve (apply_overlay_ex) is deferred to the tweak pass/v2 with its own gate report.
; Rationale: the spank marks' own fade (FadeActorTats) is already NG-blind remove/re-add;
; a second fade path in v1 doubles the surface needing dogfood.
; ------------------------------------------------------------------

; ------------------------------------------------------------------
; LIFECYCLE (presence nudge from the motherboard, BakaSL pattern)
; ------------------------------------------------------------------

Function Arm() Global
    Debug.Trace("[SNBaka] module-arm: SlaveTats presence=" + Installed() + " NG=" + NGDetected())
EndFunction

; ------------------------------------------------------------------
; SET PICKING (PrismaUI SNSlaveTats_Menu, REV-72 Task 3)
; ------------------------------------------------------------------
; The cache groups tattoos as cache -> domain("default") -> area -> section -> name,
; and one section can span several areas (e.g. face + body entries of the same pack
; section). Enumeration therefore unions across areas.
; ------------------------------------------------------------------

; Unique section names discovered in the current cache (deduped across areas).
; Returns an empty array when SlaveTats is absent or the cache is empty.
String[] Function GetSections() Global
    String[] result = Utility.CreateStringArray(0)
    If !Installed()
        Return result
    EndIf
    Int cache = SlaveTats.acquire_cache()
    If cache == 0
        Return result
    EndIf
    Int dom = JMap.getObj(cache, "default")
    If dom != 0
        String[] areas = JMap.allKeysPArray(dom)
        Int a = 0
        While a < areas.Length
            Int area = JMap.getObj(dom, areas[a])
            If area != 0
                String[] secs = JMap.allKeysPArray(area)
                Int s = 0
                While s < secs.Length
                    If result.Find(secs[s]) < 0
                        result = PapyrusUtil.PushString(result, secs[s])
                    EndIf
                    s += 1
                EndWhile
            EndIf
            a += 1
        EndWhile
    EndIf
    SlaveTats.release_cache()
    Return result
EndFunction

; Build the SNSlaveTats_Menu JSON payload: current chosen sets + every discovered
; section with its tattoo names. Capped (60 sections / 30 names) so the JS payload
; stays sane for big installs; escaping is minimal (| and quotes are not expected in
; SlaveTats section/name keys).
String Function BuildMenuJSON() Global
    Actor p = Game.GetPlayer()
    String curSpank = StorageUtil.GetStringValue(p, "SNBaka.ST.SpankSetSection", "") + "|" + StorageUtil.GetStringValue(p, "SNBaka.ST.SpankSetName", "")
    String curDef   = StorageUtil.GetStringValue(p, "SNBaka.ST.DefeatSetSection", "") + "|" + StorageUtil.GetStringValue(p, "SNBaka.ST.DefeatSetName", "")
    String curEsc   = StorageUtil.GetStringValue(p, "SNBaka.ST.EscalationSetSection", "") + "|" + StorageUtil.GetStringValue(p, "SNBaka.ST.EscalationSetName", "")
    String json = "{\"spank\":\"" + curSpank + "\",\"defeat\":\"" + curDef + "\",\"escalation\":\"" + curEsc + "\",\"sections\":["
    String[] sections = GetSections()
    Int s = 0
    Int emitted = 0
    While s < sections.Length && emitted < 60
        String[] names = GetSetNames(sections[s])
        If names.Length > 0
            If emitted > 0
                json += ","
            EndIf
            json += "{\"n\":\"" + sections[s] + "\",\"t\":["
            Int n = 0
            Int nEmitted = 0
            While n < names.Length && nEmitted < 30
                If nEmitted > 0
                    json += ","
                EndIf
                json += "\"" + names[n] + "\""
                nEmitted += 1
                n += 1
            EndWhile
            json += "]}"
            emitted += 1
        EndIf
        s += 1
    EndWhile
    json += "]}"
    Return json
EndFunction

; Open the PrismaUI SlaveTats set-picker (SNSlaveTats_Menu view). The pick comes
; back through the DLL to the motherboard's _ST_MenuChoice(slot, section, name).
Function OpenSetMenu() Global
    If !Installed()
        Debug.Notification("SlaveTats is not installed — nothing to pick from.")
        Return
    EndIf
    If !SNBakaUI.IsAvailable()
        Debug.Notification("SlaveTats menu: PrismaUI / SNBaka DLL not ready.")
        Return
    EndIf
    RefreshPacks()
    SNBakaUI.ShowSlaveTatsMenu(BuildMenuJSON())
EndFunction

; Store one slot's pick ("spank"/"defeat"/"escalation"). Empty section/name clears
; the slot. Called from SkyrimNet_BakaIntegration._ST_MenuChoice (DLL dispatch).
Function SetChoice(String asSlot, String asSection, String asName) Global
    Actor p = Game.GetPlayer()
    If asSlot == "spank"
        StorageUtil.SetStringValue(p, "SNBaka.ST.SpankSetSection", asSection)
        StorageUtil.SetStringValue(p, "SNBaka.ST.SpankSetName", asName)
    ElseIf asSlot == "defeat"
        StorageUtil.SetStringValue(p, "SNBaka.ST.DefeatSetSection", asSection)
        StorageUtil.SetStringValue(p, "SNBaka.ST.DefeatSetName", asName)
    ElseIf asSlot == "escalation"
        StorageUtil.SetStringValue(p, "SNBaka.ST.EscalationSetSection", asSection)
        StorageUtil.SetStringValue(p, "SNBaka.ST.EscalationSetName", asName)
    Else
        Return
    EndIf
    If asSection == "" || asName == ""
        Debug.Notification("SlaveTats: " + asSlot + " set cleared.")
    Else
        Debug.Notification("SlaveTats: " + asSlot + " set = " + asSection + " | " + asName)
    EndIf
EndFunction

; Tattoo names inside one section (unioned across all areas that carry it).
String[] Function GetSetNames(String asSection) Global
    String[] result = Utility.CreateStringArray(0)
    If !Installed() || asSection == ""
        Return result
    EndIf
    Int cache = SlaveTats.acquire_cache()
    If cache == 0
        Return result
    EndIf
    Int dom = JMap.getObj(cache, "default")
    If dom != 0
        String[] areas = JMap.allKeysPArray(dom)
        Int a = 0
        While a < areas.Length
            Int area = JMap.getObj(dom, areas[a])
            If area != 0
                Int sec = JMap.getObj(area, asSection)
                If sec != 0
                    String[] names = JMap.allKeysPArray(sec)
                    Int n = 0
                    While n < names.Length
                        If result.Find(names[n]) < 0
                            result = PapyrusUtil.PushString(result, names[n])
                        EndIf
                        n += 1
                    EndWhile
                EndIf
            EndIf
            a += 1
        EndWhile
    EndIf
    SlaveTats.release_cache()
    Return result
EndFunction