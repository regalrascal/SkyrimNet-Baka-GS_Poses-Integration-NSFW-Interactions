# rev162_gates.ps1 - [REV-162] ship-gate sentinels (grep-the-string on the zip)
# Carries the standing v1-v10 checklist + the REV-162 additions:
#   NEW PRESENT: strip-hold 0.5s sentinel (psc+pex), the 27-member SNGS_Pose
#                category lists IN-BINARY (both DLLs), the 3 hoisted render_mode
#                guards (BIO_RULE receipt), the re-voiced fhu narration wording.
#   ABSENT: the standing retired set; 'now + 2.0' / 'the rest as listed'.
$ErrorActionPreference = 'Stop'
$root  = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$zPath = Join-Path $root 'dist\[REV-162] Delectatio-et-Dominium ingestion-fix-final-rulings.zip'
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
  function ZipBin([string]$rel) {
    $e = $zip.Entries | Where-Object { $_.FullName.Replace('\','/') -eq $rel } | Select-Object -First 1
    if (-not $e) { return $null }
    $ms = New-Object System.IO.MemoryStream
    $e.Open().CopyTo($ms)
    return [System.Text.Encoding]::ASCII.GetString($ms.ToArray())
  }
  function Check([string]$label, [bool]$ok) { if ($ok) { Log "  PASS  $label" } else { Log "  FAIL  $label"; $script:fail++ } }

  Log '--- v1: 4.1-b strip-hold watch 2s -> 0.5s (psc + pex IN-ZIP) ---'
  $psc = ZipText 'Scripts/Source/SkyrimNet_BakaIntegration.psc'
  if (-not $psc) { $psc = ZipText 'Scripts/SkyrimNet_BakaIntegration.psc' }
  Check 'BakaIntegration psc present IN-ZIP' ($null -ne $psc)
  if ($psc) {
    Check '4.1-b: psc arms now + 0.5 (both sites)' (([regex]::Matches($psc, [regex]::Escape('now + 0.5'))).Count -ge 2)
    Check '4.1-b: psc 2s-cadence wording ABSENT' (-not $psc.Contains('2s cadence'))
  }
  $bkPex = ZipText 'Scripts/SkyrimNet_BakaIntegration.pex'
  Check '4.1-b: strip-hold armed sentinel in pex (0.5s watch since REV-162 4.1-b)' ($null -ne $bkPex -and $bkPex.Contains('0.5s watch since REV-162 4.1-b'))

  Log '--- v2: Task 3 SNGS_Pose 27-member enumeration (both DLLs IN-ZIP, binary) ---'
  $newNames = 'PoseAroused','PoseAutograph','PoseBraceArm','PoseCrouch','PoseDance','PoseDogeza','PoseDrink','PoseDrool','PoseFood','PoseGroundIdle','PoseHandOnChin','PoseHandOnFace','PoseIdle','PoseKneel','PoseMeditate','PosePickpocket','PoseScratchHead','PoseSelfTouch','PoseSleep'
  foreach ($rel in 'SKSE/Plugins/SkyrimNet_BakaIntegration.dll','SKSE/Plugins/SNAnimGS_UI.dll') {
    $t = ZipBin $rel
    Check "$rel IN-ZIP" ($null -ne $t)
    if ($t) {
      Check "$rel carries 'the rest by name' (REV-162)" ($t.Contains('the rest by name'))
      Check "$rel 'and the rest as listed' ABSENT" (-not $t.Contains('and the rest as listed'))
      $miss = @($newNames | Where-Object { -not $t.Contains($_) })
      Check "$rel all 19 newly-listed member names present (missing: $($miss -join ','))" ($miss.Count -eq 0)
      Check "$rel 2.3b category-warning carry" ($t.Contains('THIS NAME IS A CATEGORY, NOT A CALLABLE ACTION'))
    }
  }

  Log '--- v3: SNGS_Pose membership integrity (all 27 member yamls IN-ZIP) ---'
  $gsPoses = 'posedance','posedancesexy','posegroundidle','posegroundsexy','poseidle','poseplead','posepresent','poseseduce','poseselftouch','posestretch','posesubmission','poseworkout'
  $bakaPoses = 'posearoused','poseautograph','posebracearm','posecrouch','posedogeza','posedrink','posedrool','posefood','posehandonchin','posehandonface','posekneel','posemeditate','posepickpocket','posescratchhead','posesleep'
  $missY = @()
  foreach ($n in $gsPoses)  { if (-not (ZipText "SKSE/Plugins/SkyrimNet/external/regalrascal.gs-poses/actions/$n.yaml")) { $missY += "gs:$n" } }
  foreach ($n in $bakaPoses) { if (-not (ZipText "SKSE/Plugins/SkyrimNet/external/regalrascal.baka-gs-integration/actions/$n.yaml")) { $missY += "baka:$n" } }
  Check "27 SNGS_Pose member yamls present (12 gs-poses + 15 baka; missing: $($missY -join ','))" ($missY.Count -eq 0)
  $poolCount = 0
  foreach ($n in $gsPoses) { $t = ZipText "SKSE/Plugins/SkyrimNet/external/regalrascal.gs-poses/actions/$n.yaml"; if ($t -and $t.Contains('THE POOL THIS ACTION DRAWS FROM')) { $poolCount++ } }
  Check "pose enrichment batch carry: 12/12 pool lines (found $poolCount)" ($poolCount -eq 12)

  Log '--- v4: ingestion-fix receipts (3 hoisted render_mode guards, BIO_RULE) ---'
  foreach ($n in '0175_ded_cum.prompt','0176_ded_fhu.prompt','0177_ded_tattoos.prompt') {
    $e = $zip.Entries | Where-Object { $_.FullName.Replace('\','/') -eq "SKSE/Plugins/SkyrimNet/external/regalrascal.baka-gs-integration/prompts/submodules/character_bio/$n" } | Select-Object -First 1
    Check "$n IN-ZIP" ($null -ne $e)
    if ($e) {
      $r = New-Object System.IO.StreamReader($e.Open(), [System.Text.Encoding]::ASCII)
      $first = $r.ReadLine(); $r.Close()
      Check "$n line 1 = render_mode guard (BIO_RULE compliant)" ($first -match '^\{% if render_mode')
    }
  }
  Log '--- v4b: re-voiced fhu narration wording ships (REV-161b carry, IN-ZIP) ---'
  $fhuN = ZipText 'SKSE/Plugins/SkyrimNet/external/regalrascal.fhu-inflation/triggers/sdb_fhu_inflate_narr.yaml'
  Check 'sdb_fhu_inflate_narr.yaml: re-voiced text (belly swells with warmth)' ($null -ne $fhuN -and $fhuN.Contains('belly swells with warmth'))

  Log '--- v5: 2.2 view-gate carry (PrismaUI IN-ZIP) ---'
  $v = ZipText 'PrismaUI/views/SNBaka_ExecuteConfirm/index.html'
  Check '2.2 gate: file:///views/ guard in SNBaka_ExecuteConfirm' ($null -ne $v -and $v.Contains('file:///views/'))
  $m = ZipText 'PrismaUI/views/SNBaka_Menu/index.html'
  Check '2.2 gate: guard in SNBaka_Menu' ($null -ne $m -and $m.Contains('file:///views/'))

  Log '--- v6: 4.4 MCM cadence slider carry (DeD_MCM.pex IN-ZIP) ---'
  $mc = ZipText 'Scripts/DeD_MCM.pex'
  Check 'v18 canary marker present' ($null -ne $mc -and $mc.Contains('SNBaka.MCMDeD.v18'))
  Check 'SNBaka.FHUAmbientCadence key present' ($null -ne $mc -and $mc.Contains('SNBaka.FHUAmbientCadence'))

  Log '--- v7: PR#2 fold carry (Baka + GS pex IN-ZIP) ---'
  $ag = ZipText 'Scripts/SkyrimNet_AnimationsGS.pex'
  Check 'PR#2 (2): SNBaka.OrigAggr in GS pex' ($null -ne $ag -and $ag.Contains('SNBaka.OrigAggr'))
  Check 'PR#2 (7): victim-freed sentinel in Baka pex' ($null -ne $bkPex -and $bkPex.Contains('victim-freed (REV-161 PR#2 fold 7)'))

  Log '--- v8: retired-set ABSENT ---'
  Check 'retired MCM script name ABSENT across zip' (-not ($zip.Entries | Where-Object { $_.FullName -match 'SkyrimNet_BakaIntegration_MCM' }))
  Check 'retired FHU title Inflation Level Cues ABSENT in pex' ($null -eq $mc -or -not $mc.Contains('Inflation Level Cues'))
  Check 'old 2s strip cadence ABSENT in pex (now + 2.0)' ($null -eq $bkPex -or -not $bkPex.Contains('now + 2.0'))

  Log '--- v9: narration-voice grep v10 (all direct_narration trigger yamls; occurrence #2 scope) ---'
  $nvHit = 0; $nvSwept = 0
  $nvYamls = $zip.Entries | Where-Object { $_.FullName -match 'triggers/.*\.yaml$' }
  foreach ($e in $nvYamls) {
    $t = ZipText $e.FullName
    if ($null -eq $t) { continue }
    if (-not $t.Contains('direct_narration')) { continue }
    $nvSwept++
    foreach ($patt in 'Generate one','Generate a','Do NOT','Do not explain','Match their personality','do not just narrate','are prompted to','is prompted to','One line or one action','Always answer','answer in character','Make at least','call the action') {
      if ($t.Contains($patt)) { $nvHit++; Log "  NV HIT: $($e.FullName) :: $patt" }
    }
  }
  Check "narration-voice: 0 instruction-verb hits across all $nvSwept direct_narration trigger yamls (found $nvHit)" ($nvHit -eq 0 -and $nvSwept -ge 20)

  Log '--- v10: zip integrity ---'
  Check 'zip entry count = 348' ($zip.Entries.Count -eq 348)
} finally { $zip.Dispose() }
Log ('=== rev162 gates: ' + $(if ($fail -eq 0) { 'ALL PASS' } else { "$fail FAILURES" }) + ' ===')
exit $(if ($fail -eq 0) { 0 } else { 1 })