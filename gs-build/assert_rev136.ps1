$ErrorActionPreference = 'Stop'
$src = 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\DeD-Handoff-2'
$dst = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\DeD-Handoff-2'
if (Test-Path -LiteralPath $dst) { throw 'Destination already exists - aborting' }
Copy-Item -LiteralPath $src -Destination $dst -Recurse
# verify every file copied intact against the manifest
$bad = @()
Get-ChildItem -LiteralPath $dst -Recurse -File | Where-Object Name -ne 'MANIFEST-SHA256.txt' | ForEach-Object {
  $rel = $_.FullName.Substring($dst.Length + 1)
  $entry = (Get-Content -LiteralPath (Join-Path $dst 'MANIFEST-SHA256.txt')) | Where-Object { $_ -match ([regex]::Escape($rel) + '$') -and $_ -notmatch 'MANIFEST' }
  if (-not $entry) { $bad += "MISSING-IN-MANIFEST: $rel"; return }
  $expected = ($entry -split '\s+')[0]
  $actual = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
  if ($expected -ne $actual) { $bad += "HASH-MISMATCH: $rel" }
}
if ($bad.Count) { $bad; throw 'VERIFICATION FAILED - source NOT deleted' }
$nSrc = (Get-ChildItem -LiteralPath $src -Recurse -File | Measure-Object).Count
$nDst = (Get-ChildItem -LiteralPath $dst -Recurse -File | Measure-Object).Count
if ($nSrc -ne $nDst) { throw "COUNT MISMATCH src=$nSrc dst=$nDst - source NOT deleted" }
# verify manifest itself too
$mh = (Get-FileHash -LiteralPath (Join-Path $src 'MANIFEST-SHA256.txt')).Hash
$dh = (Get-FileHash -LiteralPath (Join-Path $dst 'MANIFEST-SHA256.txt')).Hash
if ($mh -ne $dh) { throw 'MANIFEST HASH MISMATCH - source NOT deleted' }
Remove-Item -LiteralPath $src -Recurse -Force
if (Test-Path -LiteralPath $src) { throw 'SOURCE DELETE FAILED' } else { "COPY-VERIFIED-AND-DELETED: $nDst files at $dst" }

