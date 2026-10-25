# REV-165 gates: release-prep ship checklist v1-v10
$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$gsrepo = 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS'
$name = '[REV-165] Delectatio-et-Dominium v0.3.0-alpha release-prep'
$z = Join-Path $root ('dist\' + $name + '.zip')
$pub = Join-Path $root 'public-staging'
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

    # ---- v1: FOMOD (new text present, requirements absent, structure intact) ----
    $mcx = ZipText 'fomod/ModuleConfig.xml'
    $ixx = ZipText 'fomod/info.xml'
    Gate 'v1a zip FOMOD: 0.3.0-alpha moduleName PRESENT' ($mcx.Contains('Delectatio et Dominium (0.3.0-alpha)'))
    Gate 'v1b zip FOMOD: billboard Baka tooltip PRESENT' ($mcx.Contains('Every emergent NSFW moment in DeD starts here'))
    Gate 'v1c zip FOMOD: billboard GS tooltip PRESENT' ($mcx.Contains('Sheogorath Mode raises the intensity') -and $mcx.Contains('Sanguine Mode, the background daemon'))
    Gate 'v1d zip FOMOD: billboard FHU tooltip PRESENT' ($mcx.Contains('Inflation becomes part of the story'))
    Gate 'v1e zip FOMOD: billboard SlaveTats tooltip PRESENT' ($mcx.Contains('The body keeps the story'))
    Gate 'v1f zip FOMOD: billboard Acheron tooltip PRESENT' ($mcx.Contains('Losing a fight becomes a scene'))
    Gate 'v1g zip FOMOD: requirements text ABSENT (README-only)' (-not ($mcx.Contains('Prerequisites:') -or $ixx.Contains('Requirements: SKSE')))
    Gate 'v1h zip FOMOD: independence model line PRESENT' ($mcx.Contains('Unchecking this removes'))
    [xml]$mcParse = $mcx
    $srcs = $mcParse.SelectNodes('//@source') | ForEach-Object { $_.'#text' } | Where-Object { $_ -and $_ -notmatch '^\s*$' }
    $missing = @()
        foreach ($s in $srcs) { $sn = ($s -replace '\\','/'); if (-not ($zipEntries.Contains($sn) -or $zipEntries.Contains($sn + '/'))) { $missing += $s } }
    Gate ('v1i FOMOD parity: every @source exists in zip (' + $srcs.Count + ' sources)') ($missing.Count -eq 0)

    # ---- v2: README/CHANGELOG/RELEASE_NOTES (public-staging surfaces) ----
    $rdme = [IO.File]::ReadAllText((Join-Path $pub 'README.md'))
    Gate 'v2a README: requirements home section PRESENT' ($rdme.Contains('## Requirements') -and $rdme.Contains('### Core (always required)'))
    Gate 'v2b README: DeD Service + independence model rows PRESENT' ($rdme.Contains('### DeD Service') -and $rdme.Contains('**Independence model:**'))
    Gate 'v2c README: MCM overview (cadence sliders + narration toggles) PRESENT' ($rdme.Contains('Daemon cadence sliders') -and $rdme.Contains('Sanguine / Sheogorath mode narration'))
    Gate 'v2d README: honest-state notes (Execute experimental + 1.7 line + picker retirement) PRESENT' ($rdme.Contains('Execute action: experimental') -and $rdme.Contains('Address-Library architecture') -and $rdme.Contains('pose picker is retired'))
    Gate 'v2e README: credits Around906 FIRST among persons (Credits section)' ($rdme.Substring($rdme.IndexOf('## Credits')).IndexOf('Around906') -lt $rdme.Substring($rdme.IndexOf('## Credits')).IndexOf('Gunslicer'))
    Gate 'v2f README: Oldcustard PR #2 credit PRESENT' ($rdme.Contains('Oldcustard'))
    Gate 'v2g README: planner disclaimer VERBATIM (transcription line) PRESENT' ($rdme.Contains("*(Disclaimer text by the project's author, transcribed verbatim.)*"))
    Gate 'v2h README: v0.3.0-alpha roadmap line PRESENT' ($rdme.Contains('v0.3.0-alpha'))
    Gate 'v2i CHANGELOG: v0.3.0-alpha entry PRESENT (public)' (([IO.File]::ReadAllText((Join-Path $pub 'CHANGELOG.md'))).Contains('## v0.3.0-alpha'))
    Gate 'v2j RELEASE_NOTES draft PRESENT' (Test-Path (Join-Path $root 'releases\RELEASE_NOTES_v0.3.0-alpha.md'))

    # ---- v3: scrub classes ABSENT from the zip + public tree ----
    $bad = 0
    foreach ($e in $zip.Entries) {
        if ($e.FullName -notmatch '\.(xml|json|yaml|yml|prompt|psc|ini|txt|html|js|css|md|bat)$') { continue }
        $sr = New-Object IO.StreamReader($e.Open())
        try { $t = $sr.ReadToEnd() } finally { $sr.Dispose() }
        foreach ($p in @('Tristan','THEMAINFRAME','C:\Users\Tristan','.cline')) { if ($t.Contains($p)) { $bad++; Write-Host "  SCRUB HIT: $($e.FullName) :: $p" } }
    }
    Gate 'v3a zip text entries: PII/machine classes ZERO' ($bad -eq 0)
    $binbad = 0
    foreach ($f in (Get-ChildItem -LiteralPath (Join-Path $pub 'Scripts') -Filter '*.pex')) {
        $b = [Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes($f.FullName))
        foreach ($p in @('Tristan','THEMAINFRAME')) { if ($b.Contains($p)) { $binbad++; Write-Host "  PEX HIT: $($f.Name) :: $p" } }
    }
    Gate 'v3b public pex headers: identity strings ZERO (patched)' ($binbad -eq 0)
    $dirt = $zip.Entries | Where-Object { $_.FullName -match 'compile-out|gs-build|/docs/' }
    Gate 'v3c zip: compile-out / internal-dirs ABSENT' (@($dirt).Count -eq 0)
    # ---- v4: narration-voice grep (standing ship-gate, direct_narration surfaces) ----
    $tmp = Join-Path $env:TEMP ("rev165_zip_" + [guid]::NewGuid().ToString("N").Substring(0,8))
    [IO.Compression.ZipFile]::ExtractToDirectory($z, $tmp)
    try {
        $ext = Join-Path $tmp "SKSE\Plugins\SkyrimNet\external"
        $narrBad = 0
        foreach ($f in (Get-ChildItem -LiteralPath $ext -Recurse -Filter "*.yaml")) {
            $t = Get-Content -LiteralPath $f.FullName -Raw
            if ($t -notmatch ('type:\s*' + [char]34 + 'direct_narration' + [char]34)) { continue }
            foreach ($p in @("Never explain","Do not invent","Generate ","Match their personality","react in character","Do NOT","Pick ONE and do it now","never name any")) {
                if ($t.Contains($p)) { $narrBad++; Write-Host "  NARRATION-VOICE HIT: $($f.Name) :: $p" }
            }
        }
        Gate "v4 narration-voice grep: ZERO directive frames in direct_narration yamls" ($narrBad -eq 0)

        # ---- v5: content-validate EVERY external layer in the zip ----
        foreach ($lay in (Get-ChildItem -LiteralPath $ext -Directory | Sort-Object Name)) {
            $yamls = Get-ChildItem -LiteralPath $lay.FullName -Recurse -Include *.yaml,*.yml -File
            $probes = Get-ChildItem -LiteralPath $lay.FullName -Recurse -Include *.prompt -File
            $badv = @(); $n = 0
            foreach ($y in $yamls) { $n++
                $t = [IO.File]::ReadAllText($y.FullName)
                if ($t.Trim().Length -eq 0) { $badv += ("empty: " + $y.Name) }
                elseif ($t -notmatch "(?m)^\s*[A-Za-z_]+\s*:") { $badv += ("no top-level key: " + $y.Name) } }
            foreach ($p in $probes) {
                $t = [IO.File]::ReadAllText($p.FullName)
                if ($t.Trim().Length -eq 0) { $badv += ("empty prompt: " + $p.Name); continue }
                if ($p.FullName -notmatch ('\\' + 'prompts' + '\\' + 'submodules') -and $t -notmatch ('\[\s*system\s*\]')) { $badv += ('no [ system ] block: ' + $p.Name) } }
            Gate ("v5 content-validate layer " + $lay.Name) ($badv.Count -eq 0)
        }
    } finally { Remove-Item -LiteralPath $tmp -Recurse -Force }

    # ---- v7: psc lockstep (fork <-> GS-repo compile-source mirrors) ----
    $a = (Get-FileHash (Join-Path $root "Scripts\Source\SkyrimNet_BakaIntegration.psc")).Hash
    $b = (Get-FileHash (Join-Path $gsrepo "Scripts\Source\SkyrimNet_BakaIntegration.psc")).Hash
    Gate "v7a lockstep: SkyrimNet_BakaIntegration.psc fork == GS-repo compile source" ($a -eq $b)
    $c1 = (Get-FileHash (Join-Path $root "dll-source-gs\src\SkyrimNetBridge.cpp")).Hash
    $c2 = (Get-FileHash (Join-Path $gsrepo "dll-source\src\SkyrimNetBridge.cpp")).Hash
    Gate "v7b lockstep: dll-source-gs SkyrimNetBridge.cpp fork == GS-repo mirror" ($c1 -eq $c2)

    # ---- v8: zip integrity + manifest + release state ----
    Gate "v8a zip: 345 entries" ($zipEntries.Count -eq 345)
    Gate "v8b manifest-rev165 written" (Test-Path (Join-Path $root "releases\manifests\manifest-rev165.txt"))
    Gate 'v8c zip sha256 sidecar PRESENT' (Test-Path -LiteralPath ($z + '.sha256'))
    Gate "v8d info.xml version 0.3.0-alpha" (((Get-Content (Join-Path $root "fomod\info.xml") -Raw)) -match "<Version>0\.3\.0-alpha</Version>")
    $gs = git -C $pub status --porcelain
    $ahead = git -C $pub rev-list origin/main..main
    Gate 'v8e public-staging: release state committed on main, ahead of origin (push user-gated)' (@($ahead).Count -gt 0)
} finally { $zip.Dispose() }
# ---- v9: modlist write assertion (session end-diff, read-only) ----
& pwsh -NoProfile -File (Join-Path $root "gs-build\modlist_snapshot.ps1")
fc.exe /b (Join-Path $root "gs-build\modlist_baseline.txt") (Join-Path $root "gs-build\modlist_snapshot.txt") | Out-Null
Gate "v9 modlist assertion: mods tree + profiles UNCHANGED across the session" ($LASTEXITCODE -eq 0)

Write-Host ""
if ($fail -eq 0) { Write-Host "REV-165 GATES: ALL PASS" } else { Write-Host "REV-165 GATES: FAILURES PRESENT" }
exit $fail
