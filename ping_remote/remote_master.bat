@echo off

::get hostname where this script is running
FOR /F "usebackq" %%i IN (`hostname`) DO SET HOST_NAME=%%i
ECHO ----------------------------SCRIPT STARTED--------------------------- >> %HOST_NAME%_pingremotelog.txt

::start child from this master
start "ping_remote" ping_remote.bat
timeout /t 12 >NUL
for /f "tokens=2 delims=," %%a in ('tasklist /v /fo csv ^| findstr /i "ping_remote"') do set "$PID=%%a"
taskkill /PID %$PID%
ECHO %DATE% %TIME% >> %HOST_NAME%_pingremotelog.txt
ECHO ---------------------------------END--------------------------------- >> %HOST_NAME%_pingremotelog.txt

ECHO ----------------------------SCRIPT ENDED----------------------------- >> %HOST_NAME%_pingremotelog.txt
:: REM ECHO Script ENDED >> %HOST_NAME%_pingremotelog.txt
:: REM taskkill /f /im ping_remote.bat >NUL
:: REM taskkill /f /im cmd.exe >NUL
:: REM ECHO "Self-destruct..." >> %HOST_NAME%_pingremotelog.txt
:: REM DEL "%~f0"
exit 0

