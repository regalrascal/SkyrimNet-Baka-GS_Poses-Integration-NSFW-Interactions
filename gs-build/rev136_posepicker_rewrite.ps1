$ErrorActionPreference = 'Stop'
$p = 'C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\docs\features\pose-picker.md'
$t = [IO.File]::ReadAllText($p)

# 1. status line
$t = $t.Replace('ready for build once the 2.2 rulings land)',
  'the 2.2 rulings LANDED REV-136, 2026-10-22 -- consumer model of record below;' + [char]10 + 'ready for the daemon-build session)')

# 2. replace the 2.2 section (from its header through the (e) block end) with the REV-136 rulings block
$new = @'
## REV-136 (2026-10-22) -- RULINGS OF RECORD + THE CONSUMER MODEL (user, this exchange)

**The consumer model (ruling (e), VOIDING the prior 2.2(e) UI question):** the
Prisma drilldown is **PLAYER-ONLY** -- the decision model NEVER appears in the
crosshair/grid UI; there is NO "LLM picks" affordance anywhere in the menu.
The prior 2.2 (a)/(b)/(c) recommendations are ruled and RE-AIMED at the
AUTONOMOUS consumers only:

- **(a) Categories:** ALL grid categories expose (the vocabulary is the
  point; the template scopes options to the picked category) -- carried,
  re-aimed at the ambient/emergent consumer.
- **(b) Context:** minimal set (actor name/sex, arousal tier, policy mode,
  current pose, location class) -- carried, re-aimed at the ambient consumer.
- **(c) Fallback:** random-in-category when no decision route is configured
  -- carried, re-aimed at the ambient consumer.

**The picker's consumers:** (1) emergent/ambient NPC pose selection;
(2) **Sanguine Mode** action selection (renamed REV-136 -- the GSAnim.Muse
technical ids unchanged). **Sheogorath Mode stays RANDOM** -- no LLM call
(the GSAnim.Overdrive lane).

**(d) Dialogue-commanded poses (ruled DEFERRED-WATCH):** stay in
SkyrimNet's NATIVE action-selection lane day-one -- no unification; the user
defers action-selection improvements to the SN devs. Recorded as a deferred
watch item: revisit ONLY if the base mod's action selection evolves.

**Design note for the daemon spec (of record):** decision templates return
an ACTION PICK, not a thought -- under Sanguine Mode the thought-seed
becomes a SEPARATE `GenerateNPCThought` call AFTER the pick (the
"two-calls" tradeoff is now the ruled shape). Resolve at the daemon build.
'@
$pat = '(?s)## 2\.2 The design questions \(ruling menu\).*?Ruling requested\.\s*\n'
if (-not ($t -match $pat)) { throw '2.2 section pattern not found' }
$t = [regex]::Replace($t, $pat, ($new + "`n"))
[IO.File]::WriteAllText($p, $t, (New-Object System.Text.UTF8Encoding($false)))
Write-Output 'pose-picker.md rewritten (REV-136 rulings of record)'
Write-Output (Get-Content -LiteralPath $p | Select-Object -First 4)