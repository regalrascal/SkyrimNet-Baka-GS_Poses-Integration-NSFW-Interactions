$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$name = '[REV-165] Delectatio-et-Dominium v0.3.0-alpha release-prep'
$d = Join-Path $root ('dist\' + $name)
$z = Join-Path $root ('dist\' + $name + '.zip')
$zs = $z + '.sha256'
foreach ($p in @($d, $z, $zs)) { if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Recurse -Force } }
# Archive rider (the [REV-148]..[REV-164] precedent): the [REV-164] dist moves
# to dist\archive\; the new cut carries from the archived tree.
$prev = Join-Path $root 'dist\[REV-164] Delectatio-et-Dominium six-issue-fixes'
$prevArch = Join-Path $root 'dist\archive\[REV-164] Delectatio-et-Dominium six-issue-fixes'
if (Test-Path -LiteralPath $prev) {
    if (Test-Path -LiteralPath $prevArch) { Remove-Item -LiteralPath $prevArch -Recurse -Force }
    Move-Item -LiteralPath $prev -Destination $prevArch
}
if (-not (Test-Path -LiteralPath $prevArch)) { throw 'archive rider: [REV-164] tree not found in dist or dist\archive' }
# REV-165: NO -ZipOut here - the tree is cut first, scrubbed (rev111 classes +
# pex header patch, the REV-111 precedent full re-run), THEN the manifest is
# regenerated and the zip cut from the scrubbed tree (rev165_scrub_rezip.ps1).
& 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\tools\dist_assemble.ps1' `
    -ForkRoot $root -OutDir $d `
    -CarryFrom $prevArch `
    -CompileOut (Join-Path $root 'Compile Archive\compile-out-rev164') `
    -ManifestOut (Join-Path $root 'gs-build\rev165_manifest_prescrub.txt') `
    *> (Join-Path $root 'gs-build\rev165_dist_receipt.txt')
Get-Content (Join-Path $root 'gs-build\rev165_dist_receipt.txt')
exit $LASTEXITCODE
