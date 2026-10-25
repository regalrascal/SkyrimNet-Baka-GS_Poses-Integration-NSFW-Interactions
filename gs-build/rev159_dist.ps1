$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$name = '[REV-159] Delectatio-et-Dominium polish-session'
$d = Join-Path $root ('dist\' + $name)
$z = Join-Path $root ('dist\' + $name + '.zip')
$zs = $z + '.sha256'
foreach ($p in @($d, $z, $zs)) { if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Recurse -Force } }
# Archive rider (REV-159 Task 6): the [REV-158] dist moves to dist\archive\ (the
# [REV-148] precedent); the new cut carries from the archived tree.
$prev = Join-Path $root 'dist\[REV-158] Delectatio-et-Dominium final-batch-152-157'
$prevArch = Join-Path $root 'dist\archive\[REV-158] Delectatio-et-Dominium final-batch-152-157'
if (Test-Path -LiteralPath $prev) {
    if (Test-Path -LiteralPath $prevArch) { Remove-Item -LiteralPath $prevArch -Recurse -Force }
    Move-Item -LiteralPath $prev -Destination $prevArch
}
if (-not (Test-Path -LiteralPath $prevArch)) { throw 'archive rider: [REV-158] tree not found in dist or dist\archive' }
& 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\tools\dist_assemble.ps1' `
    -ForkRoot $root -OutDir $d `
    -CarryFrom $prevArch `
    -CompileOut (Join-Path $root 'Compile Archive\compile-out-rev159') `
    -ManifestOut (Join-Path $root 'releases\manifests\manifest-rev159.txt') -ZipOut $z `
    *> (Join-Path $root 'gs-build\rev159_dist_receipt.txt')
Get-Content (Join-Path $root 'gs-build\rev159_dist_receipt.txt')
exit $LASTEXITCODE
