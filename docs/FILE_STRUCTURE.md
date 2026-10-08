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
- `docs/pending-approvals.md` — pending-approvals register: every §7 draft until ruled (REV-90b-close rider, 2026-10-10); rulings move text to the owning feature doc.
- `docs/STANDING_RULESET.md` — canonical ruleset (mirrored to fork `docs/`).
- `docs/FILE_STRUCTURE.md` — this registry (mirrored to fork `docs/`).
- `docs/features/`, `docs/permissions/`, gate/session reports — internal docs.
- Convention: internal records live here, NOT in the fork; two-tree doc rule per
  `78d6af8` (fork PROJECT_STATE removed). Not a deploy tree in any direction.

## 2. Project home "1a" (the fork — active worktree)

`D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\` (local folder
renamed REV-82, 2026-10-04 — was
`SkyrimNet-Baka-GS_Poses-Integration-NSFW-Interactions`; git identity,
remotes, and branch verified intact at the new path)
- Role: single active project repo (fork of upstream Baka mod; consolidated fork).
  Branch `new-features` (working branch since REV-59; `main` lags at REV-58 —
  verified 2026-10-02 REV-69 audit); origin
  `regalrascal/SkyrimNet-Baka-GS_Poses-Integration-NSFW-Interactions`.
- **`dist\` conventions:**
  - Contents are **MO2-installable full trees** (root = mod root: both esps,
    `Scripts\`, `SKSE\`, `PrismaUI\`, `Sound\`, `textures\`, `meta.ini`) plus loose
    stamped zip artifacts — not partial staging.
  - **Stamped names** carry the revision gate, bracket-prefixed per rev-42 rider,
    e.g. `dist\[REV-56] SN-BakaGS-Unified reference build\`.
  - **Stamp convention OF RECORD (REV-82 ruling, 2026-10-04):** stamped folders
    `[REV-NN] Delectatio-et-Dominium <desc>` and zips
    `Delectatio-et-Dominium-<revNN>-<desc>.zip` — clean break, first live use
    = the REV-82 cue-build package. All earlier `SN-BakaGS-Unified` /
    `SN-AnimationsGS-Baka-Unified` stamps are HISTORICAL and never renamed
    (the archive documents the transition).
  - **v1.4.1 pdb location — debug-only:** `dist\SkyrimNet_BakaIntegration-v1.4.1\SKSE\Plugins\SkyrimNet_BakaIntegration.pdb`
    is reference-build debug symbols; it is never shipped, never zipped into an
    installable tree (0 pdb in every release zip).
  - Current reference artifact: `dist\SN-AnimationsGS-Baka-Unified-REV-56-reference.zip`
    (237 entries; DLLs `8BE130F8`/`9BD281E6`) + `.sha256`.
    **REV-87 annotation (dated note, 2026-10-08):** the SNAnimGS_UI `9BD281E6`
    value in this line is a REV-56-ERA REFERENCE-RECORD value, superseded —
    the SNAnimGS_UI lineage-of-record is `7D2641C7`, verified across the REV-68
    through REV-85c dists (2026-10-07 audit, PROJECT_STATE §91). The REV-56
    zip's own bytes are unchanged (historical artifact, never edited); only
    the lineage-of-record reading is corrected here.
  - `releases\manifests\` (REV-89, 2026-10-09; dist-manifest home, ruled (b)):
    generated-at-build dist manifests versioned in-repo (dist/ itself stays
    gitignored); first artifact = manifest-rev85c-repro-dryrun.txt (the REV-89
    dry-run proof manifest, sha256 5FA12E7B).
  - **`releases\archive\` model:** superseded release zips+sha256 move to
    `releases\archive\`; the archive is append-only history.
  - **Current-zip-loose rule:** exactly ONE current release zip (+ its sha256)
    stays loose at repo root; all older ones live under `releases\archive\`.
  - **`dist\archive\` model (REV-88 rider, user-ruled 2026-10-08):** after every
    new dist build, all superseded [REV-NN] folders and zips move one level down
    into `dist\archive\`; stamps are never renamed; exactly the latest rev's
    folder + zip + sidecar stay loose at `dist\` root. One-time cleanup EXECUTED
    same rev (2026-10-08): all superseded stamped folders, zips, and sidecars
    moved to `dist\archive\` (full inventory in PROJECT_STATE §93). Loose at
    `dist\` root after cleanup: `[REV-85c] Delectatio-et-Dominium
    aroused-split` + `Delectatio-et-Dominium-rev85c-aroused-split.zip` + sidecar
    (the latest rev's set) + `compile-out-rev85c` (current build-output staging,
    not a stamped dist) + `SkyrimNet_BakaIntegration-v1.4.1` (the standing
    pdb-reference path registered above — non-rev reference tree, kept).
    `-LiteralPath` throughout (bracket-name rule above).
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

**Deploy-target convention (REV-68 ruling, user-ordered, 2026-10-02; AMENDED same
session per user correction superseding the in-place-deploy variant): the live deploy
is the latest `[REV-NN]`-stamped unified deploy folder in the MO2 modlist, and EVERY
changed deploy state gets a NEW stamped folder — deployed folders are NEVER updated
in place; the prior stamped folder is DISABLED by the user (MO2 toggle), not deleted.
Folders must tell the truth about contents (rev-42 rider corollary): a folder stamped
REV-65 that contains REV-68 pex is a violation. The Build Patch era is retired as a
named folder — `SN AnimationsGS v1.1.0 Build Patch` is a HISTORICAL record only
(verified absent from the live modlist on 2026-10-02); it is no longer a deploy
target and must not be recreated.**

Current lineage holder: `D:\Modlists\LoreRim\mods\SN-AnimationsGS-Baka-Unified-REV-74-slavetats-service\`
- THE deploy target (§1) until superseded by a later stamped folder; wins MO2 resolution
  over both base mods. Base-mod trees are never deploy targets; a build landing there is a
  wrong-tree deploy (resync to the stamped folder before the gate closes).
- **REV-74 deploy (2026-10-02):** full `[REV-74-test]` tree copy (itself the REV-72 tree +
  alias-fixed esp) + fresh 6 pex (motherboard/BakaSL/MCM/ST module/SNBakaUI/AnimGS_LoadAlias —
  the LoadAlias pex was missing from EVERY tree incl. workspace, source of the standing
  FE0B5D64 bind error) + all 20 fresh psc (MCM source-skew fix) + 2 views; 255 files,
  32/32 hash-verified from build output/repo. `[REV-74-test]` (diagnostic-only, Task-1) is
  superseded — user disables it in MO2 at the swap. Dist zip `SN-AnimationsGS-Baka-Unified-
  REV-74-slavetats-service.zip` + downloads copy hash MATCH. Record in slavetats.md.
- **REV-76 dist (2026-10-03, FIRST never-deploy-rule build):** `[REV-76] SN-BakaGS-Unified
  mcm-replacement\` = REV-74 full tree + the REV-76 esp (MCM quest replacement: fresh
  QUST 04000D99 `SNBaka_MCM` scripted + aliased; old QUST 04000D63 neutered —
  zero-script VMAD, alias stripped, record kept) + fresh `SNBaka_MCM.pex/.psc`;
  257 files. Zip `SN-AnimationsGS-Baka-Unified-REV-76-mcm-replacement.zip` (ROOT-level
  layout per REV-74 precedent) + sidecar
  `9537FECDF33E1574EB34435D8D180C4B76B9BEF467175DD1372EC4B06D30CB38`. User installs
  via MO2 install-from-archive; REV-74 folder retires at the swap. DLLs/other esps
  hash-MATCH REV-74 (untouched). Record in PROJECT_STATE §76.
- **Prior lineage holders (retired, user disables in MO2, retained for rollback):**
  `SN-AnimationsGS-Baka-Unified-REV-72-slavetats-module` (rev-72 lineage from Task-1 test era),
  `SN-AnimationsGS-Baka-Unified-REV-69-deploy-integrity` (rev-69, stale-pex restoration:
  fresh 0/0 recompile hashed `A47D3CCDB975`/`04FDEBBFDEF0`/`1E22B3C2E7E1` for
  Integration/_MCM/BakaSL; 38/38 Scripts + 3/3 esp hash-verified; root cause + lesson in
  PROJECT_STATE REV-69), `SN-AnimationsGS-Baka-Unified-REV-68-module-lifecycle` (rev-68).
- Deployed patch folders carry revision-stamped names per the rev-42 rider
  (e.g. `SN-AnimationsGS-Baka-Unified-REV-68-module-lifecycle`); renames are MO2 edits
  under a CLOSED MO2. Prior stamped folders (REV-65 detection-fix and earlier) are
  disabled by the user, retained on disk for rollback.
- The fork (1a) is the single source deploy tree; the stamped unified folder is the live
  in-game target (§1 consolidation note).
- **REV-68 deploy history:** first the three REV-68 pex
  (`SkyrimNet_BakaIntegration`/`_MCM`/`BakaSL`) + matching psc Sources were deployed
  into the REV-65 stamped folder 2026-10-02 (3/3 pex + 3/3 psc hash MATCH). That
  in-place update is the violation the same-session amendment corrects: the REV-68
  state now lives in the fresh REV-68 stamped folder (full tree copied from the
  REV-65 folder + verified FOMOD `fomod/` + manifest), and the REV-65 folder is
  retired (user disables it). ESPs untouched (Option B, zero esp edits).
- **REV-76 NEVER-DEPLOY RULE (user ruling 2026-10-03, supersedes §1's Build-Patch
  deploy convention for all future builds):** Cline NEVER deploys into the modlist.
  All new revisions land exclusively in the fork's `dist\` (stamped folder + zip +
  sha256 sidecar per convention). The USER installs everything manually via MO2
  install-from-archive; the modlist is user-owned state and Cline's surface ends at
  `dist\`. Every prior modlist-deploy notation above is historical record only —
  the pattern is retired.

## 5. DevKit (validation tooling)

`D:\Modding\Skyrim\AI\DevKit\skyrimnet-devkit-beta25.1-rc2\`
- `tools\content-validate.exe` — plugin-folder structural validation (used for the
  v0.2.0-alpha external plugin layout: exit 0, 99 entries, 0 structural errors).
- Consult for `min_skyrimnet_version` and plugin-manifest rules at build time.

## 6. Papyrus compile bat (private home — GS repo)

`C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\tools\compile\compile_baka.bat`
- Role: the re-versioned `compile_baka.bat` lineage (last publicly versioned at fork
  commit `c142008` at this same relative `tools\compile\` path; removed from the public
  tree by the B4 public-safety pass; the rev-61 session-local reconstruction was the
  interim). REV-62 (2026-10-01) committed it here as its PRIVATE home — the B4
  public-safety posture stands: it never returns to the public fork. Invocation identical
  to the rev-61 0/0-compile proof (same imports order, same paths; OUT defaults to a temp
  dir, optional `%1` override).
- Depends on: the fork's `tools\compile\{local,ostim,mfg,spe}` stub packs (public fork),
  SkyrimNet-GamePlugin Source/headers (this workspace), and installed
  SKSE/PapyrusUtil/CK-base Sources (LoreRim + Steam) — paths baked in the bat.
- **Stub pack private mirror (REV-68 ruling 2, user-ordered, 2026-10-02):** the full
  14-stub pack (`{local,ostim,mfg,spe}` — other authors' API declarations, same
  public-safety posture as the bat: PRIVATE home only, never the public fork) is now
  ALSO versioned at
  `C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\tools\compile\stubs\`
  — hash-verified against the fork pack at copy time (14/14 MATCH, 0 mismatches,
  2026-10-02). This closes the same single-point-of-loss class as the rev-61 compile-bat
  gap: the fork remains the compile-import source of record (LOCAL path in the bat is
  unchanged); the GS mirror is the versioned backup + private-home canonical reference.
  **Standing maintenance rule:** any fork stub change (e.g., the REV-68 `Acheron.psc`
  signature extension) must be mirrored to the GS copy in the same session, hash-verified,
  or the GS copy is stale and must be re-synced before the next compile gate run.
- **REV-79 stub-parity gate:** `tools\compile\stub_parity.ps1` lives beside the
  bat and runs as its BLOCKING pre-step (any signature delta between a local
  stub and the installed runtime aborts the build; ruleset REV-79 rider). The
  gate manifest's runtime paths encode the LoreRim install and the
  **Ultra-profile winners** (SexLab = `SexLab Framework PPLUS - V2.18.1`;
  Acheron = the `[NoDelete]` copy) — update on any modlist/profile change.
- **REV-82 stub-pack additions:** `OSLArousedNative.psc` + `slaFrameworkScr.psc`
  (fork `tools\compile\local\` + mirrored in GS `tools\compile\stubs\local\`;
  runtime sources = OSL Aroused Reborn and SLO Aroused NG installs — both
  carriers ship both scripts, so either profile resolves). Gate = 16 surfaces.
  Both files are ASCII-only.

---

## Naming conventions (summary)

- Release/reference zips: `SN-AnimationsGS-Baka-Unified-<version-or-rev>.zip` +
  sidecar `.sha256`; current zip loose at root, superseded → `releases\archive\`.
- Full-tree dist folders: bracket-prefixed revision stamp first —
  `[REV-NN] <descriptive name>` (rev-42 rider adapted for dist).
- Deployed MO2 patch folders: `(<rev-NN>)` suffix.
- Repo folder names follow the GitHub repo (`GS_Poses`, underscore — NOT the
  legacy `GS-_Poses` hyphen variant; that spelling marks quarantined trees only).

---

## 7. D&D Features Planner (design authority — fork root; REV-81)

`D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\D&D Features Planner.md`
(fork root, path updated at the REV-82 rename)
- Role: the project's design-authority planner (feature pipeline, tiering
  semantics, cue-wording tiers — e.g. the arousal 3-tier: >=75% enthusiastic /
  25-75% fascinated / <=25% shocked). New design work cites it as the design
  input of record; it does NOT restructure anything — structure changes stay
  with this registry and the digestion session that owns restructuring.
- Location: fork root (rides the repo tree, not a deploy artifact);
  registered here per REV-81 (2026-10-04).
- REV-82 rename EXECUTED (2026-10-04): the fork-root cover artifact
  `Delecatio_et_Dominium_Cover.jpg` (misspelled "Delecatio") renamed to
  `Delectatio_et_Dominium_Cover.jpg` in the repo-folder rename pass;
  local repo folder is now `D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium`.
- REV-83 (2026-10-04): the planner is NOW SHARED (user-moved to the fork
  root; git-untracked user artifact by standing precedent). Digested IN
  FULL (PROJECT_STATE §84 gap map). Its working projection = the
  `docs/features/` checklist tree (INDEX master checklist + module docs:
  cum-effects, cumflation, dirty-talk, baka-module, gs-poses, slavetats
  REV-83 §). ONE-WAY FLOW of record: planner -> checklist, never silently
  back (planner edits are the user's; checklist edits cite, never rewrite,
  planner intent). The planner file itself is NEVER edited by sessions.

  **REV-88 amendment (dated 2026-10-08, user-ruled):** planner shared
  authorship supersedes the never-edit convention's mechanics per the REV-88
  ruleset rider — user-authored text remains immutable (rule 1); Cline
  maintains timestamped, rev-stamped "— Project working notes —" blocks at
  feature-section ends (status pointers only, never duplicated content) with
  status-only inline asterisk flags next to user items; rulings of record may
  be appended as marked notes when they arrive via approved paste. The
  checklist tree (INDEX + feature docs) remains the single status authority —
  planner notes are convenience annotations. The planner stays git-untracked
  (unchanged). First applied same rev (PROJECT_STATE §93).
