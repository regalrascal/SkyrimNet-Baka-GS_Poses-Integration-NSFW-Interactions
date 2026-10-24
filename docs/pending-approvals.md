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
***User: Readme updated directly. Item closed.***
2. The MO2 wizard-render test against dist [REV-108b] (checkbox must be CLICKABLE and STICK with GS Poses deselected; GS files ABSENT post-install; then a full install for the 11-page MCM parity). MO2's wizard cannot be headless-simulated — this is a user leg, not a text ruling.
    (Test procedure; no wording pending.)
***User: The wizard is rendering with tooltip descriptions intact. All items are selectable/de-selectable. Item closed.***
***

***
Entry 16

Subject REV-109 MCM restructure bulk reword set (16a-16d)

Pending text:
1. The REV-109 display-length audit reword set, shipped as first drafts in `Scripts/Source/DeD_MCM.psc`: (16a) three class-(b) splits moving long text from the label/value surface into the InfoText (QTE Keys; SlaveTats intro; GS Poses intro); (16b) six absent-state "(not installed)" tail shortenings; (16c) the SlaveTats status refresh value ("N sections"); (16d) the new Settings-page headers "Framework"/"Maintenance" + the moved title "Delectatio et Dominium" and tagline "Bedroom drama for SkyrimNet". All ASCII; user wording rulings pending per the entry-14 user-editable-baseline precedent.
    Full OLD -> NEW set quoted verbatim: historical copy, lines 261-330 (includes the REV-109b/109c riders — the strings ship on the six stacked "Baka Interactions" section surfaces).
***User: MCM line splits and restructure landed successfully. The only edits I would make at this time would be to capitalize all the top level menu names (Baka, GS, Tattoos, Cum Effects, etc.).***

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
Entry 30

Subject Player-target policy MCM control (30a) + baka consideration prompt (30b)

Pending text:
1. [CLOSED 2026-10-24 at the REV-150 build — entry 30a.] The user's edit pass REMOVED the saves-migration sentence from the tooltip; the remaining text applied to the live DeD_MCM surface (the sentence stripped from DeD_MCM.psc L1701 area, byte-proven ABSENT from the pex). Wording of record: baka-module.md REV-150.
    Title: "NPCs May Target You"
    Tooltip: "When on, NPCs and creatures may choose you as the target of their autonomous actions (the Baka module's single central gate; your own initiations are never blocked). When off, nothing targets you unless you start it." 2. The baka daemon's candidate-selection prompt (30b), STAGED draft in-tree; the Mephala selection lane REQUIRES it (absent = the attempt refuses NAMED, prompt-absent); Molag-Bal needs no prompt. The user's install ruling = their 30b voice/wording ruling. The prompt receives the candidate pool, current mode, target-sex level, and player-target policy state; returns ONE pick or a refuse+reason.
    Filepath of record: fork tree `external\regalrascal.baka-gs-integration\prompts\snbaka_muse_consideration.prompt` (DRAFT-flagged header, this register cited).
    Full entry + REV-145/REV-146 riders: historical copy, lines 937-985.

***User note: Entry 30 tooltip text edited (the 2026-10-24 pen = the ruling; 30a CLOSED at the REV-150 build; 30b remains OPEN at the user's pen for the daemon build).***
***



***
Entry 32

Subject Pose-picker decision template (ded/pose_picker.prompt)

Pending text:
1. The REV-152 pose-picker decision template, shipped draft-flagged (header cites this entry) at fork tree `SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\prompts\decisions\ded\pose_picker.prompt`. User-facing LLM prompt content: the npc/moment state blocks (name, sex, location, arousal, pose policy, current pose state) + the 'pose choice' question ('Choose the single pose from the options below that this NPC would most plausibly perform at this exact moment ... Answer with one option key only') + the criteria loop rendering the dynamic poseOptions array (one 'EVENTKEY: description' line per pose of the selected category; poses.js = catalog of record). The decision model picks the pose WITHIN the category already resolved by Sanguine's consideration call; the OnPosePicked callback fires the choice through the REV-137-hardened executor (random-in-category fallback on any failure). Options are dynamic per call — only the question/state wording is fixed text. Wording ships draft-flagged at the user's pen (entries 15/16/26 precedent).
    Full text: fork tree path above (41 lines, ASCII-only).
***

***
Entry 33

Subject FHU inflate narration trigger (guidance text + MCM label/tooltip)

Pending text:
1. The REV-153 sdb_fhu_inflate_narr trigger's response guidance — the Follow-up Prompt pattern (REV-134f precedent) applied to FHU per the user's 2026-10-24 exchange shape ("a similar format to the cum detection prompt + optional direct narration trigger"). Two-surface distinction per the entry-22 precedent: the cue = WHAT HAPPENED (the entry-32-approved in-script orifice/consent/arousal desc, unchanged); the narration guidance = HOW TO RESPOND. No template variables per the D8/sec.137 binding rule; ASCII. Shipped DRAFT-flagged (header cites this entry) in the fork tree `SKSE\Plugins\SkyrimNet\external\regalrascal.fhu-inflation\triggers\sdb_fhu_inflate_narr.yaml` (response.content):
    Someone nearby has just had their belly swell noticeably fuller. Characters who notice are prompted to respond to the moment they just witnessed -- a comment, a reaction, a tease, concern, or envy, as each personality dictates. One line or one action each.

    Do not explain what caused the swelling, and never name any framework or source -- respond only to the visible moment just described.
2. The Fill Her Up MCM "Follow-up Prompt" toggle surfaces (label + tooltip DRAFT per the same exchange shape, the 134f/17b precedent; DEFAULT OFF — the Follow-up Prompt precedent; gated second surface, cue mandatory while the module is active):
    Label: "Follow-up Prompt"
    Tooltip: "Additional direct narration for inflation cues"
***

*Register state after the REV-152 build session (2026-10-24): entries 15 and 16 CLOSED at the user's pen (inline closure notes — the fork-copy notes carried to GS canonical lockstep this session). Open entries 26, 30 (30b only), 32. Entry 32 STAGED at the REV-152 build (the pose-picker decision template, draft at the user's pen). Pre-REV-152 state: open entries 15, 16, 26, 30 (30b only — 30a CLOSED at the build).

***
Entry 34

Subject FHU ambient bystander cues (band wordings + ambient-narration guidance + MCM labels/tooltips)

Pending text:
1. The REV-154 ambient bystander cue band x source wordings (the in-script descs composed for the sdb_fhu_ambient event — the planner's 30%/60% expose bands applied to FHU, the cum-ambient entry-19 subjectless shape): noticeable band = curious stares / suggestive comments ("Nearby characters notice that <name>'s belly is noticeably swollen and trade curious stares; a few dare low, suggestive comments."); heavy band = scandalized whispers ("Nearby characters cannot help staring at <name>'s heavily distended belly; scandalized whispers follow them wherever they move."); creature-source variants read the creature class ("...a few mutter that some beast has left them stuffed." / "...scandalized whispers spread that some beast has pumped them full."). Full text: SNBaka_FHUInflationModule.psc `_AmbientFire` (four desc branches; indeterminate source skips cleanly).
2. The REV-154 sdb_fhu_ambient_narr trigger's response guidance — the Follow-up Prompt pattern (153/134f precedent) applied to the AMBIENT bystander cue (the gated second surface; band wordings above are the mandatory cue). No template variables per the D8/sec.137 binding rule; ASCII. Shipped DRAFT-flagged (header cites this entry) in the fork tree `SKSE\Plugins\SkyrimNet\external\regalrascal.fhu-inflation\triggers\sdb_fhu_ambient_narr.yaml` (response.content):
    A nearby character is visibly inflated, their belly swollen well past what a normal belly looks like. Characters who notice are prompted to react to them -- curious stares, low suggestive comments, scandalized whispers, concern, or embarrassment, as each personality and the visible state dictate. One line or one action each.

    Never explain what caused the swelling, and never name any framework or source -- react only to the visible state and the cue that just described it.
3. The Fill Her Up MCM ambient surfaces (labels + tooltips + notification, DRAFTs; "Ambient Narration" DEFAULT OFF; band sliders default 30/60 per the C5 ruling — planner values = defaults, the MCM is the user valve):
    Labels: "Ambient Narration" / "Noticeable Band" / "Heavy Band"
    Tooltips: "Additional direct narration for ambient bystander cues" / "Bystander reactions start once inflation passes this percent of Fill Her Up's maximum (default 30%)." / "Reactions escalate to scandalized whispers above this percent (default 60%)."
    Notification: "Ambient Narration enabled: ambient bystander cues also produce a direct narration line." / "Ambient Narration disabled."
***

*Register state after the REV-154 build session (2026-10-24): NEW entry 34 STAGED (the FHU ambient bystander cues — the band x source cue wordings, the sdb_fhu_ambient_narr guidance text, and the Fill Her Up MCM Ambient Narration/band-slider labels/tooltips, DRAFTs at the user's pen). Open entries 26, 30 (30b only), 32, 33, 34. Fork copy lockstep.