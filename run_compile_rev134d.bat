@echo off
rem REV-134d compile (THE NARRATION ANATOMY + MCM REDESIGN + MORE CUM
rem EXPANSION + TRIGGER GROUPING):
rem  1. ANATOMY (cue-only, engine-proven): sdb_cum_ambient.yaml DELETED from
rem     the live tree -- the RegisterEvent cue persists into the LLM's event
rem     log regardless of any trigger (EventRegistrationUtils.cpp:89 receipts);
rem     the yaml's response was the separate second narration (TriggerManager
rem     "Executing response (type: 3)" -> Intake direct_narration). The old
rem     instruction-tone text dies by anatomy.
rem  2. GROUPING (R1): the regalrascal.cum-detection package is consolidated
rem     into regalrascal.baka-gs-integration (the DeD group; the trigger menu
rem     groups by provider package id -- SkyrimNet.log "provided by" receipts).
rem  3. MCM REDESIGN (R2): DeD_MCM GetVersion 11 -> 12 -- "Cum Cues Module
rem     Toggle" rename, "Decal Source Selection" dropdown (retires the
rem     SexLab Climax Proxy Share toggle; presence-gated: OCum / SexLab / P+ /
rem     SLACS 2 + SCO), subtext rows REMOVED for info-text tooltips (user
rem     texts verbatim). Motherboard: iDecalSource property (0=OCum default,
rem     default-fresh, no old-toggle migration).
rem  4. MORE CUM EXPANSION (R3): the user's area map (anus->butt+thighs,
rem     vaginal->belly+thighs, hands->chest, throat->face+mouth+chest,
rem     face->throat+mouth+chest), source-agnostic via the selected decal
rem     lane (_SelectedDecalLane); SLACS-lane no-op guard added.
rem Touched surface: DeD_MCM + motherboard + SNBaka_CumDetectionModule.
rem
rem RETIREMENT (one-lineage rule, ruleset REV-134b rider): SkyrimNet_BakaIntegration_MCM
rem is retired -- its .psc/.pex are deleted from the repo tree and must never
rem re-enter dist. The esp VMAD record stays (xEdit scope, user-gated); without
rem the pex the stale quest's script attach fails to load and it never registers.
rem
rem Denylist assertion (ruleset REV-134b rider): retired names must NEVER appear
rem in compile output or dist -- exit code 6 on violation.
rem
rem Modlist-write assertion (ruleset REV-133b rider): hashes every LoreRim
rem profile modlist.txt + every DeD folder under mods\ before and after; any
rem change without DED_MODLIST_AUTH=<reason> aborts with exit code 3.
setlocal
set COMPILER=D:\Steam\steamapps\common\Skyrim Special Edition\Papyrus Compiler\PapyrusCompiler.exe
set REPO=D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium
set OUT=%REPO%\Compile Archive\compile-out-rev134d
rem rem SkyUI's SKI_ConfigBase is BSA-only on disk; the MCM resolves against the
rem corrected native-only header stubs in the GS GamePlugin headers tree.
set IMPORTS=D:\Modlists\LoreRim\mods\Skyrim Script Extender (SKSE64)\Scripts\Source;D:\Steam\steamapps\common\Skyrim Special Edition\Data\Source\Scripts;D:\Modlists\LoreRim\mods\PapyrusUtil SE - Modders Scripting Utility Functions\Scripts\Source;D:\Modlists\LoreRim\mods\powerofthree's Papyrus Extender\Source\scripts;D:\Modlists\LoreRim\mods\[NoDelete] SkyrimNet-beta26-rc4\Source\Scripts;%REPO%\Scripts\Source;%REPO%\tools\compile\local;%REPO%\tools\compile\mfg;%REPO%\tools\compile\ostim;%REPO%\tools\compile\spe;C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-GamePlugin\headers
set FLAGS=D:\Steam\steamapps\common\Skyrim Special Edition\Data\Source\Scripts\TESV_Papyrus_Flags.flg
set SNAP=%REPO%\gs-build\modlist_snapshot.txt
set BASE=%REPO%\gs-build\modlist_baseline.txt

pwsh -NoProfile -Command "$s = foreach($p in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\profiles' -Directory){ $m=Join-Path $p.FullName 'modlist.txt'; if(Test-Path -LiteralPath $m){ ('{0}|{1}|{2}' -f $p.Name,(Get-Item -LiteralPath $m).LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-FileHash -LiteralPath $m).Hash) } }; foreach($d in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\mods' -Directory -Filter 'Delectatio-et-Dominium*'){ ('{0}|{1}|{2}' -f $d.Name,$d.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-ChildItem -LiteralPath $d.FullName -Recurse -File | Measure-Object).Count) }; foreach($d in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\mods' -Directory -Filter '[[]REV-*Delectatio*'){ ('{0}|{1}|{2}' -f $d.Name,$d.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-ChildItem -LiteralPath $d.FullName -Recurse -File | Measure-Object).Count) }; $s | Set-Content -LiteralPath 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\gs-build\modlist_snapshot.txt'"
if errorlevel 1 goto :assertfail
if not exist "%BASE%" copy "%SNAP%" "%BASE%" >nul
fc.exe /b "%BASE%" "%SNAP%" >nul 2>&1
if errorlevel 1 goto :modlistchanged

if not exist "%OUT%" mkdir "%OUT%"
"%COMPILER%" "%REPO%\Scripts\Source\SkyrimNet_BakaIntegration.psc" -f="%FLAGS%" -i="%IMPORTS%" -o="%OUT%"
if errorlevel 1 goto :compilefail
"%COMPILER%" "%REPO%\Scripts\Source\SNBaka_CumDetectionModule.psc" -f="%FLAGS%" -i="%IMPORTS%" -o="%OUT%"
if errorlevel 1 goto :compilefail
"%COMPILER%" "%REPO%\Scripts\Source\DeD_MCM.psc" -f="%FLAGS%" -i="%IMPORTS%" -o="%OUT%"
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
pwsh -NoProfile -Command "$hits = Get-ChildItem -LiteralPath '%OUT%' -Recurse -File | Where-Object { $_.Name -like 'SNBaka_MCM.*' -or $_.Name -like 'SkyrimNet_BakaIntegration_MCM.*' }; if($hits){ $hits | ForEach-Object { Write-Output ('DENYLIST HIT: ' + $_.FullName) }; exit 1 }; Write-Output 'DENYLIST CLEAN (no retired names in compile output).'"
if errorlevel 1 exit /b 6

:postcheck
rem post-compile re-assert: the modlist must be byte-identical across the whole run
pwsh -NoProfile -Command "$s = foreach($p in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\profiles' -Directory){ $m=Join-Path $p.FullName 'modlist.txt'; if(Test-Path -LiteralPath $m){ ('{0}|{1}|{2}' -f $p.Name,(Get-Item -LiteralPath $m).LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-FileHash -LiteralPath $m).Hash) } }; foreach($d in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\mods' -Directory -Filter 'Delectatio-et-Dominium*'){ ('{0}|{1}|{2}' -f $d.Name,$d.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-ChildItem -LiteralPath $d.FullName -Recurse -File | Measure-Object).Count) }; foreach($d in Get-ChildItem -LiteralPath 'D:\Modlists\LoreRim\mods' -Directory -Filter '[[]REV-*Delectatio*'){ ('{0}|{1}|{2}' -f $d.Name,$d.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'),(Get-ChildItem -LiteralPath $d.FullName -Recurse -File | Measure-Object).Count) }; $s | Set-Content -LiteralPath 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium\gs-build\modlist_snapshot.txt'"
if errorlevel 1 goto :assertfail
fc.exe /b "%BASE%" "%SNAP%" >nul 2>&1
if errorlevel 1 goto :modlistchanged
echo MODLIST ASSERTION CLEAN (compile leg).
echo COMPILE 0/0 (motherboard + cum module + live MCM). DENYLIST CLEAN.
endlocal
