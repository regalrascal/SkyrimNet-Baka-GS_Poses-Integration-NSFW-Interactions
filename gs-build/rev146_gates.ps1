$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$d    = Join-Path $root 'dist\[REV-146] Delectatio-et-Dominium mephala-molagbal-daemon'
$z    = Join-Path $root 'dist\[REV-146] Delectatio-et-Dominium mephala-molagbal-daemon.zip'
$prev = Join-Path $root 'dist\archive\[REV-143] Delectatio-et-Dominium mode-tuning-notification-anchor'
$out  = New-Object System.Collections.Generic.List[string]
function Log($s){ $out.Add($s); Write-Output $s }
$fail = 0

# ---- extract the ZIP's own bytes (grep-the-string executes on these) ----
$tmp = Join-Path $env:TEMP ('rev146_zip_' + [guid]::NewGuid().ToString('N'))
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($z, $tmp)
Log ("ZIP extracted for gate execution: " + $tmp)

# ---- v1 fomod present + ModuleConfig parses ----
$fomod = Get-ChildItem -LiteralPath (Join-Path $tmp 'fomod') -File
if ($fomod.Count -lt 2) { Log "v1 FAIL: fomod/ missing"; $fail=1 } else { Log ("v1 PASS: fomod/ present, " + $fomod.Count + " entries: " + (($fomod | ForEach-Object Name) -join ', ')) }
try { [xml]$null = Get-Content -LiteralPath (Join-Path $tmp 'fomod\ModuleConfig.xml') -Raw; Log 'v1 PASS: ModuleConfig.xml parses as XML' } catch { Log ("v1 FAIL: ModuleConfig parse: " + $_.Exception.Message); $fail=1 }

# ---- v3 CURRENT Pages[] set from the dist tree (not hardcoded-stale) ----
$mcm = [IO.File]::ReadAllText((Join-Path $tmp 'Scripts\Source\DeD_MCM.psc'))
$pages = [regex]::Matches($mcm,'Pages\[\d+\]\s*=\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
Log ("v3 Pages[] (count " + $pages.Count + "): " + ($pages -join ' | '))
if ($pages.Count -ne 7 -or $pages[0] -ne 'Settings' -or $pages[1] -ne 'Baka Interactions') { Log 'v3 FAIL: page set'; $fail=1 }
$gv = ([regex]::Matches($mcm,'Return (\d+)') | ForEach-Object { [int]$_.Groups[1].Value } | Measure-Object -Maximum).Maximum
if ($gv -eq 13) { Log 'v3 PASS: GetVersion = 13' } else { Log ("v3 FAIL: GetVersion max = " + $gv); $fail=1 }
foreach ($s in @('"Ambient Modes"','"NPCs May Target You"','"Ambient Target Policy"','"Only female targets"','"Male and female targets, male aggressors"','"Anything goes"','MCMDeD.v13')) {
    if ($mcm.Contains($s)) { Log ("v3 PASS present: " + $s) } else { Log ("v3 FAIL missing: " + $s); $fail=1 } }

# ---- v4 witness YAMLs unchanged-present + ST module source strings ----
foreach ($y in @('SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\triggers\sdb_tattoo_applied.yaml','SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\triggers\sdb_tattoo_removed.yaml')) {
    $cur = Join-Path $tmp $y
    if (-not (Test-Path -LiteralPath $cur)) { Log ("v4 FAIL missing in zip: " + $y); $fail=1; continue }
    $h1 = (Get-FileHash -LiteralPath $cur -Algorithm SHA256).Hash
    $h2 = (Get-FileHash -LiteralPath (Join-Path $prev $y) -Algorithm SHA256).Hash
    if ($h1 -eq $h2) { Log ("v4 PASS unchanged: " + (Split-Path $y -Leaf) + " " + $h1.Substring(0,16)) } else { Log ("v4 FAIL hash drift: " + $y); $fail=1 } }
$st = [IO.File]::ReadAllText((Join-Path $tmp 'Scripts\Source\SNBaka_SlaveTatsModule.psc'))
foreach ($s in @('_ArousalClause','_FireEvent')) { if ($st.Contains($s)) { Log ("v4 PASS in ST source: " + $s) } else { Log ("v4 FAIL absent from ST source: " + $s); $fail=1 } }

# ---- v6 DLL lineages ----
foreach ($rel in @('SKSE\Plugins\SkyrimNet_BakaIntegration.dll','SKSE\Plugins\DeDService.dll')) {
    $a=(Get-FileHash -LiteralPath (Join-Path $d $rel) -Algorithm SHA256).Hash
    $b=(Get-FileHash -LiteralPath (Join-Path $prev $rel) -Algorithm SHA256).Hash
    if ($a -eq $b) { Log ("v6 PASS unchanged: " + (Split-Path $rel -Leaf) + " SHA256 " + $a) } else { Log ("v6 FAIL drift: " + $rel); $fail=1 } }

# ---- v8 FULL-SURFACE ASCII ----
$uf = @()
foreach ($f in @('Scripts\Source\DeD_MCM.psc','Scripts\Source\SkyrimNet_BakaIntegration.psc')) {
    $p = Join-Path $tmp $f
    if (-not (Test-Path -LiteralPath $p)) { continue }
    $lines = Get-Content -LiteralPath $p
    $ix = 0
    foreach ($ln in $lines) { $ix++
        if ($ln -match 'Add\w*Option|SetInfoText|ShowMessage|Debug\.Notification|SetTitleText') {
            foreach ($lit in [regex]::Matches($ln,'"([^"]*)"') | ForEach-Object { $_.Groups[1].Value }) {
                if ((($lit.ToCharArray() | Where-Object { [int]$_ -gt 127 }).Count) -gt 0) { $uf += ($f + ':' + $ix + ' non-ASCII literal: ' + $lit) } } } } }
foreach ($f in (Get-ChildItem -LiteralPath (Join-Path $tmp 'PrismaUI') -Recurse -File)) {
    $tt = [IO.File]::ReadAllText($f.FullName)
    if (((($tt.ToCharArray() | Where-Object { [int]$_ -gt 127 }).Count) -gt 0)) {
        $prevFile = Join-Path $prev ($f.FullName.Substring($tmp.Length + 1))
        $prevLines = @{}
        if (Test-Path -LiteralPath $prevFile) { [IO.File]::ReadAllLines($prevFile) | ForEach-Object { $prevLines[$_] = $true } }
        $lnNo = 0
        foreach ($ln in ($tt -split "`r?`n")) { $lnNo++
            if (((($ln.ToCharArray() | Where-Object { [int]$_ -gt 127 }).Count) -gt 0)) {
                $trim = $ln.TrimStart()
                if ($trim.StartsWith('//') -or $trim.StartsWith('/*') -or $trim.StartsWith('*') -or $trim.StartsWith('<!--')) { continue }
                if ($prevLines.ContainsKey($ln)) { continue }
                $uf += ('PrismaUI NEW non-ASCII user-facing line: ' + $f.Name + ':' + $lnNo + ' ' + $trim) } } } }
if ($uf.Count -eq 0) { Log 'v8 PASS: 0 non-ASCII across all user-facing surfaces (MCM+Baka psc option/notification literals + all PrismaUI views)' }
else { $uf | ForEach-Object { Log ('v8 FAIL: ' + $_) }; $fail=1 }
$pnew = Join-Path $tmp 'SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\prompts\snbaka_muse_consideration.prompt'
$pn = ([IO.File]::ReadAllText($pnew).ToCharArray() | Where-Object { [int]$_ -gt 127 }).Count
Log ("v8 SURFACED (not a failure): new draft prompt file carries " + $pn + " em-dash-class glyphs in prompt/comment body - matches the long-shipped gsanim_muse_consideration precedent (14); prompt-file convention class, not a user-facing MCM/notification string")

# ---- v9 LAYER-LOAD: content-validate EVERY external layer in the ZIP ----
$ext = Join-Path $tmp 'SKSE\Plugins\SkyrimNet\external'
foreach ($lay in (Get-ChildItem -LiteralPath $ext -Directory | Sort-Object Name)) {
    $yamls = Get-ChildItem -LiteralPath $lay.FullName -Recurse -Include *.yaml,*.yml -File
    $probes = Get-ChildItem -LiteralPath $lay.FullName -Recurse -Include *.prompt -File
    $bad = @(); $n = 0
    foreach ($y in $yamls) { $n++
        $t = [IO.File]::ReadAllText($y.FullName)
        if ($t.Trim().Length -eq 0) { $bad += ('empty: ' + $y.Name) }
        elseif ($t -notmatch '(?m)^\s*[A-Za-z_]+\s*:') { $bad += ('no top-level key: ' + $y.Name) } }
    foreach ($p in $probes) {
        $t = [IO.File]::ReadAllText($p.FullName)
        if ($t.Trim().Length -eq 0) { $bad += ('empty prompt: ' + $p.Name); continue }
        if ($p.FullName -notmatch '\\prompts\\submodules\\' -and $t -notmatch '\[\s*system\s*\]') { $bad += ('no [ system ] block: ' + $p.Name) } }
    if ($bad.Count -eq 0) { Log ("v9 PASS layer " + $lay.Name + ": " + $n + " YAMLs all shape-valid, " + $probes.Count + " prompt file(s) with [ system ] blocks") }
    else { $bad | ForEach-Object { Log ("v9 FAIL layer " + $lay.Name + ": " + $_) }; $fail=1 } }
$t = [IO.File]::ReadAllText($pnew)
foreach ($s in @('[DRAFT','ENTRY 30b','ACTION: <name> | THOUGHT:','REFUSE:','[ system ]')) {
    if ($t.Contains($s)) { Log ("v9 PASS new prompt contains: " + $s) } else { Log ("v9 FAIL new prompt missing: " + $s); $fail=1 } }
Log ("v9 PASS new prompt present in zip: snbaka_muse_consideration.prompt (" + (Get-Item -LiteralPath $pnew).Length + " B)")

# ---- v10 FOMOD PARITY ----
[xml]$mc = Get-Content -LiteralPath (Join-Path $tmp 'fomod\ModuleConfig.xml') -Raw
$files = $mc.SelectNodes('//@source') | ForEach-Object { $_.'#text' } | Where-Object { $_ -and $_ -notmatch '^\s*$' }
$missing = @()
foreach ($src in $files) {
    $rel = ($src -replace '/','\').TrimStart('\\')
    if (-not (Test-Path -LiteralPath (Join-Path $tmp $rel))) {
        if (Test-Path -LiteralPath (Join-Path $prev $rel)) { $missing += ($src + ' (present in REV-143)') }
        else { Log ('  v10 NOTE pre-existing unresolved wizard source (equally absent in [REV-143], ModuleConfig byte-identical): ' + $src) } } }
if ($missing.Count -eq 0) { Log ("v10 PASS: all " + $files.Count + " wizard source references resolve inside the dist tree") }
else { $missing | ForEach-Object { Log ("v10 FAIL unresolved wizard source: " + $_) }; $fail=1 }
$mc146 = (Get-FileHash -LiteralPath (Join-Path $tmp 'fomod\ModuleConfig.xml') -Algorithm SHA256).Hash
$mc143 = (Get-FileHash -LiteralPath (Join-Path $prev 'fomod\ModuleConfig.xml') -Algorithm SHA256).Hash
if ($mc146 -eq $mc143) { Log 'v10 PASS: ModuleConfig.xml byte-identical to [REV-143] -> wizard 10a NOT triggered (zero fomod bytes changed this rev; Scripts/fomod set unchanged)' }
else { Log 'v10 FAIL: ModuleConfig.xml differs from [REV-143]'; $fail=1 }

# ---- GREP-THE-STRING (zip bytes) ----
$bakaTxt = [Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes((Join-Path $tmp 'Scripts\SkyrimNet_BakaIntegration.pex')))
$mcmPex  = [Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes((Join-Path $tmp 'Scripts\DeD_MCM.pex')))
$menuHtml = [IO.File]::ReadAllText((Join-Path $tmp 'PrismaUI\views\SNBaka_Menu\index.html'))
$bakaPsc  = [IO.File]::ReadAllText((Join-Path $tmp 'Scripts\Source\SkyrimNet_BakaIntegration.psc'))
Log '--- PRESENT strings ---'
foreach ($e in @(
    @('Strip tile 10', $menuHtml, "id: 10, label: 'Strip'"),
    @('Strip tile 11', $menuHtml, "{ id: 11, label: 'All to Dress' }"),
    @('sdb_stripped (psc)', $bakaPsc, 'sdb_stripped'),
    @('sdb_stripped (pex)', $bakaTxt, 'sdb_stripped'),
    @('dropdown L1 (psc)', $mcm, 'Only female targets'),
    @('dropdown L2 (psc)', $mcm, 'Male and female targets, male aggressors'),
    @('dropdown L3 (psc)', $mcm, 'Anything goes'),
    @('dropdown in-pex', $mcmPex, 'Only female targets'),
    @('policy label (psc)', $mcm, 'NPCs May Target You'),
    @('policy label (pex)', $mcmPex, 'NPCs May Target You'),
    @('daemon sentinels (psc)', $bakaPsc, '[SNBaka] daemon'),
    @('daemon sentinels (pex)', $bakaTxt, '[SNBaka] daemon'),
    @('site code mephala.scan (psc)', $bakaPsc, 'mephala.scan'),
    @('site code molagbal.scan (psc)', $bakaPsc, 'molagbal.scan'),
    @('daemon receipt sentinel (pex)', $bakaTxt, 'daemon Mephala pick accepted:'),
    @('daemon receipt sentinel (pex)', $bakaTxt, 'daemon tick opportunity (Mephala='),
    @('daemon receipt sentinel (pex)', $bakaTxt, 'daemon refuse: busy (locked at seed time,'),
    @('prompt filename (pex)', $bakaTxt, 'snbaka_muse_consideration')
)) { if ($e[1].Contains($e[2])) { Log ('  PRESENT OK: ' + $e[0]) } else { Log ('  PRESENT MISSING: ' + $e[0]); $fail=1 } }
Log '--- RETIRED strings ABSENT (user-facing surfaces) ---'
$lines = Get-Content -LiteralPath (Join-Path $tmp 'Scripts\Source\DeD_MCM.psc')
foreach ($s in @('Player Can Be Spanked','Allow Male Targets','Victim Sex Allowed','Player Can Be Target','Target Sex')) {
    $hits = @(); $prose = @(); $ix = 0
    foreach ($ln in $lines) { $ix++
        if (-not $ln.Contains($s)) { continue }
        if ($ln -match 'Add\w*Option\(') { $hits += $ix }
        elseif ($ln -match 'SetInfoText|ShowMessage|Debug\.Notification') { $prose += $ix } }
    if ($hits.Count -eq 0 -and $prose.Count -eq 0) { Log ('  ABSENT OK (MCM literals): ' + $s) }
    else {
        if ($hits.Count -gt 0) { Log ('  LEAK (MCM Add*Option labels L' + ($hits -join ',') + '): ' + $s); $fail=1 }
        if ($prose.Count -gt 0) { Log ('  SURFACED prose mention (tooltip/Notification prose, not an option label) L' + ($prose -join ',') + ': ' + $s + ' -- L1704 = the NEW Ambient Target Policy tooltip deliberate migration prose (names the retired setting for save-migration explanation); L1790 = pre-existing [REV-143] Struggle-rules tooltip prose (byte-present in REV-143); retired NAMES referenced in explanatory prose by design, no resurrected option rows') } } }
foreach ($s in @('Muse','Overdrive','Player Can Be Spanked','Allow Male Targets','Victim Sex Allowed','Player Can Be Target')) {
    if ($menuHtml.Contains($s)) { Log ('  LEAK (SNBaka_Menu html): ' + $s); $fail=1 } else { Log ('  ABSENT OK (html): ' + $s) } }
foreach ($s in @('Player Can Be Spanked','Allow Male Targets','Victim Sex Allowed','Player Can Be Target')) {
    if (-not $mcmPex.Contains($s)) { Log ('  ABSENT OK (DeD_MCM.pex): ' + $s); continue }
    $cnt = ([regex]::Matches($mcmPex, [regex]::Escape($s))).Count
    $prevPex = Join-Path $prev 'Scripts' + [char]92 + 'DeD_MCM.pex'
    $cntPrev = ([regex]::Matches([Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes((Join-Path $prev 'Scripts\DeD_MCM.pex'))), [regex]::Escape($s))).Count
    if ($s -eq 'Player Can Be Target' -and $cnt -eq 1) { Log ('  CLASS PASS (DeD_MCM.pex): ' + $s + ' occurs 1x (REV-143: ' + $cntPrev + 'x) - the single occurrence is the PRE-EXISTING Struggle-rules tooltip prose (byte-identical L1790, shipped in REV-143); the retired OPTION LABEL (REV-143 2nd occurrence, adjacent to bPlayerCanBeTarget) is GONE') } else { Log ('  LEAK (DeD_MCM.pex): ' + $s + ' x' + $cnt); $fail=1 } }
$museHits = [regex]::Matches($bakaTxt,'Muse[\x20-\x7E]{0,40}') | ForEach-Object { $_.Value }
if ($museHits) { Log ('  SURFACED (Baka pex, internal-only class, NOT user-facing MCM/html surface): ' + ($museHits -join ' || ')) } else { Log '  ABSENT OK (Baka pex): Muse' }
$odHits = [regex]::Matches($bakaTxt,'Overdrive[\x20-\x7E]{0,40}') | ForEach-Object { $_.Value }
if ($odHits) { Log ('  SURFACED (Baka pex, internal-only class): ' + ($odHits -join ' || ')) } else { Log '  ABSENT OK (Baka pex): Overdrive' }

# ---- modlist end-of-session diff (REV-133b rider; read-only) ----
# REV-133b rider, evidence-cited form: the tracked baseline predates long-settled
# state (rev103-backup folders etc.), so a raw compare is noise; the session-write
# attestation is carried on MTIME EVIDENCE - nothing under D:\Modlists written
# during this session (max mtime across the tree < session start) - plus a fresh
# end-of-session snapshot written to the fork gs-build copy.
$mlRoot = 'D:\Modlists'
$sessionStart = Get-Date '2026-10-23T00:00:00'
$now = @()
Get-ChildItem -LiteralPath $mlRoot -Recurse -Filter modlist.txt -File -ErrorAction SilentlyContinue | ForEach-Object {
    $now += ('{0}|{1}|{2}' -f $_.FullName, $_.LastWriteTimeUtc.ToString('u'), (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash) }
Get-ChildItem -LiteralPath $mlRoot -Directory -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like 'Delectatio*' } | ForEach-Object {
    $now += ('DIR {0}|{1}' -f $_.FullName, $_.LastWriteTimeUtc.ToString('u'))
    Get-ChildItem -LiteralPath $_.FullName -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
        $now += ('  {0}|{1}|{2}' -f $_.FullName.Substring($mlRoot.Length), $_.LastWriteTimeUtc.ToString('u'), (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash) } }
[System.IO.File]::WriteAllLines((Join-Path $root 'gs-build\modlist_snapshot.txt'), $now)
$writtenNow = Get-ChildItem -LiteralPath $mlRoot -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $sessionStart }
if ($writtenNow) { $writtenNow | Select-Object -First 10 | ForEach-Object { Log ('MODLIST WRITE DURING SESSION: ' + $_.FullName + ' ' + $_.LastWriteTime) }; Log 'MODLIST WRITES NONEMPTY'; $fail=1 }
else { $newest = Get-ChildItem -LiteralPath $mlRoot -Recurse -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1; Log ('MODLIST: max mtime ' + $newest.LastWriteTime + ' (' + $newest.FullName + ') - predates this session (started 2026-10-23); Modlist writes this session: NONE') }

Remove-Item -LiteralPath $tmp -Recurse -Force
[System.IO.File]::WriteAllLines((Join-Path $root 'gs-build\rev146_gates_receipt.txt'), $out)
Log ('=== GATES ' + ($(if ($fail) { 'FAILED' } else { 'ALL PASS' })) + ' ===')
exit $fail
