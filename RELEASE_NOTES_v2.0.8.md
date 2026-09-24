## v2.0.8 — GS-build scope edits: shared pose category, SexLab pose gate, pose description rewrites

*Companion release to **SkyrimNet AnimationsGS v1.1.0** — the two ship together. The
`SNGS_Pose` category definition itself lives in that mod (or its build patch).*

## Changed: the 15 solo pose actions now point at SNGS_Pose

`PoseAroused`, `PoseAutograph`, `PoseBraceArm`, `PoseCrouch`, `PoseDogeza`,
`PoseDrink`, `PoseDrool`, `PoseFood`, `PoseHandOnChin`, `PoseHandOnFace`, `PoseKneel`,
`PoseMeditate`, `PosePickpocket`, `PoseSleep`, `PoseScratchHead` — all repointed from
the DLL-registered `SNBaka_Pose` category to the YAML-defined `SNGS_Pose` category
owned by SkyrimNet AnimationsGS. One shared category now covers both mods' 27 pose
actions ("hold a solo body pose"), and its intent-selection text (concrete WHEN cues:
music, victory, flirt, dare, compliment, boredom...) is editable in YAML without
touching this mod's DLL.

Standalone behavior: without a mod defining `SNGS_Pose`, the 15 actions simply render
outside a named category (they keep working; the DLL's own `SNBaka_Pose` registration
coexists harmlessly). When the companion is installed, disable the now-empty
`SNBaka_Pose` category once via the SkyrimNet dashboard so it doesn't render as a dead
header. Revert path: repoint the YAMLs back to `SNBaka_Pose` and re-enable it in the
dashboard.

## Changed: SexLabAnimatingFaction gate on all 15 pose actions

A `SexLabAnimatingFaction == false` eligibility rule appended alongside the existing
OStim faction gate — both-framework coverage (a mid-scene actor in either framework is
now excluded at decision time), matching the GS pose files' rule-set intent.

## Changed: pose descriptions rewritten (GS-build Phase 3)

All 15 descriptions rewritten off shared boilerplate onto vivid front-loaded
one-liners with concrete WHEN cues and a "pairs naturally with a line of dialogue"
hook; three-family taxonomy across the 27 (Baka REACTIVE — aroused/drool/bracearm/
handonface/scratchhead, things that happen TO you; Baka DELIBERATE — the other ten,
functional plain register; GS PERFORMATIVE — the 12 GS poses). Women-only restrictions
preserved where they already lived (Drink/Food: FEMALE ONLY front-loaded — those two
are description-text-only restrictions by design, per the GS build's Phase 3 gate
report). No OVERRIDING CIRCUMSTANCES blocks on Baka actions (deliberate scope: the
five GS performative sensual poses only).

## Notes

- No DLL, PEX, ESP, or animation changes in this release — YAML-only.
- Restart Skyrim once (or reload SkyrimNet's config) so the repointed categories and
  gates are picked up.
- Full phase records: `docs/PHASE1_GATE_REPORT.md`–`PHASE4_GATE_REPORT.md` in the
  SkyrimNet-Animations-GS workspace repo.