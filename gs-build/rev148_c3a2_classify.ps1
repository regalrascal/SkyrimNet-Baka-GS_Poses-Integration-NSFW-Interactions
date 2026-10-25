# rev148_c3a2_classify.ps1 - classify every C3A2-bearing pex string (ASCII tooling)
$ex = Join-Path $env:TEMP 'rev148_zip_extract'
Add-Type -AssemblyName System.IO.Compression.FileSystem
if (-not (Test-Path -LiteralPath $ex)) { [System.IO.Compression.ZipFile]::ExtractToDirectory('D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\dist\[REV-148] Delectatio-et-Dominium batch-cut-146a-147.zip', $ex) }
foreach ($f in (Get-ChildItem -LiteralPath (Join-Path $ex 'Scripts') -Filter '*.pex')) {
    $raw = [System.IO.File]::ReadAllBytes($f.FullName)
    # crude pex string-table walk: pex strings are length-prefixed (u16) in the header table
    $i = 0
    while ($i -lt $raw.Length - 2) {
        $len = ($raw[$i] -shl 8) + $raw[$i+1]
        if ($len -gt 0 -and $len -lt 4096 -and ($i + 2 + $len) -le $raw.Length) {
            $str = [System.Text.Encoding]::GetEncoding(28591).GetString($raw[($i+2)..($i+1+$len)])
            if ($str -cmatch '\xC3\xA2') {
                Write-Output ("{0}: LEN={1} : {2}" -f $f.Name, $len, ($str -replace '[^\x20-\x7E]', '~'))
            }
            $i += 2 + $len
        } else { $i++ }
    }
}
Remove-Item -LiteralPath $ex -Recurse -Force
