@echo off

::get hostname where this script is running
FOR /F "usebackq" %%i IN (`hostname`) DO SET HOST_NAME=%%i
::any remote server host/ip
set remoteip="www.yahoo.com" 
goto :TRYREMOTE

:TRYREMOTE
ECHO ---------------------------------START------------------------------- >> %HOST_NAME%_pingremotelog.txt
ECHO %DATE% %TIME% >> %HOST_NAME%_pingremotelog.txt
ECHO Pinging the REMOTE server.... >> %HOST_NAME%_pingremotelog.txt
PING -n 10 %remoteip% >> %HOST_NAME%_pingremotelog.txt
ECHO %DATE% %TIME% >> %HOST_NAME%_pingremotelog.txt
ECHO ---------------------------------END--------------------------------- >> %HOST_NAME%_pingremotelog.txt
IF NOT ERRORLEVEL 1 goto :TRYREMOTE
IF     ERRORLEVEL 1 goto :ERROR

:ERROR
ECHO --------------------------ERROR START--------------------------------- >> %HOST_NAME%_pingremotelog.txt
ECHO "Some Error... Not Successfully pinged to REMOTE server at %DATE% %TIME% " >> %HOST_NAME%_pingremotelog.txt
ECHO ----------------------------ERROR END--------------------------------- >> %HOST_NAME%_pingremotelog.txt