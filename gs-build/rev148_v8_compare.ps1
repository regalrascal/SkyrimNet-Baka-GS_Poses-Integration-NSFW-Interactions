$prev = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\dist\archive\[REV-146] Delectatio-et-Dominium mephala-molagbal-daemon'
# Build the full set of non-ASCII codepoints shipped anywhere in [REV-146] text surfaces
$prevSet = New-Object 'System.Collections.Generic.HashSet[int]'
foreach ($f in (Get-ChildItem -LiteralPath $prev -Recurse -File | Where-Object { $_.Extension -match '^\.(txt|psc|json|xml|html|js|yaml)$' })) {
    $t = [System.IO.File]::ReadAllText($f.FullName)
    foreach ($ch in $t.ToCharArray()) { $n = [int]$ch; if ($n -gt 127) { [void]$prevSet.Add($n) } }
}
Write-Output ("prev non-ASCII classes: " + ($prevSet | ForEach-Object { 'U+{0:X4}' -f $_ } | Sort-Object) -join ' ')
$targets = @('PrismaUI\views\SNBaka_Menu\index.html','Scripts\Source\SkyrimNet_BakaIntegration.psc')
$cur = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\dist\[REV-148] Delectatio-et-Dominium batch-cut-146a-147'
foreach ($rel in $targets) {
    $t = [System.IO.File]::ReadAllText((Join-Path $cur $rel))
    $set = New-Object 'System.Collections.Generic.HashSet[int]'
    foreach ($ch in $t.ToCharArray()) { $n = [int]$ch; if ($n -gt 127) { [void]$set.Add($n) } }
    $new = @($set | Where-Object { -not $prevSet.Contains($_) })
    if ($new.Count) { Write-Output ("$rel NEW CLASSES: " + (($new | ForEach-Object { 'U+{0:X4}' -f $_ }) -join ' ')) }
    else { Write-Output "$rel OK - all non-ASCII classes pre-exist in [REV-146]" }
}
