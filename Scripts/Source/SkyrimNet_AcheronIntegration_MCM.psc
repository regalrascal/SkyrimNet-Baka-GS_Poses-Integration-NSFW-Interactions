Scriptname SkyrimNet_AcheronIntegration_MCM extends SKI_ConfigBase
; MCM for the Acheron<->SkyrimNet bridge. Settings live in StorageUtil (player-keyed) so there is NO CK
; property link to the bridge quest to maintain — the bridge reads them each tick (_LoadSettings).

Actor Property PlayerRef Auto   ; optional; resolved lazily if unset

Int _enabledOID
Int _cueOID
Int _proxOID
Int _confirmOID
Int _creatureHandoffOID
Int _getUpKeyOID
Int _engageChanceOID
Int _debugLogOID

Actor Function _P()
    If !PlayerRef
        PlayerRef = Game.GetPlayer()
    EndIf
    Return PlayerRef
EndFunction

Event OnConfigInit()
    ModName = "Downed SkyrimNet (Acheron)"
    Pages = new String[1]
    Pages[0] = "Settings"
    ; Second safety net (see Downed_SkyrimNet.RunConsequence for the primary one and why it exists) —
    ; MCM init is reliable and happens on every game load, so this catches the bridge being dead even
    ; before the first defeat occurs this session. EnsureAlive() is a no-op if it's already ticking.
    SkyrimNet_AcheronIntegration bridge = Game.GetFormFromFile(0x000800, "SkyrimNet_AcheronIntegration.esp") as SkyrimNet_AcheronIntegration
    If bridge
        bridge.EnsureAlive()
    EndIf
EndEvent

Event OnPageReset(String page)
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("Downed state (Acheron bridge)")
    _enabledOID = AddToggleOption("Enabled",             StorageUtil.GetIntValue(_P(),   "SNAcheron.Enabled",     1) == 1)
    _cueOID     = AddSliderOption("Reminder Cue Interval", StorageUtil.GetFloatValue(_P(), "SNAcheron.CueInterval", 30.0),   "{0} s")
    _proxOID    = AddSliderOption("Creature Check Interval", StorageUtil.GetFloatValue(_P(), "SNAcheron.ProxInterval", 10.0), "{0} s")
    _confirmOID = AddSliderOption("Auto Get-Up Timer",    StorageUtil.GetFloatValue(_P(), "SNAcheron.AutoGetUpSeconds", 600.0), "{0} s")
    _creatureHandoffOID = AddToggleOption("Creature Pounce On Recovery", StorageUtil.GetIntValue(_P(), "SNAcheron.CreatureHandoff", 1) == 1)
    _getUpKeyOID = AddKeyMapOption("Get-Up Key (hold 3s)", StorageUtil.GetIntValue(_P(), "SNAcheron.GetUpKey", 51))
    _engageChanceOID = AddSliderOption("Creature Engagement Chance", StorageUtil.GetFloatValue(_P(), "SNAcheron.CreatureEngageChance", 50.0), "{0}%")
    _debugLogOID = AddToggleOption("Enable Debug Logging", StorageUtil.GetIntValue(_P(), "SNAcheron.DebugLog", 1) == 1)
EndEvent

Event OnOptionSelect(Int option)
    If option == _enabledOID
        Int v = 1 - StorageUtil.GetIntValue(_P(), "SNAcheron.Enabled", 1)
        StorageUtil.SetIntValue(_P(), "SNAcheron.Enabled", v)
        SetToggleOptionValue(_enabledOID, v == 1)
    ElseIf option == _creatureHandoffOID
        Int v2 = 1 - StorageUtil.GetIntValue(_P(), "SNAcheron.CreatureHandoff", 1)
        StorageUtil.SetIntValue(_P(), "SNAcheron.CreatureHandoff", v2)
        SetToggleOptionValue(_creatureHandoffOID, v2 == 1)
    ElseIf option == _debugLogOID
        Int v3 = 1 - StorageUtil.GetIntValue(_P(), "SNAcheron.DebugLog", 1)
        StorageUtil.SetIntValue(_P(), "SNAcheron.DebugLog", v3)
        SetToggleOptionValue(_debugLogOID, v3 == 1)
    EndIf
EndEvent

Event OnOptionKeyMapChange(Int option, Int keyCode, String conflictControl, String conflictName)
    If option == _getUpKeyOID
        StorageUtil.SetIntValue(_P(), "SNAcheron.GetUpKey", keyCode)
        SetKeyMapOptionValue(_getUpKeyOID, keyCode)
    EndIf
EndEvent

Event OnOptionSliderOpen(Int option)
    If option == _cueOID
        SetSliderDialogStartValue(StorageUtil.GetFloatValue(_P(), "SNAcheron.CueInterval", 30.0))
        SetSliderDialogDefaultValue(30.0)
        SetSliderDialogRange(10.0, 120.0)
        SetSliderDialogInterval(5.0)
    ElseIf option == _proxOID
        SetSliderDialogStartValue(StorageUtil.GetFloatValue(_P(), "SNAcheron.ProxInterval", 10.0))
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(5.0, 60.0)
        SetSliderDialogInterval(5.0)
    ElseIf option == _confirmOID
        SetSliderDialogStartValue(StorageUtil.GetFloatValue(_P(), "SNAcheron.AutoGetUpSeconds", 600.0))
        SetSliderDialogDefaultValue(600.0)
        SetSliderDialogRange(60.0, 3600.0)
        SetSliderDialogInterval(30.0)
    ElseIf option == _engageChanceOID
        SetSliderDialogStartValue(StorageUtil.GetFloatValue(_P(), "SNAcheron.CreatureEngageChance", 50.0))
        SetSliderDialogDefaultValue(50.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(5.0)
    EndIf
EndEvent

Event OnOptionSliderAccept(Int option, Float value)
    If option == _cueOID
        StorageUtil.SetFloatValue(_P(), "SNAcheron.CueInterval", value)
        SetSliderOptionValue(_cueOID, value, "{0} s")
    ElseIf option == _proxOID
        StorageUtil.SetFloatValue(_P(), "SNAcheron.ProxInterval", value)
        SetSliderOptionValue(_proxOID, value, "{0} s")
    ElseIf option == _confirmOID
        StorageUtil.SetFloatValue(_P(), "SNAcheron.AutoGetUpSeconds", value)
        SetSliderOptionValue(_confirmOID, value, "{0} s")
    ElseIf option == _engageChanceOID
        StorageUtil.SetFloatValue(_P(), "SNAcheron.CreatureEngageChance", value)
        SetSliderOptionValue(_engageChanceOID, value, "{0}%")
    EndIf
EndEvent

Event OnOptionHighlight(Int option)
    If option == _enabledOID
        SetInfoText("Master switch for the downed-state bridge (holding, downed cues, recovery).")
    ElseIf option == _cueOID
        SetInfoText("How often, while an actor is down, we send a short 'still downed' reminder. Purely narrative - does not affect recovery timing. Default 30 s.")
    ElseIf option == _proxOID
        SetInfoText("How often we check for a nearby CREATURE, purely to give Baka's creature-escalation pipeline a shot. Does not affect recovery - proximity no longer gates getting up at all. Default 10 s.")
    ElseIf option == _confirmOID
        SetInfoText("NPCs ONLY: hard ceiling on how long an abandoned, unattended down lasts before they get up on their own - NPCs have no get-up key, so this stands in for it. The PLAYER never auto-recovers: get-up key, being helped, or winning a QTE are the only ways up. Resets to the full duration whenever someone interacts with the victim (a struggle, choke, inspect, escalation, etc.), so it never expires mid-scene. Default 600 s (10 min).")
    ElseIf option == _creatureHandoffOID
        SetInfoText("When a downed actor is about to recover because nobody's around, give Baka's creature-escalation pipeline one shot at taking them first, instead of just calming the creature and standing them up. Requires Baka's own 'Creature Escalation' switch (and, for the player, 'Can Target the Player') to ALSO be on in Baka's MCM - this only gates the attempt on the Acheron side. Default ON; harmless if Baka is absent or its own switches are off.")
    ElseIf option == _getUpKeyOID
        SetInfoText("Hold this key for 3 seconds while downed (by any means) to attempt a struggle QTE and stand up on your own, independent of any NPC or LLM ever helping you up. Winning frees you immediately with a cue; losing fires its own 'tried and failed' cue so the LLM can react. Default: Comma.")
    ElseIf option == _engageChanceOID
        SetInfoText("Chance a nearby creature bothers engaging at all once nobody able is around, rolled fresh every confirm cycle - not one-shot. After a scene ends, it can roll again and re-engage. At 100% this can loop indefinitely by design; lower it if you want downed actors to reliably get free. Default 50%.")
    ElseIf option == _debugLogOID
        SetInfoText("Write this bridge's detailed traces to the Papyrus log. Keep ON while testing/reporting issues; turn OFF for less script-engine load during normal play.")
    EndIf
EndEvent
