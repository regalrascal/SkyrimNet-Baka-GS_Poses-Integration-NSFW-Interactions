# Delectatio et Dominium — v0.3.0-alpha

**The first full release, in an honest alpha state.** Every module is in and has been
tested in-house to the extent possible — but alpha means alpha, and the release is
looking to the community for help: test the features, give feedback, and share your
SkyrimNet logs to help diagnose issues. This
release closes the arc that started with v0.1.0: the background-daemon era, the Cum /
FHU / SlaveTats v2 systems, the prompt layer, the pose-picker retirement, the module
independence audit, and the full story-voice pass are all in.

## Highlights

- **The daemon era** — Mephala and Molag Bal modes let dominant NPCs escalate on their
  own initiative, on cadences you set. The pose daemon (Sanguine Mode) picks both the pose and the exact
  move in one consideration pass.
- **Cum v2, FHU v2, SlaveTats v2** — full applied-cum awareness (appliance authority,
  decal source, ambient follow-ups, aftermath disposition), fully narrated Fill Her Up
  inflation (ambient narration on by default, OStim self-drive), and Force Tattoo LLM
  lanes with ambient exposure rolls.
- **A new service DLL** — a central, save-safe state store and scheduler behind every
  module.
- **The story-voice pass** — every cue narrates in-story: what happens, as it happens.
- **Independence** — every module is presence-gated and independently removable; any
  combination works.
- **Safety** — an absolute child boundary; the Execute action ships experimental behind a
  configurable ask-first gate.

## Honest state

- **This is an alpha.** Everything has been built and tested in-house to the extent one
  person can, but expect rough edges, bugs, and unbalanced moments. What helps most:
  test the features, report what breaks or feels wrong, and share your SkyrimNet logs
  when something misbehaves — they make diagnosis possible.
- The **Execute action** is experimental and labeled as such in-game; it can be disabled
  entirely in the MCM.
- SE 1.5.97 and AE 1.6.x are verified in-house; the 1.7.104 runtime with SKSE 2.3.1 is
  expected to work via the Address-Library architecture but is not verified in-house.

## Credits

- **Around906** — original author of the sections this project builds on, credited first
  and prominently; this project would not exist without his mods and his generosity.
- **Gunslicer** — the GSPoses animation pack.
- **Oldcustard** — the creature-struggle fix batch and the Execute mention phrasing (PR #2).
- The SkyrimNet project, and the CommonLibSSE-NG / CommonLibVR contributors.

*Release notes draft — pending project-owner review before the release goes live.*

*Asset: the `[REV-165] Delectatio-et-Dominium v0.3.0-alpha` dist zip (SHA256 recorded in
the session report).*
