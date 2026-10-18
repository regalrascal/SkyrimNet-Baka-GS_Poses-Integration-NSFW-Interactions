# Pending Approvals Register

Every §7-pending user-facing text lives HERE until ruled — quoted verbatim,
findable at a glance. Nothing ships unapproved.

**Lifecycle:** a draft enters this register at its producing session. The user
rules. Ruled-APPROVED text moves to the owning feature doc as the shipped
wording of record (+ one § line). Ruled-EDITED text is applied first, then
moved the same way. The register never keeps closed entries.

**Register rules (REV-92 rider, 2026-10-10):** (i) every §7 draft enters this
register QUOTED VERBATIM in full; pointer-only entries are prohibited.
(ii) a fork `docs/` copy of this register is maintained, refreshed at EVERY
register change, lockstep with the GS canonical; both hashes are reported at
every change.

**Register state after REV-94 (2026-10-11):** ALL entries CLOSED — 1, 2, 3,
4, 6 at REV-92; 5, 7, 8, 9, 10 at REV-94 (approved 2026-10-11; wording of
record in `fhu-inflation.md` and `baka-module.md` REV-94 sections). The
register is EMPTY of open entries; no new drafts entered at REV-94.

---

## CLOSED at REV-92 (2026-10-10) — rulings of record
- **Entry 1 (execute.yaml description)** — approved with two ruled verbatim
  additions; final full description quoted in `baka-module.md` (REV-92 line)
  and PROJECT_STATE §98. CLOSED.
- **Entry 2 (pose-removal Display string)** — ruled drop-"instead": shipped
  text is `(hold a solo pose via the Pose category). ` (applied at
  `dll-source/src/SkyrimNetBridge.cpp` L75; rides the REV-92 DLL build).
  CLOSED.
- **Entry 3 (posing-gender refusals + neutral sweep)** — approved; wording of
  record in `posing-gender.md` (REV-92 line). CLOSED.
- **Entry 4 (cum-detection cue texts + manifest)** — approved; wording of
  record in `cum-detection.md` (REV-92 line); module files verified
  byte-identical to the registered quotes. CLOSED.
- **Entry 6 (Execute nudge template wording)** — approved WITH the caveat
  ("what happens if the LLM just will not call it, popups anyway") — the
  popup IS BUILT this session (REV-92 Task 2.3), satisfying the caveat. The
  approved action-list addition shipped; the REV-92 connective sentence
  ("Execute is the deliberate killing blow...") is registered as entry 10.
  CLOSED.

---

## 5. FHU-inflation — cue texts + manifest

CLOSED at REV-94 (2026-10-11): entries 5, 7, 8, 9, 10 approved — approved
text moved to the owning feature docs as wording of record; register
refreshed; fork copy lockstep.

- **Feature:** INDEX row 6 (`fhu-inflation`) — **Rev:** REV-63/65 build, REV-66 dogfood-passed — **Status:** CLOSED at REV-94 (2026-10-11) — approved wording of record now in `fhu-inflation.md` (REV-94 section)
- **Module (read + quoted REV-92):** `SKSE\Plugins\SkyrimNet\external\regalrascal.fhu-inflation\` — manifest.json + `triggers\sdb_fhu_inflate.yaml`

**manifest.json description (L6, verbatim):**
> LLM trigger cues for Fill Her Up inflation level changes: swelling (level up) and release (level down), read from FHU's own per-actor state. Source-agnostic by design: the cues describe only the visible state and never assert what caused it, so any framework that feeds FHU benefits automatically.

**manifest.json tagline (L5, verbatim):** "The narrator sees the swelling and the release."

**sdb_fhu_inflate.yaml description (verbatim):** "An actor's belly is suddenly, noticeably fuller (DRAFT - rev-63, sec.7 approval pending)"

**sdb_fhu_inflate.yaml response content (verbatim):**
> {{ originator }}'s belly is noticeably fuller now, swelling with warmth.
> Generate one short beat of the moment -- how it shows on them, and how
> they or someone nearby reacts: embarrassment, pride, discomfort, desire,
> or casual acceptance. One line or one action. Match their personality
> exactly.
>
> Never explain what caused the swelling, and never name any framework or
> source -- describe only the state as it is visible right now.

*(The release-direction trigger rides the same ruling; its text lives in
`fhu-inflation.md` from the module build and was not re-read this session.)*

---

## 7. Execute-gate MCM option description (REV-92 Task 2.1 draft)

CLOSED at REV-94 (2026-10-11) — approved; wording of record in
`baka-module.md` (REV-94 lines). Verbatim approved draft:

> How much the player is asked before an NPC executes a downed victim. Unlimited: never asked (default). Companions ask: your companions ask first - everyone else acts freely. Always ask: every execution asks first. Your own downed-menu Execute button is never gated.

## 8. Execute-confirm popup texts (REV-92 Task 2.3 drafts)

CLOSED at REV-94 (2026-10-11) — approved; wording of record in
`baka-module.md` (REV-94 lines). Verbatim approved drafts:

**Title:** "An Execution Awaits Your Word"
**Hint line:** "SkyrimNet Baka - Execute gate"
**Question (actor names interpolated):** "{Initiator} is about to finish the downed {Target} with a deliberate killing blow." + "Accept the kill, or let the moment pass?"
**Buttons:** "Accept" / "Decline"
**Timeout hint (interpolated):** "The moment passes in {N}s"

## 9. Execute-gate refusal narrations (REV-92 Task 2.3 drafts)

CLOSED at REV-94 (2026-10-11) — approved; wording of record in
`baka-module.md` (REV-94 lines). Verbatim approved drafts:

**Shared frame (actor names interpolated):** "{Initiator} moves to finish {Target} - but the killing blow does not land. {Reason}. The moment passes without a death; keep roleplaying accordingly (do not claim the kill happened)."
**Reason - decline:** "the player declined"
**Reason - timeout:** "the player did not answer in time"
**Reason - moot:** "the moment passed - the victim is no longer helpless"
**Reason - level-2 non-companion:** "not one of the player's companions - the kill is not theirs to take"

## 10. Execute nudge-template connective sentence (REV-92 Task 2.4 draft)

CLOSED at REV-94 (2026-10-11) — approved; wording of record in
`baka-module.md` (REV-94 lines). Verbatim approved draft:

> Execute is the deliberate killing blow on a downed victim — first when the loser is an enemy the winner wants dead.

*(Sentence identical in all three templates; the baka_opportunity variant places it inside the Execute parentheses.)*

---

## 11. Execute action wording rider (REV-98b, 2026-10-12 — user-delegated wording, dogfood-gated)

CREATED + CLOSED in the same session per the user's standing ruling
(user-delegated wording). Base adopted from Oldcustard's execute-llm-action
fork — upstream repo since deleted (404, verified 2026-10-12); the base text
survives in the USER-PRESERVED copy (enabled mod folder,
`Delectatio-et-Dominium-rev96-probe-and-modules`, read-only fetch per the
REV-91 read precedent) — truth-reconciled to our executor and shipped at
REV-98b as wording of record:
`SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\actions\execute.yaml`
(the shipped file IS the verbatim wording of record; description quoted there
in full).

Ruled judgments applied: "or TIED" REMOVED (one site present in the
preserved copy — noted; no second site found); the essential/protected
survival line KEPT (TRUE per psc L2102-2107 + §103 evidence); "coup de
grâce" -> "coup de grace" (NO site present in the preserved copy — ruling
held in reserve, noted); henchman line OMITTED (ruled redundant with the
leader's-demand "Duty or orders" line); cultist entry KEPT; "If you kill,
own it - this fires a visible event the world reacts to" KEPT; ASCII-only.
Dogfood-gated: the J'zargo trial + delegation occasion ride the REV-98b
handoff (Task 5).

**REV-99 annotation (2026-10-09):** wording trial SUSPENDED 2026-10-09 —
incident (see PROJECT_STATE §105): an Execute fired during an active SexLab
scene and the session crashed; disabled pending investigation. The shipped
wording text itself is untouched by the disable (execute.yaml `enabled:`
false only).

---

## 12. Execute scene-refusal narration + re-enable ruling (REV-100/REV-101, 2026-10-11)

**CLOSED at REV-101 (2026-10-11) — both items user-ruled; lane shipped [REV-101].**

**12a. Scene-refusal narration — CLOSED (user-edited, approved verbatim).** Fired via
the `baka_execute_refused` event on every scene-active refusal (both executor guard
layers + the kill-time recheck). Wording of record (actor names interpolated — psc L6541
concatenates the initiator's display name; ASCII per checklist v8), now in baka-module.md
(REV-101 section):

> {Initiator} holds off - killing someone mid-act would end the fun, and the moment
> doesn't call for it.

(The user's edit from the REV-100 draft: "would end the scene" -> "would end the fun".)

**12b. RE-ENABLE RULING — CLOSED (user ruling 2026-10-11):** execute.yaml re-enabled
(`enabled: true`) with the [REV-100] guards live. The lane ships EXPERIMENTAL — guarded
(both layers), community-honed, honestly labeled; release-notes label of record:
"Execute action: experimental - community feedback welcome". Single reversible yaml line
if the label is ever revoked.

---
*Register refreshed at REV-94 (2026-10-11): ALL entries CLOSED (1-4, 6 at
REV-92; 5, 7-10 at REV-94). Register EMPTY of open entries as of this
refresh. Fork copy lockstep. New drafts would enter per the standing rules.*

---
*REV-98b refresh (2026-10-12): entry 11 created + closed same-session
(user-delegated wording, dogfood-gated). Register EMPTY of open entries.
Fork copy lockstep.*

## 13. Acheron-integration manifest — description + tagline (REV-104, 2026-10-12; OPEN, dogfood-gated)

**Feature:** INDEX row 16 (`unification-era`, S1 legs) — **Rev:** REV-104 —
**Status:** OPEN (user confirm pending; rides the 5.1 gate report, not a build
blocker — the layer was DEAD without any manifest, so the draft restores
function while the wording is ruled).

**Module:** `SKSE\Plugins\SkyrimNet\external\around906.acheron-integration\manifest.json`
(authored this rev from the 62-era Task-2d proposal; sha256 00F80C57..).

**manifest.json tagline (verbatim):**
> Downed-state bridge between Acheron defeats and SkyrimNet/Baka.

**manifest.json description (verbatim):**
> Connects Acheron's defeat-and-hold system to SkyrimNet: delegated downs route through Acheron.DefeatActor, downed NPCs emit cues and reminders, creature hand-off and auto get-up are configurable, and Acheron-side rescue events feed back into SkyrimNet triggers. Folded into the unified Delectatio et Dominium build; this layer carries the two framework-side triggers (acheron_downed, acheron_recovered) whose narration was invisible to the content library until REV-104.

Dogfood-gated per the REV-98b entry-11 precedent (user-delegated wording).
Also pending user confirm at the same gate: the GS pack id `regalrascal.gs-poses`
(proposed per the DevKit author.slug rule; the only rule-compliant shape).

## 14. FOMOD v2 wizard tooltips — §7 ruling + MO2 wizard test gate (REV-108, 2026-10-13; tooltip wording CLOSED at REV-108b — wizard test carried to entry 15b)

**REV-108b status amendment (2026-10-13):** the §7 tooltip-wording gate is
CLOSED — tooltips APPROVED-AS-FIRST-DRAFT per user ruling (user-editable
baseline, no longer pending). The anchor tooltip was additionally amended at
REV-108b as the factual-corruption minimum ("You cannot deselect this." —
the framework rides requiredInstallFiles regardless of the anchor checkbox).
The "Arousal Framework Check" plugin named in this entry's scope was REMOVED
at REV-108b per the C4-supersession ruling (entry 15a). The MO2 wizard-test
half of this entry carries into entry 15b (now against dist [REV-108b]).

**Feature:** INDEX row 16 (`unification-era`, FOMOD v2) — **Rev:** REV-108 —
**Status:** OPEN (the tooltips shipped as drafts in `fomod/ModuleConfig.xml`
v2 — the wizard renders them as-is; §7 ruling is a wording gate, not a
build blocker; the dist is gate-independent packaging).

**Scope (8 plugin descriptions + the info.xml Description line):** the
"Framework (always installed)" anchor tooltip, 6 module tooltips (Baka
Interactions, GS Poses incl. the muse reduced-vocabulary note, Cum
Detection, FHU Inflation, SlaveTats incl. the Acheron-coupling note,
Acheron Bridge), the "Arousal Framework Check" disclosure (the Reborn
false-positive limit + the runtime chain of record), and the info.xml
Description (module-toggle wording). All drafted in the honest-capability
register: registry detection only, modules runtime presence-gated.

**Also pending at the same gate: the MO2 wizard test (cannot be
headless-simulated):** (a) install [REV-108] with GS Poses DESELECTED —
expect the wizard to install framework + 5 modules and NO
SkyrimNet_AnimationsGS esp / SNAnimGS_UI.dll / regalrascal.gs-poses pack /
GSAnim_Menu index+poses files; (b) full install for the 11-page MCM parity;
(c) the Arousal Framework Check plugin observation (Reborn-only users see
the grey-out per the disclosed limit).

## 15. README arousal-framework line (C4 supersession surface) + REV-108b wizard-render test (REV-108b, 2026-10-13; OPEN)

**Feature:** INDEX row 16 (`unification-era`, FOMOD v2 hotfix REV-108b) —
**Rev:** REV-108b — **Status:** OPEN (two user gates).

**15a. README arousal line:** the "Arousal Framework Check" install-time
plugin is REMOVED per the user ruling (C4 supersession) — the implemented
surface of record is now the README `### Soft (strongly recommended)` line
(pick ONE framework: OSL Aroused Reborn or SL Aroused NG; runtime chain
Reborn -> SL Aroused -> neutral) + the runtime chain itself. The line SHIPPED
as a draft (README.md, after the SeverActions entry); wording ruling pending
— user edits the draft.

**REV-111 rider (2026-10-14):** the README arousal line now RIDES the
public-staging README — the [REV-111] stake copied the shipped README as the
public repo's README base and the draft line ships there in the Soft
requirements section, flagged user-reviewable at the pre-push §7 review
(README + CHANGELOG + LICENSE reviewed together; receipts PROJECT_STATE
§121 4). This register entry remains the OPEN wording gate; the public
review is the same ruling event.

**15b. Wizard-render test (checklist v10 rider 10a):** on dist [REV-108b] —
deselect one module (GS Poses): the checkbox must be CLICKABLE and the choice
must STICK (the [REV-108] bug: SelectAll locked every toggle), and the GS
files must be ABSENT post-install (no SkyrimNet_AnimationsGS esp /
SNAnimGS_UI.dll / regalrascal.gs-poses pack / GSAnim_Menu index+poses);
then a full install for the 11-page MCM parity. MO2's wizard cannot be
headless-simulated.

## 16. REV-109 MCM restructure bulk reword set (display-length audit + absent-state tails; 2026-10-13; OPEN)

**Feature:** INDEX row 16 (`unification-era`, MCM productization REV-109) —
**Rev:** REV-109 — **Status:** OPEN (user wording rulings pending; shipped as
first drafts per the entry-14 user-editable-baseline precedent).

The REV-109 display-length audit reworded these SHIPPED MCM strings in
`Scripts/Source/DeD_MCM.psc`. Every string is ASCII (the full-surface sweep
receipt = 0 non-ASCII; this entry covers REWORDS only, not the sweep). All
quoted verbatim, OLD -> NEW.

**16a. Class (b) splits — long text moved from the option surface into the
InfoText detail (three; the label/value ships SHORT, the full wording rides
the info):**

- **QTE Keys** (Baka - Resist page; value): OLD "Configured in Flash Games -
  Struggling QTE  (WASD / d-pad)" -> NEW "Flash Games - Struggling QTE".
  NEW InfoText (verbatim): "Struggle QTE keys: WASD / d-pad. Not configured
  here - set them in the 'Flash Games' mod's Struggling QTE section."
- **SlaveTats intro** (SlaveTats page; label): OLD "Sets are chosen in the
  in-game Tattoo Menu; this section only decides WHICH events fire them
  automatically." -> NEW "Sets are picked in the Tattoo Menu." NEW InfoText
  (verbatim): "Sets are chosen in the in-game Tattoo Menu; this section only
  decides WHICH events fire them automatically."
- **GS Poses intro** (GS Poses page; label): OLD "Who may be posed, by body:
  female-only keeps the shipped behavior; curated admits men to the neutral
  set; all-poses opens the whole library." -> NEW "Who may be posed, by
  body:". NEW InfoText (verbatim): "Who may be posed, by body: female-only
  keeps the shipped behavior; curated admits men to the neutral set;
  all-poses opens the whole library."

**16b. Class (a) shortenings — absent-state "(not installed)" tails
normalized (six):**

- "Allow Sell to Slavery (Simple Slavery++ not installed)" -> "Allow Sell to
  Slavery (not installed)"
- "Allow Follower Enslavement (FSM not installed)" -> "Follower Enslavement
  (not installed)"
- "Enable Lap Sitting Actions (mod not installed)" -> "Lap Sitting Actions
  (not installed)"
- "Inflation Level Cues (mod not installed)" -> "Inflation Level Cues (not
  installed)"
- "Bridge Enabled (Acheron bridge not installed)" -> "Bridge Enabled (not
  installed)"
- "Module Enabled (SlaveTats not installed)" -> "Module Enabled (not
  installed)"

**16c. Status refresh value (SlaveTats "Sections Available"; two sites — the
Add and the SetTextOptionValue refresh):** OLD "N - pick sets in the Tattoo
menu" -> NEW "N sections".

**16d. NEW headers on the Settings page (net-new surface, same gate):**
"Framework", "Maintenance" — plus the title header "Delectatio et Dominium"
+ tagline "Bedroom drama for SkyrimNet" MOVED verbatim from the old General
page (no reword).

**REV-109b rider (2026-10-13):** the reword set above is UNCHANGED. The
six "Baka - " page homes are now the six sections of the "Baka
Interactions" family page (REV-109b, PROJECT_STATE §118); the reworded
strings ship on those section surfaces as-is. The 16a-16d rulings remain
pending.

**REV-109c rider (2026-10-13):** the reword set above is UNCHANGED. The
homes are now the six STACKED sections of the ONE "Baka Interactions"
page body (REV-109c, PROJECT_STATE §119; the 109b navigation rows are
gone); the reworded strings ship on those stacked section surfaces
as-is. The 16a-16d rulings remain pending.

---

## Entry 17 — REV-109b MCM restructure fix: new navigation-surface strings (Option A)

**Feature:** INDEX row 16 (`unification-era`, MCM productization REV-109b) —
**Rev:** REV-109b — **Status:** 17a CLOSED-VOID at REV-109c (superseded -
see the banner note below); 17b + 17c informational (no approval loop).

**17a. Helper-text drafts (NEW navigation surfaces, §7) - CLOSED-VOID at
REV-109c (2026-10-13):** SUPERSESSION BANNER (not silent deletion): the
pass-3 user ruling REMOVED the REV-109b section-navigation model entirely
(state, index render, "Open" rows, "<< Back" rows, nav OIDs, handler
chain). The strings this entry gated - the section-index row value
"Open" and the back-row label "<< Back" - NO LONGER EXIST in the build
(DeD_MCM.psc pass 3; dist [REV-109c]); the entry is closed VOID, no
wording ruling needed or possible. The stacked-sections shape that
replaced it needs no new helper strings (headers only; the section names
are entry 17b).

**17b. USER-AUTHORED strings (register-cited per the Option A ruling; the
user's own wording from their dogfood list - no approval loop):** the page
name / page header "Baka Interactions"; the six section names in the
user's order: "General", "Timing", "Resist", "Spank", "Scenes & FX", "Lap
Sitting". REV-109c rider: these are now the six section-header labels of
the stacked body (the nav rows are gone with 109b); still user-authored,
still no approval loop.

**17c. Question citation ("Enable Debug Logging" - what does it do?):** the
user asked at the REV-109b session. ANSWER of record: today it toggles the
motherboard's debug-trace channel (`Main.bDebugLog` - the
SkyrimNet_BakaIntegration trace spam, e.g. action-selection/cooldown
debugging); it is NOT a mod-wide capture switch. Mod-wide capture is the
debugging-mode ticket - already registered to the polish pool (the era gap
list); this entry cites the question so the answer is on the record. No
ruling pending.

---

*Register refreshed at REV-108 (2026-10-13): entry 14 ADDED (OPEN — §7
tooltip wording ruling + the MO2 wizard test). Register holds ONE open
entry. Fork copy lockstep.*
*Register created 2026-10-10 per the REV-90b-close rider (user-approved 2026-10-10). Registered by sweeping PROJECT_STATE recent §s, the features INDEX, and all feature docs for live §7 drafts. Entry 6 added REV-91; entries 1-4+6 closed + entries 7-10 added at REV-92 (2026-10-10) per the pre-loaded 2026-10-10 rulings; entries 5 + 7-10 closed at REV-94 (2026-10-11) per the 2026-10-11 rulings; fork `docs/` copy maintained per the REV-92 register rider.*

---
*REV-100 refresh (2026-10-11): entry 12 added (OPEN — narration draft 12a + re-enable
ruling 12b, both user-gated). Register holds ONE open entry. Fork copy lockstep.*

---
*REV-101 refresh (2026-10-11): entries 12a + 12b CLOSED (user-edited wording approved
verbatim + re-enable ruling; Execute lane shipped [REV-101], EXPERIMENTAL). Register
EMPTY of open entries. Fork copy lockstep.*

---
*REV-104 refresh (2026-10-12): entry 13 ADDED (OPEN — acheron manifest description +
tagline, dogfood-gated user-delegated wording; plus the gs-poses id confirm noted
in-entry). Register holds ONE open entry. Fork copy lockstep.*

---
*REV-108b refresh (2026-10-13): entry 14 tooltip-wording gate CLOSED (tooltips
APPROVED-AS-FIRST-DRAFT per user ruling; user-editable baseline; entry heading
amended in place); entry 15 ADDED (OPEN — 15a README arousal-line wording draft,
15b the [REV-108b] wizard-render test, carried from entry 14). Register holds ONE
open entry (15). Fork copy lockstep.*

---

*REV-109 refresh (2026-10-13): entry 16 ADDED (OPEN — the REV-109 MCM reword
set: 16a three class (b) InfoText splits, 16b six absent-state tail
shortenings, 16c the SlaveTats status value, 16d the new Settings headers).
Entry 15 unchanged (still open). Register holds TWO open entries (15, 16).
Fork copy lockstep.*

---

*REV-109b refresh (2026-10-13): entry 17 ADDED (17a OPEN — the new
navigation-surface helper drafts: the section-index row value "Open" and the
back-row label "<< Back"; 17b the user-authored section/page names,
register-cited per the Option A ruling; 17c the "Enable Debug Logging"
question citation with the answer of record). Entry 16 rider appended (reword
set unchanged; homes are now the family sections) — 16 still open. Entry 15
unchanged. Register holds THREE open entries (15, 16, 17a). Fork copy
lockstep.*

---

*REV-109c refresh (2026-10-13): entry 17a CLOSED-VOID (supersession banner
in-entry - the pass-3 ruling removed the REV-109b navigation model; the
"Open"/"<< Back" strings it gated no longer exist in the build; no wording
ruling needed or possible). 17b rider appended (the names are now the
stacked body's section-header labels; still user-authored). 17c unchanged.
Entry 16 rider appended (the reword-set homes are the stacked sections;
rulings still pending). Entry 15 unchanged. Register holds TWO open entries
(15, 16). Fork copy lockstep.*

---

*REV-111 refresh (2026-10-14): entry 15 rider appended (15a arousal-line wording now rides the public-staging README pre-push review). Entries 15 + 16 unchanged otherwise; still open. Register holds TWO open entries (15, 16). Fork copy lockstep.*

---

## Entry 18 — REV-112 cum-v2 location-variant cue wordings (bulk; one entry)

**Feature:** INDEX row 9 (`cum-effects`, v2 item 2) — **Rev:** REV-112 —
**Status:** CLOSED at REV-118 (2026-10-16) — **user-edited ruling of record.**
Provenance: the user applied their edits DIRECTLY in the fork register copy
(`docs/pending-approvals.md`, 2026-10-16 15:52); the drafts below are
SUPERSEDED by the edited phrases (kept verbatim as the user left them).
Applied at `SNBaka_CumDetectionModule.psc` `_LocationPhrase` REV-118;
verified in built bytes (compile-out-rev118). The user's accompanying note
(L467) became the REV-118 source-validation rule (see entry 19 rider).
The register-lifecycle rule (ruled-EDITED text moves to the owning feature
doc) is discharged at cum-effects.md REV-118.

**18. Location-variant cue wording drafts (§7; one bulk entry; the
planner's own face/hands examples cited as the set's inspiration).**
`SNBaka_CumDetectionModule.psc` `_LocationPhrase(asArea)` — one phrase per
OCum `Area` literal (OCumMaleScript ApplyCum dispatch, 11 literals). Each
phrase appends to the mode-specific base sentence as
`", <phrase>."` — quoted verbatim, in the stated order:

**User edits applied directly to the phrases below
1. belly — "the cum splatters across their belly in thick ropes"
2. butt — "the cum pumps across their backside, basting them with thick globules"
3. chest — "the cum pumps across their chest, trickling sluggishly down their breasts"
4. face — "the cum sprays across their face in thick ropes"
5. feet — "the cum gushes over their feet"
6. hands — "the cum pumps out all over their hands"
7. mouth — "their mouth floods with jets of hot cum"
8. rectum — "load after load of cum pumps deep into their ass"
9. thighs — "the mess settling across their thighs"
10. throat — "gouts of hot cum pump deep into their throat"
11. vagina — "hot, thick cum is pumped deep into their pussy"

Composed examples (full sentence shapes, for context):
- unified mode, target present, Area=face: "A just came, finishing all
  over B, the mess settling across their face."
- per-source mode, target present, Area=mouth: "A just came; OCum applies
  the result to B, the finish settling in their mouth."

**Honest limit stated in the set (ruling context):** the SL StageEnd proxy
has no Area signal — it fires location-agnostic until the v2 state layer
exists. Fallback behavior (unknown/empty Area, or target None) = the v1
wordings verbatim (already register-prior-class, carried). Ruling
requested: approve / edit any phrase / drop locations from the set.

**Please note that the above only makes sense for male or futa characters cumming with/in/on a partner character.

---

*REV-112 refresh (2026-10-14): entry 18 ADDED (OPEN — the 11 location
phrases + 2 composed-sentence shapes, bulk). Entries 15 + 16 unchanged,
still open. Register holds THREE open entries (15, 16, 18). Fork copy
lockstep.*

---

## Entry 19 — REV-117/118 ambient cue wording + source-validation rider

**Feature:** INDEX row 9 (`cum-effects`, v2 ambient timer) — **Rev:**
REV-117 wiring / REV-118 registration repair — **Status:** CLOSED at REV-125
(2026-10-17) — **user-edited wording of record, shipped** (the user's own
fork-register edit, 2026-10-17, applied verbatim to `HandleCumAmbientDue`).

**19. Ambient cue wording draft.** `SNBaka_CumDetectionModule.psc`
`HandleCumAmbientDue` — the subjectless `sdb_cum_ambient` cue text
(verbatim):

> The lingering aftermath of their last encounter is impossible to ignore.

**REGISTER-GAP REPAIR (honest record):** REV-117's PROJECT_STATE §128 and
cum-effects.md item 7 claimed this draft was registered as "entry 19 (bulk)"
— but no register refresh actually landed it at REV-117. This entry is the
first real registration; the REV-117 claims are corrected by §129.
**Ruling status:** user mid-session ruling 2026-10-16 — the wording stays
DRAFT; the wiring ships and fires with the draft text in the staged dist
only; nothing unapproved installs to the live modlist.

**Entry 18 rider (source-validation):** the user's entry-18 note ("the above
only makes sense for male or futa characters cumming with/in/on a partner")
was implemented at REV-118 as the interim actor-model rule: cue sources must
be male (`_SexOf==0`); female non-futa sources skip the cue (state still
written); futa detection is flagged for the polish note (SexLab's `_sex==4`
lives inside SL's internal gender model, not recoverable from ActorBase
GetSex()). This is a behavior rule, not a wording — recorded here for
provenance, ruled-of-record via the user's own note.

---

*REV-118 refresh (2026-10-16): entry 18 CLOSED (user-edited wording of
record — edits applied verbatim from the user's own fork-register edits,
2026-10-16 15:52; provenance in-entry). Entry 19 ADDED (OPEN — ambient
draft + the register-gap repair; source-validation rider appended). Entries
15 + 16 unchanged, still open. Register holds THREE open entries (15, 16,
19). Fork copy lockstep.*

---

## Entry 20 — REV-125 sdb_cum_applied template rewrite (name-free; the D8 originator fix)

**Feature:** INDEX row 9 (`cum-effects`) — **Rev:** REV-125 — **Status:**
OPEN (wording surface; the fix itself is CLOSED — see provenance).

**Provenance (binding constraint, not style):** the user ruled D8 BLOCKING
(2026-10-1X: role-reversed cues make no semantic sense; wording edits ride
BEHIND the fix). Investigation (PROJECT_STATE §137) proved `{{ originator }}`
is NOT a documented template variable (WORKFLOW_TRIGGERS.md Phase 3.3 table)
and resolves to the CONVERSATION'S OWN ACTOR — each nearby NPC's render says
the NPC's own name "just came". Event actor args are not templateable at the
4-arg RegisterEvent (§4832 ruling). The template therefore CANNOT name the
originator; the only correct shape is name-free. **Constraint for any user
edit: do not reintroduce `{{ originator }}` or `{{ target }}`.**

**sdb_cum_applied.yaml response content (shipped REV-125, verbatim):**

> Someone nearby just climaxed, finishing all over their partner. Generate the
> immediate aftermath in one short beat -- a word, a sound, a look, or one
> line from anyone involved or watching. Match their personality exactly.
>
> If this happened during an aggressive or non-consensual encounter, the
> reaction should carry dominance, conquest, cruelty, or satisfaction.
>
> Do not invent which act or body part produced this, and do not name any
> framework or source -- react only to what is observable in the scene.

(Every line except the first is unchanged from the approved entry-4 wording;
the first line alone was rewritten. Entry 19's ambient wording — the user's
own edit — SHIPPED in the same build: `Notices that they are still covered in
cum from a recent sexual encounter.`; entry 19 CLOSES as wording-of-record.)

**D9-family rider (named, unfixed):** `sdb_spanked.yaml`, `sdb_slapped.yaml`,
`baka_resist_success.yaml`, `baka_sexlab_trigger.yaml` use the same
undocumented `{{ originator }}`/`{{ target }}` and misattribute in NPC
conversations the same way — follow-up rev.

*REV-125 refresh (2026-10-17): entry 19 CLOSED (user-edited wording of record,
shipped in [REV-125]). Entry 20 ADDED (OPEN — the name-free template rewrite,
user-editable under the no-{{ originator }} constraint). Register holds THREE
open entries (15, 16, 20). Fork copy lockstep.*

---

## Entry 20 rider — REV-126 (2026-10-17): the D8 re-adjudication and the binding constraint's status

**The two-event re-read (PROJECT_STATE §138, receipts cited):** the 10-17 window
held TWO application events (Hadrian's P+ fire, L5525; Hroki's own OCum fire,
L5538) — but Hroki's was DECLINED by the REV-118 source gate BEFORE any
RegisterEvent (L5542), so the "Hroki just came" renders in her conversation
cannot be her own event. ONE registered cue, cross-rendered across
conversations: **§137's conversation-binding finding CONFIRMED; entry 20's
no-`{{ originator }}` constraint STANDS** (the two models were mutually
exclusive; the event-count verdict picked binding). No revert — the name-free
template is correct as shipped.

**Event-level source enforcement (shipped same rev):** female non-futa
sources own NOTHING from us (cue OR state OR ambient debt) — new
`_EventSourceOwnsCum` guard runs before every `_WriteCumState`; sentinel
`female-source event declined (SN-SL lane) (REV-126)`.

**D9-family rider (updated, event-model lens):** the spank/slap/resist/
overpower YAMLs carry the same undocumented vars AND the same question —
per-fix method: enumerate the actual application receipts first, then read
the renders against them (one event cross-rendered = binding; a second
uncounted event = a missing-enforcement finding).

---

## Entry 21 — REV-127 (2026-10-18): sdb_cum_applied RESPONSE GUIDANCE (the YAML `response.content` surface) — QUOTED VERBATIM; the surface the user's "aftermath direct-ification" edit INTENDED to reach

**Two-surface register note (§7 rider, REV-127):** cue text and response
guidance are TWO DIFFERENT §7 surfaces, BOTH the user's. CUE TEXT = the
RegisterEvent `desc` (Papyrus-side; what-happened, rendered to the model as
event context). RESPONSE GUIDANCE = the trigger YAML's `response.content`
(how-to-respond instruction block). The 10-18 dogfood proved the split: the
user-edited cue text (entry 19) landed verbatim in both ambient renders,
while the model's "aftermath discussion" behavior tracked the APPLIED yaml's
guidance wording ("Generate the immediate aftermath...") — editing the cue
text alone cannot reach the guidance's effects.

**sdb_cum_applied.yaml `response.content` (live tree + [REV-126]/[REV-127]
dists, 846 B, 2026-10-17) — VERBATIM:**

```
Someone nearby just climaxed, finishing all over their partner. Generate the
immediate aftermath in one short beat -- a word, a sound, a look, or one
line from anyone involved or watching. Match their personality exactly.

If this happened during an aggressive or non-consensual encounter, the
reaction should carry dominance, conquest, cruelty, or satisfaction.

Do not invent which act or body part produced this, and do not name any
framework or source -- react only to what is observable in the scene.
```

Status: OPEN for the user's ruling/edits (the "aftermath" language the user
wanted direct-ified lives HERE, not in the cue text). Ships with the next
build.

## Entry 22 — REV-127 (2026-10-18): sdb_cum_ambient RESPONSE GUIDANCE — DOES NOT EXIST (finding); the ambient's only text surface today is its CUE TEXT, quoted verbatim

**Finding (REV-127, exhaustive search — fork tree, all dists, modlist):**
`sdb_cum_ambient.yaml` does not exist. The ambient cue rides SN's native
handling of a bare RegisterEvent (desc context entry + gamemaster default)
— the ambient cue has NO response-guidance surface at all; its renders are
shaped only by the cue text plus SN defaults. Whether to CREATE the yaml
(with its own `response.content`) is the user's decision; creating it would
give the ambient the same two-surface control the applied cue has.

**The ambient CUE TEXT (the only surface today; RegisterEvent desc, module
`SNBaka_CumDetectionModule.psc`; user-edited wording of record — register
entry 19, 2026-10-17) — VERBATIM:**

```
Notices that they are still covered in cum from a recent sexual encounter.
```

Status: OPEN — the yaml-creation decision + (if created) the guidance
wording are the user's pen; ships with the next build after ruling.

