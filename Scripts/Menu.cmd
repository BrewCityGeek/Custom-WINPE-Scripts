@echo off
setlocal enabledelayedexpansion

rem //--- Check if a parameter was passed to the script ---//
if /i "%1"=="/reboot" goto AutoRebootMenu

:StandardMenu
color b0
cls
echo ===============================================
echo      Windows PE Imaging Tool
echo ===============================================
echo.
echo  Please select an option:
echo.
echo  1. Deploy an Image to this computer
echo  2. Capture an Image from this computer
echo  3. Open Command Prompt
echo  4. Reboot Computer
echo  5. Shutdown Computer
echo.
echo ===============================================
set /p choice="Enter your choice (1, 2, 3, 4, or 5): "
goto ProcessChoice

:AutoRebootMenu
rem //--- Visual Countdown Loop ---//
for /L %%s in (30,-1,1) do (
color a0
cls
echo ===============================================
echo      Windows PE Imaging Tool
echo ===============================================
echo.
echo  Please select an option:
echo.
echo  1. Deploy an Image to this computer
echo  2. Capture an Image from this computer
echo  3. Open Command Prompt
echo  4. Reboot Computer
echo  5. Shutdown Computer
echo.
echo ===============================================
echo.
echo  Deployment complete! System will reboot automatically after 30 seconds.
echo  Press a key to cancel the countdown and make a selection.
echo.
rem choice /c 12345 /t 30 /d 4 /m "Press a key to cancel the countdown and make a selection."
rem set choice=%errorlevel%
rem goto ProcessChoice

    echo | set /p=" System will reboot in %%s seconds... [Press 1, 2, 3, 4, or 5 to cancel]"

    rem // Wait for 1 second OR a keypress. /d 6 is the default if no key is pressed.
    choice /c 123456 /n /t 1 /d 6 > nul
    
    rem // If errorlevel is NOT 6, a key was pressed.
    if not !errorlevel! == 6 (
        set choice=!errorlevel!
        goto ProcessChoice
    )
    if "%%s"=="1" (
	set choice=4
	goto ProcessChoice
    )
)

:ProcessChoice
if "%choice%"=="1" call %~dp0\Deploy.cmd
if "%choice%"=="2" call %~dp0\Capture.cmd
if "%choice%"=="3" call :CMD
if "%choice%"=="4" call :REBOOT
if "%choice%"=="5" call :SHUTDOWN

goto StandardMenu

:CMD
cls
echo.
echo Opening a new command prompt...
echo Type 'exit' to return to the main menu.
echo.
cmd.exe
goto StandardMenu

:REBOOT
wpeutil reboot

:SHUTDOWN
wpeutil shutdown