$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$name = '[REV-158] Delectatio-et-Dominium final-batch-152-157'
$d = Join-Path $root ('dist\' + $name)
$z = Join-Path $root ('dist\' + $name + '.zip')
$zs = $z + '.sha256'
foreach ($p in @($d, $z, $zs)) { if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Recurse -Force } }
& 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\tools\dist_assemble.ps1' `
    -ForkRoot $root -OutDir $d `
    -CarryFrom (Join-Path $root 'dist\archive\[REV-148] Delectatio-et-Dominium batch-cut-146a-147') `
    -CompileOut (Join-Path $root 'Compile Archive\compile-out-rev157') `
    -ManifestOut (Join-Path $root 'releases\manifests\manifest-rev158.txt') -ZipOut $z `
    *> (Join-Path $root 'gs-build\rev158_dist_receipt.txt')
Get-Content (Join-Path $root 'gs-build\rev158_dist_receipt.txt')
exit $LASTEXITCODE