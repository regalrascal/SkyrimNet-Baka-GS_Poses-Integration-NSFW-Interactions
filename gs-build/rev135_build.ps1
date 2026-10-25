# REV-135 build harness (idle-interrupt service): assemble run_compile_rev135.bat
# from the [REV-134f] wrapper template (baseline assertion + denylist + postcheck
# legs copied verbatim; the compile section swapped to the canonical 13-target
# compile_baka.bat call with an explicit OUT arg), then run it and tee the receipt.
$ErrorActionPreference = 'Stop'
$repo  = 'D:\Modding\Skyrim\Workspace\Delectatio-et-Dominium'
$tpl   = Join-Path $repo 'run_compile_rev134f.bat'
$bat   = Join-Path $repo 'run_compile_rev135.bat'
$rcpt  = Join-Path $repo 'gs-build\rev135_compile_receipt.txt'
$lines = Get-Content -LiteralPath $tpl

# capture the two inline snapshot pwsh commands verbatim (baseline + postcheck legs)
$snapCmd = @($lines | Where-Object { $_ -like 'pwsh -NoProfile -Command *' })

$out = New-Object System.Collections.Generic.List[string]
$out.Add('@echo off')
$out.Add('rem REV-135 compile wrapper (IDLE-INTERRUPT SERVICE -- the shared idle primitive,')
$out.Add('rem  spec of record gs-poses.md REV-134e 1.4.1-1.4.3): _IdleClass/_ExitIdle GLOBAL')
$out.Add('rem  pair + _IdleFirePath member pipeline (detect -> exit -> recheck -> fire), class-')
$out.Add('rem  aware _IsBusyElsewhere, crosshair pick path, exec-time _PoseVibe leg, muse walk')
$out.Add('rem  sentinel class-tag, T3 silence-floor routing. PURE PAPYRUS -- no DLL, no esp.')
$out.Add('rem')
$out.Add('rem Canonical compile: tools\compile\compile_baka.bat (13-target island incl. the')
$out.Add('rem GS psc; stub-parity blocking; failure propagation 0/0 + byte-verified pex).')
$out.Add('rem')
$out.Add('rem Denylist assertion (ruleset REV-134b rider): retired names must never appear in')
$out.Add('rem compile output or dist -- exit code 6 on violation.')
$out.Add('rem')
$out.Add('rem Modlist-write assertion (ruleset REV-133b rider): hashes every LoreRim profile')
$out.Add('rem modlist.txt + every DeD folder under mods\ before and after; any change without')
$out.Add('rem DED_MODLIST_AUTH=<reason> aborts with exit code 3.')
$out.Add('setlocal')
$out.Add('set OUT=' + $repo + '\Compile Archive\compile-out-rev135')
$out.Add('set REPO=' + $repo)
$out.Add('set SNAP=%REPO%\gs-build\modlist_snapshot.txt')
$out.Add('set BASE=%REPO%\gs-build\modlist_baseline.txt')
$out.Add('')
$out.Add($snapCmd[0])
$out.Add('if errorlevel 1 goto :assertfail')
$out.Add('if not exist "%BASE%" copy "%SNAP%" "%BASE%" >nul')
$out.Add('fc.exe /b "%BASE%" "%SNAP%" >nul 2>&1')
$out.Add('if errorlevel 1 goto :modlistchanged')
$out.Add('')
$out.Add('call "C:\Users\Tristan\.cline\data\workspaces\chat\gs-build\SkyrimNet-Animations-GS\tools\compile\compile_baka.bat" "%OUT%"')
$out.Add('if errorlevel 1 goto :compilefail')
$out.Add('goto :denylist')
$out.Add('')
$out.Add(':modlistchanged')
$out.Add('if not defined DED_MODLIST_AUTH (')
$out.Add('  echo MODLIST-WRITE ASSERTION TRIPPED: mods tree or profiles changed vs baseline without DED_MODLIST_AUTH. Aborting.')
$out.Add('  exit /b 3')
$out.Add(')')
$out.Add('echo MODLIST CHANGE AUTHORIZED: %DED_MODLIST_AUTH%')
$out.Add('goto :eof')
$out.Add('')
$out.Add(':assertfail')
$out.Add('echo MODLIST SNAPSHOT FAILED (read error). Aborting.')
$out.Add('exit /b 4')
$out.Add('')
$out.Add(':compilefail')
$out.Add('echo COMPILE FAILED (not 0/0). Aborting.')
$out.Add('exit /b 5')
$out.Add('')
$out.Add(':denylist')
$out.Add('rem RETIRED-NAME DENYLIST (ruleset REV-134b rider): SNBaka_MCM.* and')
$out.Add('rem SkyrimNet_BakaIntegration_MCM.* must never appear in compile output.')
$out.Add('pwsh -NoProfile -Command "$hits = Get-ChildItem -LiteralPath ''%OUT%'' -Recurse -File | Where-Object { $_.Name -like ''SNBaka_MCM.*'' -or $_.Name -like ''SkyrimNet_BakaIntegration_MCM.*'' }; if($hits){ $hits | ForEach-Object { Write-Output (''DENYLIST HIT: '' + $_.FullName) }; exit 1 }; Write-Output ''DENYLIST CLEAN (no retired names in compile output).'' "')
$out.Add('if errorlevel 1 exit /b 6')
$out.Add('')
$out.Add(':postcheck')
$out.Add('rem post-compile re-assert: the modlist must be byte-identical across the whole run')
$out.Add($snapCmd[1])
$out.Add('if errorlevel 1 goto :assertfail')
$out.Add('fc.exe /b "%BASE%" "%SNAP%" >nul 2>&1')
$out.Add('if errorlevel 1 goto :modlistchanged')
$out.Add('echo MODLIST ASSERTION CLEAN (compile leg).')
$out.Add('echo COMPILE 13/13 0/0 (canonical island, REV-135 OUT). DENYLIST CLEAN.')
$out.Add('endlocal')

Set-Content -LiteralPath $bat -Value $out -Encoding ASCII
Write-Output ('WROTE ' + $bat)

# run it; tee to receipt
cmd /c "`"$bat`" > `"$rcpt`" 2>&1"
$code = $LASTEXITCODE
Write-Output ('WRAPPER EXIT CODE: ' + $code)
Get-Content -LiteralPath $rcpt | Select-Object -Last 40 | ForEach-Object { $_ }