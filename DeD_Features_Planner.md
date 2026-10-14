# Delectatio et Dominium \- Bedroom Drama for SkyrimNet

## Planning List for Feature Modules and Associated Content Ideas

# Preface

Delectitio et Diminium is a mod aimed at expanding and enhancing the integration of the huge repository of adult Skyrim mods into SkyrimNet. Since there are already two fantastic integration mods aimed at the primary adult frameworks OStim/OstimNet, and Sexlab/SkyrimNet-Sexlab-Integration, this mod is aimed at an array of  auxiliary mods and niche content that is not already covered. The structural idea is that it will act as a modular framework that can support a number of mods, but require as few as one of them. The gameplay intent is enhanced player immersion, allowing their AI powered roleplay to integrate as much of their modist as possible.

# Core Framework

## Description

Features that govern Delectatio et Dominium as a whole rather than any single module.

## Planned Features

* \- Ambient pause discipline: no ambient or daemon function (muse, observation passes, detection polls, the future Baka daemon) fires while the game is paused or minimized. Central pause/menu-mode guard consulted by every ambient loop; skipped work reschedules rather than fires late. *[RESOLVED-BY-PLATFORM REV-88 — see working notes below]*  
* Notification muting: every module that shows on-screen notification messages gets an MCM toggle to disable them (pose refusals, muse fire notices, mode-switch confirmations, etc.).  
* Action eligibility self-hiding: downed-family actions (Execute, Escalate, Help Up) hide from the LLM's available-action list when no downed or pacified actor is present, using SkyrimNet's native action eligibility rules. Reduces action-list clutter without "do not pick this if X" padding.  
* Debugging mode and log capture (existing ticket).  
* The MCM "Settings" top-level page houses framework-level configurables (global timers, master enable, clean uninstall, stop/reset, debug toggle).

— Project working notes —

- 2026-10-08 REV-88: convention live (REV-88 ruleset rider) — this block is a Cline status-pointer layer; the checklist tree (GS repo INDEX + feature docs) stays the single status authority.
- 2026-10-08 REV-88: "Ambient pause discipline" RESOLVED-BY-PLATFORM (inline flag above) — real-time Papyrus timers freeze through pause/menu (PROJECT_STATE §92 1.2); minimized IS paused (user ruling 2026-10-08). No build required; INDEX row 15 closed. Eligible for user removal.
- 2026-10-08 REV-88: "Notification muting" — ruled 2026-10-08 (per-module MCM toggles); rides the GS polish cluster (unification-era.md roadmap item 4; gs-poses.md §3 register).
- 2026-10-08 REV-88: "Action eligibility self-hiding" + "MCM Settings page" — mapped to unification-era.md roadmap items 3 and 7 respectively (era doc = roadmap of record).
- 2026-10-09 REV-89: roadmap item 1 (dist-manifest) BUILT + item 2 (old-MCM scuttle, Acheron half) STOPPED at pre-check — the MCM quest's player alias is load-bearing (threat-tracker/OnPlayerLoadGame register); relocation ruling pending — see unification-era.md REV-89 sections.
- 2026-10-10 REV-90c: approvals surface exists — every pending §7 user-facing text is registered in GS docs/pending-approvals.md (user-approved 2026-10-10 rider); ruling moves text to the owning feature doc.
- 2026-10-14 REV-111: FRAMEWORK DLL ARCHITECTURE ruling of record (user, 2026-10-1X) — layered DLL architecture: ONE service DLL as central primitives (state store + cosave serialization + single tick scheduler + event pump; Papyrus API: RegisterState/SetState/GetState/AddTimerRule/PushEvent-class); module logic stays THIN PAPYRUS declaring state entries and timer rules; per-module C++ only when a module would MATERIALLY benefit (ruling wording, replacing "escape hatch"). Logic-vs-machinery split: anything two modules could need = central primitive; one-module-specific = module logic. The service DLL is the framework's first real DLL project; framework-grade build discipline (clean-save load gate, versioned state schema from day one); API designed completely BEFORE build. Full record: GS PROJECT_STATE §121 5-6.1 + unification-era.md REV-111 modernization-era design seed.
- 2026-10-14 REV-111: THE STAKE — the public repo Delectatio-et-Dominium is STAGED (fork `public-staging\`, fresh single-commit history v0.1.0 tagged, ship state = [REV-109c], full source incl. both DLL source trees); push USER-gated. Receipts: GS PROJECT_STATE §121. Status pointers only; this planner's user text untouched this session.
- 2026-10-14 REV-112: THE STAKE LANDED — the public repo is LIVE (https://github.com/regalrascal/Delectatio-et-Dominium, user-pushed; main + v0.1.0 @ a20d372, release = the re-cut zip). Era formally CLOSED; the POLISH POOL is the current phase — first campaign: Cum Effects v2 (service-DLL API spec drafted to GS docs/features/service-dll.md + the location-variant build staged as [REV-112]). Status pointers only; this planner's user text untouched this session. Receipts: GS PROJECT_STATE §122.


# Baka Escalate Module (full)

## Description

The interaction and escalation pipeline: grab/struggle/QTE, downed-state  
flow, defeat delegation, execution, and scene-start machinery for  
SexLab/OStim. The project's origin feature (Around906's SkyrimNet Baka  
Integration, credited).

## Implemented Features

* Interact power \+ Prisma menus (grab/intimate/display/expression/spank/ scene categories; dedicated downed menu).  
* Struggle/QTE \+ escalation pipeline (LLM-mediated opportunity/escalate/ defeat/resist triggers).  
* Local downed state (bleedout, ground window, downed menu: Escalate / Help Up / Release / Execute) — fully functional without Acheron.  
* Acheron bridge (folded, optional component): defeat delegation with liveness guards and recovery watches; feeds SkyrimNet acheron\_downed/acheron\_recovered events so NPCs stay defeat-aware.  
* Execute: pure-Papyrus kill from the downed menu (no Acheron dependency).  
* Spank system with degradation marks via SlaveTats (male-target MCM toggle; female-textured assets guarded from male bodies).  
* Scene start: SexLab (BakaSL) and OStim backends.  
* Cum detection \+ inflation cue modules (v1 reaction layers).  
* MCM "Delectatio et Dominium" (11 pages, self-migrating).

## Planned Features

* Muse-style Baka daemon (called “Melphala Mode”)  \+ overdrive mode (called “Molag Bal’s Ball) \+ Prisma buttons (specced in the existing Baka Escalate section — merge here).  
* Execute action lane: a SkyrimNet action so the LLM can command executions directly (downed/pacified-gated, Acheron-free, per the open ticket).  
* Dirty-talk pre-scene hooks (v2+, blocked on the dirty-talk module).  
* MCM restructure: Baka settings fold under a Baka section; framework-level settings move to Settings (existing ticket).  
* Scuttle the legacy Baka/Acheron MCM menus.

— Project working notes —

- 2026-10-08 REV-88: full-section checklist mapping lives in baka-module.md + baka-daemon.md + INDEX rows 3/12/14 (master checklist).
- 2026-10-08 REV-88: daemon mode names — planner "Melphala Mode"/"Molag Bal's Ball" map to baka-daemon.md's "Mephala"/"Molag Bal" context-mode rows; spelling + unclosed-quote intake flags reported in the REV-88 gate report (user's text untouched).
- 2026-10-08 REV-88: "MCM restructure" ticket — roadmap item 7 (Settings umbrella + Baka section fold), rides the SNBaka_MCM GetVersion/OnVersionUpdate rebuild machinery.
- 2026-10-13 REV-109: "MCM restructure" ticket — roadmap item 7 BUILT (DeD_MCM.psc: the Settings page + the five "Baka - " pages; GetVersion v8); dist [REV-109]; user gates open (INDEX row 16; PROJECT_STATE §117).
- 2026-10-13 REV-109b: "MCM restructure" ticket — Option A second pass BUILT (DeD_MCM.psc: ONE "Baka Interactions" page hosting SIX in-page sections incl. Lap Sitting, via the SL Defeat-precedented section-navigation pattern; GetVersion v9); dist [REV-109b]; user gates open (INDEX row 16; PROJECT_STATE §118).
- 2026-10-13 REV-109c: "MCM restructure" ticket — pass-3 ruling BUILT (DeD_MCM.psc: the 109b navigation model REMOVED; the ONE "Baka Interactions" page body STACKS the six sections under section-header rows — no nav, no state machine; census 74==74 vs REV-109 with multiset diff 0, handlers equivalent; GetVersion v10 + canary SNBaka.MCMDeD.v10); dist [REV-109c]; [REV-109b] archived; user gates open — on pass productization COMPLETE and THE STAKE unblocks (INDEX row 16; PROJECT_STATE §119). Process lesson recorded: ask "the simplest thing that satisfies the ruling" FIRST in future MCM-layout work.
- 2026-10-12 REV-96: Acheron probe cast-lie fixed (3 sites; un-cast installed check) + cum/FHU detection logic extracted to recordless modules — built, [REV-96] dist staged, dogfood pending (INDEX rows 5/6/16; PROJECT_STATE §102).
- 2026-10-09 REV-97: rev96 dogfood "Execute regression" diagnosed NOT-A-REGRESSION — player-button chain alive through Actor.Kill; block = victim's base Essential/Protected immunity, kill-path code byte-identical rev94->rev96, install hashes verified 6/6 (PROJECT_STATE §103; INDEX row 14).
- 2026-10-08 REV-88: "Execute action lane" — well-evidenced open ticket (INDEX row 14: author, not adopt; Acheron-free shape ruled); roadmap item 3.
- 2026-10-08 REV-88: seated-candidate policy (exclude / candidacy-relax / interrupt-then-fire) is the daemon spec's open ruling request (baka-daemon.md REV-87/88 notes).

# Gunslicer Poses Module (full)

## Description

The pose and idle-animation module: a library of solo posing actions (dances,  
stretches, seduction and display sets, ground poses, prop-gated idles)  
delivered through the crosshair pose menu, the ambient muse daemon, and LLM  
action calls. The visual vocabulary other modules draw on for teasing,  
display, and ambient life.

## Implemented Features

* Pose library: 28 pose-family actions covering \~168 individual animation events (dances, workout/stretch, seduction/display, ground sets, prop idles).  
* Crosshair pose menu (minor power \+ Prisma grid): category tiles drill down to per-pose tiles; works on male or female targets per the gender policy.  
* Gender policy, 3 MCM modes: female-only / curated male set (12 poses incl. Workout, Stretch, Plead, non-sexy Dance) / all poses; per-mode refusal messages.  
* Aroused clip split: male actors play male aroused clips.  
* Muse ambient daemon: 30s tick, one actor at a time, 60s per-NPC floor, fully-fireable vocabulary, direct-fire allowlist, state guards (sleeping/swimming/mounted/sneaking), session-scoped toggle.  
* Overdrive mode (faster cadence).  
* Arousal lean: high-arousal NPCs weighted toward seduction-family poses (OSL/SLAroused chain; no framework \= no lean).

## Planned Features

* Idle/furniture interrupt (evidence-backed): idling actors (sitting, leaning on walls/markers) currently refuse poses and are excluded from muse candidacy — starving ambient posing in idle-dense spaces like taverns. Investigate organically breaking the idle (stand from furniture, push off the wall) and then posing, or queueing the pose through the transition.  
* MCM tempo controls: player-adjustable muse and overdrive tick intervals; overdrive gains an "unlimited" option. (Spec after the idle fix — candidate supply, not interval, is the density lever.)  
* Notification muting per the Core Framework item (pose messages toggle).  
* SlaveTats tie-in: tattoo-themed pose \+ dialogue on a worn-tattoo timer (requires both modules).  
* Aroused-lean tuning: further reduce bland picks at high arousal.

— Project working notes —

- 2026-10-08 REV-88: full-section checklist mapping lives in gs-poses.md + posing-gender.md + INDEX rows 2/13.
- 2026-10-08 REV-88: RULING OF RECORD (2026-10-07 approval block): Baka<->GS de-tangle lands LAST in the de-tangle sequence; the shared pose category mechanism is the ruled seed (unification-era.md roadmap item 5 + boundary inventory).
- 2026-10-08 REV-88: RULING OF RECORD (2026-10-08): idle/furniture interrupt = OPTION A (pose-with-transition: furniture-exit / wall-push; skip sentinel; recheck-at-fire per rev-20 precedent) — roadmap item 4; design memo = gs-poses.md REV-87 register.
- 2026-10-08 REV-88: "Notification muting" (pose messages toggle) — ruled 2026-10-08; roadmap item 4 cluster. "MCM tempo controls" — after the idle fix (the section's own sequencing note; roadmap item 4).
- 2026-10-08 REV-88: muse cadence — live values confirmed 30s interval / 60s per-NPC floor; the user's supply-theory (idle-excluded pool + per-NPC cooldown) is the working hypothesis of record (unification-era.md §Muse interval read; §92 1.3).

# Cum Effects

## Description

Enhanced NPC and player reaction to cum effects and overlays that are placed at the end of adult animations.

## Connected Mods

* Sexlab (cum effect and visuals)  
* Sexlab P+ (if it adds anything in terms of cum application)  
* OCumAcended (dependant on OStim by association)  
* Whichever mod adds cum debuff magic effects based on enemy type (this should be investigated to confirm which mod this comes from)  
* SL Aroused (used to supply arousal level to help gauge reactions, actions, and triggers)  
* OSL Aroused (used to supply arousal level to help gauge reactions, actions, and triggers)  
* SkyrimNet (possible prompt/trigger overlap)  
* OStimNet (possible prompt/trigger overlap)  
* Note: User can pick which systems they have installed in FOMOD menu. Both adult animation frameworks should be supported simultaneously, but the arousal frameworks should mutually exclusive

## Planned Features

* SkyrimNet triggers for when cum is applied  
  * Triggers should have variant based on what location cum was applied to  
  * Triggers for bystanders should be prioritized if any are present, but triggers for the cum receiver should be available as a backup  
    * Example for cum applied to face: {{character1}} feels {{characters2}} seed coating their lips and dripping from their eyelids, warm and sticky. \*\*{{Character1}} is prompted to speak\*\*  
      * Speech guide example: “You certainly do make quite a mess, don’t you, I hope nobody sees me before I can get cleaned up”.  
    * Example for cum applied to hands: {{character1}} feels {{character2}}’s load pump hot and sticky over their fingers and wrist. \*\*{{Character1}} is prompted to speak\*\*  
    * Further context could be delivered based on whether the scene that delivered the effect was consensual or not  
  * Bystanders should get  who are reacting to triggers should have their reaction change base on how aroused they are:  
    * High arousal (arousal \>= 75%) \- React with enthusiastically with desire and approval  
    * Medium arousal (25% \< arousal \< 75%) \- React with surprise, interest and slightly scandalized fascination  
    * Low arousal (arousal \<= 25%) \- React with shock, horror, and disgust  
  * For the duration of the cum effect being applied, and if the character either is the player or is near the player, there should be an ambient timer that dispenses triggers every \~2 minutes prompting any nearby NPCs to comment on the applied cum.   
    * This timer should be tied to the cum effect itself and release when the effect is gone  
    * It should persist through area changes, sleep, and travel as long as the cum effect is still applied  
    * It should have a maximum lifecycle limit of 10 minutes in case there is a bug keeping the cum effect stuck on.  
  * SkyrimNet \- Sexlab Integration and OStimNet may have their own mechanics around cum triggers and NPC commentary. Implementation should take care to investigate these and report overlap. Possible routes forward could include:  
    * Avoiding overlap and working around existing prompts/triggers  
    * Overwriting the severely overlapping triggers/features with an explicitly labelled toggle option  
    * Enabling a mechanism that forced the LLM to take turns with which overlapping trigger/prompt was exposed for every interaction

— Project working notes —

- 2026-10-14 REV-111: DECISIONS RULED (user, 2026-10-1X; receipts: GS PROJECT_STATE §121 5-6.2 + cum-effects.md REV-111 section) — (a) STATE LAYER RULED: unified state authority, OCum + SL as EVENT SOURCES feeding OUR layer (OCum's own spell state = a reconciliation CHECKPOINT, not a duplicate authority); backing store = the framework service DLL (see Core Framework notes above) per the user's "pay the design cost now" ruling — the DLL API is designed as part of cum-v2's spec and built as the framework's first DLL project. (b)/(f) parked (wording/sequencing). (c) two-YAML bystander pair RULED (bystander cue priority + receiver cue probability-gated backup; mechanical priority, user-tunable per-YAML). (d) decorator-branched arousal tiering RULED design-green from the creator's Discord answer "I think so" — design-green-NOT-PROOF, VERIFY at the first cum-v2 build session (named gate leg); fallback = prompt-side guidance. (e) OStimNet spectator overlap: AVOID (different observables; one overlap-register line, no mechanism). B2 standing: the FHU integration point MIGRATES to fhu-inflation's v2 planning. Ruled v2 sequence: service-DLL API spec -> location variants -> two-YAML pair -> tiering -> ambient timer -> FHU integration point.
- 2026-10-13 REV-110: "Cum Effects" v2 SCOUT COMPLETE (report-only; this section's checklist tree untouched) — every planned feature mechanism-verified against the installed runtime (full receipts: GS PROJECT_STATE §120; v2 map of record: gs repo cum-effects.md REV-110 section). Key verdicts: location variants buildable via in-script wording dispatch on the OCum `Area` string (10-literal domain); no native recipient-priority exists (bystander-priority needs a two-trigger interplay or prompt-side fallback — user decision); bystander arousal tiering has an open witness-selection question (the trigger layer picks the perceiving NPC); the ambient timer rides OCum's own persistent state (spell duration default 5 min, swim-dispel) with our 10-min failsafe; SL-side persistent cum state requires OUR own state layer (SexLab has none); B2 CLOSED — the enemy-type cum-debuff mod is Fill Her Up Baka Edition (per-race cum-effect spell lists). Decisions (a)-(f) surfaced for the user, NOT decided.

# Cumflation (Cum inflation integration)

## Description

Introduce NPC and player reactions to inflation events and mechanics introduced by inflation mods like Fill Her Up Baka and SILF.

## Connected Mods

* Fill her Up Baka (base mod for the events, animations, and application  
* Sexlab Inflation Framework (for central tracking for inflation metrics between FHU and any other inflation enabled mods added in the future)  
* SL FHU Baka Ostim (for FHU OStim integration)  
* OstimNet (modular pull-out feature integration)  
* Devious Devices (plugging functionality)  
* SL Aroused (used to supply arousal level to help gauge reactions, actions, and triggers)  
* OSL Aroused (used to supply arousal level to help gauge reactions, actions, and triggers)

## Planned Features

* Triggers for inflated actors immediately after an inflation has occurred.  
  * Multiple triggers variation should exist depending on the amount of inflation that took place and the arousal of the actor.  
    * High arousal and large inflation increase ((arousal \> 75%) and (inflation \>= 50%)) \- React enthusiastically with desire and approval, while acknowledging the intense physical sensation of being so stuffed  
    * High arousal and medium inflation increase ((arousal \> 75%) and (25% \< inflation \< 50%)) \- React enthusiastically with desire and approval, noticing the considerable swell in your belly and comfortable feeling of being full  
    * High arousal and small inflation increase ((arousal \> 75%) and (inflation \<= 25%)) \- React enthusiastically with desire and approval, noticing the small bump and warm feeling in your belly  
    * Medium arousal and large inflation increase ((25% \< arousal \< 75%) and (50% \<= inflation)) \- React with shock, disbelief, and severe discomfort at the swollen feeling  
    * Medium arousal and medium inflation increase ((25% \< arousal \< 75%) and (25% \< inflation \> 50%)) \- React with surprise and fascination at the considerable amount of cum you were just filled by  
    * Medium arousal and small inflation increase ((25% \< arousal \< 75%) and (inflation \<= 25%)) \- React neutrally to slight sensation of the small amount of warm cum inside you  
    * Low arousal and large inflation increase ((arousal \<= 25%) and (50% \<= inflation)) \- React with dismay and horror, barely able to keep from vomiting at the unwelcome intrusion of so much cum  
    * Low arousal and medium inflation increase ((arousal \<= 25%) and (25% \< inflation \> 50%)) \- React with reluctance and disgust at the large load that was just deposited inside you  
    * Low arousal and small inflation increase ((arousal \<= 25%) and (inflation \<= 25%)) \- React with grumpy distaste at having been finished inside  
  * I am unsure of the total range of values possible for inflation amounts so any value state in examples should be taken as a percentage of the total range.  
  * Make the reaction values changeable by MCM so that the user can adjust to their liking and based on their arousal mod and inflation settings  
  * Further context could be delivered based on whether the scene that caused the inflation was consensual or not  
  * Further context could be delivered based on whether the inflation was delivered vaginally, anally, or orally.  
  * OstimNet, in its recent releases, has introduced a “pull-out” feature where the male player or NPC can choose to pull out before climaxing. It would be good to provide support for this feature and prevent inflation when “pull-out” is selected  
  * Similar to the ambient trigger timer for cum effects, there should be a timer that releases triggers for NPCs to react to the player or nearly NPCs when they have a noticeable level of inflation   
    * Actors with an inflation level below 30% of the total should not draw expose triggers  
    * Actors with an inflation levels between 30% and 60% should draw curious stares and suggestive comments  
    * Actors with inflation levels above 60% should be stared at and draw scandalized whispers  
    * Reactions can have context variations based on arousal level similarly to the instant event triggers  
  * Triggers should exist for the various events based around expelling cum either. Inflated NPCs will do this ambiently over time and the player can trigger it themselves.  
    * Triggers should be based on where the cum is being expelled  
      * Orally \- they are literally puking out cum in front of everyone  
      * Anally \- Unable to hold it they are forced to squat down and squirt cum out of their backdoor  
      * Vaginally \- They are suddenly hit by an undeniable need to evacuate, and with legs squeezed together they feel push, and the cum pours out of their sex  
  * There is additional functionality for actors being plugged with devious devices. If the area they are inflated in is plugged then they will be unable to deflate. This should be investigated and triggers should be added to cover these situations  
  * The goal is both sexlab and ostim versions of FHU would be supported for this feature. Together, if possible, but with an MCM choice/toggle option if not.

# Tattoo Application

## Description

Add actions for the application of adult themed tattoos implemented by the mod SlaveTats, and NPC/player reactions to those tattoos.

## Connected Mods

* SlaveTats (base tattoo feature add)  
* SlaveTats packs (packs for tattoo assets that SlaveTats can use)  
* SlavetatsNG (upgraded speed for tattoo application)  
* Magelight UI (framework for organizing and visualizing tattoos during application)   
* SL Aroused (used to supply arousal level to help gauge reactions, actions, and triggers)  
* OSL Aroused (used to supply arousal level to help gauge reactions, actions, and triggers)  
* Fade Tattoos Continued (allow option for tattoos to disappear over time)  
* Prisma UI (used currently, possibly update to Magelight UI)

## Planned Features

* Integration with the Baka escalation path by adding an “Apply Tattoo” button/option through prisma UI on downed actors.  
  * This option would exist for the AI as well when they are the aggressor in a baka sequence, or if they find the player in a downed position and have a high arousal state  
* Added action that can be triggered through dialogue where you can apply a tattoo to an NPC who you have a dominant relationship with. They would need to feel intimidated and/or submissive toward you to accept the action.  
* A tattoo application action should be available to the NPCs as well. They can access it if the player either requests a tattoo, or if the NPC feels like humiliating or marking ownership of the player  
  * LLM should be presented with a choice of where they want to add the tattoo, what color the tattoo should be, and then they should pick a tattoo name from the list (filtered by their earlier decisions) based on their arousal, mood, and character of the NPC who is applying the tattoo.  
  * Once complete the tattoo should be applied automatically to the player using SlavetatsNG  
* For tattoo application carried out on NPCs by the player, I would like to use Magelight UI as the delivery system as opposed to prisma UI or the native methods used by SlaveTats or SlaveTatsNG.   
  * Magelight UI would house the nested decision categories that tattoos require (location, tattoo name, color), and it has a feature that can render a live visual of the NPC being worked on within the menu.   
  * The Severactions plugin uses this feature to great effect for visualizing the application of outfits to followers.   
  * We would use it to apply the tattoos live, while the menu is open (immediately removing the old tattoo and re-applying on location/type/color changes by the user), and then lock in the final decision when the user presses an “Accept” button, which would expose the tattoo to SkyrimNet/our integration mod  
  * A cancel option should also be available to abort the task, adding a small trigger stating that you changed your mind  
  * The tattoo target will need to have all their equipment removed while they are rendered in the Magelight UI (be undressed) so that the tattoos are visible. Their prior clothing state should be restored once the tattoo process has been completed or cancelled. Care should be taken not to break any other mod’s clothing handling system (example: severations outfit system or Nether’s Follower Framework equipment system) when temporarily undressing the actor for tattoo render.  
* A configurable hotkey should be assignable in the MCM for applying tattoos with a single button press.  
  * This hotkey assignment should allow a modifier keys like alt or shift as a second option in the MCM  
  * A hotkey press should take the user directly in the magelight UI interface for tattoo application  
  * After application the tattoo, it should be exposed to SkyrimNet and our mod as normal  
* Tattoo tracking  
  * If any framework exists within slavetats or slavetats NG for tracking the tattoos on characters then it should be used to track if any nearby NPCs or the player have tattoos that could expose triggers.  
* Triggers for tattoos  
  * If a tattoo of an actor comes into view then a trigger will be sent to nearby NPCs.  
    * NPCs should be able to see the content/name of the tattoo and react to it. If the tattoo is an invitation to “use” the tattooed actor, and the triggered NPC has high arousal, they might just decide to do so.  
    * There should be an MCM toggleable option that requires a tattoo to be exposed before it can fire a trigger (it is on their torso and they are wearing no armor, legs tattoo with no boots, face tattoo with no helmet, arm tattoo with no gloves). Other SkyrimNet plugins have nudity detection, we might be able to piggyback, but we may have to build our own awareness too.  
* Character bio appearance block update  
  * There should be a toggleable MCM option to update the tattooed actor’s SkyrimNet bio (specifically the appearance block) with descriptions of the tattoos they have.  
  * If the character has over 3 tattoos the description of them should begin to be generalized, capturing the essence of the tattoo combination they have.  
* Tattoo Fading  
  * A toggleable MCM option should exist to allow tattoos to fade over time (as an alternative to player removal)  
  * This can be pulled from the Tattoo Fading Continued mod (present in my load order, but inactive), or require that mod as a prerequisite. Ideally it should not require the mod if possible.  
* Male applicable tattoos  
  * Investigate whether there is any hard barrier to applying the tattoo meshes to physics enabled male bodies like HIMBO.  
  * If allowing this is possible and low cost, enable the feature and remove any barriers in-code.

— Project working notes —

- 2026-10-08 REV-88: v1 + reaction layer shipped (INDEX row 4; slavetats.md); v2/v3 parked per Option C sequencing.
- 2026-10-08 REV-88: "Male applicable tattoos" (HIMBO/physics-body investigation) mapped to the slavetats v2 row (slavetats.md; INDEX master checklist) — research-class, unstarted.

# Improved Dirty Talk

## Description

Improved dirty talk aims at changing the way NPCs talk to each other during sexlab or Ostim Scenes. Currently, the conversations during scenes are primarily aimed at describing the active position changes, and vocalizing some general sounds or exclamations of pleasure or displeasure. Boring. I want to inject more context and feeling into the scenes by pulling more information for the LLM to work with, and encouraging it really feel out what is going on in the scene. Who is involved in the scene? What is their relationship? What activity are they doing or is being done to them? How does that make them feel emotionally? Roleplay that and make it interesting alongside some descriptive narration. There was also a problem, particularly with sexlab scenes where actors in the scene would often talk/argue with nearby NPCs who were reacting to them. While bystanders should comment if they have a line of sight, the active conversation should be focused between the participants in the scene, and dialogue should rotate between them. Bystanders can be incorporated into this rotation with reduced preference rather than taking it over when they are introduced The new beta 26 conversation/speaker picker could be helpful for that.

## Connected Mods

* SkyrimNet (integration may require custom prompts, context supply for actors in scenes)  
* SkyrimNet-Sexlab-Integration (some prompts may be overridden or adjusted by our own, context supply for actors in scenes)  
* OStimNet (some prompts may be overridden or adjusted by our own, context supply for actors in scenes)  
* Sexlab/Sexlab P+ (possible context source for actors in scenes)  
* Ostim (possible context source for actors in scenes)

## Features

* Conversation rotation during dirty talk (during adult animation scenes)  
  * Conversation rotation should be implemented using the new beta 26 TypeSafe's Jev feature to help choose who speaks next.   
    * The active participants in a scene should be prioritized to be the next speaker.  
    * Bystanders who have line of sight can comment, but they should only be allowed to intrude a maximum of every 3rd rotation between the scene participants  
      * Speaking sequence example: participant 1, participant 2, participant 1, participant 2, bystander 1, participant 1, participant 2, participant 1, participant 2, participant 1, participant 2, bystander 2, participant 1, participant 2\.  
  * This aims to solve a problem often present in sexlab scenes where conversation will tend to be taken over by bystanders who are reacting to the scene, and one of the scene’s participants.  
  *  If the player is one of the participants in the sexlab/ostim scene then the conversation flow should offer a small space of time for the player to respond to any questions the other participants asks them, or any statements they make  
    * Example: Participant 1 “Ooooh, no\! What are you doing?\! Don’t use my ass\!”, wait \~5s to detect some form of SkyrimNet response entry from the player (text/speech/transform speech), if a response entry is detected then wait for the deliver (bake in a timeout failsafe), player “You’re going to take it and you’re going to like it”.  
    * Example: Participant 1 “Ahhh yes, I’ve wanted you inside me ever since I caught sight of you in the Jarl’s hall”, wait \~5s to detect some form of SkyrimNet response entry from the player (text/speech/transform speech), if a response entry is detected then wait for the deliver (bake in a timeout failsafe), player “I’ve wanted you since the moment I saw your face. Gods, you feel incredible”.  
  * I am unsure of the best path for implementation of this feature. We will need to investigate. I suspect that we will need to build a prompt or multiple prompts to cover this feature. We will need to be careful of the other SkyrimNet plugins that cover adult scenes. We do not want to lose context, like positioning, but they have their own conversation structure that we can take lessons from, but may ultimately need to override to implement this properly.  
  * If the module does need to override portions of other prompts, then it should be explicit in its FOMOD description about what it does and what the user is choosing between.  
  * Communication between Cline, the strategy chat, and the user/manager needs to be close, open, and extensive when deciding where and how to overwrite any existing integrations.  
* Dirty talk context depth  
  * The AI should be exposed to, and integrate more context into it’s dialogue during dirty talk.   
    * Relationship with their scene partner  
      * Are they friends, enemies, comrades, lovers, family(taboo)?   
      * Are they aroused or not?   
        * This could change the context of how they see all the other exposed information. A taboo encounter could be terrible/mortifying if not too aroused, but it could be naughty/thrilling if arousal is high.  
      * Do they have any memories or accessible history with their scene partner that could be relevant to dirty talk?  
        * Have they ever desired their partner before?  
        * Is this a transaction that they want something at the end?  
        * Are they currently wounded?  
        * Where are they and does it matter to the scene?  
      * What is happening physically  
        * Position changes  
        * Type of scene (oral,anal,vaginal,etc.)  
      * Is this scene consensual or not?  
      * Is the character wearing any devices or restraints?  
        * If so, can they even speak or just make muffled noises around a gag?  
  * Don’t be afraid to look at the prompts, changelogs, and repos of the other integrations to make sure no gaps are being left open. This is not to plagiarize, just to ensure that quality is maintained in the event of an overwrite being necessary.  
  * The new decision/picker model should be considered for the decisions necessary in this module as well  
* Position change reactions  
  * Rather than fight the position switch reactions that are supplied the the other adult integrations, they should be fed into the sequence of what is happening   
  * Conversation rotations can be interrupted to describe how the position is changing through narration  
  * If the position change description has no difference to the description of the last position/animation-stage (possible in sexlab-integration if the description has not been made yet) then the change should be ignored in preference to continuing the dirty talk  
* Lean to ward genuine dirty talk  
  * This module exists more to dramatize the scene than make it “realistic”.  
  * We want the user to be immersed in the rich detail of what is happening rather than getting bland, canned lines about positions and enjoyment. Don’t get me wrong, those things have their place, but we want to go a few levels deeper  
  * Dialogue should imagine like it is coming from a movie (or maybe an adult film with hollywood level dialogue). It needs to be emotive and interesting, and it needs to lean dirty. SFW has little place in this module  
  * Narration should be interspersed as the LLM thinks it is necessary. I am personally a fan of it, but maybe there can be an MCM option that encourages more narration to be added in the prompt  
* Pre-scene dirty talk  
  * This is where I want to place optional integrations with the rest of the modules, like baka, GS poses, cum effects and slavetats.  
    * Is the NPC horny and sees the player? Do a sexy GS dance and throw out a dirty talk line.  
    * Does the player respond positively? Do a proposition pose (like a blowjob proposition pose) and throw out another dirty talk line.  
  * Is the character tough, assertive and aggressive?  
    * Start a baka pipeline flow with a struggle and throw out a dirty talk line  
    * Down the character and throw out another dirty talk line  
    * Start a scene and continue with the dirty talk  
  * Notice cum on the player/an NPC?  
    * Shame them with some dirty talk  
  * See a slavetat on an actor?  
    * Tell them what you think of them with some dirty talk  
* Cheating and Cuckolding  
  * If a married character cheats on their spouse, update their relationship block to reflect this event, how they feel about it, and the context of the infidelity  
  * Add a trigger especially for cheating (if possible to track)  
    * It may be up to an LLM to identify when it is happening   
  * Requirements should exist for whether the cuckolded NPC actually finds out about the affair  
    * Line of site  
    * Rumors function (could be tied in with another SkyrimNet integration like narrative engine, or intelengine, both of which handle rumors  
    * Could be a simple, native rumor function that seeds thoughts about hearing a rumor about the affair based on context (who the NPC knows and where they live, how they found out), and based on a percentage chance when the deed takes place  
      * More people in the area could increase the chance of being caught  
      * Direct line of site by people in the area could increase the chance of being caught  
      * Cum effects and tattoos could change the chance of discovery (tie ins with the related modules if present)  
  * The actual effect of how the NPC deals with this information should be based on their personality  
    * Maybe they actually like being a cuckold  
    * Maybe they are angry at the cuckolder  
    * Maybe they are angry at their partner  
    * Maybe they are angry enough to start a fight  
    * Maybe they want a “flesh price” to make things right  
    * Their reaction should be somehow stored by the module, and held for a reasonable amount of time so that it can be used by Dirty Talk (maybe 15 in-game days)  
    * When the hold period for the record done, it should be archived as an extension to the NPC’s background block in their character bio

# Open Ticket Issues

## Description

A compilation of issues, bugs, and requirements not connected to any specific module that have been noted by users or encountered during the mod building process. They vary in complexity, and have no specific sequential requirements besides those suggested by Cline and/or the strategy chat. These issues require solutions, and should be checked off as they are completed.

## Open Ticket Issues List

* The baka pose called “Show off Body” has a misleading name. When it is triggered, the actor who triggers it ogles the body of the target while the target strikes an ostentatious (relatively non-sensual) pose. The animation ends with the target slapping the hand of the triggerer when they try to touch them. There are a couple options to fix this, and we should follow the path of least resistance.  
  * Change the name of the pose/action/Prisma button to “Ogle body” or “Simp over body”  
  * Or, reverse the polarity of actor positions in the pose  
  * Either way, the description of the pose, the action selection description, and its yaml should be adjusted to match the vibe of the animation *[EXECUTED REV-84]*  
* .esp combination  
  * Baka, GS, and Acheron esp files combine into one to reduce mod footprint  
* Baka Interactions and Gunslicer Poses de-tanglining (scripts, actions, deploys, etc.), and slotting them into their own separate modules, respecting the mods overall modular framework. Neither should be mandatory  
* Adding FOMOD toggle options for all the available features  
  * Each module option should have a FOMOD tooltip description  
  * The FOMOD should run a check for the active prerequisite mods in the user’s load order, and default the related module to active if they are present  
* There is a new image that should act as the cover for the mod.  
  * Location: "D:\\Modding\\Skyrim\\Workspace\\Delectatio-et-Dominium\\Delectatio\_et\_Dominium\_Cover.jpg"  
  * It should be pushed to the github where it will replace the current readme image.  
  * It should be used as the FOMOD thumbnail  
* Baka Escalate Module *[SECTIONS EXIST REV-85]*  
  * Create a new module section in this document for the Baka Escalate module. It should follow the same format as the others and be filled with a description of the module as it currently stands as well as the currently implemented features  
    * New features to be added to the list for this module, but incomplete  
      * Muse-style game mode where random nearby NPCs will receive command to perform a baka action based on an ambient timer  
        * 30 second timer  
        * One actor selected to perform action at a time  
        * 60 second cooldown before the same actor can be targeted again  
        * The actor must select an action from among the module supplied actions  
        * Greater arousal will result in more extreme actions  
          * Struggle action picks should do the drunk struggle action when in taverns or if the target is drunk  
        * Contextual thoughts seeded based on the action they pick and the available exposed context from SkyrimNet  
      * Overdrive mode type game mode, functions similarly to the muse mode, but without the seeded thoughts, and with a shorter timer and cooldown (15 seconds and 30 seconds, respectively)  
      * These modes should be available through prisma UI buttons  
* Gunslicer Poses Module *[SECTIONS EXIST REV-85]*  
  * Create a new module section in this document for the Gunslicer Poses module. It should follow the same format as the others and be filled with a description of the module as it currently stands as well as the currently implemented features  
    * New features/changes to be added to the list for this module, but incomplete  
      * Make all animations/poses without a hard requirement for a female actor gender agnostic to perform  
      * Make the prisma UI pose selector work on Male NPCs as well for all poses that can be applied to male actors  
      * I want a much stronger lean toward sexy dance, sexual invitation gesture, and seducing pose actions when NPCs are aroused. Especially when in muse, where we can control it better  
        * As an issue note, I notice that very aroused actors still pick bland muse options too often. The picks should be more colorful, with a naughty lean  
      * Create tie-in for slavetats module (IF it is also installed)  
        * If the actors has a tattoo, occasionally pick a pose that connects to the tattoo and prompt some dialogue  
          * Example: If they have an “anal” themed tattoo, then have them twerk or show off their ass  
          * Example: If they have a brat tattoo have them do a dance  
          * Example: If they have slut tattoo have them do a sexy dance or proposition gesture  
        * This could be tied to a timer for nearby actors that have a tattoo, for the duration that they do have the tattoo  
* A user has brought up an issue with the “Execute” action from the Baka module  
  * Apparently when they command a follower to execute an enemy, they just ended up grabbing them instead  
  * They claim that there is no SkyrimNet action yaml or papyrus script connected with it  
  * We need to investigate the intended path and verify if this is true or not  
  * My suspicion is that the execute action relies on Acheron in some way and the user lacked it, but I could be wrong. Either way, it should be performable without Acheron if they lack that mod.  
* MCM unusual characters and spacing  
  * Some of the strings in the MCM have strange characters that must be the result of characters that are not accepted in the Skyrim engine (perhaps dashes or underscores?). I’ve seen this before in earlier issues with the muse activation message, and believe I remember it being an ASCII papyrus limitation. Investigation and fix required *[ASCII CLOSED REV-85b + rider; CRAMPED LAYOUT OPEN — see working notes]*  
  * Some of the longer strings on the left of the menu get cramped and overlap with the strings on the right. These need be broken into two stacked lines, or fixed in some otherway  
    * Example: The loaded tattoo sets menu item in the slavetats submenu  
* Consentuality detection  
  * In conversation with the strategy bot and Cline, it has come up that determining whether an adult scene has the roleplay characteristic of “consent” is difficult to gauge based on the information available by animation tags alone  
  * I know that this is not true in all cases because SkyrimNet-Sexlab-Integration directly fields and option to start or receive a “non-consensual” scene in the hotkey popup menu, and through certain actions available to the LLM. Also our baka pipeline carries a strong impression of this in how downed actors are treated  
  * Can this information be pulled and exposed to modules like Dirty Talk?  
  * In situations where it isn’t possible, or in all situations if the idea is feasible, is it possible to use TypeSafe's Jev to make a lightweight, lightning fast decision that decides whether the encounter is non-consensual, and which actor is the victim?  
* Readme disclaimer  
  * I realize some of the content in these modules is fairly extreme. While I can’t and don’t judge what roleplay my fellow gamers want to pursue in their sessions, I want to make clear that these theme explorations are only acceptable because they are happening in a harmless environment of code and animation. The game represents an environment where the users agree with themselves, as adults, to explore, roleplay, and visualize these themes, as if they were writing a story for themselves on the topic. The content of this roleplay is not meant to be shared or to produce content for anyone else, and the whole process is built to be consensual by definition. The existence of these modules and the themes they cover are in no way meant to encourage or normalize this kind of behavior in the real world. They exist in this mod because their moral repugnancy and cultural taboo shock, thrill, and horrify in the same way they would in a TV show, or movie. I will belabor the point no more, but I hope it is well made. Enjoy the mod for what it is, and do not take it as an endorsement for real sexual violence or illegal activaties.  
* Dealing with the old Baka and Acheron MCM menus  
  * The continued existence of the old MCMs in cosaves that load the new version of the mod is problematic. It could confuse the user on where to find adjust the module settings  
  * We should find a way to scuttle these old menus if at all possible  
  * In truth, I’m not sure if the acheron integration menu exists separately still from being a submenu inside the D\&D MCM. The submenu is the goal, the extra menu is a liability  
* Restructuring the D\&D MCM to make the Baka and GS portions exist as plugin categories in the left pane the same way the other feature plugins currently do  
  * All existing MCM top level menu items should be considered for whether they fall under the Baka umbrella, and be moved into the Baka sub-menu if they do  
  * All of them might need to go into the new submenu, but if any actually apply to the D\&D framework as a whole they can be moved into a (maybe already existing) top level menu item called settings  
  * The Settings top level menu item will be available for the future lifetime of the mod to house any top level configurables that govern the functioning of the whole D\&D framework  
    * Adjustable global timers  
    * Activate/deactivate mod  
    * Clean and uninstall  
    * Stop all processes and reset  
    * Enable debugging log  
    * Etc.  
* Debugging mode and log capture  
  * It would be nice, moving forward, if we could generate an easy way of reading user logs to detect issues  
  * Build out the idea for a debugging mode that captures detailed logs associated with our mod  
  * Design it in a way that makes diagnosing a wide range of AI/animation/SkyrimJank/ModConflict issues easier  
* The upcoming version will be like a full re-release of the mod. It is a different beast from when Dag/Around906 put the project down. *[ruled 2026-10-07 — records C10; see working notes]*   
  * I would like to rebrand as more or less a new mod that happens to contain this older mod (that I am also stewarding) as an optional internal component  
  * Around906 should be credited as the original author of the sections where that is true (baka, GS, and Acheron), but this project is not really his anymore in any meaningful way.  
  * I would like to start a new github with a new readme and versioning history that is completely owned by Delectatio et Dominium.  
  * After that is complete I will go through the task of releasing the mod on the new plugin environment (actually accessed in-game)

— Project working notes —

- 2026-10-08 REV-88: ticket mapping (checklist tree is the status authority): "Show off Body" — EXECUTED REV-84 (renamed "Ogle Body"; gs-poses.md REV-84 §; esp CK-label relabel ticket carried, xEdit user gate). ".esp combination" — C7-amended: merge = re-release-packaging decision at roadmap item 9. De-tangling ticket — roadmap item 5 (detection listeners -> recordless first; BakaSL; Baka<->GS boundary LAST, shared-category seed 2026-10-07). Truncated "comfortably" ticket — still the user's to complete (INDEX intake flag, carried). Cover image — queued, roadmap item 9. Baka/GS section-creation — SECTIONS EXIST REV-85 (flags inline above). Execute issue — INDEX row 14, roadmap item 3. MCM characters — ASCII leg CLOSED REV-85b + runtime-string rider; cramped-layout leg OPEN (Scenes&FX 25 / General 19 / SlaveTats 17 options — rides the item-7 restructure). Scuttle old MCMs — roadmap item 2. MCM restructure — item 7. Debugging mode — Settings umbrella scope, item 7. Readme disclaimer — item 9 (§7 flows; this text is the user's own).
- 2026-10-08 REV-88: RULING OF RECORD (2026-10-07 approval block): era re-scope — full re-release/rebrand; new GitHub created immediately before release (current fork stays the dev tree); Around906 credited as original author of his sections; absorption never; version scheme open (v1.0 vs v0.3.0-alpha). Flag-only above (the re-release bullets are the user's own text and already carry the intent); full record: INDEX C10 + unification-era.md rulings of record.
- 2026-10-08 REV-88: RULING OF RECORD (2026-10-07/08): Modernization era opens after the unification era's release, with a full investigation pass of the inherited codebase as its opener (unification-era.md post-era queue).
- 2026-10-08 REV-88: Dist hygiene ruled (REV-88 ruleset rider) — dist\archive\ model; one-time cleanup executed same rev (PROJECT_STATE §93).


- [REV-91 2026-10-10] Execute dogfood FAILED (Mode-2: evaluator picked AttackTarget x3, sentinels silent; fix = downed-nudge wording, pending-approvals #6). Em-dash full-surface ASCII sweep SHIPPED as [REV-91] dist (26 user-facing sites, 4 scripts, compile 0/0); checklist v8 full-surface guard added. DeD-Handoff closed (folder gone from disk).

- [2026-10-10 REV-92 - Project working note] Execute lane complete (nudge + 3-level MCM gate + popup; INDEX row 14 fixed-pending-dogfood); DLL ASCII sweep + pose-removal ruled string shipped; register entries 1-4+6 closed, 5+7-10 open; reference sheets created. [REV-92] dist staged, not deployed.

---

## Working note (REV-94, 2026-10-11)

- Execute initiator guard WIDENED (user-approved; lenient initiator, strict target): Acheron-defeated but standing/pacified initiators may now execute; targets stay strict (standing-recovered victim = moot, not a kill). Deployed rev94.
- Execute-gate MCM default = Unlimited (0) USER-CONFIRMED.
- FHU + cum application: heavy rework planned AFTER the de-tangle era, before next release - era extraction keeps module boundaries clean, does not gold-plate internals.
- A/B scuttle (Option A approved): relocate SNAcheron_MCM alias duties to bridge quest 0x800 then tombstone - spec of record in acheron-fold.md; NEXT standalone session; ends at the USER xEdit gate.

## Working note (REV-98b, 2026-10-12)

- Scuttle CANCELLED by ruling (Amendment 3, Option C): manager + alias stay on 0x801 (esp-attached since the REV-62 fold - REV-96 orphaned finding withdrawn); MCM script stubbed; 0x800-as-manager casts retargeted to 0x801; no esp bytes. Execute YAML wording rider shipped (entry 11).

## Working note (REV-99, 2026-10-09)

- INCIDENT: Execute fired mid-active SexLab scene during the J'zargo era-end trial (command "J'zargo, finish Frabbi off. She's served her purpose." -> first pick misrouted to SexLab_Sexual_Assault_Speaker; corrected pick Execute landed at 19:36:57) -> kill on the scene-bound target (Frabbi) -> session crash (null-fp in SeverActionsNative processing Frabbi, crash-2026-10-09-19-36-58). NOTE: logs show the kill landed on the TARGET; no J'zargo death on any log surface - the reported initiator-death is recorded as an evidence conflict (§105).
- SAFETY-DISABLE shipped [REV-99]: execute.yaml enabled: false (one line + 4-line comment; reversible). Wording untouched. Wording trial SUSPENDED pending investigation (register entry 11 annotated).
- Execute lane does NOT inherit the IsEligible mid-scene guard (IsInSexAnimation) - confirmed by code citation (psc L6355-6415 / L7387-7409); YAML guards OStim only. Fix proposals (scene-active guard + kill-time re-resolve + parked-lane wording) are NEXT session's ruling - NO fixes built this session per the stop conditions.

## Working note (REV-100, 2026-10-11)

- §105 fixes BUILT: scene-active guard both layers (executor L6396-6398 + choice-5 L7423-7425 via IsInSexAnimation, both actors; yaml SexLabAnimatingFaction rule beside OStim) + kill-time recheck (L7434-7459, per-reason sentinels, narration after recheck). execute.yaml STAYS enabled: false — the re-enable ruling is the user's. [REV-100] dist shipped (266/266; esps byte-identical to rev99). Dogfood legs: outside scene -> kill; mid-scene -> refusal narration + no crash.
- Archive rider executed: [REV-96]/[REV-98b]/[REV-99] folders + rev96 zip/sidecar moved to dist\archive\; only [REV-100] loose (prior builds left [REV-96]/[REV-98b] loose — under-execution flagged in §106).
- Registered, no build: routing watch item (kill-intent free-pick misroute class; parked wording rider owns it) + downed-loop scene-yield DESIGN QUESTION (era doc).
- Known nit: psc L6535's comment cites register entry 11 for the refusal narration; the actual entry is 12 — comment-only drift, fix at the next psc-touching build (no recompile for a comment).

## Working note (REV-101, 2026-10-11)

- Execute lane CLOSED: execute.yaml enabled: true per user ruling (register 12b); refusal narration = the user-edited 12a wording of record (end-the-fun wording, psc L6541 + baka-module.md REV-101 section). The lane ships EXPERIMENTAL - release-notes label of record: Execute action: experimental - community feedback welcome (registered on the release-prep checklist, era item 9). [REV-101] dist 266/266; manifest delta vs rev100 = 11 pex + psc + execute.yaml only (zero esp/DLL/fomod lines); archive rider executed ([REV-100] -> dist archive). User gates: install at leisure (the guarded REV-100 build is already installed; this adds the enable + the user wording); OPTIONAL dogfood with no expectations (outside scene -> kill; mid-scene -> the refusal with the user's wording); era-end consolidated dogfood unchanged.

## Working note (REV-102, 2026-10-11)

- Baka<->GS boundary investigation COMPLETE (report-only, no builds): the separation plan of record lives in the GS repo era doc, section "Baka<->GS boundary" (full inventory tables in PROJECT_STATE §108). Boundary facts of record: 78 member actions + 3 YAML category defs across ONE content pack; the only cross-side couplings are 2 soft state keys (SNBaka.Locked/OnGround read GS-side, default-0), 1 log-only presence probe, the GS Poses MCM page's home (SNBaka_MCM), and the muse's 27-name dispatch list naming both sides' pose executors; views and DLLs are already cleanly sided. Plan: sessions S1 (content-pack split) -> S2 (busy-state contract) -> S3 (muse dispatch guarding, atomic with S1's prompt move) -> S4 (MCM re-home); esps stay deferred. USER decisions queued (D1-D5): Baka-only installs? GS-only installs? owner of the 15 Babo pose executors? category-def owner (discriminating dogfood test named, era-end)? FOMOD-advertised combos?

## Working note (REV-104, 2026-10-12)

- S1 failed-layers repair SHIPPED: GS pack renamed regalrascal.gs-poses (id+folder per DevKit author.slug rule), acheron layer manifest authored (dead since the REV-62 fold - the Task-2d draft never landed; both acheron triggers now load), 2 tattoo action filename mismatches fixed (ApplyTattoo/RemoveTattoos - settings keys preserved, name: fields untouched). All 5 external layers validate ok=true; 80-action census restored (16 back: 14 GS poses + 2 tattoo). Full receipts: PROJECT_STATE 110, era doc REV-104 section, INDEX row 16. Open user gates: gs-poses id + acheron manifest wording (pending-approvals entry 13); dogfood 5.1(a)-(d).

## Working note (REV-105, 2026-10-13)

- S2 busy-state contract SHIPPED: the Baka motherboard advertises the busy-state service (busy.baka-half, the REV-74 service registry); GS's _IsBusyElsewhere probes it before the SNBaka.Locked/OnGround reads. Zero save migration (key names stay the wire format); Baka-absent = the soft default made explicit. Shared contract now 2-of-3 sessions landed (S1 + S3 done; S4 MCM re-home remains). Dist rule of record: proven-bytes lineage (pex compile is byte-non-deterministic - only source-changed scripts get fresh pex; all else carried [REV-104] bytes). Full receipts: PROJECT_STATE 111, era doc REV-105 section, INDEX row 16. Open user gates: dogfood 5.x sentinels (probe present=True; blocked-by on a busy actor; GS-only present=False).

## Working note (REV-106, 2026-10-13)

- S4a MCM logical re-home SHIPPED (script-only, zero esp bytes): the shared MCM quest severs its compiled Main property - motherboard access resolves at runtime via GetFormFromFile (once per load, sentinel logged), pages are presence-gated (11/10/3/2 combos, order preserved), the leaked unconditional GS Poses page is fixed by a GS-esp probe, 19 PlayerRef/call sites de-Mained, GetVersion bumped to v6 with a rebuild canary. The absent-motherboard state is not physically reachable yet (MCM quest + motherboard quest co-homed in the Baka esp) - S4b (physical quest-record move + GenderPolicy page home GS-side) is the queued esp session. Proven-bytes lineage held: manifest delta vs rev105 = exactly SNBaka_MCM.pex + psc. Full receipts: PROJECT_STATE 112, era doc REV-106 section, INDEX row 16. Open user gates: v6 OnVersionUpdate canary trace; presence-gated page sets per combo; motherboard-resolution + GS-poses-probe sentinels in Papyrus.0.log.

## Working note (REV-107, 2026-10-13)

- S4b physical re-home BUILT (esp session; pending the user xEdit gate + dogfood): DeD_Framework.esp authored (the project's first authored esp, 359 B, masters Skyrim+Update only) and the MCM quest record moved into it (fresh QUST 02000800 EDID `DeD_MCM`); the Baka esp loses QUST 04000D99 (minus-one-record, everything else byte-identical); script renamed SNBaka_MCM -> DeD_MCM with the identity boundary byte-verified (ModName/keys/markers/probe literals unchanged; GetVersion v7 canary). GenderPolicy page home resolved: framework-hosted, GS-content-gated via the S2-probe pattern (already the shipped shape). Boundary plan's build sessions ALL COMPLETE pending gates. Proven-bytes lineage held: delta vs rev106 = exactly 6 rows. Full receipts: PROJECT_STATE 113, era doc REV-107 section, INDEX row 16.

## Working note (REV-107b, 2026-10-13)

- FOMOD manifest parity fix SHIPPED: the wizard's ModuleConfig install set now carries all four root esps — DeD_Framework.esp was present in the [REV-107] zip but silently dropped by the wizard (the install set was authored at REV-68 with three esps; user-reported at reinstall; confirming trace = the REV-104 wizard-consumption evidence). Full manifest-vs-tree parity audit receipts: 4/4 root files enumerated, all 264 nested files proven under the six folder patterns (external layers ride SKSE/; fomod/ itself is wizard-consumed, never installed), zero pattern-uncoverable files. Checklist v10 FOMOD PARITY rider added (both ruleset copies; count stays 10). Dist [REV-107b]: delta vs rev107 = fomod/ModuleConfig.xml ONLY — all esp/DLL bytes identical; zip `B1EADCB2284C07C0…` (324 entries, 6,705,748 B); manifest-rev107b; [REV-107] archived (zip hash re-verified vs sidecar pre-move). Proof-of-fix = the user's reinstall (gate 4.1): DeD_Framework.esp must appear in the MO2 plugins list — MO2's wizard is not headless-simulable; then the REV-107 gates as issued (xEdit -> install -> dogfood). Full receipts: PROJECT_STATE 114, INDEX row 16.

