@echo off
setlocal EnableDelayedExpansion

echo.
echo WARNING:
echo Before running this batch file, make sure you have got the appid of IIS Express.
echo It can be obtained by running the following command:
echo netsh http show sslcert
echo DON'T include {} in the appid, just the guid value.
echo.
SET /P CONT=Are you sure you want to continue (Y/[N])?
if /I "%CONT%" NEQ "Y" goto :eof

if "%1"=="" goto usage
if "%2"=="" goto usage
powershell -executionPolicy bypass .\iisexcert.ps1 -thumprint %1 -appid %2

:usage
echo.
echo %~n0 thumprint appid
if "%1"=="" (
	echo.
	echo Missing thumprint. This can be obtained by running:
	echo certmgr.msc ^> [Store] ^> [Open Certificate] ^> Details Tab ^> Thumprint
)

if "%2"=="" (
	echo.
	echo Missing appid. This can be obtained by running:
	echo netsh http show sslcert
	echo DON'T include {} in the appid, just the guid value.
)
