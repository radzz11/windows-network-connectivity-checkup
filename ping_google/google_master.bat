@echo off

::get hostname where this script is running
FOR /F "usebackq" %%i IN (`hostname`) DO SET HOST_NAME=%%i

ECHO ----------------------------SCRIPT STARTED--------------------------- >> %HOST_NAME%_pinggooglelog.txt
::start child from this master
start "ping_google" ping_google.bat
timeout /t 12 >NUL
for /f "tokens=2 delims=," %%a in ('tasklist /v /fo csv ^| findstr /i "ping_google"') do set "$PID=%%a"
taskkill /PID %$PID%
ECHO %DATE% %TIME% >> %HOST_NAME%_pinggooglelog.txt
ECHO ---------------------------------END--------------------------------- >> %HOST_NAME%_pinggooglelog.txt

ECHO ----------------------------SCRIPT ENDED----------------------------- >> %HOST_NAME%_pinggooglelog.txt
:: REM ECHO Script ENDED >> %HOST_NAME%_pinggooglelog.txt
:: REM taskkill /f /im ping_google.bat >NUL
:: REM taskkill /f /im cmd.exe >NUL
:: REM ECHO "Self-destruct..." >> %HOST_NAME%_pinggooglelog.txt
:: REM DEL "%~f0"
exit 0
