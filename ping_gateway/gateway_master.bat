@echo off

::get hostname where this script is running
FOR /F "usebackq" %%i IN (`hostname`) DO SET HOST_NAME=%%i

ECHO ----------------------------SCRIPT STARTED--------------------------- >> %HOST_NAME%_pinggatewaylog.txt
::start child from this master
start "ping_gateway" ping_gateway.bat
timeout /t 12 >NUL
for /f "tokens=2 delims=," %%a in ('tasklist /v /fo csv ^| findstr /i "ping_gateway"') do set "$PID=%%a"
taskkill /PID %$PID%
ECHO %DATE% %TIME% >> %HOST_NAME%_pinggatewaylog.txt

ECHO ---------------------------------END--------------------------------- >> %HOST_NAME%_pinggatewaylog.txt

ECHO ----------------------------SCRIPT ENDED----------------------------- >> %HOST_NAME%_pinggatewaylog.txt
:: REM ECHO Script ENDED >> %HOST_NAME%_pinggatewaylog.txt
:: REM taskkill /f /im ping_gateway.bat >NUL
:: REM taskkill /f /im cmd.exe >NUL
:: REM ECHO "Self-destruct..." >> %HOST_NAME%_pinggatewaylog.txt
:: REM DEL "%~f0"
exit 0
