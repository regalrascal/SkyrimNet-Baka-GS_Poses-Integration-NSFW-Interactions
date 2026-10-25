$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$gsrepo = 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS'
$name = '[REV-164] Delectatio-et-Dominium six-issue-fixes'
$z = Join-Path $root ('dist\' + $name + '.zip')
$fail = 0
function Gate([string]$label, [bool]$ok) {
    if ($ok) { Write-Host "PASS -- $label" } else { Write-Host "FAIL -- $label"; $script:fail = 1 }
}
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [IO.Compression.ZipFile]::OpenRead($z)
try {
    $zipEntries = $zip.Entries | ForEach-Object { $_.FullName }
    function ZipText([string]$entry) {
        $e = $zip.GetEntry($entry)
        if (-not $e) { return $null }
        $sr = New-Object IO.StreamReader($e.Open())
        try { $sr.ReadToEnd() } finally { $sr.Dispose() }
    }
    function PexText([string]$file) {
        [Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes((Join-Path $root ('Compile Archive\compile-out-rev164\' + $file))))
    }

    # ---- v1: pex sentinels (compile-out, shipped bytes) ----
    $bk = PexText 'SkyrimNet_BakaIntegration.pex'
    Gate 'v1a pex: ApplyTattoo downed-gate string PRESENT' ($bk.Contains('apply lane gated'))
    Gate 'v1b pex: ApplyTattoo curated-fallback string PRESENT' ($bk.Contains('curated fallback'))
    Gate 'v1c pex: ApplyTattoo [nopacks] refuse PRESENT' ($bk.Contains('no spank set configured'))
    Gate 'v1d pex: bFHUAmbientNarration property PRESENT' ($bk.Contains('bFHUAmbientNarration'))
    $ach = PexText 'SkyrimNet_AcheronIntegration.pex'
    Gate 'v1e pex: Acheron DownCueCount key PRESENT' ($ach.Contains('DownCueCount'))
    Gate 'v1f pex: Acheron DownCueGateRT key PRESENT' ($ach.Contains('DownCueGateRT'))
    Gate 'v1g pex: Acheron 180s gate trace PRESENT' ($ach.Contains('gated 180s'))
    $fhu = PexText 'SNBaka_FHUInflationModule.pex'
    Gate 'v1h pex: FHU first-fire acceleration trace PRESENT' ($fhu.Contains('first ambient fires NOW'))

    # ---- v2: the choice-12 tile + dispatch branch RETIRED ----
    $html = [IO.File]::ReadAllText((Join-Path $root 'PrismaUI\views\SNBaka_Menu\index.html'))
    Gate 'v2a tree: Force Tattoo tile ABSENT from panel' (-not $html.Contains("'Force Tattoo'"))
    $psc = [IO.File]::ReadAllText((Join-Path $root 'Scripts\Source\SkyrimNet_BakaIntegration.psc'))
    $disp = $psc.Substring($psc.IndexOf('Function _DispatchDownedAction'))
    Gate 'v2b tree: downed dispatch no longer routes choice 12' (-not $disp.Contains('choice == 12'))
    Gate 'v2c tree: _ForcedTattoo_Execute RETAINED (daemon lane)' ($psc.Contains('Function _ForcedTattoo_Execute'))
    $zh = ZipText 'PrismaUI/views/SNBaka_Menu/index.html'
    Gate 'v2d zip: Force Tattoo tile ABSENT' (($null -ne $zh) -and (-not $zh.Contains("'Force Tattoo'")))

    # ---- v3: category description rewrites IN-BINARY (both DLLs) ----
    $bkdll = [Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes((Join-Path $root 'SKSE\Plugins\SkyrimNet_BakaIntegration.dll')))
    $gsdll = [Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes((Join-Path $root 'SKSE\Plugins\SNAnimGS_UI.dll')))
    Gate 'v3a BK DLL: new Display direction string PRESENT' ($bkdll.Contains('Command or savor a display FROM the target'))
    Gate 'v3b BK DLL: Display member list PRESENT' ($bkdll.Contains('ShowOffBody'))
    Gate 'v3c BK DLL: old Display string ABSENT' (-not $bkdll.Contains('show off your body for them'))
    Gate 'v3d BK DLL: new Pose audience string PRESENT' ($bkdll.Contains('someone asked to watch'))
    Gate 'v3e BK DLL: old Pose repeller ABSENT' (-not $bkdll.Contains('for no one in '))
    Gate 'v3f GS DLL: new Pose audience string PRESENT' ($gsdll.Contains('someone asked to watch'))
    Gate 'v3g GS DLL: old Pose repeller ABSENT' (-not $gsdll.Contains('for no one in '))
    Gate 'v3h zip: both rebuilt DLLs present' ((($zipEntries | Where-Object { $_ -eq 'SKSE/Plugins/SkyrimNet_BakaIntegration.dll' }).Count -gt 0) -and (($zipEntries | Where-Object { $_ -eq 'SKSE/Plugins/SNAnimGS_UI.dll' }).Count -gt 0))

    # ---- v4: the story-voice sweep (swept families, tree + zip) ----
    $ext = Join-Path $root 'SKSE\Plugins\SkyrimNet\external'
    $sweptYamls = @(
        'regalrascal.fhu-inflation\triggers\sdb_fhu_inflate.yaml',
        'regalrascal.fhu-inflation\triggers\sdb_fhu_creature_cum.yaml',
        'regalrascal.fhu-inflation\triggers\sdb_fhu_deflate_vaginal.yaml',
        'regalrascal.fhu-inflation\triggers\sdb_fhu_deflate_anal.yaml',
        'regalrascal.fhu-inflation\triggers\sdb_fhu_deflate_oral.yaml',
        'around906.acheron-integration\triggers\acheron_downed.yaml',
        'regalrascal.baka-gs-integration\triggers\sdb_mephala_mode_narr.yaml',
        'regalrascal.baka-gs-integration\triggers\sdb_molagbal_mode_narr.yaml',
        'regalrascal.gs-poses\triggers\gsanim_sanguine_mode_narr.yaml',
        'regalrascal.gs-poses\triggers\gsanim_sheogorath_mode_narr.yaml',
        'regalrascal.gs-poses\actions\posegroundidle.yaml',
        'regalrascal.gs-poses\actions\poseidle.yaml',
        'regalrascal.gs-poses\actions\poseplead.yaml',
        'regalrascal.gs-poses\actions\posestretch.yaml',
        'regalrascal.gs-poses\actions\posesubmission.yaml',
        'regalrascal.gs-poses\actions\poseworkout.yaml',
        'regalrascal.gs-poses\actions\posedancesexy.yaml',
        'regalrascal.gs-poses\actions\posegroundsexy.yaml',
        'regalrascal.gs-poses\actions\posepresent.yaml',
        'regalrascal.gs-poses\actions\poseselftouch.yaml',
        'regalrascal.gs-poses\actions\poseseduce.yaml'
    )
    $badPatterns = @('Never explain', 'never name any', 'Never name any', 'Do not invent', 'DO NOT USE', 'FEMALE CHARACTERS ONLY', 'How the moment shows')
    $remn = 0
    foreach ($rel in $sweptYamls) {
        $t = [IO.File]::ReadAllText((Join-Path $ext $rel))
        foreach ($p in $badPatterns) { if ($t.Contains($p)) { $remn++; Write-Host "  REMNANT: $rel :: $p" } }
        $ze = ZipText ('SKSE/Plugins/SkyrimNet/external/' + ($rel -replace '\\','/'))
        if ($ze) { foreach ($p in $badPatterns) { if ($ze.Contains($p)) { $remn++; Write-Host "  ZIP REMNANT: $rel :: $p" } } }
    }
    Gate 'v4 tree+zip: ZERO instructional remnants in the 21 swept yamls' ($remn -eq 0)

    # ---- v4b: narration-voice grep (standing ship-gate scope, direct_narration surfaces) ----
    $narrBad = 0
    foreach ($f in (Get-ChildItem -LiteralPath $ext -Recurse -Filter '*.yaml' | Where-Object { (Get-Content -LiteralPath $_.FullName -Raw) -match 'type:\s*"direct_narration"' })) {
        $t = Get-Content -LiteralPath $f.FullName -Raw
        foreach ($p in @('Never explain', 'Do not invent', 'Generate ', 'Match their personality', 'react in character', 'Do NOT', 'Pick ONE and do it now', 'never name any')) {
            if ($t.Contains($p)) { $narrBad++; Write-Host "  NARRATION-VOICE HIT: $($f.Name) :: $p" }
        }
    }
    Gate 'v4b narration-voice grep: ZERO directive frames in direct_narration yamls' ($narrBad -eq 0)

    # ---- v5: user-quoted inflate pattern + cue-cap constants ----
    $inf = [IO.File]::ReadAllText((Join-Path $ext 'regalrascal.fhu-inflation\triggers\sdb_fhu_inflate.yaml'))
    Gate 'v5a tree: user-quoted inflate pattern PRESENT' ($inf.Contains('has swollen with cum'))
    $dwn = [IO.File]::ReadAllText((Join-Path $ext 'around906.acheron-integration\triggers\acheron_downed.yaml'))
    Gate 'v5b tree: acheron_downed cooldown 60' ($dwn.Contains('cooldownSeconds: 60'))
    Gate 'v5c tree: acheron_downed neutral order (HelpUp first, Execute last)' ($dwn.IndexOf('HelpUp') -lt $dwn.IndexOf('Execute --'))
    $apscc = [IO.File]::ReadAllText((Join-Path $root 'Scripts\Source\SkyrimNet_AcheronIntegration.psc'))
    Gate 'v5d psc: cue-cap constants (3 fires / 60s spacing / 180s gate)' ($apscc.Contains('nCue >= 3') -and $apscc.Contains('< 60.0') -and $apscc.Contains('now + 180.0'))

    # ---- v6: ambient default flip + first-fire acceleration (tree) ----
    $bkpsc = [IO.File]::ReadAllText((Join-Path $root 'Scripts\Source\SkyrimNet_BakaIntegration.psc'))
    Gate 'v6a tree: bFHUAmbientNarration default True' ($bkpsc.Contains('Bool  Property bFHUAmbientNarration = True Auto'))
    $fhupsc = [IO.File]::ReadAllText((Join-Path $root 'Scripts\Source\SNBaka_FHUInflationModule.psc'))
    Gate 'v6b tree: first ambient fires at band entry' ($fhupsc.Contains('first ambient fires NOW'))

    # ---- v7: psc lockstep (fork <-> GS-repo compile-source mirrors) ----
    $a = (Get-FileHash (Join-Path $root 'Scripts\Source\SkyrimNet_BakaIntegration.psc')).Hash
    $b = (Get-FileHash (Join-Path $gsrepo 'Scripts\Source\SkyrimNet_BakaIntegration.psc')).Hash
    Gate 'v7a lockstep: SkyrimNet_BakaIntegration.psc fork == GS-repo compile source' ($a -eq $b)
    $c1 = (Get-FileHash (Join-Path $root 'dll-source-gs\src\SkyrimNetBridge.cpp')).Hash
    $c2 = (Get-FileHash (Join-Path $gsrepo 'dll-source\src\SkyrimNetBridge.cpp')).Hash
    Gate 'v7b lockstep: dll-source-gs SkyrimNetBridge.cpp fork == GS-repo mirror' ($c1 -eq $c2)

    # ---- v8: zip integrity + manifest ----
    Gate 'v8a zip: 345 entries' ($zipEntries.Count -eq 345)
    Gate 'v8b zip: re-voiced FHU inflate PRESENT' ((($zipEntries | Where-Object { $_ -match 'sdb_fhu_inflate\.yaml' }).Count -gt 0))
    Gate 'v8c zip: manifest-rev164 written' (Test-Path (Join-Path $root 'releases\manifests\manifest-rev164.txt'))
} finally {
    $zip.Dispose()
}

# ---- v9: modlist write assertion (session end-diff, read-only) ----
& pwsh -NoProfile -File (Join-Path $root 'gs-build\modlist_snapshot.ps1')
fc.exe /b (Join-Path $root 'gs-build\modlist_baseline.txt') (Join-Path $root 'gs-build\modlist_snapshot.txt') | Out-Null
Gate 'v9 modlist assertion: mods tree + profiles UNCHANGED across the session' ($LASTEXITCODE -eq 0)

Write-Host ''
if ($fail -eq 0) { Write-Host 'REV-164 GATES: ALL PASS' } else { Write-Host 'REV-164 GATES: FAILURES PRESENT' }
exit $fail
