# rev161_gates.ps1 - [REV-161] ship-gate sentinels (grep-the-string on the zip)
$ErrorActionPreference = 'Stop'
$root  = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$zPath = Join-Path $root 'dist\[REV-161] Delectatio-et-Dominium dogfood-continuation-polish.zip'
$fail = 0
function Log($m) { Write-Output $m }
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($zPath)
try {
  $cache = @{}
  function ZipText([string]$rel) {
    if ($cache.ContainsKey($rel)) { return $cache[$rel] }
    $e = $zip.Entries | Where-Object { $_.FullName.Replace('\','/') -eq $rel } | Select-Object -First 1
    if (-not $e) { return $null }
    $r = New-Object System.IO.StreamReader($e.Open(), [System.Text.Encoding]::ASCII)
    $t = $r.ReadToEnd(); $r.Close(); $cache[$rel] = $t; return $t
  }
  function Check([string]$label, [bool]$ok) { if ($ok) { Log "  PASS  $label" } else { Log "  FAIL  $label"; $script:fail++ } }
  Log '--- v1: 2.1 lock-release fix (PSC IN-ZIP) ---'
  $psc = ZipText 'Scripts/Source/SkyrimNet_BakaIntegration.psc'
  if (-not $psc) { $psc = ZipText 'Scripts/SkyrimNet_BakaIntegration.psc' }
  Check 'BakaIntegration psc present IN-ZIP' ($null -ne $psc)
  if ($psc) {
    Check '2.1 fix: SNBaka.Locked mentions >= 2 in the psc' (([regex]::Matches($psc, [regex]::Escape('SNBaka.Locked'))).Count -ge 2)
  }
  Log '--- v2/v3: 2.2 view-gate fix (PrismaUI IN-ZIP) ---'
  $v = ZipText 'PrismaUI/views/SNBaka_ExecuteConfirm/index.html'
  Check '2.2 gate: file:///views/ guard in SNBaka_ExecuteConfirm' ($null -ne $v -and $v.Contains('file:///views/'))
  $m = ZipText 'PrismaUI/views/SNBaka_Menu/index.html'
  Check '2.2 gate: guard in SNBaka_Menu' ($null -ne $m -and $m.Contains('file:///views/'))
  Log '--- v4: 2.3b category-as-action warning (DLLs IN-ZIP, binary) ---'
  foreach ($rel in 'SKSE/Plugins/SkyrimNet_BakaIntegration.dll','SKSE/Plugins/SNAnimGS_UI.dll') {
    $e = $zip.Entries | Where-Object { $_.FullName.Replace('\','/') -eq $rel } | Select-Object -First 1
    Check "$rel IN-ZIP" ($null -ne $e)
    if ($e) {
      $ms = New-Object System.IO.MemoryStream
      $e.Open().CopyTo($ms)
      $t = [System.Text.Encoding]::ASCII.GetString($ms.ToArray())
      Check "$rel carries THIS NAME IS A CATEGORY, NOT A CALLABLE ACTION" ($t.Contains('THIS NAME IS A CATEGORY, NOT A CALLABLE ACTION'))
    }
  }
  Log '--- v5: 2.3a twerk routing + 4.3 pose enrichment (yamls IN-ZIP) ---'
  $pd = ZipText 'SKSE/Plugins/SkyrimNet/external/regalrascal.gs-poses/actions/posedancesexy.yaml'
  Check 'posedancesexy.yaml: Twerking IS this action' ($null -ne $pd -and $pd.Contains('Twerking IS this action'))
  Check 'posedancesexy.yaml: THE POOL THIS ACTION DRAWS FROM (priority set)' ($null -ne $pd -and $pd.Contains('THE POOL THIS ACTION DRAWS FROM'))
  $poolCount = 0
  foreach ($n in 'posedance','posedancesexy','posegroundsexy','posegroundidle','poseseduce','posepresent','poseselftouch','posestretch','poseworkout','posesubmission','poseplead','poseidle') {
    $t = ZipText "SKSE/Plugins/SkyrimNet/external/regalrascal.gs-poses/actions/$n.yaml"
    if ($t -and $t.Contains('THE POOL THIS ACTION DRAWS FROM')) { $poolCount++ }
  }
  Check "pose enrichment batch: 12/12 pose yamls carry the pool line (found $poolCount)" ($poolCount -eq 12)

  Log '--- v6: 4.1 CommandTattoo wording + down.yaml Execute mention ---'
  $ct = ZipText 'SKSE/Plugins/SkyrimNet/external/regalrascal.baka-gs-integration/actions/CommandTattoo.yaml'
  Check 'CommandTattoo: mark their skin' ($null -ne $ct -and $ct.Contains('mark their skin'))
  Check 'CommandTattoo: give them a tattoo' ($null -ne $ct -and $ct.Contains('give them a tattoo'))
  Check 'CommandTattoo: brand them with my mark' ($null -ne $ct -and $ct.Contains('brand them with my mark'))
  Check 'CommandTattoo: KILL VS INK distinction' ($null -ne $ct -and $ct.Contains('KILL VS INK'))
  $dn = ZipText 'SKSE/Plugins/SkyrimNet/external/regalrascal.baka-gs-integration/actions/down.yaml'
  Check 'down.yaml: Execute mention' ($null -ne $dn -and $dn.Contains('deliberate killing blow (Execute)'))
  Check 'down.yaml: Oldcustard PR #2 credit' ($null -ne $dn -and $dn.Contains('Oldcustard PR #2'))
  Log '--- v7: 4.2 tattoo ambient recast (pex IN-ZIP) ---'
  $st = ZipText 'Scripts/SNBaka_SlaveTatsModule.pex'
  Check 'recast cue: others-first wording IN-PEX' ($null -ne $st -and $st.Contains('grow newly aware of it too'))
  Log '--- v8: 4.4 MCM cadence sliders (DeD_MCM.pex IN-ZIP) ---'
  $mc = ZipText 'Scripts/DeD_MCM.pex'
  Check 'v18 canary marker present' ($null -ne $mc -and $mc.Contains('SNBaka.MCMDeD.v18'))
  Check 'v18 OnVersionUpdate canary text present' ($null -ne $mc -and $mc.Contains('v18 OnVersionUpdate'))
  Check 'slider label Ambient Cue Interval present (pex string table dedupes; 1 entry = 3 rows)' ($null -ne $mc -and (([regex]::Matches($mc, [regex]::Escape('Ambient Cue Interval'))).Count -ge 1))
  Check 'SNBaka.FHUAmbientCadence key present' ($null -ne $mc -and $mc.Contains('SNBaka.FHUAmbientCadence'))
  Check 'SNBaka.CumAmbientCadence key present' ($null -ne $mc -and $mc.Contains('SNBaka.CumAmbientCadence'))
  Check 'SNBaka.ST.AmbientFloor key present' ($null -ne $mc -and $mc.Contains('SNBaka.ST.AmbientFloor'))
  $fh = ZipText 'Scripts/SNBaka_FHUInflationModule.pex'
  Check 'FHU module reads the cadence key' ($null -ne $fh -and $fh.Contains('SNBaka.FHUAmbientCadence'))
  $cu = ZipText 'Scripts/SNBaka_CumDetectionModule.pex'
  Check 'Cum module reads the cadence key' ($null -ne $cu -and $cu.Contains('SNBaka.CumAmbientCadence'))
  Log '--- v9: retired-set ABSENT checks ---'
  Check 'retired MCM script name ABSENT across zip' (-not ($zip.Entries | Where-Object { $_.FullName -match 'SkyrimNet_BakaIntegration_MCM' }))
  Check 'retired FHU title Inflation Level Cues ABSENT in pex' ($null -eq $mc -or -not $mc.Contains('Inflation Level Cues'))
  Check 'retired Mephala Mode exact toggle ABSENT in pex' ($null -eq $mc -or -not $mc.Contains(('Mephala Mode' + [char]0)))
  Log '--- v10: narration-voice grep on the baka trigger set (instruction verbs ABSENT) ---'
  $nvHit = 0
  foreach ($n in 'baka_calloff','baka_defeat','baka_escalate','baka_interaction_end','baka_interaction_start','baka_intervention','baka_opportunity','baka_panic','baka_resist_fail','baka_resist_start','baka_resist_success','baka_sexlab_trigger') {
    $t = ZipText "SKSE/Plugins/SkyrimNet/external/regalrascal.baka-gs-integration/triggers/$n.yaml"
    if ($t) {
      foreach ($patt in 'Generate one','Do NOT','Match their personality exactly','do not just narrate') {
        if ($t.Contains($patt)) { $nvHit++; Log "  NV HIT: $n.yaml :: $patt" }
      }
    } else { $nvHit++; Log "  NV FAIL: $n.yaml missing from zip" }
  }
  Check "narration-voice: 0 instruction-verb hits in the 12 baka triggers (found $nvHit)" ($nvHit -eq 0)
  Log '--- v11: PR#2 fold sentinels (Oldcustard fix/creature-struggle-bugs, by-concept, REV-161) ---'
  $bk = ZipText 'Scripts/SkyrimNet_BakaIntegration.pex'
  Check 'PR#2 (1): _RTStampStale relaunch guard in Baka pex' ($null -ne $bk -and $bk.Contains('_RTStampStale'))
  Check 'PR#2 (2): cross-tree pacify reads GSAnim.Pacified in Baka pex' ($null -ne $bk -and $bk.Contains('GSAnim.Pacified'))
  $ag = ZipText 'Scripts/SkyrimNet_AnimationsGS.pex'
  Check 'PR#2 (2): GS-side shared original key SNBaka.OrigAggr in GS pex' ($null -ne $ag -and $ag.Contains('SNBaka.OrigAggr'))
  Check 'PR#2 (2): GS-side cross-check SNBaka.Pacified in GS pex' ($null -ne $ag -and $ag.Contains('SNBaka.Pacified'))
  Check 'PR#2 (7): abort victim-freed sentinel in Baka pex' ($null -ne $bk -and $bk.Contains('victim-freed (REV-161 PR#2 fold 7)'))
  Check 'PR#2 (6): threats-only hold threaded in psc' ($null -ne $psc -and $psc.Contains('_ProtectNearbyAllies(akVictim, akCreature, True, False)'))
} finally { $zip.Dispose() }
Log ('=== rev161 gates: ' + $(if ($fail -eq 0) { 'ALL PASS' } else { "$fail FAILURES" }) + ' ===')
exit $(if ($fail -eq 0) { 0 } else { 1 })
