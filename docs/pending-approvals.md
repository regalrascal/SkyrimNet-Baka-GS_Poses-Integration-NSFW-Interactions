# Pending Approvals Register (STAGED - open entries only)

**HISTORICAL COPY (pointer of record):** `C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\pending-approvals-history.md` — the full pre-restructure register: every closed entry, its ruling, and its wording-of-record home. The historical copy is NOT updated except to append newly closed items (entry number + closure ruling + home of the wording of record). All research into closed rulings uses the historical copy.

**REGISTER FORMAT (user ruling, 2026-10-23 — supersedes the REV-92 register rule (i) for the very-large-text case):** every staged entry uses this format —

***
Entry <entry number>

Subject <subject title line>

Pending text:
1. <Maximum 3 sentence description of what the text is and where it is from>
    <text>
2. <...>
***

If an entry would be a very large amount of text, the pending-text item may instead cite a FILEPATH + LINE NUMBERS for navigation (user ruling, 2026-10-23). CLOSED ENTRIES ARE REMOVED from this document at closure (the closure note is appended to the historical copy only). Nothing ships unapproved.

**Lifecycle:** a draft enters this register at its producing session. The user rules. Ruled-APPROVED text moves to the owning feature doc as the shipped wording of record (+ one section line). Ruled-EDITED text is applied first, then moved the same way. Closure = remove from this document + append to the historical copy.

**Fork copy rider (REV-92):** a fork `docs/` copy of this register is maintained, refreshed at EVERY register change, lockstep with the GS canonical; both hashes are reported at every change.

**Register state after the 2026-10-23 restructure:** open entries 15, 16, 26, 29, 30 (30a/30b), 31 — restaged in the format above; all closed entries removed to the historical copy.

---

***
Entry 15

Subject README arousal-framework line (15a) + FOMOD wizard-render test (15b)

Pending text:
1. The draft arousal-framework line shipped in the public-staging README's "Soft (strongly recommended)" section (pick ONE framework: OSL Aroused Reborn or SL Aroused NG; runtime chain Reborn -> SL Aroused -> neutral), from the REV-108b C4-supersession ruling. It rides the public-staging README, user-reviewable at the pre-push section-7 review (REV-111 rider); the wording ruling is the user's edits to that draft line.
    Full entry detail + REV-111 rider: historical copy, lines 232-259.
2. The MO2 wizard-render test against dist [REV-108b] (checkbox must be CLICKABLE and STICK with GS Poses deselected; GS files ABSENT post-install; then a full install for the 11-page MCM parity). MO2's wizard cannot be headless-simulated — this is a user leg, not a text ruling.
    (Test procedure; no wording pending.)
***

***
Entry 16

Subject REV-109 MCM restructure bulk reword set (16a-16d)

Pending text:
1. The REV-109 display-length audit reword set, shipped as first drafts in `Scripts/Source/DeD_MCM.psc`: (16a) three class-(b) splits moving long text from the label/value surface into the InfoText (QTE Keys; SlaveTats intro; GS Poses intro); (16b) six absent-state "(not installed)" tail shortenings; (16c) the SlaveTats status refresh value ("N sections"); (16d) the new Settings-page headers "Framework"/"Maintenance" + the moved title "Delectatio et Dominium" and tagline "Bedroom drama for SkyrimNet". All ASCII; user wording rulings pending per the entry-14 user-editable-baseline precedent.
    Full OLD -> NEW set quoted verbatim: historical copy, lines 261-330 (includes the REV-109b/109c riders — the strings ship on the six stacked "Baka Interactions" section surfaces).
***

***
Entry 26

Subject Cum prompt-fragment texts (install gate) + decorated-template stash

Pending text:
1. The staged cum fragments, shipped draft-flagged in the [REV-132b] dist with install GATED on this ruling: `character_bio/0175_ded_cum.prompt` (the facts fragment — self/other split + freshness bands 10 min fresh / 1 h drying / faded) and `user_final_instructions/0520_ded_cum_disposition.prompt` (the disposition fragment — tier-3 "run hot", tier-2 "intrigued", tier-1 "taken aback", keyed on the ACTING NPC's arousal; gate structure + tier-keying are the spec's FIXED parts). Ruling the drafts (edit or approve) = the install gate; enabling them also runs the first-ever runtime test of bio-surface decorators (clean render = LIVE; error box = escalate).
    Full entry: historical copy, lines 811-825 (texts quoted in cum-prompt-spec.md §3; receipts PROJECT_STATE §145).
2. The decorated-template stash (the REV-129 riders + branches, REMOVED from `sdb_cum_ambient.yaml` by the REV-132b flattening; verbatim text preserved in git history commit `dc3fceb^..dc3fceb` and the [REV-129] dist) — the reopening asset: riders + branches return to the ambient ONLY if/when response-content decorator rendering is fixed upstream (entry 25's note, historical copy). Until then the ambient ships FLAT (entry-22 base text) and the rich behavior rides the fragments above.
    (No wording pending; pointer of record.)
***

***
Entry 29

Subject Pose narration workshop — user template + three MCM toggle titles/tooltips + per-pose variants

Pending text:
1. The user's template of record for pose-narration event descs, to be workshop-resolved into per-family desc variants drafted from the R.4 census. Names ride in the EVENT TEXT, never template vars (the D8/§137 lesson); the player is named when the player performs.
    "{{name}} performed a {{category}}, they did a {{specific pose}}"
    Registered route drafts: vibe routes "<NPC> strikes <label>, holding it in place."; crosshair route "<NPC> strikes a pose -- <desc> at <Player>'s direction."; player route "<Player> strikes ... holding it for show."
2. Three toggle titles + draft tooltips (DeD_MCM GS Poses page; GetVersion bump with the build):
    1. "Sanguine Pose Narration" — "Show a cue line in the event log when Sanguine Mode makes someone pose."
    2. "Emergent Pose Narration" — "Show a cue line in the event log when someone strikes a pose on their own."
    3. "Player Initiated Pose Narration" — "Show a cue line in the event log when you pose someone or yourself."
3. Per-pose phrasing variants (REV-146a amendment — the 10-23 dogfood findings: "a slow trail of her own fingers" read nonsensical; "victim" a strong word for a sexy dance):
    dance_sexy: "<NPC> performs a slow, provocative dance - a show with one clear audience in mind." (the "victim"->"audience" class, user suggestion verbatim)
    dance (playful): "<NPC> dances a little - light on the feet, feet answering the music."
    selftouch: "<NPC> trails a slow line along their own skin - provocative and sensual."
    ground_sexy: "<NPC> stretches out along the ground in a wanton and obscene display of arousal."
    present: "<NPC> holds a presenting pose - deliberately trying to entice."
    aroused: "<NPC> shifts their weight, restless - arousal worn openly."
    Crosshair + player routes carry the same variants with their existing route prefixes. USER'S PEN per variant.
Full entry: historical copy, lines 906-935 (REV-137f) + 999-1016 (REV-146a amendment).

***User note: Edits applied to entry 29 text.***
***

***
Entry 30

Subject Player-target policy MCM control (30a) + baka consideration prompt (30b)

Pending text:
1. The SNBaka.PlayerTargetPolicy control wording (30a), BUILT on the live DeD_MCM v13 "Baka Interactions" page using the draft label verbatim; install/wording ruling still the user's.
    Title: "NPCs May Target You"
    Tooltip: "When on, NPCs and creatures may choose you as the target of their autonomous actions (the Baka module's single central gate; your own initiations are never blocked). When off, nothing targets you unless you start it." 2. The baka daemon's candidate-selection prompt (30b), STAGED draft in-tree; the Mephala selection lane REQUIRES it (absent = the attempt refuses NAMED, prompt-absent); Molag-Bal needs no prompt. The user's install ruling = their 30b voice/wording ruling. The prompt receives the candidate pool, current mode, target-sex level, and player-target policy state; returns ONE pick or a refuse+reason.
    Filepath of record: fork tree `external\regalrascal.baka-gs-integration\prompts\snbaka_muse_consideration.prompt` (DRAFT-flagged header, this register cited).
    Full entry + REV-145/REV-146 riders: historical copy, lines 937-985.

***User note: Entry 30 tooltip text edited.***
***

***
Entry 31

Subject Baka cue-descriptor workshop — per-action personality drafts

Pending text:
1. baka_forced — one desc per forced-family action, personality-matched like flirt/embrace (provenance: the user's 10-23 dogfood finding — "the forced/overpowered variants don't have the same individual personality"):
    ForcedKiss: "{A} pressed their lips to {B}'s mouth mid-word - the kiss taken, not offered."
    BackHugMolest: "{A} wrapped {B} from behind and helped themselves - roaming hands, no invitation offered."
    ChokeHug: "{A} caught {B} in a choke-held embrace - possessively holing them much too tightly for comfort."
    WombHit: "{A} drove a low, punishing blow into {B}'s lower belly - they double over in pain."
    PinHelpless: "{A} pinned {B} flat and kept them there - not allowing them to rise."
    Subdue: "{A} put {B} down hard and made staying down the easy choice."
    Struggle: "{A} grappled {B} into a struggle - the stronger will decides the terms."
2. baka_intimate — family variants keyed by action, the flirt/embrace personality class:
    Flirt: "{A} lingered on {B} with their eyes and let it show."
    TouchBreasts: "{A} reached for {B}'s chest - bold, warm, and unrepentant."
    SuckBreasts: "{A} bent to {B}'s chest, licking and suck at their breasts."
    FondlePussy: "{A}'s hand reached between {B}'s legs, fondling their privates."
    OralOnTarget: "{A} dropped to their knees for {B} - sucking at their privates."
    USER'S PEN per line; nothing ships unruled; ASCII-only once ruled.

***User edits applied.***

Full entry + the Molag-Bal/Sheogorath KEEP rulings + polish-pool notes: historical copy, lines 987-1044 (REV-146a section).
***

*Register restaged 2026-10-23 (user ruling): open entries 15, 16, 26, 29, 30 (30a/30b), 31. Entry 32 (REV-149 FHU cues) CLOSED-APPROVED 2026-10-24 per the user's ruling note "All text approved" — closure appended to the historical copy; wording of record: fhu-inflation.md REV-149. Entries 29/30/31 carry the USER'S 2026-10-24 EDIT PASS (provenance notes in-entry; edited text = pending text of record; application + closure ride their owning builds). Closed entries removed — historical copy holds all closures (pointer at top). Fork copy lockstep.*

