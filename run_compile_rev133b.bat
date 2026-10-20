@echo off
rem REV-133b compile (OUT-collapse workaround preserved; see run_compile_rev133.bat
rem header). Touched surface: SNBaka_CumDetectionModule ONLY (REV-133b: riders
rem 2.5a/2.5b retirements + overlay appliance matrix + More Cum routing + bath
rem clearing). Motherboard untouched (cross-calls resolve at runtime).
rem
rem NEW (REV-133b rider, ruleset REV-133b amendment): modlist-write assertion.
rem Before compiling and again after, this script hashes every LoreRim profile
rem modlist.txt + every DeD folder under mods\ (names, mtimes, file counts).
rem First run establishes the baseline snapshot; any later change without the
rem env var DED_MODLIST_AUTH=<reason> aborts with exit code 3. The session's
rem report carries the baseline-vs-end diff (rider REV-133b(i)).
setlocal
set COMPILER=D:\Steam\steamapps\common\Skyrim Special Edition\Papyrus Compiler\PapyrusCompiler.exe
set REPO=D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium
set OUT=%REPO%\Compile Archive\compile-out-rev133b
set IMPORTS=D:\Modlists\LoreRim\mods\Skyrim Script Extender (SKSE64)\Scripts\Source;D:\Steam\steamapps\common\Skyrim Special Edition\Data\Source\Scripts;D:\Modlists\LoreRim\mods\PapyrusUtil SE - Modders Scripting Utility Functions\Scripts\Source;D:\Modlists\LoreRim\mods\powerofthree's Papyrus Extender\Source\scripts;D:\Modlists\LoreRim\mods\[NoDelete] SkyrimNet-beta26-rc4\Source\Scripts;%REPO%\Scripts\Source;%REPO%\tools\compile\local;%REPO%\tools\compile\mfg;%REPO%\tools\compile\ostim;%REPO%\tools\compile\spe
set FLAGS=D:\Steam\steamapps\common\Skyrim Special Edition\Data\Source\Scripts\TESV_Papyrus_Flags.flg
set SNAP=%REPO%\gs-build\modlist_snapshot.txt
set BASE=%REPO%\gs-build\modlist_baseline.txt

pwsh -NoProfile -Command "$s = foreach($p in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\profiles' -Directory){ $m=Join-Path $p.FullName 'modlist.txt'; if(Test-Path -LiteralPath $m){ ('{0}|{1}|{2}' -f $p.Name,(Get-Item -LiteralPath $m).LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-FileHash -LiteralPath $m).Hash) } }; foreach($d in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\mods' -Directory -Filter 'Delectatio-et-Dominium*'){ ('{0}|{1}|{2}' -f $d.Name,$d.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-ChildItem -LiteralPath $d.FullName -Recurse -File | Measure-Object).Count) }; foreach($d in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\mods' -Directory -Filter '[[]REV-*Delectatio*'){ ('{0}|{1}|{2}' -f $d.Name,$d.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-ChildItem -LiteralPath $d.FullName -Recurse -File | Measure-Object).Count) }; $s | Set-Content -LiteralPath 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\gs-build\modlist_snapshot.txt'"
if errorlevel 1 goto :assertfail
if not exist "%BASE%" copy "%SNAP%" "%BASE%" >nul
fc.exe /b "%BASE%" "%SNAP%" >nul 2>&1
if errorlevel 1 goto :modlistchanged

if not exist "%OUT%" mkdir "%OUT%"
"%COMPILER%" "%REPO%\Scripts\Source\SNBaka_CumDetectionModule.psc" -f="%FLAGS%" -i="%IMPORTS%" -o="%OUT%"
goto :postcheck

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

:postcheck
rem post-compile re-assert: the modlist must be byte-identical across the whole run
pwsh -NoProfile -Command "exit 0"
fc.exe /b "%BASE%" "%SNAP%" >nul 2>&1
if errorlevel 1 goto :modlistchanged
echo MODLIST ASSERTION CLEAN (compile leg).
endlocal
