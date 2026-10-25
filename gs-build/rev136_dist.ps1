$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$d = Join-Path $root 'dist\[REV-136] Delectatio-et-Dominium idle-service-fixes-mode-renames'
$z = Join-Path $root 'dist\[REV-136] Delectatio-et-Dominium idle-service-fixes-mode-renames.zip'
$zs = $z + '.sha256'
foreach ($p in @($d, $z, $zs)) { if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Recurse -Force } }
& 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\tools\dist_assemble.ps1' `
    -ForkRoot $root -OutDir $d `
    -CarryFrom (Join-Path $root 'dist\[REV-135] Delectatio-et-Dominium idle-interrupt-service') `
    -CompileOut (Join-Path $root 'Compile Archive\compile-out-rev136') `
    -ManifestOut (Join-Path $d 'dist-manifest.txt') -ZipOut $z `
    *> (Join-Path $root 'gs-build\rev136_dist_receipt.txt')
Get-Content (Join-Path $root 'gs-build\rev136_dist_receipt.txt')
exit $LASTEXITCODE
