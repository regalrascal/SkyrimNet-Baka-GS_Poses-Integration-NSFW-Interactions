# FILE_STRUCTURE — canonical path registry

**Canonical:** GS repo `SkyrimNet-Animations-GS`, branch `gs-muse-redesign`, `docs/FILE_STRUCTURE.md`.
**Established:** rev-57 (2026-09-30), on the 1b→1a repo migration.
**Authority:** this file is the single path authority (rev-57 ruleset rider). Historical
path references in earlier records are superseded by this registry. Historical records are
immutable — corrections are banner-prepending only. An audit finding that conflicts with
this design is a STOP for planner/user decision.

---

## 1. Cline workspace (GS canonical, internal — never deployed)

`C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\`
- Role: canonical GS repo and internal records home. Branch `gs-muse-redesign`.
- `docs/PROJECT_STATE.md` — central internal record (this file's sibling).
- `docs/STANDING_RULESET.md` — canonical ruleset (mirrored to fork `docs/`).
- `docs/FILE_STRUCTURE.md` — this registry (mirrored to fork `docs/`).
- `docs/features/`, `docs/permissions/`, gate/session reports — internal docs.
- Convention: internal records live here, NOT in the fork; two-tree doc rule per
  `78d6af8` (fork PROJECT_STATE removed). Not a deploy tree in any direction.

## 2. Project home "1a" (the fork — active worktree)

`D:\Modding\Skyrim\Workspace\SkyrimNet-Baka-GS_Poses-Integration-NSFW-Interactions\`
- Role: single active project repo (fork of upstream Baka mod; consolidated fork).
  Branch `main`; origin `regalrascal/SkyrimNet-Baka-GS_Poses-Integration-NSFW-Interactions`.
- **`dist\` conventions:**
  - Contents are **MO2-installable full trees** (root = mod root: both esps,
    `Scripts\`, `SKSE\`, `PrismaUI\`, `Sound\`, `textures\`, `meta.ini`) plus loose
    stamped zip artifacts — not partial staging.
  - **Stamped names** carry the revision gate, bracket-prefixed per rev-42 rider,
    e.g. `dist\[REV-56] SN-BakaGS-Unified reference build\`.
  - **v1.4.1 pdb location — debug-only:** `dist\SkyrimNet_BakaIntegration-v1.4.1\SKSE\Plugins\SkyrimNet_BakaIntegration.pdb`
    is reference-build debug symbols; it is never shipped, never zipped into an
    installable tree (0 pdb in every release zip).
  - Current reference artifact: `dist\SN-AnimationsGS-Baka-Unified-REV-56-reference.zip`
    (237 entries; DLLs `8BE130F8`/`9BD281E6`) + `.sha256`.
  - **`releases\archive\` model:** superseded release zips+sha256 move to
    `releases\archive\`; the archive is append-only history.
  - **Current-zip-loose rule:** exactly ONE current release zip (+ its sha256)
    stays loose at repo root; all older ones live under `releases\archive\`.
- **Build-warning (gates the next DLL build):** the rev-57 migration left stale
  CMake caches pointing at the old BKA path. Before the next clean build of either
  DLL, run from repo root: `git clean -xdf dll-source/build/ dll-source-gs/build/`.
  This warning is also embedded in both build bats (`dll-source\build_plugin.bat`,
  `dll-source-gs\build_plugin-gs.bat`) where it will be seen at build time.
- Note: bracket-named (`[REV-56]…`) paths break PowerShell wildcards and
  `cmd /c rmdir` — always use `-LiteralPath`.

## 3. Quarantined read-only fallbacks (1b, 1c — do not work here)

- **1b:** `D:\Modding\Skyrim\Workspace\BKA\SkyrimNet-Baka-GS-_Poses-Integration-NSFW-Interactions\`
  - Origin: the migration SOURCE (robocopy /MIR → 1a on 2026-09-30). The `BKA`
    parent folder is a wrapper, not a repo.
  - Frozen state: HEAD `78d6af8` (REV-57), branch `main`, clean tree.
  - Role: read-only reference/fallback only. Quarantined per its QUARANTINE_NOTICE.txt (2026-09-30).
- **1c:** `D:\Modding\Skyrim\Workspace\SkyrimNet-Baka-GS-_Poses-Integration-NSFW-Interactions\`
  - Origin: wrong-destination copy from an earlier mis-migration (hyphen variant
    `GS-_Poses`); identical repo state to 1b at freeze.
  - Role: read-only reference only; slated for deletion. Quarantined 2026-09-30.
- Both carry `QUARANTINE_NOTICE.txt` at repo root (dated 2026-09-30). All
  subsequent work happens at 1a ONLY.

## 4. MO2 deploy target (one deploy target)

`D:\Modlists\LoreRim\mods\SN AnimationsGS v1.1.0 Build Patch\`
- THE deploy target (ruleset §1) — the Build Patch wins MO2 resolution over both
  base mods. Base-mod trees are never deploy targets; a build landing there is a
  wrong-tree deploy (resync to patch before the gate closes).
- Deployed patch folders carry revision-stamped names per the rev-42 rider
  (e.g. `SN-AnimationsGS-Baka-CommunityPatch (rev-42)`); renames are MO2 edits
  under a CLOSED MO2.
- The fork (1a) is the single source deploy tree; the Build Patch remains the
  live target until the fork lands in-game (§1 consolidation note).

## 5. DevKit (validation tooling)

`D:\Modding\Skyrim\AI\DevKit\skyrimnet-devkit-beta25.1-rc2\`
- `tools\content-validate.exe` — plugin-folder structural validation (used for the
  v0.2.0-alpha external plugin layout: exit 0, 99 entries, 0 structural errors).
- Consult for `min_skyrimnet_version` and plugin-manifest rules at build time.

---

## Naming conventions (summary)

- Release/reference zips: `SN-AnimationsGS-Baka-Unified-<version-or-rev>.zip` +
  sidecar `.sha256`; current zip loose at root, superseded → `releases\archive\`.
- Full-tree dist folders: bracket-prefixed revision stamp first —
  `[REV-NN] <descriptive name>` (rev-42 rider adapted for dist).
- Deployed MO2 patch folders: `(<rev-NN>)` suffix.
- Repo folder names follow the GitHub repo (`GS_Poses`, underscore — NOT the
  legacy `GS-_Poses` hyphen variant; that spelling marks quarantined trees only).
