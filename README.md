<p align="center">
  <img src="logo.png" alt="SkyrimNet Baka Integration + Animations GS" width="640">
</p>

<h1 align="center">SkyrimNet Baka Integration + Animations GS — NSFW Interactions</h1>

<p align="center">
  <em>LLM-driven physical &amp; intimate interactions and facial expressions for
  <a href="https://goncalo22.github.io/SkyrimNet-GamePlugin/Installation%20Guide/skyrimnet-installation/">SkyrimNet</a>.</em>
</p>

> ⚠️ **Adult content (18+).** This addon adds non-consensual / NSFW interactions. Use responsibly.

---

## What it does

This is a unified addon for **SkyrimNet** — it consolidates the Baka Integration and
Animations GS mods into a single deploy tree, combining **paired interaction scenes**
(spanking, groping, kissing, fondling, capture, slavery, creature escalation, struggle QTE)
with **a full solo-pose system** (19 high-quality GS animations — seductive, dance, workout,
submission, idle, stretch, and more — on both the player and nearby NPCs).

The AI driving your NPCs can choose, in context, to perform physical and intimate actions
and react with facial expressions during roleplay. It hooks into SkyrimNet through custom
**actions, triggers, and decorators**. Key features across both mods:

**Paired interactions (Baka Integration):**
- Affectionate / forced / sexual actions through the **Interact power** — targeted at any
  NPC, a downed victim, a hostile creature, or yourself during a sex scene
- Escalation system: NPCs can escalate from groping to full scenes; victims can resist,
  struggle, submit, or call for help
- Capture, tie-up, slavery, creature escalation, and a full MCM for toggles and tuning

**Solo posing (Animations GS):**
- **Player pose grid** — a PrismaUI panel that pauses the game, lets you browse 19 pose
  categories (each with multiple variants) on a scrollable grid, and fires the chosen
  animation on yourself or any crosshair-targeted NPC
- **LLM-driven NPC posing** — the AI puts nearby female NPCs into mood-fitting solo poses
  contextually (seductive, dancing, submissive, hard-working, playful, etc.) through the
  **Muse** background daemon, with **Overdrive Mode** to double the rate
- **Crosshair targeting** — cast the GS Pose Selector at any NPC to pose them instead of
  yourself; refusal feedback if the target can't comply
- An **LLM consideration prompt** grounds every pose in the current scene context, NPC
  personality, and room tone — no canned seeds, every pose is context-aware

**Shared across both:**
- A **unified 27-pose-action YAML category** (`SNGS_Pose`) that the LLM sees as one flat
  pose list — no distinction between which mod provides which pose animation
- Both halves are fully **writable- and game-scoped** — all YAML config is in a single
  deploy tree; no dual-file setup needed

*(add screenshots / a short demo clip here)*

## What to expect

Once everything is installed, your NPCs can — when it fits the scene and their personality —
**start or be drawn into these interactions on their own**, decided by SkyrimNet's model rather than
menus or hotkeys. Expect *emergent, unscripted* moments: a dominant NPC spanking someone bent over a
table, a captor escalating on a defeated victim, faces shifting to fear or pain in the moment, or
characters striking fitting body language while they speak — **and**: an innkeeper leaning idle against
a wall after closing, a bard spontaneously dancing at the tavern, a warrior striking a victorious pose
after winning a brawl, a nervous courtier fidgeting during a tense conversation.

- It is **player- and NPC-targetable** and leans **dark / non-consensual** by design in the paired
  interaction half; the solo-posing half is neutral/atmospheric and works with any roleplay tone.
  Both follow the characters and context you set.
- Nothing fires at random — give characters fitting personalities and the LLM drives the rest. Master
  toggles, an intensity slider, and **the Muse on/off toggle** let you dial both halves back.
- It needs several frameworks and **the GSPoses animation pack by Gunslicer** (see **Requirements**) —
  without them, the relevant pieces simply do nothing rather than break.

## How it works

### The Interact power

Everything the LLM can do on its own, you can also trigger yourself with the **Interact power** — a
lesser power added to your spell list automatically once the mod is set up. It's aimed like any other
power or shout:

- Point your crosshair at an NPC and cast it — a PrismaUI menu opens with **Affectionate / Forced /
  Sexual** categories to pick an action from.
- Aim it at someone **downed or bleeding out** instead, and you get a different menu — Escalate, Help
  Up, Tie Up, Execute, Release, and so on.
- Cast it **during your own sex scene** (no target needed) to open a spank menu for your partner(s).
- Aim it at a **supported hostile creature** and, if creature escalation is enabled, it attempts to pin
  the nearest valid victim directly instead of opening a menu.
- A target already locked in another interaction or mid-scene is refused outright — the power won't
  interrupt something already running.

Think of it as the deliberate, player-driven half of the mod; the LLM-driven half is the same set of
actions chosen contextually by SkyrimNet's model during roleplay.

### The Muse & Overdrive Mode (Animations GS)

**The Muse** is a background daemon (toggled from the PrismaUI grid footer). Every ~30 seconds it
considers ONE nearby NPC, picks a fitting pose from the 19-pose gender-split vocabulary via an
LLM consideration prompt (fed current scene context, NPC personality, and room tone), fires the
pose directly, and seeds the justification thought. It tries to fire every time it finds someone
free to pose — guards skip legitimately (sleeping, swimming, mounted, sneaking, busy, already
posing), and a 60-second per-NPC floor prevents repeating the same actor too soon. Overdrive
preempts the Muse while active.

**Overdrive Mode** (the button next to the Muse in the grid footer) raises the ambient intensity:
short-lived ambience cues fire at T1 cadence, solo-pose cooldowns drop to a 10s floor, and the
daemon polls at a faster rate. Overdrive auto-expires after ~5 minutes (combat pauses the clock).
It preempts the Muse while running; the Muse resumes automatically when Overdrive ends.

Both are entirely optional — leave both off and the baseline is total silence, with nothing firing
except what the LLM drives through standard actions.

### The GS Anim Menu (pose selector grid)

Open the **GS Pose Selector** from your Powers menu — a PrismaUI grid of 27 solo poses (12 GS
performative, 15 Baka deliberate/reactive). Click one to pose yourself, or **point your crosshair
at an NPC before casting** to pose **that NPC** instead (refusal feedback if the target can't
comply — dead, male-only-poses, or already busy). A **Stop Pose** button in the grid footer ends
the current pose of your targeted NPC.

While a pose is active, **pressing any movement key (WASD / jump / sprint / sneak) ends it**
immediately. NPC-posed characters are pacified during their pose; **starting combat frees them**
instantly, and every pose auto-ends after ~30 seconds as a safety cap. The LLM (or another
character via dialogue) can tell a posing NPC to **stop** through the `command_stop_pose` action,
and the NPC herself can decide to stop mid-pose if context changes.

The **Muse toggle** and **Overdrive Mode** button live in the same grid footer. Open the grid,
click once, and the daemon runs in the background until you turn it off or the conditions change.
In-panel **size control** lets you scale the grid window up/down, like the Baka interaction menu.

### MCM options

Settings are split across six pages:

- **General** — master enable, whether the player can be targeted, target-sex filter, animated tears,
  AI action cooldown; a **Capture** section (Sell to Slavery, Follower Enslavement, and the
  player-distance gate for it); and an emergency **panic reset** for stuck actor states.
- **Timing** — how long each paired animation loop/stage holds (hug, molest, kiss, touch, sequence
  stages).
- **Resist** — the struggle QTE (on/off, escape difficulty), NPC-vs-NPC auto-rolled struggles (escape
  chance, stage duration, post-escape grace), and the fallback defeat window/QTE difficulty.
- **Spank** — behaviour toggles (player can be spanked, male targets, furniture reactions) and
  tattoo-mark pacing (spanks per stage, hours per stage).
- **Scenes & FX** — sex framework selector (Auto/SexLab/OStim); facial expressions (on/off +
  intensity); the whole **Creatures** block (master toggle, can-target-the-player, mid-combat,
  escalate-on-hit chance, escalate-to-sex, LLM-gated escalations, victim-sex filter, framework,
  success chance, group size, and more); corner notifications and debug logging; and the humanoid
  mid-combat escalate-on-hit settings.
- **Plugins** — toggles for optional third-party integrations, each auto-greyed-out when the
  corresponding mod isn't installed.

## Features

- **Physical interactions** the LLM picks contextually:
  - Spanking — butt / face / breast slaps, with accumulating skin marks &amp; tattoos, impact sounds, and reactions
  - Grab hold, choke hold, struggle — paired animations with a resist QTE
  - Drug-food &amp; drunk exploit (incapacitate), womb hit
  - Forced kiss, fondle, touch / suck breasts, oral, examine / inspect
- **Solo poses** — 27 solo body poses across 13 categories, LLM- or player-directed:
  - **GS performative** (12): Dance, DanceSexy, GroundIdle, GroundSexy, Idle, Plead, Present,
    Seduce, SelfTouch, Stretch, Submission, Workout
  - **Baka deliberate/reactive** (15): the companion mod's pose set
  - All 27 share the composite `SNGS_Pose` category for unified LLM intent selection
- **Escalation → SexLab or OStim** aggressive scenes, with defeat / bleedout &amp; recovery
- **Creature encounters (opt-in, OFF by default)** — supported creature types (falmer, draugr,
  giants, wolves, rieklings, spiders, chaurus, trolls…) can pin a victim in a paired struggle QTE
  and, on a win, claim them in a scene:
  - Proximity attempts on **downed** victims every few seconds, plus optional **on-hit mid-combat
    grapples** (own toggle + chance slider) for followers and the player
  - **Struggle vs escalate split** — "Escalate to Sex After Win" OFF gives pure predator struggles:
    a beast mauling its prey, no scene ever starts, no adult creature animation packs needed
  - **Group scenes** — up to two same-type companions join (3v1 / 2v1), automatically falling back
    3 → 2 → pair until your animation library actually has a scene for that size and creature type
  - Optional **LLM gate** — SkyrimNet's model answers a strict yes/no ("should this escalation
    happen right now?") before any downed-victim claim; pacing control by the narrator itself
- **Downed = vanilla mortality + executions** — no artificial invulnerability while defeated: any
  weapon-delivered hit (melee, **fists**, **arrows/bolts** — never spells or stray magic) on a
  defeated actor is a killing blow. Essential/protected actors survive it; victims mid-struggle or
  mid-scene are untouchable, and every exit carries a short post-escape mercy window so nobody gets
  spawn-killed the frame protection drops. An **Execute** action (menu button + LLM-callable) gives a
  guaranteed finishing blow that doesn't depend on a weapon hit actually landing and registering.
- **Tied prisoners** — bind a defeated victim (**TieUp**) instead of resolving them immediately: they
  stay down for an MCM-configured number of game hours (default 12), can't struggle free or
  auto-recover while bound, and can still be escalated on and returned to their bound pose
  afterward. **Untie** cuts them loose to a normal down; **HelpUp** does both at once. Bindings also
  loosen on their own once the timer runs out.
- **Facial expressions** — happy / angry / afraid / sad / pained / surprised / confused
  - LLM-triggerable *and* automatic in-scene (fear in a struggle, pain on a choke / bleedout, sadness while crying)
  - Adjustable intensity
- **Reactions** — animated tears, face / tear overlays that survive sex scenes, cover-self after a spank
- **PrismaUI menus** for choosing interactions and setting up encounters
- **Paired-animation physics fix** — both actors' Havok bumper capsules shrink to 5% of vanilla for
  the duration of any paired animation (exact radii cached per actor and restored afterward, never a
  shrink-of-a-shrink), so partners stop physically shoving each other out of alignment mid-pose

## Compatibility

Skyrim **SE (1.5.97)**, **AE (1.6.x)**, and **VR**. The SKSE plugin is built with
**CommonLibSSE-NG / CommonLibVR**, so a single `SkyrimNet_BakaIntegration.dll` runs on all three
runtimes. (VR additionally needs SkyrimNet and PrismaUI themselves to work in VR.)

## Requirements

### Hard (must have)
- [SkyrimNet](https://goncalo22.github.io/SkyrimNet-GamePlugin/Installation%20Guide/skyrimnet-installation/) (+ SKSE64, [Address Library](https://www.nexusmods.com/skyrimspecialedition/mods/32444))
- [PrismaUI](https://www.nexusmods.com/skyrimspecialedition/mods/148718)
- [PapyrusUtil](https://www.nexusmods.com/skyrimspecialedition/mods/13048), [MfgFix](https://www.nexusmods.com/skyrimspecialedition/mods/11669), [powerofthree's Papyrus Extender](https://www.nexusmods.com/skyrimspecialedition/mods/22854)
- [SlaveTatsNG](https://www.loverslab.com/files/file/35989-slavetatsng/) (or classic [SlaveTats](https://www.loverslab.com/files/file/619-slavetats/)) — for spank marks &amp; the sex-tear overlay. This mod bundles the `blank.dds` clear-texture, so SlaveTatsNG works without the old SlaveTats SE installed.
- **A sex framework for escalation scenes — SexLab _or_ [OStim Standalone (OStim SA)](https://www.nexusmods.com/skyrimspecialedition/mods/98163).** Pick it in the MCM (Auto uses whichever is installed). Neither is a hard requirement; without one, escalation just won't start a scene.
- [Emotional Tears Effect (EmoTears)](https://www.nexusmods.com/skyrimspecialedition/mods/122296) — for animated tears
- [Baka Motion Data Pack](https://www.loverslab.com/files/file/26992-baka-motion-data-pack/) — the paired interaction animations; build with **FNIS / Nemesis / Pandora**
- [GSPoses](https://www.loverslab.com/files/file/28221-gsposes/) — the 12 GS solo pose animations; also required by Animations GS

### Soft (strongly recommended)
- [Flash Games – Struggling QTE](https://www.nexusmods.com/skyrimspecialedition/mods/121909) — blocking-based QTE for grab/choke holds
- [Dynamic Feminine Female Modesty Animations OAR](https://www.nexusmods.com/skyrimspecialedition/mods/104374) — cover-self reaction (this mod doesn't bundle animations)
- [Additional Expressions Project](https://www.nexusmods.com/skyrimspecialedition/mods/72337) — facial-expression morph values (the values are baked in; the mod itself isn't required at runtime)
- [SeverActions – SkyrimNet Action Pack](https://www.loverslab.com/files/file/34312-severactions-skyrimnet-action-pack/) — enriches the LLM's downed/capture options (cease fighting, adjust relationship, take prisoner/arrest, ransom, dismiss/recruit). Baka downed cues invite these outcomes, so they "just work."

### Flavor (optional, each degrades gracefully if absent)
- [OCreatures Revived](https://www.loverslab.com/files/file/49059-ocreatures-revived/) — needed for the creature escalation feature to actually produce a scene. Without it, creature escalation can still trigger narratively but the scene may not work correctly. You also need creature animation packs (e.g. Billyy's, Anub's) covering each creature type.
- **Escalate to Sex After Win — male-victim coverage (SexLab P+ users).** When a male NPC ends up the victim at the escalation handoff, the mod applies a temporary SexLab `TreatAsFemale` override at handoff (rolled back at scene end) so female-authored aggressive scenes match. On **P+ (SexLab Framework PPLUS)** this works out of the box. On base SexLab (no P+) the override is skipped as inert. Optional coverage enhancement for P+ users: installing an animation pack that marks male-eligibility in its animation definitions widens the scene pool.
- [Simple Slavery Plus Plus (SS++)](https://www.loverslab.com/files/file/13674-simple-slavery-plus-plus/) — required for the `SellToSlavery` action (targets the defeated **player** only)
- [Follower Slavery Mod (FSM)](https://www.loverslab.com/files/file/30956-follower-slavery-mod-/) — required for the `EnslaveFollower` action (OFF by default in MCM)
- [SkyrimNet Acheron Integration](https://github.com/Around906/SkyrimNet-Acheron-Integration) — optional companion that coordinates defeat/recovery states. Works fully standalone without it.
## Installation

**Single-mod install.** This fork ships both mods' assets in one deploy tree. If you were running
the original Baka Integration and Animations GS separately, remove them first — the fork replaces
both.

1. **Install requirements** (see above).
2. Install the mod the same way as any Skyrim mod — MO2 / Vortex manual drop or mod-manager
   install. The archive deploys into `SKSE/Plugins/`, `SKSE/`, `Scripts/`, and `SL_AnimationJob/`.
3. Run **Pandora / FNIS / Nemesis** so paired animations register.
4. Launch the game, load your save, and wait for SkyrimNet to pick up the new actions (or reload
   its config from the in-game dashboard). The mod's MCM should appear once.
5. **(One-time, only if updating from a pre-fork install)** Open the SkyrimNet dashboard and
   **disable the `SNBaka_Pose` category** — the DLL-registered category is now empty; all 27 pose
   actions use the composite YAML `SNGS_Pose` category instead. The old category header will sit
   empty in the dashboard with nothing in it — hiding it cleans up the list.

### Notes
- The archive is the **release set only** — source code (`dll-source/`, `dll-source-gs/`,
  `Scripts/Source/`) is available from the repository but **not included** in the zip.
- `docs/`, `release/`, and `tools/compile/` are internal directories, excluded from the release
  archive.
- After updating, **reload SkyrimNet's config** (or restart) so new/changed actions are picked up.
- Faces feel too strong or too flat? Adjust **`fExpressionIntensity`** (0.0–1.0) in the MCM.
- Actions are chosen by SkyrimNet's model **in context** — give your characters fitting
  personalities and dispositions. The action descriptions tell the model *when* each one fits.

## Building from source

Papyrus scripts for both mods are in `Scripts/Source/` (`SkyrimNet_Baka*.psc`, `SNBakaUI.psc`,
`_ANIMGS_AnimQuestScript.psc`, `SkyrimNet_AnimationsGS.psc`, etc.) — shared so anyone can read,
fork, or improve the logic. To **recompile** them you also need minimal compile stubs for the
dependency APIs (SkyrimNet, SexLab, OStim `OThread`, `MfgConsoleFunc`, po3, `SKI_ConfigBase`, etc.)
on the compiler import path; those aren't bundled here since they belong to their respective mods.
Point the Papyrus compiler at this `Scripts/Source/` folder **plus** the dependency mods' script
sources.

The C++ source for the two DLLs is published in:
- `dll-source/` — `SkyrimNet_BakaIntegration.dll` (CommonLibSSE-NG / CommonLibVR project; see
  [`dll-source/BUILD.md`](dll-source/BUILD.md))
- `dll-source-gs/` — `SNAnimGS_UI.dll` (CommonLibSSE-NG project)

Both are there for transparency and forking; both are **excluded from the release archive** (end
users only need the prebuilt DLLs). CommonLibVR is vendored as a git submodule in the Baka project,
so clone with `--recurse-submodules`.

## Credits

This is a unified fork consolidating two upstream mods. Upstream authors and contributors:

- **SkyrimNet** — the framework everything builds on
- **Animations GS** ([Gorgonian](https://www.loverslab.com/profile/6566656-gorgonian/)) — solo poses,
  the Muse daemon, Overdrive Mode, the GS Anim Menu grid, SNAnimGS_UI, YAML rewrites, prompts
- **Baka Integration** ([BakaFactory](https://www.loverslab.com/profile/815319-bakafactory/) + 
  community) — paired interactions, MCM, creature escalation, struggle QTE, slavery, capture
- Paired interaction animations — *Babo / SLAP* animation authors
- Cover-self reaction — driven by the *Dynamic Feminine Female Modesty Animations OAR* mod
  (Kahvipannu84 / Gunslicer); install it for that feature (no animations are bundled here)
- Facial-expression morph values — [Additional Expressions Project](https://www.nexusmods.com/skyrimspecialedition/mods/72337)
  (optional; the values are baked in, so it isn't required at runtime)
- Frameworks — SexLab, PrismaUI, PapyrusUtil, MfgFix, po3 Papyrus Extender, SlaveTats, EmoTears4NPCs
- CommonLibSSE-NG / CommonLibVR migration (single SE/AE/VR build) — **langfod**

> Bundled third-party animations/assets remain the property of their original authors and are
> included per their permissions. If you are an author and want something removed, open an issue.

## Links

- Repository: [GitHub](https://github.com/YOUR_USER/SkyrimNet-Baka-GS-_Poses-Integration-NSFW-Interactions)
- SkyrimNet: [Installation Guide](https://goncalo22.github.io/SkyrimNet-GamePlugin/Installation%20Guide/skyrimnet-installation/)
