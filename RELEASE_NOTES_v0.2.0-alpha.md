# v0.2.0-alpha — Beta 25 Plugin Migration

This release migrates the mod's content to SkyrimNet **Beta 25's** new
plugin format. Features and behavior are unchanged from v0.1.0-alpha —
this is a delivery-layer migration.

## What changed

- All SkyrimNet content (78 actions, 15 triggers, 6 prompts) now ships as
  a proper plugin (`regalrascal.baka-gs-integration`) in the new
  external-layer location. SkyrimNet lists it under **Installed Plugins**
  with an External badge.
- 70 action files were renamed to satisfy Beta 25's filename rule. The
  in-game action names are unchanged, and per-action enable/cooldown
  settings are keyed by action name — **your toggles carry over**
  (confirmed against live config/Actions.yaml storage).
- The old loose-file layout is retired (Beta 25 ignores it anyway).

## Requirements change

- **SkyrimNet Beta 25 (0.25.x) or newer is now required.** On older
  builds, the mod's content is silently ignored (scripts and assets still
  load, but no actions, triggers, or prompts).

## Updating from v0.1.0-alpha

1. Update SkyrimNet to Beta 25+, then update this mod (replace the old
   version).
2. **Do not** use SkyrimNet's "Import Old Content" on this mod's files —
   an imported copy would shadow every future update of ours.
3. Optional sanity check after first launch: the dashboard's Plugins page
   should list this mod with an External badge, and `SkyrimNet.log`
   should show no skipped-file warnings.

## SHA256

`9C6233A147D89111C82BE88D07165C0EEC49FF60955B0293DC79D277A90A7785`