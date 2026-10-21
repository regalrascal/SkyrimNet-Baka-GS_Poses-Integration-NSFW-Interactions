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

***User: I'm editing the beginning portion of the sentence, " to make it fit better semantically with the second portion (11 litersal).***
***User: edits applied directly to the phrases below***
***User: Second round of user edits applied directly below, me writing {{giver}} means the source of the cum and {{receiver}} means the receiving actor.***

***User: The opening phrase that preceeds these variable should be changed from "{{giver}} just came, finishing all over {{receiver}}" to "{{giver}} just came,". This will make the new 11 literals make more senser semantically***
1. belly — "the cum splatters across B's belly in thick ropes"
2. butt — "the cum pumps across {{receiver}}'s ass, basting them with thick globules"
3. chest — "the cum pumps across {{receiver}}'s chest, trickling sluggishly down their breasts (chest if male)"
4. face — "the cum shoots across {{receiver}}'s face in thick ropes"
5. feet — "the cum gushes over {{receiver}}'s feet"
6. hands — "the cum pumps out all over {{receiver}}'s hands"
7. mouth — "{{receiver}}'s mouth floods with jets of hot cum"
8. rectum — "load after load of cum pumps deep into {{receiver}}'s ass"
9. thighs — "the mess settling across {{receiver}}'s thighs"
10. throat — "gouts of hot cum pump directly down {{receiver}}'s throat"
11. vagina — "hot, thick cum is pumped deep into {{receiver}}'s pussy"

***User: Unified mode example should be the only phrasing option regardless of the source framework. No need to confuse the LLM with framework details when we don't want it to mention the framework.***
Composed examples (full sentence shapes, for context):
- unified mode, target present, Area=face: "A just came, the cum splatters across B's belly in thick ropes ."

**Honest limit stated in the set (ruling context):** the SL StageEnd proxy
has no Area signal — it fires location-agnostic until the v2 state layer
exists. Fallback behavior (unknown/empty Area, or target None) = the v1
wordings verbatim (already register-prior-class, carried). Ruling
requested: approve / edit any phrase / drop locations from the set.

***User note: Please note that the above only makes sense for male or futa characters cumming with/in/on a partner character.***

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

***User: edited to feed more sensibly into gamemaster consideration.***
> Nearby characters notice that someone is covered in cum from a recent sexual encounter.

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

***User edited***
> Look for someone nearby who is noticeably covered in cum from a recent
> sexual encounter. Generate a response from someone who notices -- 
> a comment, praise, or admonishment about their appearance as the 
> situation dictates. Direct it towards the cum covered person.
> Deliver the dialogue in-character with narration as needed.
>
> If the commenter is aggressive or cruel, the reaction should carry 
> dominance, scorn, cruelty, or satisfaction.
>
***User question: does the information for how/where the cum was applied live in the log already? If so, it may not be necessary to fill in the information with decorators in this instance.***
> Do not invent which act produced the cum or where the cum is visible --
> react only to what is observable in the scene based on existing context.

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

***User: I edited this text in entry 20, above, but I will do so here as well.
```
Look for someone nearby who is noticeably covered in cum from a recent
sexual encounter. Generate a response from someone who notices -- 
a comment, praise, or admonishment about their appearance as the 
situation dictates. Direct it towards the cum covered person.
Deliver the dialogue in-character with narration as needed.

If the commenter is aggressive or cruel, the reaction should carry 
dominance, scorn, cruelty, or satisfaction.

Do not invent which act produced the cum or where the cum is
visible -- react only to what is observable in the scene based on existing context.
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

***User edited. I edited this in entry 19 as well.***
```
Nearby characters notice that someone is covered in cum from a recent sexual encounter.
```

Status: OPEN — the yaml-creation decision + (if created) the guidance
wording are the user's pen; ships with the next build after ruling.

---

## REV-127b refresh (2026-10-18, wording application): entries 18/19/20 CLOSED as re-ruled user-edited wording of record; entry 21 CLOSED-shipped; entry 22 RIDES to the draft-and-review pass

**Provenance:** the user applied all four edits DIRECTLY in this register
copy this exchange (markers `***User edited***` in entries 18/19/20 and the
quoted blocks in entries 21/22 are the user's own pen, verbatim). Applied
verbatim to the register-declared surfaces; byte-verified in the built pex
and the shipped YAML. Ships as the [REV-127] wording re-cut (same rev label;
superseded zip archived per the honest-history rule, never deleted).

**Surface map (each edit's actual home; no misplacements found):**
- Entry 20/21 response guidance -> YAML `sdb_cum_applied.yaml`
  `response.content` (932 B shipped; no-`{{ originator }}` constraint held).
- Entry 18's 11 location literals + base sentence -> IN-CODE,
  `SNBaka_CumDetectionModule.psc` `_LocationPhrase` + `_FireCumCue`/
  `HandleSLStageEnd` desc strings (register's declared home; consistent).
- Entry 19 ambient cue -> IN-CODE, `HandleCumAmbientDue` desc.

**Consumer-of-record note (entry 19):** the ambient cue text feeds the
GAMEMASTER'S world-direction (a context entry the gamemaster turns into
speaker direction), NOT a speaker line; the user's phrasing validated
against that model. Recorded in-code above the desc.

**Entry 18 re-ruling, as applied:** base sentence `{{giver}} just came,` +
literal + `.`; the literals carry `{{receiver}}` (= target.GetDisplayName();
receiver naming DEFERRED to the literals, the "finishing all over X" class
REMOVED from all base sentences and fallbacks); the unified example is the
ONLY phrasing in BOTH MCM mode branches (the mode toggle no longer changes
cue wording); no framework mentions (OCum/SL/OStim) in any desc. TWO
DISCREPANCY REPAIRS of record: (1) literal 1's register text carried a
stale `B` placeholder — applied as `{{receiver}}` per the set's own
convention; (2) literal 3's `(chest if male)` read as a user ANNOTATION and
implemented as a receiver-sex wording selection (breasts/chest via the
interim `_SexOf==0` rule), not literal text. Both repairs reversible on
the user's word.

**Entry 20's user question, answered:** YES — how/where the cum was applied
lives in the log already: the applied cue desc (with the location literal)
lands in the conversation context via RegisterEvent, so it is observable
scene context. Decorators are not needed to supply it; the new guidance's
"react only to what is observable ... based on existing context" line rides
on that fact.

**Entry 22 status per its own note:** the ambient guidance surface STILL
DOES NOT EXIST — the user's ambient edit was cue-side only, and no register
edit this exchange rules the yaml created; the guidance-surface creation
question RIDES to the DECORATION DRAFT-AND-REVIEW pass per the standing
plan. Register holds TWO open entries (15, 16). Fork copy lockstep.

---

*REV-127b refresh (2026-10-18): entries 18/19/20 CLOSED (user-edited
re-rulings of record, this exchange; applied + byte-verified). Entry 21
CLOSED (shipped in the [REV-127] wording re-cut). Entry 22 unchanged-OPEN
(rides to draft-and-review). Register holds TWO open entries (15, 16).
Fork copy lockstep.*


---

## Entry 20 rider — REV-128 (2026-10-18): the applied narration's NEW WORDING (user riding ruling 2) — supersedes entry 20's shipped guidance; entry 20 CLOSES on it

**Riding ruling (user, 2026-10-18, this exchange):** the new narration wording below supersedes the shipped REV-127b `response.content` (quoted at entry 20 above); entry 20 closes on it. Quoted VERBATIM — the user's capitalization/bolding as authored:

***User edited***
```
THE recent sexual encounter left one of its participants covered in cum.
Nearby people start to notice and comment on it. They offer praise or
admonishments to the cum soaked person as the situation, and their
personality dictates. Use context. Do not make up the source or location
of the cum.
```

**Surface + timing (per riding ruling 1, same exchange):** this text is the applied trigger's NARRATION surface (yaml `response.content`), and it DEFERS to SCENE-END +10s — the cue at climax is unchanged; the bystander-solicitation surface defers. Implementation spec (two mechanism options, Option A recommended: module-held second event `sdb_cum_aftermath` at scene-end+10s via a new HookAnimationEnd registration) lives in cum-effects.md REV-128 §2 and rides as register entry 23 (below) — the mechanism RULING is the user's. Ships with the next build after the joint review. **Status: entry 20 CLOSED on this wording** (supersession of record; the shipped REV-127b guidance remains the shipped bytes until the build session lands this set).

---

## Entry 22 amendment — REV-128 (2026-10-18): DRAFTED — the ambient's RESPONSE GUIDANCE SURFACE authored in the construction set; the user's pen pending

Per this entry's own status note, the guidance-surface creation question rode to the decoration draft-and-review — it has now been drafted (cum-effects.md REV-128 §3). The draft would create `sdb_cum_ambient.yaml` (same two-surface control as the applied cue). **DRAFT `response.content` (NOT of record until the user rules/edits):**

***User: Edited to a more narrative tone for use with the direct narration function that consumes it.***
```
The recent sexual encounter left one of its participants covered in cum. Nearby people start to notice and comment on it. They offer praise or admonishments to the cum soaked person as the situation, and their personality dictates. Use context. **Do not make up the source or location of the cum**.
```

**Riding with the draft (all quoted in cum-effects.md REV-128 §3, none assumed):** (a) the wearer-reference construction — the wearer-naming sentence `...directed at {{ get_ded_cum(actor_uuid).wearer_name }}, the cum soaked person...` (decorator-gated; the name-free fallback shape is the draft text above); (b) the three arousal-branch texts (hot/intrigued/taken-aback, tier-keyed to `get_ded_arousal(actor_uuid).tier`, conditionals gated on the build-session probe); (c) the freshness phrasing class (flagged, not forced). The ambient CUE TEXT stays unchanged (entry 19's wording of record, in-code). **Status: DRAFT-AND-REVIEW (the user's pen; the strategist's grammar pass rides jointly per the standing gate).**

---

## Entry 23 — REV-128 (2026-10-18): the SCENE-END+10s DEFERRAL MECHANISM — the ruling rides to the user with the construction set

Riding ruling 1 (user, 2026-10-18): the applied trigger's narration defers to SCENE-END +10s; the cue at climax is unchanged. The implementation is NOT yet ruled — the construction set's spec (cum-effects.md REV-128 §2, cited there in full) puts two viable mechanisms to the user:

- **Option A (RECOMMENDED) — module-held second event:** `sdb_cum_applied` keeps only its cue; a new `sdb_cum_aftermath` event fires at scene-end+10s (new `HookAnimationEnd` registration beside HookStageEnd; `RegisterForSingleUpdate(10.0)`; a new `sdb_cum_aftermath.yaml` carries the new narration wording, entry 20's rider above). Honest failsafe: no scene-end -> no aftermath narration (ambient at +60s still carries the surface).
- **Option B — trigger-side delay field: ruled OUT on the documented schema** (WORKFLOW_TRIGGERS.md carries no delay/scheduling field; revivable only if the build session's DevKit read surfaces one).

**Status: OPEN — the user rules the mechanism; the build session cuts from the ruled set (the probe first, then the constructions per its verdict).** Register after this session: open entries 15, 16, 22 (drafted), 23. Fork copy lockstep.

---

## REV-129 closures (2026-10-19, the decoration build session): entries 22 and 23 CLOSED on the user's rulings; branch texts CLOSED as approved

- **Entry 22 — CLOSED** on the user's narrative-voice text (the entry's own amendment block above, `***User: Edited to a more narrative tone for use with the direct narration function that consumes it.***` — the user's pen, in-register, this exchange). The text ships VERBATIM as `sdb_cum_ambient.yaml`'s `response.content` (byte-verified: this register's line contained in the shipped yaml bytes at build AND in the [REV-129] dist; the instruction-tone draft does NOT ship). The riding constructions ship with it per the user's approval: the three arousal branches (tier-keyed), the freshness class (fresh/drying/faded), and the wearer-naming sentence — all via the documented `originator_uuid` form (probe verdict; see PROJECT_STATE §141).
- **Entry 23 — CLOSED** on **Option A (approved)**: module-held second event `sdb_cum_aftermath` at scene-end+10s (HookAnimationEnd registration beside HookStageEnd; the +10s hold on the motherboard's REV-63 real-time mux; `sdb_cum_applied.yaml` retired — cue only at climax). Built per the REV-128 §2 spec; edge cases (no-wearer / already-ended / multi-scene / interrupted-thread -> honest silence) cited in-code.
- **Branch texts — CLOSED as approved** (the REV-128 §3(b) texts, `else if` spelling per prompt-file-syntax.md, `actor_uuid` -> documented `originator_uuid`).
- Register after this session: open entries **15, 16** only. Fork copy lockstep. Receipts: PROJECT_STATE §141 + cum-effects.md REV-129.

---

## Entry 24 — REV-130 (2026-10-19): the MORE CUM MCM description — DRAFT, the user's pen

The toggle ships on the cum-detection page; label **"More Cum"** (user-ruled). Behavior spec of record = cum-effects.md REV-130 §2 (SL-scene-scoped: throat applications also apply face + chest via the OCum drive — the external-area calls are the pull-out decal variant by construction, per the user's ruling; OStim-side unchanged; the build rides the NEXT build session). The MCM description DRAFT:

```
When enabled, SexLab scenes that finish in your partner's throat also leave visible cum on her face and chest, layered with the same decals OCum uses for its pull-out climaxes. Only affects scenes run through SexLab.
```

**Status: OPEN — the user's pen (edit or approve the draft; the build session cuts from the ruled text).** Register after this session: open entries **15, 16, 24**. Fork copy lockstep. Receipts: PROJECT_STATE §142 + cum-effects.md REV-130.

---

## Entry 25 — REV-131 (2026-10-19): SN NOTE DRAFT — response-template rendering with custom decorators (beta-28 report; the USER SENDS)

The beta-28 kit census raised the response-rendering question again: beta-28-rc2 docs are byte-identical to beta-26-rc4 on the decorator/response surfaces, the conversation overhaul (GamePlugin PR #754 + the 10-19 Conversation System doc) states response rendering untouched, and the beta-26-rc4 runtime repro (decorator call inside a `response.content` conditional → PromptEngineRender-class error, template posted verbatim per WORKFLOW_TRIGGERS.md L152) remains the reproducible case. VERDICT (c): indeterminate from kit sources — the runtime probe (REV-132's first task) adjudicates. The NOTE DRAFT (full quoted text of record = cum-prompt-spec.md §6):

> Does the response-template renderer evaluate custom decorators (e.g. `get_ded_cum`) used inside conditionals or text in `response.content` YAMLs? In beta-26-rc4 a decorated conditional in a response template produced a PromptEngineRender-class error and the template text was posted verbatim into chat (WORKFLOW_TRIGGERS.md's "template posted verbatim" path). Beta-28's docs don't cover response rendering, so: is this supported (and the beta-26 case a bug), unsupported-by-design (flat text is the contract), or changed in the overhaul?

**Status: OPEN — the USER sends (review/edit first); the answer gates the decorated-template stash (stays CLOSED pending the probe/answer; flat fallbacks build regardless).** Register after this session: open entries **15, 16, 24, 25**. Fork copy lockstep. Receipts: PROJECT_STATE §143 + cum-prompt-spec.md §6.

---

## REV-132b register actions (2026-10-19, evening): entry 24 CLOSED; entry 26 OPENED

- **Entry 24 — CLOSED (scope growth):** the More Cum MCM build rides REV-133 with the user's RULED text (§144's ruling: the edited description + the additional-decals scope) — keeping it open here would double-track the ruling; REV-133's brief cites this entry as the text of record. The draft above is superseded by the ruled text in PROJECT_STATE §144.
- **Entry 25 — STILL OPEN, now with runtime receipts:** the beta-28 session adjudicated verdict (c) AGAINST response-content decorators (the decorated ambient failed at fire time — engine fell back to the event-desc cue with `- **` debris; PROJECT_STATE §145). The note's premise stands and is now STRONGER; the user still sends.
- **Register open entries after this session: 15, 16, 26.**

---

## REV-133c register action (2026-10-20): entry 25 gains the orphan rider

- **Entry 25 — STILL OPEN, gains a second rider (REV-133c §147):** the ambient's separate DirectNarration event call is now RETIRED (user-ruled CONSERVATIVE) while `sdb_cum_ambient.yaml` stays as the consumer-of-record — so the SN-team follow-up now ALSO asks: **does an emitter-less yaml (an event type with a registered consumer but no RegisterEvent emitter) have any residual lane in the trigger engine?** Trigger-engine source located (`skyrimnet-beta28-rc2\Source\Scripts\SkyrimNetApi.psc`: RegisterEvent = the native trigger-bus entry; C++ matching internals not in the installed trees) — current evidence says the yaml does not fire; the question rides this note as records/curiosity only.
- **Register open entries after this session: 15, 16, 26.** (Entry 24's ruled text shipped in the REV-133c build — More Cum built; no register change.)

## REV-134a register note (2026-10-20 evening): entry 25's orphan rider — ANSWERED BY REGRESSION

- **Entry 25 — the orphan rider RESOLVES TO A NOTE (no SN-team answer needed):** the user's dogfood of [REV-133c] answered the question empirically — with the PSC emitter deleted, the retired sentinel logged every 60s with NO ambient emission: **an emitter-less yaml does not fire.** RegisterEvent was load-bearing (REV-133c's dependency read was inverted — the misdiagnosis, on record in §148). The emission is RESTORED in [REV-134a] (P2 trigger-bus class); `sdb_cum_ambient.yaml` retained verbatim as inert documentation. Entry 25's remaining live cargo: the original SN-team follow-up (response-content decorators / beta-28 render behavior) — still the user's pen.
- **Register open entries after this session: 15, 16, 26.**

---

## Entry 26 — REV-132b (2026-10-19): the PROMPT FRAGMENT TEXTS + the DECORATED-TEMPLATE STASH — the user's pen

Two things ride here:

1. **The staged fragment texts (SHIPPED as drafts in the [REV-132b] dist, install GATED on this ruling):**
   - `character_bio/0175_ded_cum.prompt` — the facts fragment: self/other split ("You have fresh cum on you — in your mouth and on your skin…" / "{{ cum.wearer_name }} is marked with cum, still fresh — visible at {{ cum.locations | join(", ") }}") + freshness bands (10 min fresh / 1 h drying / faded). Drafted per cum-prompt-spec.md §3 (the drafted construction of record); the user may edit any line.
   - `user_final_instructions/0520_ded_cum_disposition.prompt` — the disposition fragment (tier-keyed on the ACTING NPC's arousal): tier-3 "run hot — open admiration and appetite…", tier-2 "intrigued — curiosity and fascination, appraising without staring", tier-1 "taken aback — shock, disgust, or scandalized disapproval" (the register-22/23 rider wording, closed as approved in the stash). The gate structure + tier-keying are the spec's FIXED parts.
   - Ruling the drafts (edit or approve) = the INSTALL gate per the §7 staging shape. Note: enabling them also runs the first-ever runtime test of bio-surface decorators (verdicts (a)/(b) were never obtained — the probe never deployed; PROJECT_STATE §145). Clean render = LIVE; an error box = escalate.
2. **The decorated-template stash (the REV-129 riders + branches, REMOVED from `sdb_cum_ambient.yaml` by the REV-132b flattening; verbatim text preserved in git history commit `dc3fceb^..dc3fceb` and the [REV-129] dist):** the reopening asset — riders + branches return to the ambient ONLY if/when response-content decorator rendering is fixed upstream (entry 25's note). Until then the ambient ships FLAT (entry-22 base text) and the rich behavior rides the fragments above.

**Status: OPEN — the user's pen.** Receipts: PROJECT_STATE §145 + cum-prompt-spec.md (as-built note).


---

## Entry 27 — REV-134e (2026-10-21): the STRIP cue text — DRAFT, the user’s pen

The Strip action (downed-menu forced action; spec of record = baka-module.md REV-134e;
NOTHING BUILT) fires a cue-only event per the REV-134d applied pattern — working event
name `sdb_stripped`, actor names interpolated at fire time. DRAFT description:

```
{Stripper} strips the downed {Victim} of their clothes and armor, leaving them exposed and helpless on the ground.
```

**Status: OPEN — edit or approve; the build session cuts from the ruled text.**

---

## Entry 28 — REV-134e (2026-10-21): the FORCED-TATTOO cue text — DRAFT, the user’s pen

The forced-tattoo action (downed-menu, hostile/aggressor-gated per the Execute-gate
ruling template; spec of record = slavetats.md REV-134e §6.3; NOTHING BUILT) fires a
cue-only event — working event name `sdb_forced_tattoo`, actor names interpolated at
fire time. DRAFT description:

```
{Aggressor} forces a tattoo onto the downed {Victim}, marking their skin where everyone can see.
```

**Status: OPEN — edit or approve; the build session cuts from the ruled text.**

*REV-134e register state: open entries 15, 16, 26, 27, 28. Fork copy lockstep (this
refresh). Receipts: PROJECT_STATE §152 + the four feature-doc scout sections.*

---

---

## Entry 29 — REV-134f (2026-10-21): the FOLLOW-UP PROMPT narration gate — CLOSED (user-ruled + BUILT)

The ambient cum cue's direct narration ("People feel the need to express their reaction
to the cum covered person, and begin to make comments.") is now a SEPARATE, MCM-gated
surface per the user's dogfood ruling (2026-10-21, name + tooltip verbatim): the cue
(`sdb_cum_ambient` RegisterEvent) stays MANDATORY when the module is active; the
narration rides the gated event type `sdb_cum_ambient_narr` (yaml
`regalrascal.baka-gs-integration/triggers/sdb_cum_ambient_narr.yaml`, entry-22 text
VERBATIM) and fires ONLY when the new Cum Effects MCM toggle **"Follow-up Prompt"**
(motherboard property `bCumFollowUpNarration`, DEFAULT OFF; tooltip "Additional direct
narration for cum application events") is ON. The stale overwrite-overlay
`sdb_cum_ambient.yaml` (the live leg that kept narrating un-gated after REV-134d's
cue-only deletion) is deleted from the modlist this rev. Text of record = entry 22
(reused, not re-drafted); MCM label/tooltip = the user's verbatim ruling.

**Status: CLOSED-SHIPPED (REV-134f).** Register after this rev: open entries 15, 16,
26, 27, 28. Fork copy lockstep. Receipts: PROJECT_STATE §153 + cum-effects.md REV-134f.

