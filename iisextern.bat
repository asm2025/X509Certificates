@echo off
setlocal EnableDelayedExpansion

echo Removing https://localhost:[44300~44399]/
echo And adding https://localhost:[44300~44399]/
echo Then mapping each port to 127.65.43.[1~100]

for /L %%i in (44300,1,44399) do (
	set /A c=%%i-44300+1
	echo https://127.0.0.1:%%i/ =^> https://127.65.43.!c!/

	netsh http delete urlacl url=https://localhost:%%i/
	netsh interface portproxy delete v4tov4 listenaddress=127.65.43.!c! listenport=80

	netsh http add urlacl url=https://localhost:%%i/ user=everyone
	netsh interface portproxy add v4tov4 listenaddress=127.65.43.!c! listenport=80 connectaddress=127.0.0.1 connectport=%%i 
)
