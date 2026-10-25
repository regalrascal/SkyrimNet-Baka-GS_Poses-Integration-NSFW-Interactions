# rev148_counts.ps1 - C3A2 counts: current cut vs [REV-146] archive (evidence for the v8 receipt)
$cur = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\dist\[REV-148] Delectatio-et-Dominium batch-cut-146a-147\Scripts'
$prev = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\dist\archive\[REV-146] Delectatio-et-Dominium mephala-molagbal-daemon\Scripts'
foreach ($f in (Get-ChildItem -LiteralPath $cur -Filter '*.pex')) {
    $name = $f.Name
    $rc = [System.IO.File]::ReadAllBytes($f.FullName)
    $cc = 0; for ($i=0; $i -le $rc.Length-2; $i++) { if ($rc[$i] -eq 0xC3 -and $rc[$i+1] -eq 0xA2) { $cc++ } }
    $pp = Join-Path $prev $name
    $pc = -1
    if (Test-Path -LiteralPath $pp) { $rp = [System.IO.File]::ReadAllBytes($pp); $pc = 0; for ($i=0; $i -le $rp.Length-2; $i++) { if ($rp[$i] -eq 0xC3 -and $rp[$i+1] -eq 0xA2) { $pc++ } } }
    Write-Output ("{0}: current={1} prev146={2}" -f $name, $cc, $pc)
}
