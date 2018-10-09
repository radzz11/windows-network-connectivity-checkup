@echo off

::get hostname where this script is running
FOR /F "usebackq" %%i IN (`hostname`) DO SET HOST_NAME=%%i

goto :TRYGOOGLE

:TRYGOOGLE
ECHO ---------------------------------START------------------------------- >> %HOST_NAME%_pinggooglelog.txt
ECHO %DATE% %TIME% >> %HOST_NAME%_pinggooglelog.txt
ECHO Pinging the google.com.... >> %HOST_NAME%_pinggooglelog.txt
REM PING -n 10 www.google.com|find "Reply from " >NUL
PING -n 10 www.google.com  >> %HOST_NAME%_pinggooglelog.txt
ECHO %DATE% %TIME% >> %HOST_NAME%_pinggooglelog.txt
ECHO ---------------------------------END--------------------------------- >> %HOST_NAME%_pinggooglelog.txt
IF NOT ERRORLEVEL 1 goto :TRYGOOGLE
IF     ERRORLEVEL 1 goto :ERROR

:ERROR
ECHO --------------------------ERROR START--------------------------------- >> %HOST_NAME%_pinggooglelog.txt
ECHO "Some Error... Not Successfully pinged to google.com at %DATE% %TIME% " >> %HOST_NAME%_pinggooglelog.txt
ECHO ----------------------------ERROR END--------------------------------- >> %HOST_NAME%_pinggooglelog.txt
