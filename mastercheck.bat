:: @echo off

::Get/Save hostname of windows where this script is running
FOR /F "usebackq" %%i IN (`hostname`) DO SET HOST_NAME=%%i

:: Ping the gateway & save in file %HOST_NAME%_pinggatewaylog.txt(eg mypchostname_pinggatewaylog.txt)
cd "ping_gateway"
ECHO Gateway master started %DATE% %TIME% >> %HOST_NAME%_pinggatewaylog.txt
start "gateway_master" /min  ping_gateway.bat

:: Ping to Google & save in file %HOST_NAME%_pinggatewaylog.txt(eg mypchostname_pinggooglelog.txt)
cd "..\ping_google"
ECHO Google master started %DATE% %TIME% >> %HOST_NAME%_pinggooglelog.txt
start "google_master" /min ping_google.bat

:: Ping to Particular Remote Server
cd "..\ping_remote"
ECHO Remote master started %DATE% %TIME% >> %HOST_NAME%_pingremotelog.txt
start "remote_master" /min ping_remote.bat

:: Check Download Speed Using Wget
:: cd "..\check_down_wget"
:: ECHO Wget master started %DATE% %TIME% >> %HOST_NAME%_downloadspeedwgetlog.txt
:: start "wget_master" check_down_wget.bat

:: Check Download Speed Using Curl
:: cd "..\check_download"
:: ECHO Curl master started %DATE% %TIME% >> %HOST_NAME%_downloadspeed_curl_log.txt
:: start "curl_master" check_down.bat

::Timeout for this master file to run all childs for e.g timeout /t 10800 >NUL <<-- run for 3 hours=10801 secs, 15mins = 900 secs
timeout /t 60 >NUL


:: Find & Kill Gateway Process
for /f "tokens=2 delims=," %%a in ('tasklist /v /fo csv ^| findstr /i "gateway_master"') do set "$PID1=%%a"
taskkill /PID %$PID1%
cd "..\ping_gateway"
ECHO %DATE% %TIME% >> %HOST_NAME%_pinggatewaylog.txt
ECHO ---------------------------------END--------------------------------- >> %HOST_NAME%_pinggatewaylog.txt
ECHO Gateway master ended %DATE% %TIME% >> %HOST_NAME%_pinggatewaylog.txt

:: Find & Kill Google Process
for /f "tokens=2 delims=," %%a in ('tasklist /v /fo csv ^| findstr /i "google_master"') do set "$PID2=%%a"
taskkill /PID %$PID2%  
cd "..\ping_google"
ECHO %DATE% %TIME% >> %HOST_NAME%_pinggooglelog.txt
ECHO ---------------------------------END--------------------------------- >> %HOST_NAME%_pinggooglelog.txt
ECHO Google master ended %DATE% %TIME%  >> %HOST_NAME%_pinggooglelog.txt

:: Find & Kill Remote Process
for /f "tokens=2 delims=," %%a in ('tasklist /v /fo csv ^| findstr /i "remote_master"') do set "$PID3=%%a"
taskkill /PID %$PID3%  
cd "..\ping_remote"
ECHO %DATE% %TIME% >> %HOST_NAME%_pingremotelog.txt
ECHO ---------------------------------END--------------------------------- >> %HOST_NAME%_pingremotelog.txt
ECHO Remote master ended %DATE% %TIME% >> %HOST_NAME%_pingremotelog.txt

:: Find & Kill Wget Process
:: for /f "tokens=2 delims=," %%a in ('tasklist /v /fo csv ^| findstr /i "wget_master"') do set "$PID4=%%a"
:: taskkill /PID %$PID4%  
:: cd "..\check_down"
:: ECHO %DATE% %TIME% >> %HOST_NAME%_downloadspeedwgetlog.txt
:: ECHO ---------------------------------END--------------------------------- >> %HOST_NAME%_downloadspeedwgetlog.txt
:: ECHO Wget master ended %DATE% %TIME% >> %HOST_NAME%_downloadspeedwgetlog.txt

:: Find & Kill Curl Process
:: for /f "tokens=2 delims=," %%a in ('tasklist /v /fo csv ^| findstr /i "curl_master"') do set "$PID5=%%a"
:: taskkill /PID %$PID5%  
:: cd "..\check_download"
:: ECHO %DATE% %TIME% >> %HOST_NAME%_downloadspeed_curl_log.txt
:: ECHO ---------------------------------END--------------------------------- >> %HOST_NAME%_downloadspeed_curl_log.txt
:: ECHO Curl master ended %DATE% %TIME% >> %HOST_NAME%_downloadspeed_curl_log.txt



: Get relevant log from log files start

::Enter in main directory & wait for 5 secs for log file to be ready

cd ..
timeout /t 5 >NUL

:: check windows current running version start
setlocal
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j

IF "%version%" == "10.0" ( echo Windows 10.		>>  finalreport.txt)
IF "%version%" == "6.3" ( echo Windows 8.1 		>>  finalreport.txt)
IF "%version%" == "6.2" ( echo Windows 8.		>>  finalreport.txt)
IF "%version%" == "6.1" ( echo Windows 7.		>>  finalreport.txt)
IF "%version%" == "6.0" ( echo Windows Vista. 	>>  finalreport.txt)
IF "%version%" == "5.2" ( echo Windows XP x64	>>  finalreport.txt)
IF "%version%" == "5.1" ( echo Windows XP.		>>  finalreport.txt)
:: check windows current running version  end

IF "%version%" EQU "5.1" ( goto SKIP )
IF "%version%" EQU "5.2" ( goto SKIP )
IF "%version%" EQU "6.0" ( goto SKIP )
IF "%version%" EQU "6.1" ( goto START_FINAL_REPORT )
IF "%version%" EQU "6.2" ( goto START_FINAL_REPORT )
IF "%version%" EQU "6.3" ( goto START_FINAL_REPORT )
IF "%version%" EQU "10.0" ( goto START_FINAL_REPORT )
endlocal

:START_FINAL_REPORT

:: Gateway ping report start
setlocal enabledelayedexpansion
:: You can set limits below, if ping gets above limit i.e here 2 ms to 5 ms than network status is not good / it maybe slow
set gatewaymaxping1=2
set gatewaymaxping2=5
set gatewaycounter1=0
set gatewaycounter2=0
:: Loop through log file & get count of lines having more than 2 ms and 5 ms count
for /f "tokens=5 delims=time" %%a in ('findstr "Reply From "  %cd%\ping_gateway\%HOST_NAME%_pinggatewaylog.txt ')  do (
	set str=%%a
    set str=!str:~1,5!
	IF !str! GEQ !gatewaymaxping1!	(
		set /a gatewaycounter1=gatewaycounter1+1
	)
	IF !str! GEQ !gatewaymaxping2!	(
		set /a gatewaycounter2=gatewaycounter2+1
	)
)
:: Loop through log file & get error counts of lines from file
for /f %%i in ('findstr "Request timed out Destination net unreachable General failure No Resources transmit fail"   %cd%\ping_gateway\%HOST_NAME%_pinggatewaylog.txt ^| find /v "Pinging the lan router" /c') do set gatewayfailurecount=%%i
:: Gateway ping report end

:: Google ping report start
setlocal enabledelayedexpansion
:: You can set limits below, if ping gets above limit i.e here 100 ms to 200 ms than network status is not good / it maybe slow
set maxping1=100
set maxping2=200
set googlecounter1=0
set googlecounter2=0

:: Loop through log file & get count of lines having more than 100 ms and 200 ms count
for /f "tokens=5 delims=time" %%a in ('findstr "Reply From "   %cd%\ping_google\%HOST_NAME%_pinggooglelog.txt ')  do (
	set str=%%a
    set str=!str:~1,5!
	IF !str! GEQ !maxping1!	(
		set /a googlecounter1=googlecounter1+1
	)
	IF !str! GEQ !maxping2!	(
		set /a googlecounter2=googlecounter2+1
	)
)
:: Loop through log file & get error counts of lines from file
for /f %%i in ('findstr "Request timed out Destination net unreachable General failure No Resources transmit fail"   %cd%\ping_google\%HOST_NAME%_pinggooglelog.txt ^| find /v "Pinging the lan router" /c') do set googlefailurecount=%%i
:: Google ping report end

:: Remote Server ping report start
setlocal enabledelayedexpansion
set maxping1=100
set maxping2=200
set remotecounter1=0
set remotecounter2=0
for /f "tokens=5 delims=time" %%a in ('findstr "Reply From "  %cd%\ping_remote\%HOST_NAME%_pingremotelog.txt ')  do (
	set str=%%a
	set str=!str:~1,5!
 	IF !str! GEQ !maxping1!	(
 		set /a remotecounter1=remotecounter1+1
 	)
 	IF !str! GEQ !maxping2!	(
 		set /a remotecounter2=remotecounter2+1
 	)
)
for /f %%i in ('findstr "Request timed out Destination net unreachable General failure No Resources transmit fail"   %cd%\ping_remote\%HOST_NAME%_pingremotelog.txt ^| find /v "Pinging the lan router" /c') do set remotefailurecount=%%i
:: Remote Server ping report ended


:: Download speed report start
:: for /f %%i in ('findstr "x=Error"  %cd%\check_download\%HOST_NAME%_downloadspeed_curl_log.txt ^| find /v "---0---" /c ' ) do set downloadfailurecount=%%i
:: for /f %%i in ('findstr "x=Error"  %cd%\check_download\%HOST_NAME%_downloadspeed_curl_log.txt ^| find "---0---" /c ' ) do set downloadsuccesscount=%%i
:: Download speed report ended


:: Save all high ping counters & error counters in final log file  
ECHO ---------------------------------- %HOST_NAME% user report start %DATE% %TIME% ----------------------------------   >> finalreport.txt

:: ECHO Download failure count		-- !downloadfailurecount!	 >> finalreport.txt
:: ECHO Download success count		-- !downloadsuccesscount!	 >> finalreport.txt

ECHO Gateway high ping more than !gatewaymaxping1! ms count		-- !gatewaycounter1!		(ping above !gatewaymaxping1! ms to Gateway server)  >> finalreport.txt
ECHO Gateway high ping more than !gatewaymaxping2! ms count		-- !gatewaycounter2!		(ping above !gatewaymaxping2! ms to Gateway server)  >> finalreport.txt
ECHO Gateway failure count				-- !gatewayfailurecount!		(ping error count like "Request timed out or Destination net unreachable or General failure or No Resources or Transmit fail" )  >> finalreport.txt

ECHO Google high ping more than !maxping1! ms count		-- !googlecounter1!			(ping above !maxping1! ms to Google server)  >> finalreport.txt
ECHO Google high ping more than !maxping2! ms count		-- !googlecounter2!			(ping above !maxping2! ms to Google server)  >> finalreport.txt
ECHO Google Server failure count			-- !googlefailurecount!			(ping error count like "Request timed out or Destination net unreachable or General failure or No Resources or Transmit fail" )  >> finalreport.txt

ECHO Remote Server high ping more than !maxping1! ms count		-- !remotecounter1!			(ping above !maxping1! ms to Remote Server)  >> finalreport.txt
ECHO Remote Server high ping more than !maxping2! ms count		-- !remotecounter2!			(ping above !maxping2! ms to Remote Server)  >> finalreport.txt
ECHO Remote Server failure count				-- !remotefailurecount!			(ping error count like "Request timed out or Destination net unreachable or General failure or No Resources or Transmit fail" )  >> finalreport.txt

ECHO ---------------------------------- %HOST_NAME% user report ended %DATE% %TIME% ----------------------------------   >> finalreport.txt
:: Get relevant log from log files end
exit

:SKIP
ECHO FOUND OLD WINDOWS OS (XP or Vista) RUNNING....BYE  >> finalreport.txt
exit 0

