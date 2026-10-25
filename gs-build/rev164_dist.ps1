$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$name = '[REV-164] Delectatio-et-Dominium six-issue-fixes'
$d = Join-Path $root ('dist\' + $name)
$z = Join-Path $root ('dist\' + $name + '.zip')
$zs = $z + '.sha256'
foreach ($p in @($d, $z, $zs)) { if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Recurse -Force } }
# Archive rider (the [REV-148]..[REV-163] precedent): the [REV-163] dist moves
# to dist\archive\; the new cut carries from the archived tree.
$prev = Join-Path $root 'dist\[REV-163] Delectatio-et-Dominium picker-decommission'
$prevArch = Join-Path $root 'dist\archive\[REV-163] Delectatio-et-Dominium picker-decommission'
if (Test-Path -LiteralPath $prev) {
    if (Test-Path -LiteralPath $prevArch) { Remove-Item -LiteralPath $prevArch -Recurse -Force }
    Move-Item -LiteralPath $prev -Destination $prevArch
}
if (-not (Test-Path -LiteralPath $prevArch)) { throw 'archive rider: [REV-163] tree not found in dist or dist\archive' }
& 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\tools\dist_assemble.ps1' `
    -ForkRoot $root -OutDir $d `
    -CarryFrom $prevArch `
    -CompileOut (Join-Path $root 'Compile Archive\compile-out-rev164') `
    -ManifestOut (Join-Path $root 'releases\manifests\manifest-rev164.txt') -ZipOut $z `
    *> (Join-Path $root 'gs-build\rev164_dist_receipt.txt')
Get-Content (Join-Path $root 'gs-build\rev164_dist_receipt.txt')
exit $LASTEXITCODE
