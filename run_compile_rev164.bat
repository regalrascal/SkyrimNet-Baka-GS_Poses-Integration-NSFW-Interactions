@echo off
rem REV-164 compile wrapper (THE SIX-ISSUE FIX PASS + ambient-voice sweep + [REV-164] cut:
rem Issue #2 pose-misroute category description rewrites in BOTH DLL sources (SNBaka_Display
rem direction-of-performance + member list; SNGS_Pose audience-driven dance admission) -
rem DLL rebuilds REQUIRED (rev-55 discipline); Issue #3 Force Tattoo tile 12 retirement
rem (PrismaUI index.html + choice-12 branch) + ApplyTattoo_Execute downed-gate + spank-set
rem decouple (SkyrimNet_BakaIntegration.psc); Issue #4 FHU ambient default flip OFF->ON +
rem first-fire acceleration (BakaIntegration + SNBaka_FHUInflationModule.psc); Issue #5
rem Acheron downed-cue cap 1+2 @ 60s then 180s gate (SkyrimNet_AcheronIntegration.psc);
rem Issues #1/#6 story-voice re-voices (5 FHU + acheron_downed + 4 mode-narr + 10 pose
rem yamls + ApplyTattoo.yaml, all yaml-only).
rem
rem Canonical compile: tools\compile\compile_baka.bat (12-target island incl.
rem the GS psc; stub-parity blocking; failure propagation 0/0 + byte-verified pex).
rem
rem Denylist assertion (ruleset REV-134b rider): retired names must never appear
rem in compile output or dist -- exit code 6 on violation.
rem
rem Modlist-write assertion (ruleset REV-133b rider): hashes every LoreRim profile
rem modlist.txt + every DeD folder under mods\ before and after; any change without
rem DED_MODLIST_AUTH=<reason> aborts with exit code 3.
setlocal
set OUT=D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\Compile Archive\compile-out-rev164
set REPO=D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium
set SNAP=%REPO%\gs-build\modlist_snapshot.txt
set BASE=%REPO%\gs-build\modlist_baseline.txt

pwsh -NoProfile -File "%REPO%\gs-build\modlist_snapshot.ps1"
if errorlevel 1 goto :assertfail
if not exist "%BASE%" copy "%SNAP%" "%BASE%" >nul
fc.exe /b "%BASE%" "%SNAP%" >nul 2>&1
if errorlevel 1 goto :modlistchanged

call "C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\tools\compile\compile_baka.bat" "%OUT%"
if errorlevel 1 goto :compilefail
goto :denylist

:modlistchanged
if not defined DED_MODLIST_AUTH (
  echo MODLIST-WRITE ASSERTION TRIPPED: mods tree or profiles changed vs baseline without DED_MODLIST_AUTH. Aborting.
  exit /b 3
)
echo MODLIST CHANGE AUTHORIZED: %DED_MODLIST_AUTH%
goto :eof

:assertfail
echo MODLIST SNAPSHOT FAILED (read error). Aborting.
exit /b 4

:compilefail
echo COMPILE FAILED (not 0/0). Aborting.
exit /b 5

:denylist
rem RETIRED-NAME DENYLIST (ruleset REV-134b rider): SNBaka_MCM.* and
rem SkyrimNet_BakaIntegration_MCM.* must never appear in compile output.
pwsh -NoProfile -Command "$hits = Get-ChildItem -LiteralPath '%OUT%' -Recurse -File | Where-Object { $_.Name -like 'SNBaka_MCM.*' -or $_.Name -like 'SkyrimNet_BakaIntegration_MCM.*' }; if($hits){ $hits | ForEach-Object { Write-Output ('DENYLIST HIT: ' + $_.FullName) }; exit 1 }; Write-Output 'DENYLIST CLEAN (no retired names in compile output).' "
if errorlevel 1 exit /b 6

:postcheck
rem post-compile re-assert: the modlist must be byte-identical across the whole run
pwsh -NoProfile -File "%REPO%\gs-build\modlist_snapshot.ps1"
if errorlevel 1 goto :assertfail
fc.exe /b "%BASE%" "%SNAP%" >nul 2>&1
if errorlevel 1 goto :modlistchanged
echo MODLIST ASSERTION CLEAN (compile leg).
echo COMPILE 12/12 0/0 (canonical island, REV-157 OUT). DENYLIST CLEAN.
endlocal
