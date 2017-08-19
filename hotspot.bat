@ECHO off

:: BatchGotAdmin
:-------------------------------------
REM  --> Credit: https://stackoverflow.com/a/10052222
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    ECHO =======================================
    ECHO Requesting administrative privileges...
    ECHO =======================================
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    ECHO UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"    

@ECHO OFF
CLS

:PROMPT
ECHO =======================================
ECHO *           Simple Hotspot            *
ECHO *                Tool                 *
ECHO =======================================
ECHO * 1. Start Hotspot                    *
ECHO * 2. Stop Hotspot                     *
ECHO * 3. View Hotspot status              *
ECHO * 4. (Re)configure Hotspot            *
ECHO * 5. Quit                             *
ECHO * 6. Credits / Repo                   *
ECHO =======================================

CHOICE /C 123456 /M "Enter your choice: "

IF ERRORLEVEL 6 GOTO Credits
IF ERRORLEVEL 5 GOTO End
IF ERRORLEVEL 4 GOTO Configure
IF ERRORLEVEL 3 GOTO Status
IF ERRORLEVEL 2 GOTO Stop
IF ERRORLEVEL 1 GOTO Start 

:Start
CLS
netsh wlan start hostednetwork
GOTO PROMPT 

:Stop
CLS
netsh wlan stop hostednetwork
GOTO PROMPT 

:Status
CLS
netsh wlan show hostednetwork
GOTO PROMPT 

:Configure
CLS
@ECHO off
set /p ssid="Enter SSID: "
set /p key="Enter Key: "
netsh wlan set hostednetwork mode=allow %ssid% key=%key%
netsh wlan show hostednetwork
GOTO PROMPT

:Credits
CLS
@ECHO off
ECHO. 
ECHO =======================================
ECHO *               CREDITS               *
ECHO =======================================
ECHO *
ECHO * UAC Permissions request: https://stackoverflow.com/a/10052222
ECHO *
ECHO * Comments/suggestions?
ECHO * Github repo: https://github.com/lauriemustafic/netsh-hotspot-tool
ECHO *
ECHO =======================================
@ECHO off
ECHO. 
PAUSE
CLS
GOTO PROMPT

:End
