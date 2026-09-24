# Changelog

## v0.1.0-alpha — 2026-09-24: unified fork consolidation (rev-49)

**Consolidates** the SkyrimNet Baka Integration + Animations GS codebases into a
single deploy tree. This is the first alpha release of the unified fork.

### Merges
- `gs/gs-muse-redesign` (66 commits) — GS Animations v1.x lineage (Muse redesign,
  pose selector grid, crosshair posing, 27 YAML rewrites, Overdrive Mode, prompts,
  PrismaUI GSAnim_Menu view, `SkyrimNet_AnimationsGS.esp`, `SNAnimGS_UI.dll`)
- `baka/main` (53 commits) — Baka Integration v2.x lineage post-v2.0.7 (integration
  script pipeline, L2 victim gating, lock-race fix, matching-preference insertion,
  Phase 6a `_SexOf` leveledsexfix port, `SkyrimNet_BakaIntegration.dll`)

### New (fork-only)
- Unified README — single-mod install, consolidated requirements, unified credits
- Writable collection-scope config (no more dual-tree YAML deploy)
- **Overdrive Mode** (renamed from Performance Mode): button, footer, and all
  notification strings use the new name throughout. Internal identifiers
  (`GSAnim.Overdrive`, `_Overdrive*`, `OVERDRIVE_TOGGLE`) unchanged.

### Source availability
- **dll-source/** — `SkyrimNet_BakaIntegration.dll` (CommonLibSSE-NG/VR)
- **dll-source-gs/** — `SNAnimGS_UI.dll` (CommonLibSSE-NG)
- **Scripts/Source/** — all Papyrus scripts for both mods

### Notes
- This is an **internal consolidation release** — the Build Patch remains the live
  deploy target until dogfood verification completes.
- `docs/`, `release/`, and `tools/compile/` are internal-only directories, excluded
  from the release archive.

## v1.2.0 (Muse redesign — the context-pull nudge loop)

**Changed:** the muse is no longer a canned seed pool — every thought is derived from a
live LLM consideration call (one per ~100s while ON; YES-biased: a miss only when all 27
pose categories are unsuited to the pulled context). The call returns WHICH pose fits +
the grounded in-world thought; the thought is seeded via the NPC's inner voice and the
pose fires through her own action selection. Guards are actor-local (not in combat /
mid-animation / busy — checked at selection and again at seed time) and the muse keeps
ticking during player combat. **Removed:** the always-on `gsanim_muse_ambience` trigger
(the tone-blind "room hums easy tonight" artifact class — the baseline is now total
silence with both toggles off) and the desire/restraint-slip seed pool. **New:** the
`gsanim_muse_consideration.prompt` template (grounds every nudge in the pulled context).
Overdrive Mode is unchanged.

## v1.1.0 (Phases 2–4f — crosshair posing, 27 description rewrites, muse daemon + Performance Mode)

**New:** cast the GS Pose Selector power with an NPC under the crosshair and your grid
pick poses THAT NPC instead of you. Cast with nothing/yourself targeted and the pick
poses the player exactly as before — the player path is untouched.

- Target captured at cast time (`Game.GetCurrentCrosshairRef()` in `OpenSelector`) — the
  cursor is free while the grid is open, so the crosshair can't be read at pick time.
- On pick, the target is validated in order: not-player → not-dead → female →
  `_IsBusyElsewhere`. Refusals show a short in-game notification ("X can't pose: dead." /
  "female poses only." / "can't pose right now."). It NEVER falls back to posing the
  player when a target was captured, and the pending target is cleared on every exit
  path (pick, refusal, cancel).
- `_PoseDirect` mirrors `_PoseVibe` (restrain, pacify, anim event, `GSAnim.*` keys,
  posing list, 3s monitor) but plays the explicit chosen event with `LockAI = 0`; the
  SkyrimNet event `gsanim_npc_pose` is worded player-directed ("X strikes a pose — … at
  Player's direction.").
- The grid now sends `event|description|category` (`_choose` in index.html). Papyrus
  parses the third field and times NPC-directed poses with the category's vibe timeout
  (`workout`/`stretch`/`dance`/`dance_sexy` = 45s active, everything else 25s; unknown
  or missing category = default). Player-only categories (`explicit`, `situational`)
  simply fall to the default timeout. Player poses ignore the field entirely.
- **Stop Pose button** in the grid footer (revised design — a "stop on cancel" branch was
  rejected for accidental-stop risk; plain Cancel/Esc is deliberately inert and never ends a
  pose). Click it with a posing NPC targeted: her pose ends via the existing `_StopActorPose`
  machinery only (no parallel stop path; the shared `GSAnim.Posing` list entry is left for the
  3s monitor sweep, so other posers are untouched), plus an in-game notification and a
  `gsanim_npc_pose` SkyrimNet event ("Player gestures for X to stop posing; X relaxes out of
  the pose."). Targeted but not posing → "X isn't posing."; no target → "No one targeted."
- Strictly additive: no DLL changes; the grid keeps working regardless of target.

**Phase 3 — the 27 description rewrites:** all pose action descriptions (12 GS + 15
Baka, the latter in the Baka repo) rewritten off shared boilerplate onto vivid
front-loaded one-liners with concrete WHEN cues ("pairs naturally with a line of
dialogue"); three-family taxonomy (GS performative / Baka deliberate / Baka reactive);
OVERRIDING CIRCUMSTANCES blocks on the five GS performative sensual poses only;
women-only restrictions preserved (Baka drink/food front-loaded FEMALE ONLY); no
futanari-narrative anywhere (decision of record — base-sex gates make the text moot).

**Phase 4 — muse daemon + Performance Mode + event-desc rider:** one shared daemon
loop (OnUpdate) driving the muse thought-seeder (`GSAnim.Muse`, defaults OFF, footer
toggle; GenerateNPCThought desire/restraint-slip seeds, ≥2 min global / ≥5 min per-NPC
throttles) and Performance Mode (`GSAnim.Overdrive`, footer toggle, ~5 min,
combat-suspended: T1 ~20s scene-context ambience cues, T2 10s cooldown floor across all
27 pose actions, T3 ≥40s silence-floor auto-pose — solo-safe GS vibes only, strict
guard chain); event-desc rider on all `gsanim_npc_pose` registrations; one-shot muse
debug window (4c); `_EnsurePools()` lazy-init heal for pre-Phase-4 saves (4d — the A5
save-lifecycle defect: pools restored as None with zero log warnings); automatic
debug-window re-arm (4e); 4f fix pair (muse ambience trigger: the Jinja random pool
never rendered — raw template injected verbatim — replaced with a static line; T2
zero-cooldown → 10s floor, user taste call). All `Debug.Notification` strings are pure
ASCII (Skyrim's vanilla UI font renders non-ASCII as garbage glyphs); trace strings may
keep rich characters. Gate closed 2026-09-11 on an instrumented re-test (3 muse seeds
in throttle bands + healthy heartbeat, 6 T3 auto-poses at ~1–2.5 min cadence, T2 floor
holding, zero trigger-manager errors, zero new template contamination).

## v1.0.5

**New:** the shared pose category is now defined by THIS mod (`cat_sngs_pose.yaml`, internal id
`SNGS_Pose`) instead of borrowed from Baka Integration's DLL-registered `SNBaka_Pose`. All 12 pose
actions here repoint to it, and Baka Integration's own 15 pose actions repoint to it as well (in its
repo) — the LLM still sees one flat pose list, now 27 actions across both mods.

Why: the DLL category's description is locked in compiled C++ and is WHAT-only. The YAML category
gives us control of the intent-selection text — concrete WHEN cues (music, victory, flirt, dare,
compliment, boredom...) that drive retrieval — plus a functional combat-skip line, since a YAML
category has no built-in combat gate (the DLL one did).

After deployment, disable the now-empty `SNBaka_Pose` category once via the SkyrimNet dashboard —
the DLL registration coexists harmlessly but should be turned off so it doesn't render as a dead
header. Revert path: repoint YAMLs back to `SNBaka_Pose` and re-enable it in the dashboard.

Standalone note: the poses no longer require Baka Integration at all for category grouping — this
mod now owns the category definition.

## v1.0.3

**New:** all 12 pose actions (Dance, DanceSexy, GroundIdle, GroundSexy, Idle, Plead, Present,
Seduce, SelfTouch, Stretch, Submission, Workout) now set `customCategory: SNBaka_Pose`, joining the
same SkyrimNet action category Baka Integration's own solo-pose action uses. One shared category
covering both mods' "hold a solo body pose" concept — the LLM sees a single flat list of pose
options regardless of which mod's animation backend actually plays a given one.

Requires Baka Integration to actually register `SNBaka_Pose` (as of its own v2.0.2) for these
actions to render inside a named category — this mod keeps working standalone without it, but the
12 poses will show up uncategorized rather than grouped until Baka Integration (or another mod) is
present to define it.

## v1.0.2

**Fixed:** poses could still fire on an actor who was mid-scene elsewhere — breaking sex scenes,
downed/bleedout states, and Baka Integration struggles.

The `is_busy` eligibility gate added in v1.0.1 only checks state at the moment the LLM *decides* to
pose someone; it can't see the actor becoming busy in the gap between that decision and the pose
actually executing. That gap was the actual cause of the reported breakage.

Added an exec-side backstop (`_IsBusyElsewhere`), checked immediately before every pose fires — for
both the player's manual pose and LLM-driven NPC vibes — covering:
- A Baka Integration paired animation, struggle, or downed/ground-window state
- An Acheron Integration hold, even with no Baka involved
- Any vanilla bleedout, regardless of what caused it (SeverActions, plain combat, Acheron, Baka)
- A SexLab or OStim scene that didn't go through Baka at all

All checks are soft (plain StorageUtil keys or factions resolved by FormID) — nothing here requires
Baka or Acheron to be installed; this mod keeps working standalone with all of it defaulting to "not
busy."

## v1.0.1

Added `is_busy == false` to every pose action's eligibility gate (already blocked posing in combat
or in the SexLab/OStim animating factions), so the LLM stops offering a pose to an NPC who's mid-scene,
in furniture, in dialogue, or otherwise occupied — at decision time.

## v1.0.0

Per-category NPC pose hard-stop timing: 45s for workout/stretch/dance, 25s for everything else
(previously a single flat timeout for every vibe).
