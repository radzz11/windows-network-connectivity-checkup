@echo off

::get hostname where this script is running
FOR /F "usebackq" %%i IN (`hostname`) DO SET HOST_NAME=%%i

goto :TRYGATEWAY

:TRYGATEWAY
ECHO ---------------------------------START------------------------------- >> %HOST_NAME%_pinggatewaylog.txt
ECHO %DATE% %TIME% >> %HOST_NAME%_pinggatewaylog.txt
ECHO Pinging the lan router.... >> %HOST_NAME%_pinggatewaylog.txt

ipconfig | findstr /i gateway | findstr /R [0-9] > gateway.txt

for /f "tokens=13" %%a in (gateway.txt) do @Set "DefaultGateway=%%a"
ECHO Found Gateway...Ping to.... %DefaultGateway% >> %HOST_NAME%_pinggatewaylog.txt
ECHO ping -n 10 %DefaultGateway%  >> %HOST_NAME%_pinggatewaylog.txt
ping -n 10 %DefaultGateway% >> %HOST_NAME%_pinggatewaylog.txt
ECHO %DATE% %TIME% >> %HOST_NAME%_pinggatewaylog.txt
ECHO ---------------------------------END--------------------------------- >> %HOST_NAME%_pinggatewaylog.txt
IF NOT ERRORLEVEL 1 goto :TRYGATEWAY
IF     ERRORLEVEL 1 goto :ERROR

:ERROR
ECHO --------------------------ERROR START--------------------------------- >> %HOST_NAME%_pinggatewaylog.txt
ECHO "Some Error... Not Successfully pinged to gateway at %DATE% %TIME% " >> %HOST_NAME%_pinggatewaylog.txt
ECHO ----------------------------ERROR END--------------------------------- >> %HOST_NAME%_pinggatewaylog.txt
