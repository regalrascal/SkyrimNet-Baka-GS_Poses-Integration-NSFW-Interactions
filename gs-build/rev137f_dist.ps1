$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$d = Join-Path $root 'dist\[REV-143] Delectatio-et-Dominium mode-tuning-notification-anchor'
$z = Join-Path $root 'dist\[REV-143] Delectatio-et-Dominium mode-tuning-notification-anchor.zip'
$zs = $z + '.sha256'
foreach ($p in @($d, $z, $zs)) { if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Recurse -Force } }
& 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\tools\dist_assemble.ps1' `
    -ForkRoot $root -OutDir $d `
    -CarryFrom (Join-Path $root 'dist\archive\[REV-142] Delectatio-et-Dominium package-hold-formid-fix') `
    -CompileOut (Join-Path $root 'Compile Archive\compile-out-rev137f') `
    -ManifestOut (Join-Path $d 'dist-manifest.txt') -ZipOut $z `
    *> (Join-Path $root 'gs-build\rev137f_dist_receipt.txt')
Get-Content (Join-Path $root 'gs-build\rev137f_dist_receipt.txt')
exit $LASTEXITCODE