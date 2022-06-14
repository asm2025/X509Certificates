@echo off
setlocal EnableDelayedExpansion

for /L %%i in (44300,1,44399) do netsh http add urlacl url=https://localhost:%%i/ user=everyone
