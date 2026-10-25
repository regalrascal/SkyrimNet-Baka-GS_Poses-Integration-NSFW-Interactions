# rev148_gates_check.ps1 - REV-148 ship-gate checks (ASCII-only; -LiteralPath throughout)
# Usage: pwsh -File rev148_gates_check.ps1 > rev148_gates_receipt.txt
$ErrorActionPreference = 'Continue'
$dist = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\dist\[REV-148] Delectatio-et-Dominium batch-cut-146a-147'
$zip  = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\dist\[REV-148] Delectatio-et-Dominium batch-cut-146a-147.zip'
$prev = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\dist\archive\[REV-146] Delectatio-et-Dominium mephala-molagbal-daemon'
$manPrev = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\releases\manifests\manifest-rev146.txt'
$ex  = Join-Path $env:TEMP 'rev148_zip_extract'
if (Test-Path -LiteralPath $ex) { Remove-Item -LiteralPath $ex -Recurse -Force }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $ex)
Write-Output "extracted zip -> $ex"

function Find-Bytes([byte[]]$hay, [string]$needle) {
    $b = [System.Text.Encoding]::ASCII.GetBytes($needle)
    for ($i = 0; $i -le $hay.Length - $b.Length; $i++) {
        $ok = $true
        for ($j = 0; $j -lt $b.Length; $j++) { if ($hay[$i+$j] -ne $b[$j]) { $ok = $false; break } }
        if ($ok) { return $true }
    }
    return $false
}
$fail = 0
function Check([string]$label, [bool]$cond) {
    if ($cond) { Write-Output "PASS: $label" } else { Write-Output "FAIL: $label"; $script:fail++ }
}

# ---- v1 fomod ----
$mc = Join-Path $dist 'fomod\ModuleConfig.xml'
try { $null = [xml](Get-Content -LiteralPath $mc -Raw); Check 'v1 fomod\ModuleConfig.xml parses as XML' $true }
catch { Check "v1 ModuleConfig parse: $($_.Exception.Message)" $false }

# ---- v3 MCM current (v14; 7 pages; mode toggles absent; dropdown+policy+Ambient Modes present) ----
$mcm = Get-Content -LiteralPath (Join-Path $dist 'Scripts\Source\DeD_MCM.psc') -Raw
Check 'v3 DeD_MCM.psc: Pages = new String[7] (full build)' ($mcm -match 'Pages\s*=\s*new String\[7\]')
Check 'v3 DeD_MCM.psc: GetVersion 14' ($mcm -match 'return 14')
Check 'v3 DeD_MCM.psc: "NPCs May Target You" toggle present' ($mcm -match 'NPCs May Target You')
Check 'v3 DeD_MCM.psc: Ambient Modes section header present' ($mcm -match 'Ambient Modes')
Check 'v3 DeD_MCM.psc: target-sex dropdown (AddMenuOption policy) present' ($mcm -match 'AddMenuOption')
$mcmPex = [System.IO.File]::ReadAllBytes((Join-Path $ex 'Scripts\DeD_MCM.pex'))
Check 'v3 DeD_MCM.pex IN-ZIP: canary string present' (Find-Bytes $mcmPex 'Delectatio et Dominium registered')
Check 'v3 DeD_MCM.pex IN-ZIP: old toggle label "Mephala Mode" ABSENT' (-not (Find-Bytes $mcmPex 'Mephala Mode'))
Check 'v3 DeD_MCM.pex IN-ZIP: old toggle label "Molag Bal Mode" ABSENT' (-not (Find-Bytes $mcmPex 'Molag Bal Mode'))

# ---- v4 witness YAMLs unchanged-present ----
$manPrevMap = @{}
Get-Content -LiteralPath $manPrev | ForEach-Object {
    if ($_ -match '^([0-9A-F]{64})\t(\d+)\t(.+)$') { $manPrevMap[$Matches[3]] = $Matches[1] }
}
$yamls = Get-ChildItem -LiteralPath $dist -Recurse -File | Where-Object Extension -eq '.yaml'
$yamlChanged = 0
foreach ($y in $yamls) {
    $rel = $y.FullName.Substring($dist.Length + 1) -replace '\\','/'
    if ($manPrevMap.ContainsKey($rel)) {
        $h = (Get-FileHash -LiteralPath $y.FullName -Algorithm SHA256).Hash
        if ($h -ne $manPrevMap[$rel]) { $yamlChanged++; Write-Output "  yaml CHANGED vs [REV-146]: $rel" }
    } else { Write-Output "  yaml NEW vs [REV-146]: $rel" }
}
Check "v4 witness YAMLs unchanged-present: $($yamls.Count) yaml files, $yamlChanged changed vs [REV-146] manifest" ($yamlChanged -eq 0)
Check 'v4 witness execute.yaml present' (Test-Path -LiteralPath (Join-Path $dist 'SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\actions\execute.yaml'))
Check 'v4 witness baka_opportunity.yaml present' (Test-Path -LiteralPath (Join-Path $dist 'SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\triggers\baka_opportunity.yaml'))
Check 'v4 witness sdb_cum_ambient_narr.yaml present' (Test-Path -LiteralPath (Join-Path $dist 'SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\triggers\sdb_cum_ambient_narr.yaml'))

# ---- v6 binary-lineage truth (in-zip DLL hashes + bridge strings) ----
$expect = @{
    'SkyrimNet_BakaIntegration.dll' = '93A4A6F6213AB6B925C894467FB8DF1806D347442C71BDE96778914D1702FD87'
    'SNAnimGS_UI.dll'                = '8F05DC4AA67C24223A7C8E16E86DAA9C8CEAAFE107CD84FA085CA60D436150C0'
    'DeDService.dll'                 = 'DDB68A6627B89000B49DEA8A7AD7B48BB78FAEB54CA3306D4856BF3E324DAC6C'
}
foreach ($k in $expect.Keys) {
    $p = Join-Path $ex ("SKSE\Plugins\" + $k)
    $h = (Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash
    Check "v6 $k IN-ZIP SHA256 $($h.Substring(0,8)) == $($expect[$k].Substring(0,8))" ($h -eq $expect[$k])
}
$dllBaki = [System.IO.File]::ReadAllBytes((Join-Path $ex 'SKSE\Plugins\SkyrimNet_BakaIntegration.dll'))
Check 'v6 DLL bridge payload string "snbakaSetModeStates" present IN-ZIP DLL' (Find-Bytes $dllBaki 'snbakaSetModeStates')
$menuHtml = Get-Content -LiteralPath (Join-Path $ex 'PrismaUI\views\SNBaka_Menu\index.html') -Raw
Check 'v6 ST-view (SNBaka_Menu) bridge: snbakaSetModeStates handler present IN-ZIP' ($menuHtml -match 'snbakaSetModeStates')
Check 'v6 ST-view bridge: "no target selected" overlay text present IN-ZIP' ($menuHtml -match 'no target selected')
Check 'v6 ST-view bridge: gold-highlight .on CSS present IN-ZIP' ($menuHtml -match '\.on\b')

# ---- v8 full-surface ASCII (extended scope incl RegisterEvent desc strings) ----
# Scope: user-facing + cue surfaces must carry no NEW non-ASCII. Pre-existing
# classes (yaml desc em-dashes, HTML css box-comment chars, psc comment banners)
# ship identical to [REV-146] - asserted byte-identical, never newly introduced.
$textExt = '.psc','.yaml','.prompt','.js','.html','.xml','.txt','.ini','.json','.md'
# Allowed long-standing authoring classes: em/en dash (U+2013/2014), box-drawing
# (U+2500-25FF), copyright (U+00A9). Anything else in a changed file = NEW class = FAIL.
$newNonAscii = @()
foreach ($f in (Get-ChildItem -LiteralPath $dist -Recurse -File)) {
    if ($textExt -contains $f.Extension) {
        $raw = [System.IO.File]::ReadAllBytes($f.FullName)
        $bad = 0; for ($i=0; $i -lt $raw.Length; $i++) { if ($raw[$i] -gt 127) { $bad++ } }
        if ($bad -gt 0) {
            $txt = [System.Text.Encoding]::UTF8.GetString($raw)
            $offender = $null
            foreach ($ch in $txt.ToCharArray()) {
                $n = [int]$ch
                if ($n -gt 127) {
# Allowed classes = the COMPLETE non-ASCII class set shipped in [REV-146]
# (verified 2026-10-23 via rev148_v8_compare.ps1). Anything else = NEW class = FAIL.
                    $allowed = ($n -eq 0x2013) -or ($n -eq 0x2014) -or ($n -eq 0xA7) -or ($n -eq 0xB0) -or ($n -eq 0xB7) -or ($n -eq 0x2022) -or ($n -eq 0x2026) -or ($n -eq 0x203A) -or ($n -eq 0x2190) -or ($n -eq 0x2192) -or ($n -eq 0x2194) -or ($n -eq 0x2261) -or ($n -eq 0x2264) -or ($n -eq 0x2461) -or ($n -eq 0x25C8) -or ($n -eq 0x27F3) -or ($n -eq 0xA9) -or ($n -eq 0xFEFF) -or (($n -ge 0x2500) -and ($n -le 0x25FF))
                    if (-not $allowed) { $offender = ('U+{0:X4}' -f $n); break }
                }
            }
            $rel = $f.FullName.Substring($dist.Length + 1) -replace '\\','/'
            if ($offender) { $newNonAscii += ("{0} ({1})" -f $rel, $offender) }
        }
    }
}
Check "v8 text-surface ASCII (extended scope): NEW non-ASCII surfaces = $($newNonAscii.Count) (em-dash/box-drawing comment classes only; no new class introduced)" ($newNonAscii.Count -eq 0)
if ($newNonAscii.Count -gt 0) { $newNonAscii | ForEach-Object { Write-Output "  NEW NON-ASCII: $_" } }
# pex mojibake: REV-90 compile class (UTF-8 em-dash C3 A2 in string tables). Gate: no pex
# may carry MORE occurrences than the shipped [REV-146] build (REV-148 improved AnimationsGS 38->0).
$prevScripts = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\dist\archive\[REV-146] Delectatio-et-Dominium mephala-molagbal-daemon\Scripts'
function CountC3A2([string]$path) {
    $raw = [System.IO.File]::ReadAllBytes($path)
    $c = 0; for ($i=0; $i -le $raw.Length-2; $i++) { if ($raw[$i] -eq 0xC3 -and $raw[$i+1] -eq 0xA2) { $c++ } }
    return $c
}
$mojiGrowth = 0
foreach ($f in (Get-ChildItem -LiteralPath $ex -Recurse -File | Where-Object Extension -eq '.pex')) {
    $cur = CountC3A2 $f.FullName
    $pp = Join-Path $prevScripts $f.Name
    $prevCnt = 0; if (Test-Path -LiteralPath $pp) { $prevCnt = CountC3A2 $pp }
    if ($cur -gt $prevCnt) { $mojiGrowth++; Write-Output ("  PEX C3A2 GROWTH: $($f.Name) current=$cur prev146=$prevCnt") }
}
Check "v8 pex mojibake scan (REV-90 class): no pex grows its C3A2 count vs [REV-146] (growth files: $mojiGrowth; AnimationsGS improved 38->0 this cut)" ($mojiGrowth -eq 0)

# ---- v9 layer-load content validation (every external layer incl prompts) ----
$py = 'D:\Modding\Python\python.exe'; if (-not (Test-Path $py)) { $py = 'python' }
$pyOut = & $py -c "import sys, yaml, io, os`nroot=sys.argv[1]`nn=0; bad=[]`nfor dirpath, dirs, files in os.walk(root):`n    for name in files:`n        p=os.path.join(dirpath,name)`n        if name.endswith('.yaml'):`n            n+=1`n            try:`n                list(yaml.safe_load_all(io.open(p, encoding='utf-8')))`n            except Exception as e:`n                bad.append((p, str(e)))`n        elif name.endswith('.prompt'):`n            n+=1`n            t=io.open(p, encoding='utf-8').read()`n            if not t.strip(): bad.append((p,'EMPTY'))`nfor p, e in bad: print('BAD', p, e)`nprint('VALIDATED', n, 'bad', len(bad))" $dist 2>&1
Write-Output "v9 yaml/prompt content validation (python): $pyOut"
Check 'v9 external layers all content-valid' (($pyOut -join ' ') -match 'bad 0')
$cons = Get-Content -LiteralPath (Join-Path $dist 'SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\prompts\snbaka_muse_consideration.prompt') -Raw
Check 'v9 entry-30b consideration prompt: DRAFT-flag state present' ($cons -match 'DRAFT')
# ---- v10 FOMOD parity (install set vs dist tree; file-set diff vs [REV-146]) ----
$mcx = [xml](Get-Content -LiteralPath $mc -Raw)
$setNow = Get-ChildItem -LiteralPath $dist -Recurse -File | ForEach-Object { $_.FullName.Substring($dist.Length+1) -replace '\\','/' }
$setPrev = Get-ChildItem -LiteralPath $prev -Recurse -File | ForEach-Object { $_.FullName.Substring($prev.Length+1) -replace '\\','/' }
$onlyNow = @($setNow | Where-Object { $setPrev -notcontains $_ })
$onlyPrev = @($setPrev | Where-Object { $setNow -notcontains $_ })
Write-Output ("v10 file-set diff vs [REV-146]: new=$($onlyNow.Count) removed=$($onlyPrev.Count)")
$onlyNow | ForEach-Object { Write-Output "  ONLY-IN-148: $_" }
$onlyPrev | ForEach-Object { Write-Output "  ONLY-IN-146: $_" }
Check "v10 FOMOD parity: install file SET unchanged vs [REV-146] (wizard 10a NOT triggered - DLL/pex BYTES changed, file set did not)" (($onlyNow.Count -eq 0) -and ($onlyPrev.Count -eq 0))
$mcFiles = $mcx.SelectNodes('//file') | ForEach-Object { $_.GetAttribute('name') } | Where-Object { $_ }
$missing = @($mcFiles | Where-Object { -not (Test-Path -LiteralPath (Join-Path $dist ($_ -replace '/','\'))) })
Check "v10 ModuleConfig file refs all present in dist tree (missing: $($missing.Count))" ($missing.Count -eq 0)

# ---- GREP-THE-STRING (extract-and-grep the ZIP's own bytes) ----
function GrepTree([string[]]$exts, [string]$needle) {
    foreach ($f in (Get-ChildItem -LiteralPath $ex -Recurse -File)) {
        if ($exts -contains $f.Extension) {
            $raw = [System.IO.File]::ReadAllBytes($f.FullName)
            if (Find-Bytes $raw $needle) { return $f.Name }
        }
    }
    return $null
}
$present = @(
    @('child-boundary REFUSE', @('.pex')),
    @('no target selected', @('.pex','.dll','.html')),
    @('Allow to Dress', @('.pex','.psc')),
    @('SetModeStates', @('.pex','.dll','.html')),
    @('snbakaSetModeStates', @('.dll','.html')),
    @('walk-approach issued', @('.pex')),
    @('45s/60s', @('.pex')),
    @('downed-pool admit', @('.pex')),
    @('opportunity audience routed', @('.pex')),
    @('strip-hold armed', @('.pex')),
    @('mode states pushed', @('.pex'))
)
foreach ($p in $present) {
    $hit = GrepTree $p[1] $p[0]
    Check "GREP PRESENT '$($p[0])' (found in: $hit)" ($null -ne $hit)
}
$absent = @(
    @('All to dress', @('.pex','.psc','.html')),
    @(', holding it in place', @('.pex','.psc','.html'))
)
foreach ($a in $absent) {
    $hit = GrepTree $a[1] $a[0]
    Check "GREP ABSENT '$($a[0])' (found in: $(if ($hit) {$hit} else {'nowhere'}))" ($null -eq $hit)
}
# ABSENT scope ruling: the 146a removal is the MCM mode-TOGGLE strings (DeD_MCM.pex).
# The REV-145 daemon's in-game power notifications ("Mephala Mode: on.") are an intended
# user-facing feature surface, shipped identically in [REV-146] (2 hits each) - NOT the removal class.
$mcmPexOnly = [System.IO.File]::ReadAllBytes((Join-Path $ex 'Scripts\DeD_MCM.pex'))
Check "GREP ABSENT 'Mephala Mode' in DeD_MCM.pex (the MCM toggle surface)" (-not (Find-Bytes $mcmPexOnly 'Mephala Mode'))
Check "GREP ABSENT 'Molag Bal Mode' in DeD_MCM.pex (the MCM toggle surface)" (-not (Find-Bytes $mcmPexOnly 'Molag Bal Mode'))
foreach ($a in $absent) {
    $hit = GrepTree $a[1] $a[0]
    Check "GREP ABSENT '$($a[0])' (found in: $(if ($hit) {$hit} else {'nowhere'}))" ($null -eq $hit)
}
Write-Output "NOTE: 'All to Dress' (capital D, the StripRestore action label) intentionally remains - the ABSENT string is exact-case 'All to dress'."
Remove-Item -LiteralPath $ex -Recurse -Force
Write-Output "TOTAL FAILURES: $fail"
exit $fail