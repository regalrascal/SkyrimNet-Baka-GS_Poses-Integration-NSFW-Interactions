@echo off
setlocal

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" >nul 2>&1

REM dll-source-gs reference build: vcvars64 wrapper for cmake --preset release
REM Gate 0 class: build-config only (no source changes).

set SRC=%~dp0
if "%SRC:~-1%"=="\" set SRC=%SRC:~0,-1%
set BUILD=%SRC%\build\release
set CMAKE=C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe

if exist "%BUILD%" rmdir /s /q "%BUILD%"

"%CMAKE%" --preset release --fresh

if %ERRORLEVEL% neq 0 ( echo CONFIGURE FAILED & exit /b 1 )

"%CMAKE%" --build --preset release

if %ERRORLEVEL% neq 0 ( echo BUILD FAILED & exit /b 1 )

echo BUILD SUCCEEDED