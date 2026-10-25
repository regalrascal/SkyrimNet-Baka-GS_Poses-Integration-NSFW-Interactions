$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$name = '[REV-162] Delectatio-et-Dominium ingestion-fix-final-rulings'
$d = Join-Path $root ('dist\' + $name)
$z = Join-Path $root ('dist\' + $name + '.zip')
$zs = $z + '.sha256'
foreach ($p in @($d, $z, $zs)) { if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Recurse -Force } }
# Archive rider (the [REV-148]/[REV-159]/[REV-160]/[REV-161] precedent): the [REV-161] dist
# moves to dist\archive\; the new cut carries from the archived tree.
$prev = Join-Path $root 'dist\[REV-161] Delectatio-et-Dominium dogfood-continuation-polish'
$prevArch = Join-Path $root 'dist\archive\[REV-161] Delectatio-et-Dominium dogfood-continuation-polish'
if (Test-Path -LiteralPath $prev) {
    if (Test-Path -LiteralPath $prevArch) { Remove-Item -LiteralPath $prevArch -Recurse -Force }
    Move-Item -LiteralPath $prev -Destination $prevArch
}
if (-not (Test-Path -LiteralPath $prevArch)) { throw 'archive rider: [REV-161] tree not found in dist or dist\archive' }
& 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\tools\dist_assemble.ps1' `
    -ForkRoot $root -OutDir $d `
    -CarryFrom $prevArch `
    -CompileOut (Join-Path $root 'Compile Archive\compile-out-rev162') `
    -ManifestOut (Join-Path $root 'releases\manifests\manifest-rev162.txt') -ZipOut $z `
    *> (Join-Path $root 'gs-build\rev162_dist_receipt.txt')
Get-Content (Join-Path $root 'gs-build\rev162_dist_receipt.txt')
exit $LASTEXITCODE