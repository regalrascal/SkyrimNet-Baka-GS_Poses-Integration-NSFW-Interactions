@echo off
rem REV-132b compile (OUT-collapse workaround preserved: compiler writes
rem Papyrus.0.log to its cwd; -o must be a fresh dir). Touched surface:
rem SNBaka_CumDetectionModule ONLY (get_ded_cum_any decorator + bio-fragment
rem windowing wiring). The motherboard is untouched this rev (no recompile
rem needed -- its cross-calls to the module resolve at runtime via the
rem decorator/event registrations).
setlocal
set COMPILER=D:\Steam\steamapps\common\Skyrim Special Edition\Papyrus Compiler\PapyrusCompiler.exe
set REPO=D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium
set OUT=%REPO%\Compile Archive\compile-out-rev132b
set IMPORTS=D:\Modlists\LoreRim\mods\Skyrim Script Extender (SKSE64)\Scripts\Source;D:\Steam\steamapps\common\Skyrim Special Edition\Data\Source\Scripts;D:\Modlists\LoreRim\mods\PapyrusUtil SE - Modders Scripting Utility Functions\Scripts\Source;D:\Modlists\LoreRim\mods\powerofthree's Papyrus Extender\Source\scripts;D:\Modlists\LoreRim\mods\[NoDelete] SkyrimNet-beta26-rc4\Source\Scripts;%REPO%\Scripts\Source;%REPO%\tools\compile\local;%REPO%\tools\compile\mfg;%REPO%\tools\compile\ostim;%REPO%\tools\compile\spe
set FLAGS=D:\Steam\steamapps\common\Skyrim Special Edition\Data\Source\Scripts\TESV_Papyrus_Flags.flg
if not exist "%OUT%" mkdir "%OUT%"
"%COMPILER%" "%REPO%\Scripts\Source\SNBaka_CumDetectionModule.psc" -f="%FLAGS%" -i="%IMPORTS%" -o="%OUT%"
