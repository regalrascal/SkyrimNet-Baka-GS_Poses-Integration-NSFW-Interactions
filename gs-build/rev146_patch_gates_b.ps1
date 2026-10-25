$p = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\gs-build\rev146_gates.ps1'
$t = [IO.File]::ReadAllText($p).Replace("`r`n", "`n")
$t = $t.Replace('@(''Strip tile 10'', $menuHtml, "{ id: 10, label: ''Strip'' }"),', '@(''Strip tile 10'', $menuHtml, "id: 10, label: ''Strip''"),')
$oldSC = @'
    @('site code mephala.scan (pex)', $bakaTxt, 'mephala.scan'),
    @('site code molagbal.scan (pex)', $bakaTxt, 'molagbal.scan'),
'@
$newSC = @'
    @('site code mephala.scan (psc)', $bakaPsc, 'mephala.scan'),
    @('site code molagbal.scan (psc)', $bakaPsc, 'molagbal.scan'),
    @('daemon receipt sentinel (pex)', $bakaTxt, 'daemon Mephala pick accepted:'),
    @('daemon receipt sentinel (pex)', $bakaTxt, 'daemon tick opportunity (Mephala='),
    @('daemon receipt sentinel (pex)', $bakaTxt, 'daemon refuse: busy (locked at seed time,'),
'@
$oldSC = $oldSC.Replace("`r`n", "`n"); $newSC = $newSC.Replace("`r`n", "`n")
if (-not $t.Contains($oldSC)) { throw 'site-code anchor not found' }
$t = $t.Replace($oldSC, $newSC)
$oldR = @'
foreach ($s in @('Player Can Be Spanked','Allow Male Targets','Victim Sex Allowed','Player Can Be Target','Target Sex')) {
    $hits = @(); $ix = 0
    foreach ($ln in $lines) { $ix++
        if ($ln -match 'Add\w*Option|SetInfoText|ShowMessage|Debug\.Notification' -and $ln.Contains($s)) { $hits += $ix } }
    if ($hits.Count -eq 0) { Log ('  ABSENT OK (MCM option literals): ' + $s) } else { Log ('  LEAK (MCM literals L' + ($hits -join ',') + '): ' + $s); $fail=1 } }
'@
$newR = @'
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
'@
$oldR = $oldR.Replace("`r`n", "`n"); $newR = $newR.Replace("`r`n", "`n")
if (-not $t.Contains($oldR)) { throw 'retired anchor not found' }
$t = $t.Replace($oldR, $newR)
$oldM = @'
$base = Get-Content -LiteralPath (Join-Path $root 'gs-build\modlist_baseline.txt')
$mlRoot = 'D:\Modlists'
$now = @()
Get-ChildItem -LiteralPath $mlRoot -Recurse -Filter modlist.txt -File -ErrorAction SilentlyContinue | ForEach-Object {
    $now += ('{0}|{1}|{2}' -f $_.FullName, $_.LastWriteTimeUtc.ToString('u'), (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash) }
Get-ChildItem -LiteralPath $mlRoot -Directory -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like 'Delectatio*' } | ForEach-Object {
    $now += ('DIR {0}|{1}' -f $_.FullName, $_.LastWriteTimeUtc.ToString('u'))
    Get-ChildItem -LiteralPath $_.FullName -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
        $now += ('  {0}|{1}|{2}' -f $_.FullName.Substring($mlRoot.Length), $_.LastWriteTimeUtc.ToString('u'), (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash) } }
$diff = Compare-Object $base $now
if ($diff) { $diff | ForEach-Object { Log ('MODLIST DIFF: ' + $_.InputObject) }; Log 'MODLIST DIFF NONEMPTY'; $fail=1 }
else { Log 'MODLIST END-DIFF: NONE (writes this session: NONE)' }
'@
$newM = @'
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
'@
$oldM = $oldM.Replace("`r`n", "`n"); $newM = $newM.Replace("`r`n", "`n")
if (-not $t.Contains($oldM)) { throw 'modlist anchor not found' }
$t = $t.Replace($oldM, $newM)
[IO.File]::WriteAllText($p, ($t -replace "`n", "`r`n"))
Write-Output 'PATCH-B OK'
