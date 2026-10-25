$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$d135 = Join-Path $root 'dist\[REV-135] Delectatio-et-Dominium idle-interrupt-service'
$d136 = Join-Path $root 'dist\[REV-136] Delectatio-et-Dominium idle-service-fixes-mode-renames'

function Read-Man($path) {
    $h = @{}
    foreach ($line in Get-Content -LiteralPath $path) {
        $p = $line -split "`t"
        if ($p.Count -ge 3) {
            $hash = $p[0].TrimStart('C')
            $h[$p[2]] = $hash
        }
    }
    return $h
}
$m135 = Read-Man (Join-Path $d135 'dist-manifest.txt')
$m136 = Read-Man (Join-Path $d136 'dist-manifest.txt')
'entries 135: ' + $m135.Count + '  136: ' + $m136.Count
'NEW-ONLY:'
foreach ($k in $m136.Keys) { if (-not $m135.ContainsKey($k)) { '  ' + $k } }
'OLD-ONLY:'
foreach ($k in $m135.Keys) { if (-not $m136.ContainsKey($k)) { '  ' + $k } }
'CHANGED (hash differs):'
foreach ($k in $m136.Keys) { if ($m135.ContainsKey($k) -and $m135[$k] -ne $m136[$k]) { '  ' + $k } }
'zip sha256: ' + (Get-FileHash -LiteralPath (Join-Path $root 'dist\[REV-136] Delectatio-et-Dominium idle-service-fixes-mode-renames.zip') -Algorithm SHA256).Hash
