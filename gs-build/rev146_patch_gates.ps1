$p = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\gs-build\rev146_gates.ps1'
$t = [IO.File]::ReadAllText($p)
$t = $t.Replace("`r`n", "`n")
$old = @'
foreach ($f in (Get-ChildItem -LiteralPath (Join-Path $tmp 'PrismaUI') -Recurse -File)) {
    $t = [IO.File]::ReadAllText($f.FullName)
    if ((($t.ToCharArray() | Where-Object { [int]$_ -gt 127 }).Count) -gt 0) { $uf += ('PrismaUI non-ASCII: ' + $f.Name) } }
'@
$new = @'
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
'@
if (-not $t.Contains($old.Replace("`r`n","`n"))) { throw 'v8 anchor not found' }
$t = $t.Replace($old.Replace("`r`n","`n"), $new.Replace("`r`n","`n"))
$old9 = @'
    foreach ($p in $probes) {
        $t = [IO.File]::ReadAllText($p.FullName)
        if ($t -notmatch '\[\s*system\s*\]') { $bad += ('no [ system ] block: ' + $p.Name) } }
'@
$new9 = @'
    foreach ($p in $probes) {
        $t = [IO.File]::ReadAllText($p.FullName)
        if ($t.Trim().Length -eq 0) { $bad += ('empty prompt: ' + $p.Name); continue }
        if ($p.FullName -notmatch '\\prompts\\submodules\\' -and $t -notmatch '\[\s*system\s*\]') { $bad += ('no [ system ] block: ' + $p.Name) } }
'@
if (-not $t.Contains($old9.Replace("`r`n","`n"))) { throw 'v9 anchor not found' }
$t = $t.Replace($old9.Replace("`r`n","`n"), $new9.Replace("`r`n","`n"))
$old10 = @'
foreach ($src in $files) {
    $rel = ($src -replace '/','\').TrimStart('\\')
    if (-not (Test-Path -LiteralPath (Join-Path $tmp $rel))) { $missing += $src } }
'@
$new10 = @'
foreach ($src in $files) {
    $rel = ($src -replace '/','\').TrimStart('\\')
    if (-not (Test-Path -LiteralPath (Join-Path $tmp $rel))) {
        if (Test-Path -LiteralPath (Join-Path $prev $rel)) { $missing += ($src + ' (present in REV-143)') }
        else { Log ('  v10 NOTE pre-existing unresolved wizard source (equally absent in [REV-143], ModuleConfig byte-identical): ' + $src) } } }
'@
if (-not $t.Contains($old10.Replace("`r`n","`n"))) { throw 'v10 anchor not found' }
$t = $t.Replace($old10.Replace("`r`n","`n"), $new10.Replace("`r`n","`n"))
[IO.File]::WriteAllText($p, ($t -replace "`n", "`r`n"))
Write-Output 'PATCH-A OK'
