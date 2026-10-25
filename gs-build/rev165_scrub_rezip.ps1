# REV-165 4: the scrub (REV-111 precedent, full re-run) on the [REV-165] cut tree,
# then manifest regeneration + zip cut from the SCRUBBED tree.
$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$name = '[REV-165] Delectatio-et-Dominium v0.3.0-alpha release-prep'
$d = Join-Path $root ('dist\' + $name)
$z = Join-Path $root ('dist\' + $name + '.zip')
$zs = $z + '.sha256'
$man = Join-Path $root 'releases\manifests\manifest-rev165.txt'
if (-not (Test-Path -LiteralPath $d)) { throw "cut tree not found: $d" }

Write-Host '=== 4.1 comment-class sweep (rev111_scrub, text/comments only) ==='
& (Join-Path $root 'tools\rev111_scrub.ps1') -Stage $d

Write-Host '=== 4.1 pex header identity patch (rev111_pexpatch) ==='
& (Join-Path $root 'tools\rev111_pexpatch.ps1') -ScriptsDir (Join-Path $d 'Scripts')

Write-Host '=== 4.2/4.3 PII + machine-string sweep (REPORT: every hit listed, nothing auto-stripped) ==='
$hits = @()
foreach ($f in (Get-ChildItem -LiteralPath $d -Recurse -File)) {
    if ($f.Extension -in '.jpg','.dds','.wav','.xwm','.swf','.hkx','.bin') { continue }
    if ($f.Extension -in '.dll','.esp','.pex') {
        $b = [Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes($f.FullName))
        foreach ($p in @('Tristan','THEMAINFRAME','C:\Users','.cline')) {
            if ($b.Contains($p)) { $hits += ('BINARY: ' + $f.FullName.Substring($d.Length+1) + ' :: ' + $p) }
        }
        continue
    }
    $t = [IO.File]::ReadAllText($f.FullName)
    foreach ($p in @('Tristan','THEMAINFRAME','C:\Users','.cline','D:\Modding')) {
        if ($t.Contains($p)) { $hits += ('TEXT: ' + $f.FullName.Substring($d.Length+1) + ' :: ' + $p) }
    }
}
if ($hits.Count -gt 0) { $hits | ForEach-Object { Write-Host ('  PII HIT: ' + $_) } }
else { Write-Host '  PII sweep: ZERO hits across the cut tree' }

Write-Host '=== manifest regeneration (post-scrub SHA256s) ==='
$manifest = @('# dist manifest - GENERATED at build time (never maintained); option (b) ruling 2026-10-08/09','# format: SHA256<TAB>size<TAB>relpath')
$n = 0
foreach ($f in (Get-ChildItem -LiteralPath $d -Recurse -File | Sort-Object { ($_.FullName -replace '\\','/') })) {
    $rel = $f.FullName.Substring($d.Length + 1) -replace '\\','/'
    $manifest += ((Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash + "`t" + $f.Length + "`t" + $rel)
    $n++
}
[IO.File]::WriteAllLines($man, $manifest)
Write-Host ("manifest written: $man ($n entries)")

Write-Host '=== zip cut from the SCRUBBED tree ==='
foreach ($p in @($z, $zs)) { if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force } }
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Get-Rel([string]$base, [string]$full) { $full.Substring($base.Length).TrimStart('\','/') -replace '\\','/' }
$files = Get-ChildItem -LiteralPath $d -Recurse -File
$dirs  = Get-ChildItem -LiteralPath $d -Recurse -Directory
$zip = [System.IO.Compression.ZipFile]::Open($z, 'Create')
try {
    foreach ($dir in $dirs) { [void]$zip.CreateEntry((Get-Rel $d $dir.FullName) + '/') }
    foreach ($f in $files) {
        [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $zip, $f.FullName, (Get-Rel $d $f.FullName), [System.IO.Compression.CompressionLevel]::Optimal)
    }
} finally { $zip.Dispose() }
$zipSize = (Get-Item -LiteralPath $z).Length
if ($zipSize -lt 5.0MB -or $zipSize -gt 8.0MB) { throw ("zip-size sanity FAILED: $zipSize B") }
$zh = (Get-FileHash -LiteralPath $z -Algorithm SHA256).Hash
[IO.File]::WriteAllText($zs, ($zh + "  " + [IO.Path]::GetFileName($z) + "`n"))
Write-Host ("zip built: $z ($($files.Count + $dirs.Count) entries, $zipSize B) SHA256 $zh")
