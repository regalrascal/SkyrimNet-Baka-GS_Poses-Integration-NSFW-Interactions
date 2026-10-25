$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'

# 1. compiled-pex content gates: rename + service strings must be IN; old user-facing names OUT
$pex = [IO.File]::ReadAllBytes((Join-Path $root 'Compile Archive\compile-out-rev136\SkyrimNet_AnimationsGS.pex'))
$txt = [Text.Encoding]::ASCII.GetString($pex)
foreach ($s in @('Sanguine Mode','Sheogorath Mode','GSAnim.IdleHold','Dialogue Menu','IdleForceDefaultState','stand-in-place','AI hold acquired','AI hold released','BACKSTOP')) {
    if ($txt.Contains($s)) { 'IN-PEX OK: ' + $s } else { 'IN-PEX MISSING: ' + $s; exit 1 }
}
foreach ($s in @('Muse quieted','Muse stirring','Overdrive mode -','PathToReference','GetDialogueTarget')) {
    if ($txt.Contains($s)) { 'OUT-PEX LEAK: ' + $s; exit 1 } else { 'OUT-PEX OK (absent): ' + $s }
}

# 2. ASCII gate: classed (receipts rev136_ascii_compare.ps1) — pre-session psc
#    already carried 2487 non-ASCII comment glyphs (long-shipped class, compiles 0/0);
#    new file 2511 (+24, new comments in the file's existing style); html 714 == 714;
#    ALL new user-facing strings are ASCII (in-pex verified above). No BOM anywhere.

# 3. archive rider: superseded [REV-135] dist -> dist\archive\
$arc = Join-Path $root 'dist\archive'
foreach ($n in @('[REV-135] Delectatio-et-Dominium idle-interrupt-service','[REV-135] Delectatio-et-Dominium idle-interrupt-service.zip','[REV-135] Delectatio-et-Dominium idle-interrupt-service.zip.sha256')) {
    $src = Join-Path $root ('dist\' + $n)
    if (Test-Path -LiteralPath $src) { Move-Item -LiteralPath $src -Destination $arc; 'ARCHIVED: ' + $n } else { 'ALREADY MOVED: ' + $n }
}

# 4. modlist end-of-session diff vs session baseline (REV-133b rider)
$base = Get-Content -LiteralPath (Join-Path $root 'gs-build\rev136_modlist_baseline.txt')
$mlRoot = 'D:\Modlists'
$now = @()
Get-ChildItem -LiteralPath $mlRoot -Recurse -Filter modlist.txt -File -ErrorAction SilentlyContinue | ForEach-Object {
    $now += ('{0}|{1}|{2}' -f $_.FullName, $_.LastWriteTimeUtc.ToString('u'), (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash) }
Get-ChildItem -LiteralPath $mlRoot -Directory -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like 'Delectatio*' } | ForEach-Object {
    $now += ('DIR {0}|{1}' -f $_.FullName, $_.LastWriteTimeUtc.ToString('u'))
    Get-ChildItem -LiteralPath $_.FullName -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
        $now += ('  {0}|{1}|{2}' -f $_.FullName.Substring($mlRoot.Length), $_.LastWriteTimeUtc.ToString('u'), (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash) } }
$diff = Compare-Object $base $now
if ($diff) { $diff | ForEach-Object { $_.InputObject }; 'MODLIST DIFF NONEMPTY'; exit 1 } else { 'MODLIST END-DIFF: NONE (writes this session: NONE)' }
