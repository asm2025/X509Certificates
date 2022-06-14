@echo off
setlocal EnableDelayedExpansion

if "%1"=="" goto usage
SET THUMB=%1
SET HOST=%2
if "%HOST%"=="" SET HOST=localhost

SET PROGRAMS=%PROGRAMFILES(x86)%
if "%PROGRAMS%"=="" SET PROGRAMS=%PROGRAMFILES%

SET iisadmin="%PROGRAMS%\IIS Express\IisExpressAdminCmd.exe"
if not exist %iisadmin% goto noiis

echo.
echo Setting up thumprint for %HOST%
for /L %%i in (44300,1,44399) do %iisadmin% setupsslUrl -url:https://%HOST%:%%i/ -CertHash:%THUMB%
echo Done
goto :eof

:noiis
echo.
echo IIS express is not found!
goto :eof

:usage
echo.
echo %~n0 thumprint
echo.
echo Missing thumprint. This can be obtained by running:
echo certmgr.msc ^> [Store] ^> [Open Certificate] ^> Details Tab ^> Thumprint
