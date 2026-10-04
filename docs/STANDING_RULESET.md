# STANDING RULESET — GS / Baka SkyrimNet work

**Canonical:** GS repo `SkyrimNet-Animations-GS`, branch `gs-muse-redesign`, `docs/STANDING_RULESET.md`.

**READ FIRST — standing rule:** this ruleset is read at the start of EVERY task
list. The gate report confirms compliance: **"ruleset: read, 10 rules checked."**

**Precedence:** on any conflict with a brief, instruction set, or chat memory,
THIS RULESET WINS.

---

## 1. Deploy target

All Baka/GS runtime artifacts (`.pex`, `.psc`, prompts, YAMLs) deploy to the
**Build Patch ONLY** — `D:\Modlists\LoreRim\mods\SN AnimationsGS v1.1.0 Build Patch\`.
The Build Patch wins MO2 resolution over both base mods
(`SkyrimNet_AnimationsGS_v1.0.4`, `SkyrimNet - SkyrimNet_BakaIntegration_v2.0.7`)
— **empirically proven 09-16** (Ultra profile; patch-priority win confirmed by
modlist order plus live-trace-vs-string match on the 09-15 session logs).
Base-mod copies are never the deploy target; if a build lands there it is a
**wrong-tree deploy**: resync to the patch before the gate closes.
Exceptions on record: none for scripts. **§1 dual-tree YAML exception RETIRED at rev-49 consolidation** — the fork is now the single deploy tree (one copy). The Build Patch remains the live deploy target until the fork lands in-game; wrong-tree-deploy protection (resync to patch before gate closes) stands.

## 2. Post-deploy resolution check

After every deploy, verify the file the GAME loads — the patch-tree copy at the
winning priority. **Hash-verify the Build Patch copy specifically**, not just
the deploy target. A deploy is not done until the patch tree matches the fresh
lineage.

## 3. Compile integrity

Compile from a clean checkout at the recorded commit. Stub-signature audit
against installed framework source on any framework-adjacent build. Compile
bats are versioned per repo — **open item: both bats currently unversioned**
(flagged; user's call).

## 4. Validate-first

`validate_custom_action` / `validate_prompt` per protocol. Smoke test with the
corrected markers at every game-up. The main-menu form proves connectivity
only — the **in-game form (save loaded, NPCs near) is the validated pass**.

## 5. Sentinels

Every behavioral change ships with unconditional trace sentinels in the code.
Log-read greps are drawn from the sentinels list — never from ids that don't
appear in the render.

## 6. Commit discipline

Mod-separated commits (GS repo and Baka repo separately); commit-per-artifact;
records updated **in** the task's commit, not after. `PROJECT_STATE.md`
(GS repo, canonical) is updated in the same commit as every completed task.

## 7. Evidence before intervention

Diagnose from logs before changing behavior. **Report-only gates**: findings
and proposals are reported for approval, not built unapproved. User-facing
strings require user text approval.

**§7 rider — FOMOD/manifest title fields (REV-68 ruling, user-ordered,
2026-10-02):** all player-facing TITLE fields (FOMOD `info.xml` `<Name>` /
`ModuleConfig.xml` `<moduleName>` / SkyrimNet manifest `title`, and any future
player-facing title surface) are authored as **"Delectatio et Dominium"**,
tagline **"Bedroom drama for SkyrimNet"**. Legacy Beta 25 names are retained
ONLY in technical path/manifest ids (`{author}.{slug}` ids, e.g.
`regalrascal.baka-gs-integration`; folder names; esp filenames) — those ids are
load-bearing and DO NOT change. The title/tagline pair above is
user-text-approved as of this rider.

## 8. Honest-assumption audit

Every session ends with an explicit audit of assumptions made — including any
that were silently baked in.

## 9. Known log surfaces

- openrouter_input / openrouter_output: `D:\Modlists\LoreRim\overwrite\SKSE\Plugins\SkyrimNet\logs\`
- Papyrus logs (current + rotated): `%USERPROFILE%\Documents\My Games\Skyrim Special Edition\Logs\Script\`
- conversation_log · STFU log · threads.json (SkyrimNet logs tree)
- dashboard: `localhost:8080` · MCP: `localhost:8889`

## 10. Ruleset precedence

When this ruleset conflicts with any brief or chat memory, the ruleset wins
(see header). Rules 1–2 exist because a wrong-tree deploy silently un-shipped
a full build once (09-16, §4 audit in `TASK4_RECORDS_REV16.md`).

---

**Rider (rev-22, approved) — LLM-output exact-match normalization:** any
exact-match comparison (allowlist, keyword switch, dictionary lookup) against
LLM-generated output MUST normalize whitespace — trim leading AND trailing
characters — before comparison. Origin: the rev-20 muse trailing-space defect
(`(PoseAroused )` skipped "not allowlisted" on 9/9 seeds because the parse site
trimmed only a leading space; fixed rev-21). Applies to every current and future
parse site that consumes openrouter/LLM strings. Rides on the §5 sentinel
discipline; the numbered rule count stays 10.

**Rider (rev-42, user-ordered) — revision-stamped MO2 folder names:** every
DEPLOYED patch artifact's MO2 folder name carries its landing revision gate —
e.g. `SN-AnimationsGS-Baka-CommunityPatch (rev-42)` — so the load order is
self-auditing at a glance. Renames are MO2 edits, done only under a CLOSED
MO2; the modlist is re-verified after the rename; the boot sentinel remains
the load-time proof regardless of the name. Stale-revision folders (e.g. the
superseded StageGraph Overlay rev-28/rev-30 folders) should be removed at the
same opportunity. Rides on §1/§2; the numbered rule count stays 10.

**Rider (rev-47, approved) — plan/act split:** planner-role sessions (planning, evidence analysis, log interpretation, diagnostics, gate-report content) are separated from act-role sessions (file edits specified by an approved plan, grep/hash/copy/compile execution, and other mechanical operations). (1) Every act-model batch must be verified after completion — hash checks on every touched file, compile results confirmed (0 errors / 0 warnings or explained), manifest/diff checks where applicable. A batch that cannot be verified is reported as incomplete. (2) The gate report's FINDINGS and VERDICTS must be planner-authored or planner-reviewed-and-amended; if the planner cannot write files, the act model may transcribe the report, but the planner must review and confirm the findings/verdicts before the gate closes — recorded as a one-line planner-confirmation note in the report. An act-model-only report cannot close a gate. (3) If the act model encounters anything not specified by the plan (unexpected content, a mismatch, a judgment call), it STOPS and reports back for planner/user decision rather than improvising — partial completion with a clear stop-note beats silent improvisation. (4) Rides on §7 (report-only gates) and §8 (honest-assumption audit); both remain planner obligations regardless of which model executes. The numbered rule count stays 10.

**Rider (rev-55, user ruling, dated 2026-09-29) — binary-build discipline + feature-doc routing:** the standing no-rebuild convention is RETIRED (user ruling of record, this rev) — the project may modify both DLLs and esps via the real toolchain. Replaced by: (a) DLL/esp changes build from tracked source via the real toolchain; hand-edited binaries remain forbidden; (b) a verified reference build precedes the first modified build of any binary; (c) reference builds are not expected to byte-match shipped binaries — verification = zero-error build + matching exports/entry points + mandatory dogfood; (d) shipped binary hashes are recorded in release manifests. Additionally (documentation-model rider, same ruling): a finding lives in its `docs/features/{feature}.md`; it goes central (PROJECT_STATE.md) ONLY if it concerns multiple features, toolchain, releases, rules, or cross-feature rulings; `docs/features/INDEX.md` rows update on every status change; the ruleset itself never modularizes. Rides on §3/§4/§5; the numbered rule count stays 10.

**Rider (rev-57, approved) — FILE_STRUCTURE path authority:** `docs/FILE_STRUCTURE.md` (GS canonical repo; mirrored here as `docs/FILE_STRUCTURE.md`) is the single path authority for all worktrees, deploy targets, archives, and tool paths. Historical path references in earlier records are superseded by it — historical records are immutable and are corrected only by banner-prepending, never by rewriting. If an audit finding (including this repo's stale-path audits) conflicts with FILE_STRUCTURE design, that conflict is a STOP for planner/user decision, not an improvisation point. Rides on §7/§10; the numbered rule count stays 10.

**Rider (rev-75, user-ordered 2026-10-03) — tool-loop / runaway-batch guards:** after
three user-interrupted runaway tool loops (latest: a ~180-call batch with duplicates
and no-op filler commands), the following are STANDING while executing any task:
(1) **Batch cap:** a single response contains at most **4 tool calls**; larger
evidence needs are split across responses. (2) **No filler:** every call must have a
distinct, task-relevant purpose; identical or trivial no-op calls ("echo done") are
forbidden. (3) **Dedupe:** no command (by text or by intent) is issued twice in a
session unless its prior result is explicitly noted as unusable and why. (4) **Retry
budget:** a failing command/tool gets at most **3 attempts** (with a materially
different fix each time), then it is reported as blocked and the task proceeds by
other means or stops. (5) **Missing-result halt:** if tool results come back empty,
duplicated, or "[migration] missing", the agent STOPS issuing calls, states what
happened, and re-derives the smallest next batch — it never "re-sends everything."
(6) **Three-strike stop:** after 3 consecutive failed/empty batches, halt and report
for user decision. Rides on §7/§8 (report what was and wasn't verified); the numbered
rule count stays 10.

**Rider (REV-77 close, user-ordered 2026-10-04) — shipping-features checklist
(reconciliation-gate guard, generalized):** the dist-build reconciliation gate
now runs THE SHIPPING-FEATURES CHECKLIST — a maintained list where every
persistent, user-facing feature of the package gets a guard line **at ship
time, not at discovery time**. File-set consistency alone is not completeness:
**a reconciliation gate inherits the blind spots of its first manifest —
consistency is not completeness** (the fomod/ lesson: fomod/ vanished from
dist zips at REV-72 and the gate stayed green for four builds because no
checklist line asserted the feature). Checklist v1:
1. `fomod/` present at zip root; `ModuleConfig.xml` parses as XML (REV-76-b).
Pending future entries (append at their ship): real module toggles.
Checklist v2 (REV-79, 2026-10-04): 2. REV-79 zip contains the 8-page
MCM (8 `Pages[]` entries in `SNBaka_MCM.psc`: General / Timing /
Resist / Spank / Scenes & FX / Plugins / Acheron / SlaveTats) —
the REV-79 restructure shipped and is asserted at ship time.
Rides on §3/§5; the numbered rule count stays 10.
[appended at REV-79: this rider was missing from the fork mirror — resynced
from GS canonical with the checklist already at v2; see PROJECT_STATE §80 5b.]

**Rider (REV-79, user-approved 2026-10-04) — stub-parity build gate +
Papyrus log location (§3/§5 riders):** (1) `tools\compile\stub_parity.ps1`
runs as a BLOCKING pre-step of `compile_baka.bat` (exit 1 aborts the
build): every local compile-stub signature must parity-match the
INSTALLED runtime source, defaults included, with inherited members
resolved (the gate walks `extends` chains on the runtime side; stubs
stay flat); and shipped pex must not call any function the runtime
lacks (SkyUI truth = the `SkyUI_SE.bsa` name table). Motivating class:
`JArray.getObj` 2-vs-3 args (PROJECT_STATE §80; 294 runtime aborts) and
`Acheron.AddOption` 3-arg-void vs 4-arg-int (caught by the gate's first
live run, same class). Any stub change must be mirrored to the GS
`tools\compile\stubs\` copy in the same session, hash-verified. Gate
scripts and build bats are ASCII-only — no em-dashes (PowerShell 5.1 +
no-BOM UTF-8 + em-dash = parse breakage). (2) The Papyrus script log
lives under `Documents\My Games\Skyrim Special Edition\Logs\Script\`,
NOT under the SKSE dir. Rides on §3/§5; the numbered rule count stays 10.
