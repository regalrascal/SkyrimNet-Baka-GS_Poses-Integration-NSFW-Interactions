$ErrorActionPreference = 'Stop'
$p = 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\docs\features\INDEX.md'
$t = [IO.File]::ReadAllText($p)

# Row 3 (baka-daemon): append the REV-134e/136 strip-rulings pointer before the row's closing pipe
$r3old = 'inherits the idle-interrupt service day-one (gs-poses.md REV-134e); alpha-28 rows mapped. NOTHING BUILT. |'
$r3new = 'inherits the idle-interrupt service day-one (gs-poses.md REV-134e; REV-136 fixes applied: stand-in-place exit + AI-hold re-grab prevention + mid-dialogue narrowed to the vanilla menu). alpha-28 rows mapped. **REV-136 (2026-10-22): STRIP rulings of record** (baka-module.md REV-136 rulings-applied): (i)(a) gear to victim OWN inventory (tracked); (ii)(b) stays off + NEW "All to dress" downed-menu tile (id 11) restoring tracked gear, MANDATORY v2-build pre-check (no SeverActions/SL-OStim dress-GUI conflict; restore only OUR tracked items; STOP if no clean shape); (iii) SexLab StripActor primary, vanilla presence-gated fallback. Register entry 27 CLOSED (approved) - wording of record in baka-module.md. NOTHING BUILT. |'
if (-not $t.Contains($r3old)) { throw 'row 3 anchor not found' }
$t = $t.Replace($r3old, $r3new)

# Row 6 (fhu-inflation): append the REV-136 rulings pointer
$r6old = 'three options surfaced, ruling requested, user lean noted. Report-only. |'
$r6new = 'three options surfaced, ruling requested, user lean noted. **REV-136 (2026-10-22): ALL FIVE RULED** (fhu-inflation.md REV-136 section): (a) instant-inflate arousal = CAPTURED-AT-SCENE-ENTRY (stash per actor at scene start); (b) CONSENT-CONTEXT primary frame; (c) deflate/ambient keep the post-collapse "sated" read; (d) NEW creature-cum ambient cue lane - user template quoted verbatim in-doc, discovery pre-check (FHU per-race cum-effect FormLists, sr_inflateConfig L1687-1789 + sr.inflater.injector formlists) deferred to the v2 build, canned descriptions are section-7 (register at build); (e) NEW per-orifice deflation (anal/vaginal/oral) as distinct ambient trigger types - discriminator = which sr.inflater.cum.* float dropped, design home = the planner expel-triggers subsection. Report-only. |'
if (-not $t.Contains($r6old)) { throw 'row 6 anchor not found' }
$t = $t.Replace($r6old, $r6new)

# Row 18 (pose-picker): rewrite the rulings-menu tail
$r18old = 'rulings menu 2.2 (a)-(e) OPEN; executor consumes the idle-interrupt service. NOTHING BUILT. |'
$r18new = 'rulings LANDED REV-136 (2026-10-22, pose-picker.md REV-136 section): (e) the Prisma drilldown is PLAYER-ONLY - the decision model NEVER appears in the crosshair/grid UI (prior 2.2(e) VOID); consumers = the AUTONOMOUS lanes only (emergent/ambient NPC pose selection + Sanguine Mode action selection; Sheogorath Mode stays RANDOM); (a) all categories / (b) minimal context / (c) random-in-category fallback - carried, re-aimed at the ambient consumer; (d) dialogue-commanded poses STAY in SN native action-selection (deferred watch item, revisit only if base-mod selection evolves). Design note: templates return an action PICK - under Sanguine Mode the thought-seed is a separate GenerateNPCThought call after the pick (resolve at daemon build). Executor consumes the idle-interrupt service. NOTHING BUILT. |'
if (-not $t.Contains($r18old)) { throw 'row 18 anchor not found' }
$t = $t.Replace($r18old, $r18new)

[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
Write-Output 'INDEX rows 3/6/18 updated (REV-136 notes)'