# rev148_ascii_inspect.ps1 - evidence-cite the v8 findings (ASCII tooling)
$ex = Join-Path $env:TEMP 'rev148_zip_extract'
$dist = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\dist\[REV-148] Delectatio-et-Dominium batch-cut-146a-147'
if (-not (Test-Path -LiteralPath $ex)) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory('D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\dist\[REV-148] Delectatio-et-Dominium batch-cut-146a-147.zip', $ex)
}
Write-Output '=== C3A2 contexts in pex (first 4 per file) ==='
foreach ($name in 'SkyrimNet_BakaIntegration.pex','SkyrimNet_BakaInteractEffect.pex','SNBaka_SlaveTatsModule.pex','Downed_SkyrimNet.pex') {
    $raw = [System.IO.File]::ReadAllBytes((Join-Path $ex ('Scripts\' + $name)))
    $shown = 0
    for ($i = 0; $i -le $raw.Length - 2 -and $shown -lt 4; $i++) {
        if ($raw[$i] -eq 0xC3 -and $raw[$i+1] -eq 0xA2) {
            $s = [Math]::Max(0, $i - 45); $e = [Math]::Min($raw.Length - 1, $i + 45)
            $ctx = [System.Text.Encoding]::GetEncoding(28591).GetString($raw[$s..$e]) -replace '[^\x20-\x7E]', '~'
            Write-Output ("{0} @{1}: {2}" -f $name, $i, $ctx)
            $shown++
        }
    }
}
Write-Output '=== non-ASCII contexts in changed text files ==='
foreach ($rel in 'PrismaUI\views\GSAnim_Menu\poses.js','PrismaUI\views\SNBaka_Menu\index.html','Scripts\Source\DeD_MCM.psc','Scripts\Source\SNBakaUI.psc','Scripts\Source\SkyrimNet_BakaInteractEffect.psc','SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\prompts\snbaka_muse_consideration.prompt') {
    $p = Join-Path $dist $rel
    $raw = [System.IO.File]::ReadAllBytes($p)
    $shown = 0
    for ($i = 0; $i -lt $raw.Length -and $shown -lt 4; $i++) {
        if ($raw[$i] -gt 127) {
            $s = [Math]::Max(0, $i - 45); $e = [Math]::Min($raw.Length - 1, $i + 45)
            $ctx = [System.Text.Encoding]::UTF8.GetString($raw[$s..$e]) -replace '\s+', ' '
            $ctx = $ctx -replace '[^\x20-\x7E]', '~'
            Write-Output ("{0} @{1}: {2}" -f $rel, $i, $ctx)
            $shown++
            $i += 60
        }
    }
}
Remove-Item -LiteralPath $ex -Recurse -Force
