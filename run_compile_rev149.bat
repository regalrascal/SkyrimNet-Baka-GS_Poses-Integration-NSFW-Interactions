@echo off
rem REV-149 compile wrapper (FHU v2 session 1: entry-arousal capture at
rem HookAnimationStart + consent context, cleared at HookAnimationEnd; orifice-
rem aware instant inflate; per-orifice deflate split sdb_fhu_deflate_vaginal/_anal/
rem _oral with the generic type RETIRED; creature-cum ambient cue with the canned
rem class map. OStim capture lane STOPPED per the mid-rev user ruling -- the SL FHU
rem Baka Ostim 0.18 bridge is disabled in the active Ultra profile and the enabled
rem FHU 2.11 Beta has no OStim registrations).
rem PURE PAPYRUS + content; NO dist (batch mode).
rem
rem Canonical compile: tools\compile\compile_baka.bat (12-target island incl.
rem  the GS psc; stub-parity blocking; failure propagation 0/0 + byte-verified pex).
rem
rem Denylist assertion (ruleset REV-134b rider): retired names must never appear
rem in compile output or dist -- exit code 6 on violation.
rem
rem Modlist-write assertion (ruleset REV-133b rider): hashes every LoreRim profile
rem modlist.txt + every DeD folder under mods\ before and after; any change without
rem DED_MODLIST_AUTH=<reason> aborts with exit code 3.
setlocal
set OUT=D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\Compile Archive\compile-out-rev149
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
pwsh -NoProfile -Command "$s = foreach($p in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\profiles' -Directory){ $m=Join-Path $p.FullName 'modlist.txt'; if(Test-Path -LiteralPath $m){ ('{0}|{1}|{2}' -f $p.Name,(Get-Item -LiteralPath $m).LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-FileHash -LiteralPath $m).Hash) } }; foreach($d in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\mods' -Directory -Filter 'Delectatio-et-Dominium*'){ ('{0}|{1}|{2}' -f $d.Name,$d.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-ChildItem -LiteralPath $d.FullName -Recurse -File | Measure-Object).Count) }; foreach($d in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\mods' -Directory -Filter '[[]REV-*Delectatio*'){ ('{0}|{1}|{2}' -f $d.Name,$d.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-ChildItem -LiteralPath $d.FullName -Recurse -File | Measure-Object).Count) }; $s | Set-Content -LiteralPath 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\gs-build\modlist_snapshot.txt'"
if errorlevel 1 goto :assertfail
fc.exe /b "%BASE%" "%SNAP%" >nul 2>&1
if errorlevel 1 goto :modlistchanged
echo MODLIST ASSERTION CLEAN (compile leg).
echo COMPILE 12/12 0/0 (canonical island, REV-149 OUT). DENYLIST CLEAN.
endlocal
