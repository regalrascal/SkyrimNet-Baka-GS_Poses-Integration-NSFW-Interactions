$ErrorActionPreference = 'Stop'
$files = @(
    "$env:TEMP\gs135raw.psc",
    'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\Scripts\Source\SkyrimNet_AnimationsGS.psc',
    "$env:TEMP\gsh135raw.html",
    'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\PrismaUI\views\GSAnim_Menu\index.html'
)
foreach ($f in $files) {
    $b = [IO.File]::ReadAllBytes($f)
    $bom = if ($b[0] -eq 0xEF) { 'BOM' } else { 'noBOM' }
    '{0}  len={1}  nonASCII={2}  {3}' -f $f, $b.Length, @($b | Where-Object { $_ -gt 127 }).Count, $bom
}
