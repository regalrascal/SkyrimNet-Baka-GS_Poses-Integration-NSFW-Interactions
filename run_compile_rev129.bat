@echo off
rem REV-129 decoration-build compile (OUT-collapse workaround preserved:
rem compiler writes Papyrus.0.log to its cwd; -o must be a fresh dir).
rem Touched surfaces: SNBaka_CumDetectionModule (get_ded_cum + aftermath
rem hold/fire legs) and SkyrimNet_BakaIntegration (get_ded_arousal +
rem HookAnimationEnd + OnUpdate mux leg). Module compiled FIRST (the
rem motherboard's new cross-calls resolve against its fresh psc/pex).
setlocal
set COMPILER=D:\Steam\steamapps\common\Skyrim Special Edition\Papyrus Compiler\PapyrusCompiler.exe
set REPO=D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium
set OUT=%REPO%\Compile Archive\compile-out-rev129
set IMPORTS=D:\Modlists\LoreRim\mods\Skyrim Script Extender (SKSE64)\Scripts\Source;D:\Steam\steamapps\common\Skyrim Special Edition\Data\Source\Scripts;D:\Modlists\LoreRim\mods\PapyrusUtil SE - Modders Scripting Utility Functions\Scripts\Source;D:\Modlists\LoreRim\mods\powerofthree's Papyrus Extender\Source\scripts;D:\Modlists\LoreRim\mods\[NoDelete] SkyrimNet-beta26-rc4\Source\Scripts;%REPO%\Scripts\Source;%REPO%\tools\compile\local;%REPO%\tools\compile\mfg;%REPO%\tools\compile\ostim;%REPO%\tools\compile\spe
set FLAGS=D:\Steam\steamapps\common\Skyrim Special Edition\Data\Source\Scripts\TESV_Papyrus_Flags.flg
if not exist "%OUT%" mkdir "%OUT%"
"%COMPILER%" "%REPO%\Scripts\Source\SNBaka_CumDetectionModule.psc" -f="%FLAGS%" -i="%IMPORTS%" -o="%OUT%"
"%COMPILER%" "%REPO%\Scripts\Source\SkyrimNet_BakaIntegration.psc" -f="%FLAGS%" -i="%IMPORTS%" -o="%OUT%"
