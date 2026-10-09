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

---
*Register refreshed at REV-94 (2026-10-11): ALL entries CLOSED (1-4, 6 at
REV-92; 5, 7-10 at REV-94). Register EMPTY of open entries as of this
refresh. Fork copy lockstep. New drafts would enter per the standing rules.*

---
*REV-98b refresh (2026-10-12): entry 11 created + closed same-session
(user-delegated wording, dogfood-gated). Register EMPTY of open entries.
Fork copy lockstep.*

---
*Register created 2026-10-10 per the REV-90b-close rider (user-approved 2026-10-10). Registered by sweeping PROJECT_STATE recent §s, the features INDEX, and all feature docs for live §7 drafts. Entry 6 added REV-91; entries 1-4+6 closed + entries 7-10 added at REV-92 (2026-10-10) per the pre-loaded 2026-10-10 rulings; entries 5 + 7-10 closed at REV-94 (2026-10-11) per the 2026-10-11 rulings; fork `docs/` copy maintained per the REV-92 register rider.*
