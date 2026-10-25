$ErrorActionPreference = 'Stop'
$root = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$name = '[REV-163] Delectatio-et-Dominium picker-decommission'
$z = Join-Path $root ('dist\' + $name + '.zip')
$fail = 0
function Gate([string]$label, [bool]$ok) {
    if ($ok) { Write-Host "PASS -- $label" } else { Write-Host "FAIL -- $label"; $script:fail = 1 }
}
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [IO.Compression.ZipFile]::OpenRead($z)
try {
    $zipEntries = $zip.Entries | ForEach-Object { $_.FullName }
    function ZipText([string]$entry) {
        $e = $zip.GetEntry($entry)
        if (-not $e) { return $null }
        $sr = New-Object IO.StreamReader($e.Open())
        try { $sr.ReadToEnd() } finally { $sr.Dispose() }
    }

    # v1: pex picker symbols ABSENT, REV-163 symbols PRESENT (build output + zip pex)
    $pex = [IO.File]::ReadAllBytes((Join-Path $root 'Compile Archive\compile-out-rev163\SkyrimNet_AnimationsGS.pex'))
    $t = [Text.Encoding]::ASCII.GetString($pex)
    Gate 'v1a pex: OnPosePicked ABSENT' (-not $t.Contains('OnPosePicked'))
    Gate 'v1b pex: pose_picker ABSENT' (-not $t.Contains('pose_picker'))
    Gate 'v1c pex: _posePickActor ABSENT' (-not $t.Contains('_posePickActor'))
    Gate 'v1d pex: _PosePickWanted ABSENT' (-not $t.Contains('_PosePickWanted'))
    Gate 'v1e pex: | CLIP: PRESENT' ($t.Contains('| CLIP:'))
    Gate 'v1f pex: poseCatalog PRESENT' ($t.Contains('poseCatalog'))
    Gate 'v1g pex: _MusePoseCatalogText PRESENT' ($t.Contains('_MusePoseCatalogText'))
    Gate 'v1h pex: LLM move pick sentinel PRESENT' ($t.Contains('LLM move pick'))
    Gate 'v1i pex: exact-pick fires sentinel PRESENT' ($t.Contains('exact-pick fires'))
    $zp = ZipText 'Scripts/SkyrimNet_AnimationsGS.pex'
    Gate 'v1j zip pex: picker symbols ABSENT, CLIP PRESENT' (($null -ne $zp) -and (-not $zp.Contains('OnPosePicked')) -and (-not $zp.Contains('pose_picker')) -and $zp.Contains('| CLIP:'))

    # v2: the retired decision template ABSENT from tree + zip
    Gate 'v2a tree: pose_picker.prompt deleted' (-not (Test-Path (Join-Path $root 'SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\prompts\decisions\ded\pose_picker.prompt')))
    Gate 'v2b zip: no pose_picker entry' (-not ($zipEntries | Where-Object { $_ -match 'pose_picker' }))

    # v3: the consideration prompt carries the catalog + CLIP contract (tree + zip)
    $pr = Join-Path $root 'SKSE\Plugins\SkyrimNet\external\regalrascal.gs-poses\prompts\gsanim_muse_consideration.prompt'
    $pt = [IO.File]::ReadAllText($pr)
    Gate 'v3a prompt: poseCatalog render PRESENT' ($pt.Contains('{{ poseCatalog }}'))
    Gate 'v3b prompt: CLIP answer contract PRESENT' ($pt.Contains('POSE: <pose name> | CLIP: <exact move key>'))
    Gate 'v3c prompt: static library list GONE' (-not ($pt.Contains('PoseMeditate, PoseScratchHead')))
    $zp2 = ZipText 'SKSE/Plugins/SkyrimNet/external/regalrascal.gs-poses/prompts/gsanim_muse_consideration.prompt'
    Gate 'v3d zip prompt: catalog + CLIP PRESENT' (($null -ne $zp2) -and $zp2.Contains('{{ poseCatalog }}') -and $zp2.Contains('CLIP'))

    # v4: instruction-tail removals (tree + zip)
    $checks = @(
        @('sdb_fhu_ambient_narr.yaml', 'Never explain'),
        @('sdb_tattoo_observed_narr.yaml', 'Do not invent'),
        @('posedance.yaml', 'FEMALE CHARACTERS ONLY'),
        @('posedance.yaml', 'DO NOT USE'),
        @('poseseduce.yaml', 'DO NOT USE')
    )
    foreach ($c in $checks) {
        $f = Get-ChildItem -LiteralPath (Join-Path $root 'SKSE') -Recurse -Filter $c[0] -File
        $ok = ($f.Count -gt 0)
        foreach ($x in $f) { if ((Get-Content -LiteralPath $x.FullName -Raw).Contains($c[1])) { $ok = $false } }
        Gate "v4 tree: $($c[1]) ABSENT in $($c[0])" $ok
        foreach ($ze in ($zipEntries | Where-Object { $_.EndsWith($c[0]) })) {
            $zt = ZipText $ze
            if ($zt -and $zt.Contains($c[1])) { Gate "v4 zip: $($c[1]) ABSENT in $ze" $false }
        }
    }
    # (the ten un-swept yamls still carry DO NOT USE -- expected, flagged)
    $unswept = @('posedancesexy','posegroundsexy','posegroundidle','poseidle','poseplead','posepresent','poseselftouch','posestretch','posesubmission','poseworkout')
    $carry = 0
    foreach ($u in $unswept) {
        $p = Join-Path $root ("SKSE\Plugins\SkyrimNet\external\regalrascal.gs-poses\actions\$u.yaml")
        if ((Get-Content -LiteralPath $p -Raw).Contains('DO NOT USE')) { $carry++ }
    }
    Gate "v4c known-tail census: 10/10 un-swept yamls still carry DO NOT USE (flagged)" ($carry -eq 10)

    # v5: psc mirror lockstep (fork <-> GS canonical)
    $a = (Get-FileHash -LiteralPath (Join-Path $root 'Scripts\Source\SkyrimNet_AnimationsGS.psc')).Hash
    $b = (Get-FileHash -LiteralPath 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\Scripts\Source\SkyrimNet_AnimationsGS.psc').Hash
    Gate 'v5 psc mirror: fork == GS canonical' ($a -eq $b)

    # v6: register lockstep + entry 40
    $ra = (Get-FileHash -LiteralPath (Join-Path $root 'docs\pending-approvals.md')).Hash
    $rb = (Get-FileHash -LiteralPath 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\docs\pending-approvals.md').Hash
    Gate 'v6a register: fork == GS lockstep' ($ra -eq $rb)
    $reg = Get-Content -LiteralPath (Join-Path $root 'docs\pending-approvals.md') -Raw
    Gate 'v6b register: entry 40 staged' ($reg.Contains('Entry 40'))
    Gate 'v6c register: open set = 36, 37, 39, 40' ($reg.Contains('Open entries: 36, 37, 39, 40'))

    # v7: staging copies hash-matched
    foreach ($rel in @('posedance.yaml','poseseduce.yaml','gsanim_muse_consideration.prompt')) {
        $m = Get-ChildItem -LiteralPath (Join-Path $root 'SKSE') -Recurse -Filter $rel -File | Select-Object -First 1
        $s = Get-ChildItem -LiteralPath (Join-Path $root 'public-staging\SKSE') -Recurse -Filter $rel -File | Select-Object -First 1
        Gate "v7 staging hash: $rel" ((Get-FileHash -LiteralPath $m.FullName).Hash -eq (Get-FileHash -LiteralPath $s.FullName).Hash)
    }
} finally { $zip.Dispose() }

Write-Host ''
if ($fail -eq 0) { Write-Host 'REV-163 GATES: ALL PASS'; exit 0 } else { Write-Host 'REV-163 GATES: FAILURES PRESENT'; exit 1 }
