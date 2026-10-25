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
    [REV-161b RE-VOICE (2026-10-25, per the user's narration-voice occurrence-#2 ruling; the instruction-voiced REV-153 draft superseded — kept for the record below it):]
    The recently filled character's belly swells with warmth. Nearby people start to notice. Their reactions differ -- a comment, a tease, concern, envy, shock, amusement -- but they all notice, and the most affected feel compelled to speak.

    The source of the swelling is not apparent; the visible moment speaks for itself.
    [Superseded draft, for the record: "Someone nearby has just had their belly swell noticeably fuller. Characters who notice are prompted to respond to the moment they just witnessed -- a comment, a reaction, a tease, concern, or envy, as each personality dictates. One line or one action each. / Do not explain what caused the swelling, and never name any framework or source -- respond only to the visible moment just described."]
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
    [REV-161b RE-VOICE (2026-10-25, per the user's narration-voice occurrence-#2 ruling; the instruction-voiced REV-154 draft superseded — kept for the record below it):]
    A nearby character is visibly inflated, their belly swollen well past what a normal belly looks like. Those who notice take the sight in their own way -- curious stares, low suggestive comments, scandalized whispers, concern, or embarrassment -- each true to who they are and to what they are looking at. The most affected feel compelled to speak.
    [Superseded draft, for the record: "A nearby character is visibly inflated, their belly swollen well past what a normal belly looks like. Characters who notice are prompted to react to them -- curious stares, low suggestive comments, scandalized whispers, concern, or embarrassment, as each personality and the visible state dictate. One line or one action each. / Never explain what caused the swelling, and never name any framework or source -- react only to the visible state and the cue that just described it."]
3. The Fill Her Up MCM ambient surfaces (labels + tooltips + notification, DRAFTs; "Ambient Narration" DEFAULT OFF; band sliders default 30/60 per the C5 ruling — planner values = defaults, the MCM is the user valve):
    Labels: "Ambient Narration" / "Noticeable Band" / "Heavy Band"
    Tooltips: "Additional direct narration for ambient bystander cues" / "Bystander reactions start once inflation passes this percent of Fill Her Up's maximum (default 30%)." / "Reactions escalate to scandalized whispers above this percent (default 60%)."
    Notification: "Ambient Narration enabled: ambient bystander cues also produce a direct narration line." / "Ambient Narration disabled."
***

***
Entry 35

Subject Tattoo v2 ambient exposure cues + application lanes (branch wordings + narr guidance + two action descriptions + MCM labels/tooltips)

Pending text:
1. The REV-156 sdb_tattoo_observed branched cue wording (the in-script desc composed by SNBaka_SlaveTatsModule.AmbientExposurePass — branches on application-specific information: location + the SPECIFIC mark + the wearer; the wearer's observable arousal tier rides the REV-82 APPROVED _ArousalClause wording of record verbatim — cited, not re-drafted): "<name> has a tattoo showing on <location>: '<tattoo name>' (<section>). Anyone who notices it reacts to the specific mark." Location branches (v3 area -> observable wording): Body = "their exposed torso" / Face = "their face" / Hands = "their bare hands" / Feet = "their bare feet" / unknown = "their exposed skin". Full text: SNBaka_SlaveTatsModule.psc AmbientExposurePass (the RegisterEvent call).
2. The REV-156 sdb_tattoo_observed_narr trigger's response guidance — the Follow-up Prompt pattern (134f/153/154 precedent) applied to the tattoo AMBIENT cue (the gated second surface, DEFAULT OFF; the mandatory cue is the sdb_tattoo_observed event text itself, cue-only, no yaml of its own — the 134d anatomy). No template variables per the D8/sec.137 binding rule; ASCII. Shipped DRAFT-flagged (header cites this entry) in the fork tree SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\triggers\sdb_tattoo_observed_narr.yaml (response.content):
    [REV-161b RE-VOICE (2026-10-25, per the user's narration-voice occurrence-#2 ruling; the instruction-voiced REV-156 draft superseded — kept for the record below it):]
    A nearby character has a visible tattoo showing on their skin, and it has just been noticed. Those who see it take the specific mark the cue described in their own way -- a comment, a look, a step closer or away, amusement, scandal, or interest -- each true to who they are and where they stand. The most affected feel compelled to speak.
    [Superseded draft, for the record: "A nearby character has a visible tattoo showing on their skin, and it has just been noticed. Characters who see it are prompted to react to the specific mark the cue described -- a comment, a look, a step closer or away, amusement, scandal, or interest, as each personality and their own state dictate. One line or one action each. / Do not invent details about the tattoo beyond what the cue described, and never name any framework or source -- react only to the visible mark." The invent-no-details constraint is carried by the cue itself (the desc names location + the specific mark + section) plus the story-truth rider class; if the user wants it explicit, it can return as story truth ("nothing beyond the mark the cue described is apparent to onlookers") at the pen.]
3. The two new LLM action descriptions (DRAFTs; the planner's dominant-relationship dialogue row and ownership/humiliation NPC-on-player row as the wording basis; full text: fork tree SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\actions\CommandTattoo.yaml and MarkPlayer.yaml description blocks — CommandTattoo: "The initiator commands a tattoo onto a standing character who accepts their dominance..."; MarkPlayer: "An NPC who wants to humiliate the player, or mark ownership of them, applies a tattoo to the player's skin. The NPC decides where the mark goes, which specific tattoo it is, and its color, based on their own arousal, mood, and character...").
4. The SlaveTats MCM ambient surfaces (labels + tooltips, DRAFTs; "Tattoo Ambient Narration" DEFAULT OFF — the Follow-up Prompt precedent; "Ambient Exposure Chance" default 35 per the user's ~35% ruling; the "Ambient Observation Cues" tooltip RE-POINTED to the daemon-tick pass):
    Labels: "Ambient Exposure Chance" / "Tattoo Ambient Narration"
    Tooltips: "Chance each daemon-tick ambient pass fires a visible-tattoo reaction cue when someone nearby has an exposed mark (default 35%). Failing rolls are silent." / "Additional direct narration for ambient tattoo reaction cues (a second prompt surface on top of the mandatory cue). Default OFF." / "Master gate for ambient tattoo reaction cues: while a Baka daemon mode is on, every daemon tick rolls a chance for nearby personas to notice any VISIBLE tattoo - covered marks are not reacted to, marks applied by any means are. Default ON."
***

Entry 36

Subject REV-157 prompt-layer mold (one batch entry): the 4 fragment branch texts (FHU + tattoos, bio + disposition) + the two slimmed ambient cue descs

Pending text:
1. The REV-157 FHU BIO fragment branch texts (STRATEGIST DRAFTs — the user's ruling gates INSTALL; first enabled render IS the probe): the SELF "## Your Body" branches (heavy/noticeable band x fresh <600s / settled — e.g. fresh-heavy "Your belly is hugely distended and still swelling — the heavy, taut roundness of it strains with every breath." / settled-heavy "Your belly remains hugely distended — the heavy swell has settled in and refuses to go down." / fresh-noticeable "Your belly is noticeably swollen and still filling — a warm, weighted fullness you can feel with every step." / settled-noticeable "Your belly stays noticeably swollen — the lingering fullness has not gone down.") and the OTHER "## Who Is Nearby" sentence (name + band + filling/settled, e.g. "<name> is hugely distended, belly heavy and taut with the swelling, and it is still filling."). Full text: fork tree SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\prompts\submodules\character_bio\0176_ded_fhu.prompt.
2. The REV-157 TATTOOS BIO fragment branch texts (same DRAFT class): the SELF visible-marks branch ("## Your Body" — the subject's own visible marks listed) and the OTHER "## Who Is Nearby" marks-list sentence (wearer + per-mark section/name/location, e.g. "<name> has visible tattoos: <section> — '<name>' on their exposed skin."). Full text: ...\prompts\submodules\character_bio\0177_ded_tattoos.prompt.
3. The REV-157 DISPOSITION tier texts, both ufi fragments (witness disposition keyed to the ACTING NPC's arousal tier; tier-3 "run hot" / tier-2 "be intrigued" / tier-1 "be taken aback"; tier-0 silence) — FHU: "When reacting to the swollen belly, run hot — open fascination and hungry appraisal; you do not bother hiding how the sight holds you." (+ tiers 2/1); tattoos: "When reacting to the visible tattoos, run hot — open admiration and appetite; the marks on their skin hold your gaze and you make no effort to hide it." (+ tiers 2/1). Full text: ...\prompts\submodules\user_final_instructions\0521_ded_fhu_disposition.prompt and 0522_ded_tattoos_disposition.prompt.
4. The two REV-157 AMBIENT-CUE DESC SLIMS (ruling (b) — nudge-class wording; the standing facts moved to the bio fragments, the application events untouched per ruling (a)): the FHU sdb_fhu_ambient band x source texts (4, in SNBaka_FHUInflationModule.AmbientExposePass — e.g. noticeable/human "A few passersby steal glances at <name>'s noticeably swollen belly." / heavy/human "Heads turn as <name> passes; the hugely swollen belly draws every eye." / noticeable+heavy/creature murmurs branches) and the ST sdb_tattoo_observed cue (in SNBaka_SlaveTatsModule.AmbientExposurePass — location + specific mark + wearer + the APPROVED REV-82 arousal clause retained; the directive tail "Anyone who notices it reacts to the specific mark." REMOVED).
***

*Register state after the REV-157 build session (2026-10-24): NEW entry 36 STAGED (the REV-157 prompt-layer mold — the 4 fragment branch texts + the two ambient-cue desc slims, one batch entry, DRAFTs at the user's pen). Open entries 26, 30 (30b only), 32, 33, 34, 35, 36. Fork copy lockstep.*

*Register state after the REV-158 final-batch dist cut (2026-10-24): NO rulings arrived before the cut — the open set (26, 30b, 32, 33, 34, 35, 36) ALL SHIPPED DRAFT-FLAGGED in the [REV-158] dist per the standing precedent (the install-time ruling is the user's; the first enabled render is the probe per the shipped-fragment convention). No entries closed; no new entries staged. Fork copy lockstep, hashes reported in the session report.*
***
Entry 37

Subject REV-159 polish-session batch: mode-narration labels + guidance texts (4 modes) + cadence slider labels + MCM tooltips + F-2 FOMOD descriptions

Pending text:
1. The MODE DIRECT-NARRATION TRIGGER surfaces (134f Follow-up Prompt pattern, user-ruled at the 10-24 dogfood; DEFAULT OFF, MCM-gated second surfaces; the mandatory event desc is script-composed actor names + action, the guidance texts below are the yaml response.content - register entry 34/35 yaml shape): MCM labels "Mephala Mode Narration" / "Molag Bal Mode Narration" (Baka Interactions page; motherboard properties bMephalaModeNarration/bMolagBalModeNarration) and "Sanguine Mode Narration" / "Sheogorath Mode Narration" (GS Poses page; StorageUtil GSAnim.SanguineModeNarr/GSAnim.SheogorathModeNarr); MCM tooltips "Additional direct narration when Mephala Mode actions fire, asking nearby characters to react" (+ Molag Bal/Sanguine/Sheogorath variants); yaml guidance texts shipped DRAFT-flagged at regalrascal.baka-gs-integration\triggers\sdb_mephala_mode_narr.yaml and sdb_molagbal_mode_narr.yaml, regalrascal.gs-poses\triggers\gsanim_sanguine_mode_narr.yaml and gsanim_sheogorath_mode_narr.yaml. [REV-161b RE-VOICE (2026-10-25, per the user's narration-voice occurrence-#2 ruling; the REV-159 instruction-voiced drafts superseded): each now reads in-story -- e.g. mephala: "Something has just happened between two people nearby, described by the cue above. Those who witnessed it take it in their own way -- a glance, a comment, a step closer or away, amusement, shock, or feigned blindness -- each true to who they are and where they stand. The most affected feel compelled to speak." (same shape for molagbal / sanguine / sheogorath, their reaction menus carried over; the superseded drafts remain in the git history of the REV-159 cut).] MOLAG BAL RULING CARRIED: narration YES, thoughts still NO.
2. The CADENCE SLIDER surfaces (user-ruled range 15s-240s; defaults unchanged): labels "Mephala Tick Interval" / "Molag Bal Tick Interval" (Baka Interactions page; keys SNBaka.MephalaCadence/SNBaka.MolagBalCadence, defaults 45/15) and "Sanguine Tick Interval" / "Sheogorath Tick Interval" (GS Poses page; keys GSAnim.NudgeInterval default 30 / GSAnim.T3Interval default 15); tooltips "Seconds between <mode> action/pose opportunities (default Ns)."
3. The POSE-NARRATION TOGGLES (titles USER-AUTHORED per the 137f rider - register-cite; DEFAULT ON, current behavior preserved): "Sanguine Pose Narration" / "Emergent Pose Narration" / "Player Initiated Pose Narration" (GS Poses page; keys GSAnim.PoseNarrSanguine/Player/Emergent). Tooltips are DRAFTs with the lean "narration cue" resolution of the user {{prompt/trigger}} placeholders - the user verbatim quotes were lost to the session-history migration, flagged for the user pen: "Send the narration cue when Sanguine Mode poses an NPC (default on)." / "Send the narration cue when autonomous or emergent forces pose an NPC (default on)." / "Send the narration cue when you pose an NPC or gesture for them to stop (default on)."
4. The REV-159 3.2(b) FHU MCM retitle (USER-PROVIDED verbatim, cited): label "Module Toggle - Fill Her Up Awareness", tooltip "Enable/disable cues and reactions for Fill Her Up Baka" (the three-row subtext retired).
5. The F-2 FOMOD group descriptions (S181 finding; entry-14 baseline): the FHU Inflation group - "unchecking this removes the cue pack ASSETS only - the inflation cue and narration templates. The module awareness logic is framework-carried and stays installed, inert without the pack: the Fill Her Up MCM section greys out and the level poll idles. Nothing breaks either way."; the SlaveTats group - "unchecking this removes the ASSETS only - the tattoo textures and the picker UI. The content layer (the tattoo prompts, triggers and actions) is framework-carried and stays installed, inert until SlaveTats itself is present and the toggles are used... The SlaveTats MCM section stays but reports the module as inert. Nothing breaks either way."
6. The 2.3 RECOMMENDATION (not built - surfaced): the CommandTattoo action description could state that no tools or preparation are needed ("The mark appears on their skin at the initiator command - no tools or preparation are needed."); the 10-24 non-pick was the absent-build (the action was not in the tested [REV-148] install), so this is an optional nudge at the user pen.
***

*Register state after the REV-159 polish-session build (2026-10-25): NEW entry 37 STAGED (the polish-session batch - mode-narration labels + guidance, cadence slider labels, pose-narration tooltips, the user-provided 3.2(b) texts cited, the F-2 FOMOD descriptions, the 2.3 recommendation). Open entries 26, 30b, 32, 33, 34, 35, 36, 37. Fork copy lockstep, hashes in the session report.*

Entry 38

Subject REV-160 narration-voice sweep (one batch entry): 14 Baka trigger yamls + sdb_slapped/sdb_spanked/sdb_tattoo_applied/sdb_tattoo_removed + 3 in-script cue sites re-voiced to narration; rule citation rides the entry

Pending text:
Swept (DRAFTs at the user pen -- full text at the cited paths; the REV-160 pattern of record is the user own example: in-story storyteller narration, third person, present tense, no meta-instruction):
1-12. The baka trigger yaml set at SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\triggers\ -- baka_calloff, baka_defeat, baka_escalate, baka_interaction_end, baka_interaction_start, baka_intervention, baka_opportunity, baka_panic, baka_resist_fail, baka_resist_start, baka_resist_success, baka_sexlab_trigger: every directive frame removed ("Generate ...", "Do NOT", "Match their personality exactly", "Make it land", "call the action, do not just narrate"); replaced with third-person present-tense world narration (action-option facts kept: Execute/Escalate/HelpUp/Release listings, "never StartNewSex"). baka_escalate_slipped.yaml left as-is (already narrative).
13-14. sdb_slapped.yaml + sdb_spanked.yaml (same directory): "Generate their immediate reaction ... Match their personality exactly. Do not describe ..." re-voiced to narration register.
15-16. sdb_tattoo_applied.yaml + sdb_tattoo_removed.yaml: "React only to what is observable / do not name any framework or source" recast as story truth ("How the mark came to be is not apparent to onlookers, and nothing beyond the event text is." / "nothing beyond it is apparent to onlookers.").
17-19. IN-SCRIPT, Scripts\Source\SkyrimNet_BakaIntegration.psc: _RoleplayHint tails -- "Speak and react in character as whichever of them is talking." and "React in character." REMOVED (narrative bodies kept verbatim); the two baka_defeat/baka_opportunity cue twins (L~4632/L~4725) -- "must still decide NOW and carry it out (use the action, do not just describe it)" -> "the choice is on them right now, and it lands through action"; "Pick ONE and do it now." -> "The decision lands through the action itself."
RULE CITATION (rides this entry): STANDING_RULESET REV-160 rider -- NARRATION-VOICE STANDARD (all trigger/narration content is in-story narration; LLM instructions live in prompt files and action descriptions only; the ship-gate grep gains the instruction-verb patterns).
FLAGGED-ONLY (NOT swept at REV-160; per-item user ruling required -- GRANDFATHER keep as ruled vs RE-VOICE re-rule the voice): the register-DRAFT narration yamls carrying the same instruction-tone patterns -- sdb_cum_ambient_narr (entry 22, user-verbatim wording of record -- already narrative), sdb_mephala_mode_narr + sdb_molagbal_mode_narr + gsanim_sanguine_mode_narr + gsanim_sheogorath_mode_narr (entry 37), sdb_tattoo_observed_narr (entry 35), sdb_fhu_ambient_narr (entry 34), sdb_fhu_creature_cum + sdb_fhu_inflate + sdb_fhu_deflate_anal/oral/vaginal (rev-149 entries). [RESOLVED (2026-10-25, REV-161b): the per-item ruling arrived the same session -- the user's occurrence-#2 message ruled the whole flagged class re-voiced. All 14 surfaces re-voiced (the 12 named here MINUS sdb_cum_ambient_narr, which was already narrative and untouched, PLUS acheron_downed.yaml and baka_opportunity.yaml, which carried the same directive ladder); receipts: PROJECT_STATE S185; gate v10 extended to all 32 direct_narration yamls, 0 hits. The entries stay open only for their remaining wording dispositions.]
***

*Register state after the REV-160 session (2026-10-25): NEW entry 38 STAGED (the narration-voice sweep batch -- 19 swept surfaces + rule citation + the flagged-only list). Open entries 26, 30b, 32, 33, 34, 35, 36, 37, 38. Fork copy lockstep, hashes in the session report.*

Entry 39

Subject REV-161 dogfood-continuation batch: CommandTattoo call-phrases + kill-vs-ink, down.yaml Execute mention, tattoo ambient recast, three ambient cadence sliders, twelve pose pool enrichments

Pending text:
1. CommandTattoo action description additions (DRAFTs at the user pen; the USER-QUOTED phrases verbatim): the WHEN-TO-USE list gains "The character asks to 'mark their skin', to 'give them a tattoo', or to 'brand them with my mark' - all of these mean THIS action", plus the KILL VS INK distinction ("when the intent is a lasting mark of ownership or shame on a living character, this is the action. Execute is the killing blow... a character who only wants to brand or mark someone never reaches for Execute."). Full text: fork tree SKSE\Plugins\SkyrimNet\external\regalrascal.baka-gs-integration\actions\CommandTattoo.yaml (both copies).
2. down.yaml category description Execute mention + credit note: "...ink them with Force Tattoo, or - when the loser is an enemy the winner wants dead - deliver the deliberate killing blow (Execute)... (Execute-mention phrasing credit: Oldcustard PR #2, folded REV-161.)" Full text: actions\down.yaml (both copies).
3. The sdb_tattoo_observed AMBIENT cue recast (REV-161 3.2): the observed cue drops the wearer's immediate-reaction clause (_ArousalClause stays APPLIED-cue only, per sdb_tattoo_applied) and carries OTHERS noticing, with the wearer optionally re-noticing later: "<name> has a tattoo showing on <location>: '<tattoo>' (<section>). Anyone close enough sees the mark; those who notice it react in their own way, and the wearer may catch their looks and grow newly aware of it too." Narration-voice standard. Full text: Scripts\Source\SNBaka_SlaveTatsModule.psc AmbientExposurePass (the RegisterEvent call).
4. Three MCM ambient cadence sliders (the 159 pattern; labels DRAFTs at the user pen; DEFAULTS UNCHANGED): Fill Her Up page "Ambient Cue Interval" (key SNBaka.FHUAmbientCadence, default 60s, 15-240s, read live at every pass); Cum Effects page "Ambient Cue Interval" (key SNBaka.CumAmbientCadence, default 60s, 15-240s, slider accept re-arms the DeDService ambient rule live); SlaveTats page "Ambient Cue Interval" (existing key SNBaka.ST.AmbientFloor, default 600s, 60-1800s, read live by the existing pass). Full text: Scripts\Source\DeD_MCM.psc (the v18 bump block, page builds, slider open/accept handlers) + the module read sites.
5. Twelve pose action description pool enrichments (batch DRAFTs at the user pen; the twerk-bearing pair flagged PRIORITY): each pose yaml gains a "THE POOL THIS ACTION DRAWS FROM:" line naming the moves in its pool (posedancesexy + posegroundsexy priority -- the twerk-bearing set). Full text: regalrascal.gs-poses\actions\pose{dance,dancesexy,groundsexy,groundidle,seduce,present,selftouch,stretch,workout,submission,plead,idle}.yaml (both copies; all 24 files hash-matched at the cut).
***

*Register state after the REV-161 session (2026-10-25): NEW entry 39 STAGED (the dogfood-continuation batch -- CommandTattoo phrases/kill-vs-ink, down.yaml Execute mention, the tattoo ambient recast, the three ambient cadence sliders, the twelve pose pool enrichments). Open entries 26, 30b, 32, 33, 34, 35, 36, 37, 38, 39. Fork copy lockstep, hashes in the session report.*

*Register note (2026-10-25, REV-161b -- narration-voice occurrence #2): the user s re-flag of the narration-voice standard (trigger content = in-story narration, not LLM instructions; REV-160 rider) is the per-item ruling the rider s flag-only protection required. The instruction-voice defects on the fhu/acheron/gs-poses narr surfaces -- including the entry-32/33 family -- are RE-VOICED per that ruling (14 surfaces; receipts: PROJECT_STATE S185; gate v10 extended to all 32 direct_narration yamls, 0 hits). The entries stay open for the user s remaining wording dispositions.*
