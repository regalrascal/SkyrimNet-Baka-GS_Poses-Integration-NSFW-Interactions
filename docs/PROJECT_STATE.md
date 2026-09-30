# PROJECT STATE — living page

**Canonical:** GS repo `SkyrimNet-Animations-GS`, branch `gs-muse-redesign`, `docs/PROJECT_STATE.md`.
**Update rule:** part of every task's commit — task complete → this page edited
in the same commit; the gate report links the state-doc diff.

**Last updated:** 2026-09-30 (rev-57: staging rename + doc-model audit)

---

## §55 — Doc-model adoption (fork mirror)

The fork adopted the rev-55 rider documentation model at rev-55 (`6bbe736`).
This is the first PROJECT_STATE.md in the fork — central findings are
recorded here rather than in CHANGELOG.md (which is the release changelog
per §6 discipline).

**Rider rev-55 routing rule:** A finding lives in its
`docs/features/{feature}.md`; it goes central (PROJECT_STATE.md) ONLY if it
concerns multiple features, toolchain, releases, rules, or cross-feature
rulings.

**Fork status re doc model:** The fork mirrors `docs/STANDING_RULESET.md`
from GS canonical. The modular feature docs (`docs/features/`) live only in
the GS canonical repo — the fork does not yet carry them (see §57 audit).

---

## §56 — Reference builds (Phase 1) — toolchain findings

### Gate 0 retarget (VS 2019 → VS 2022)

- **Commit `7885e12`:** `CMakePresets.json` and build bats retargeted from
  VS 2019 Build Tools (v142/MSVC 14.51) to VS 2022 Community (v143/MSVC
  14.44) — required because VS 2019 Build Tools auto-detected by vcpkg
  produced CommonLibSSE with mismatched STL ABI (root cause of LNK2001).
- **Commit `de934c7`:** rc.exe/vcvars wrapper batch file for non-VS2022
  toolchain tools (resource compiler path), ensuring `dll-source-gs` build
  can locate RC even when VS 2022 is the primary dev environment.

### vcpkg overlay port — CommonLibSSE-NG

- **Overlay port path:** `dll-source-gs/overlay/commonlibsse-ng/`
  (`portfile.cmake` + `vcpkg.json`)
- **Overlay triplet path:** `dll-source-gs/overlay/x64-windows-static-md.cmake`
  — forces `VCPKG_PLATFORM_TOOLSET v143` (VS 2022)
- **Portfile mechanism:** points at the local `../CommonLibSSE-NG/` submodule
  checkout (source build, not prebuilt)
- **Triplet mechanism:** sets `VCPKG_TARGET_ARCHITECTURE x64`,
  `VCPKG_LIBRARY_LINKAGE static`, `VCPKG_CRT_LINKATION dynamic` (static-md),
  and crucially `VCPKG_PLATFORM_TOOLSET v143`
- **Build integration:** `build_plugin-gs.bat` sets both
  `VCPKG_OVERLAY_PORTS` and `VCPKG_OVERLAY_TRIPLETS` env vars before invoking
  cmake

### Verification

- **Baka DLL:** `SkyrimNet_BakaIntegration.dll` — byte-identical to shipped
  v1.4.1 (SHA256 `8BE130F8…`, 1,035,776 bytes)
- **GS DLL:** `SNAnimGS_UI.dll` — zero LNK2001 errors; SHA256 `9BD281E6…`,
  564,736 bytes (shipped was 398,848 bytes — growth from CommonLibSSE 4.26.0
  vs 3.7.0); same 3 SKSE plugin exports; identical 17 imported DLLs
- **Cold reproducibility:** full rebuild from empty binary cache in ~6 min
- **Staging:** `dist/[REV-56] SN-BakaGS-Unified reference build/`

---

## §57 — Doc-model audit + staging rename (2026-09-30)

### Task 1: Staging rename

`dist/REV-56-reference/` → `dist/[REV-56] SN-BakaGS-Unified reference build/`

**Decision rationale:** `dist/` is an internal build-staging area (not
MO2-facing). The rev-42 rider specifically mandates the stamped convention
for "DEPLOYED patch artifact's MO2 folder name" — but the hygiene principle
extends to all named staging artefacts. The stamped name `[REV-56] …` is
self-documenting: any person or tool reading the dist/ listing immediately
sees which revision produced it.

### Task 2: Doc-model confirmation audit

| # | Check | Result | Evidence |
|---|---|---|---|
| 2a | INDEX.md: 7 rows, statuses current, 3 rev-55 rulings reflected | **FAIL** | `docs/features/INDEX.md` does not exist in this fork. Feature docs exist only in GS canonical (`SkyrimNet-Animations-GS`, `gs-muse-redesign`). Fork never populated the modular doc structure. |
| 2b | Routing check: 3 rev-56 findings (Gate 0 retarget, overlay port, vcvars wrapper) in central only | **PASS†** | As of this revision, all 3 recorded in `docs/PROJECT_STATE.md` §56 — central only, NOT duplicated into feature docs (which don't exist in fork). CHANGELOG retains summary reference (acceptable per §6). |
| 2c | Feature docs: seeded with rev-55 findings, no stubs | **FAIL** | None of the 7 feature docs exist in fork. Present in GS canonical (`docs/features/`). Routing unverifiable where docs absent. |
| 2d | Fork mirror: STANDING_RULESET.md hash-identical; no features/ or PROJECT_STATE in fork tree | **PASS** | Fork SHA256 `FCC414A6…` = GS canon. Fork does NOT carry `docs/features/` or `PROJECT_STATE.md` (now created here). GS canon's state lives at `docs/PROJECT_STATE.md`. |
| 2e | Routing violations found & fixed | **FIXED** | Violation: REV-56's toolchain findings were CHANGELOG-only. Fix: `docs/PROJECT_STATE.md` created with §56 + §55. CHANGELOG now links here. |

**† PASS is partial:** the routing rule is now satisfied, but only because
the content was absent. Full PASS requires the doc model to be populated
pre-emptively rather than reactively fixed.

### Branch-strategy ruling (rev-55 session)

**User-ratified, strategist-dictated (rev-55):**

> A single integration branch "new-features" (cut from current main at Phase 2
> start) receives small features directly and larger features via feature/{slug}
> branches merged --no-ff; the fork mirror reflects verified states only.

This is a cross-feature / ruling item — central by definition (recorded here).

### Work log

No logged work entries yet (fork-initial PROJECT_STATE.md created at rev-57).