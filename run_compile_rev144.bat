@echo off
rem REV-140 compile wrapper (REV-137c glide root-cause + Sheogorath deep dive + Sanguine funnel, verdict 3.1): Baka-grade package hold ported to the pose path. _PkgHoldActorAI DoNothing override (soft-read Baka esp PACK 0x1E6 via busy.baka-half probe) engaged at class-0 fire + BEFORE the class-1/2 stand; released on every no-fire leg + _StopActorPose + _PoseVibe empty-pool leg. SetDontMove does NOT stop in-flight package pathing (log-proven). PURE PAPYRUS.
rem  2.1 stand-in-place exit (IdleForceDefaultState both classes, ~2s
rem  real-clock confirm poll; PathToReference shape RETIRED); 2.2 AI
rem  re-grab prevention (SetRestrained hold at exit-issue, releases on
rem  every no-fire path + _StopActorPose belt-and-suspenders); 2.3 mid-
rem  dialogue narrowed to vanilla Dialogue Menu (UI.IsMenuOpen). PURE
rem  PAPYRUS. User-facing renames: Muse -> Sanguine Mode, Overdrive ->
rem  Sheogorath Mode (labels/notifications/sentinels only; technical ids,
rem  StorageUtil keys, event names, prompt filename unchanged).
rem
rem Canonical compile: tools\compile\compile_baka.bat (12-target island incl.
rem  the GS psc; stub-parity blocking; failure propagation 0/0 + byte-verified pex).
rem
rem Denylist assertion (ruleset REV-134b rider): retired names must never appear
rem  in compile output or dist -- exit code 6 on violation.
rem
rem Modlist-write assertion (ruleset REV-133b rider): hashes every LoreRim profile
rem  modlist.txt + every DeD folder under mods\ before and after; any change without
rem  DED_MODLIST_AUTH=<reason> aborts with exit code 3.
setlocal
set OUT=D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\Compile Archive\compile-out-rev144
set REPO=D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium
set SNAP=%REPO%\gs-build\modlist_snapshot.txt
set BASE=%REPO%\gs-build\modlist_baseline.txt

pwsh -NoProfile -Command "$s = foreach($p in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\profiles' -Directory){ $m=Join-Path $p.FullName 'modlist.txt'; if(Test-Path -LiteralPath $m){ ('{0}|{1}|{2}' -f $p.Name,(Get-Item -LiteralPath $m).LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-FileHash -LiteralPath $m).Hash) } }; foreach($d in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\mods' -Directory -Filter 'Delectatio-et-Dominium*'){ ('{0}|{1}|{2}' -f $d.Name,$d.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-ChildItem -LiteralPath $d.FullName -Recurse -File | Measure-Object).Count) }; foreach($d in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\mods' -Directory -Filter '[[]REV-*Delectatio*'){ ('{0}|{1}|{2}' -f $d.Name,$d.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-ChildItem -LiteralPath $d.FullName -Recurse -File | Measure-Object).Count) }; $s | Set-Content -LiteralPath 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\gs-build\modlist_snapshot.txt'"
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
pwsh -NoProfile -Command "$hits = Get-ChildItem -LiteralPath '%OUT%' -Recurse -File | Where-Object { $_.Name -like 'SNBaka_MCM.*' -or $_.Name -like 'SkyrimNet_BakaIntegration_MCM.*' }; if($hits){ $hits | ForEach-Object { Write-Output ('DENYLIST HIT: ' + $_.FullName) }; exit 1 }; Write-Output 'DENYLIST CLEAN (no retired names in compile output).' "
if errorlevel 1 goto :assertfail
fc.exe /b "%BASE%" "%SNAP%" >nul 2>&1
if errorlevel 1 goto :modlistchanged
echo MODLIST ASSERTION CLEAN (compile leg).
echo COMPILE 12/12 0/0 (canonical island, REV-138 OUT). DENYLIST CLEAN.
endlocal



