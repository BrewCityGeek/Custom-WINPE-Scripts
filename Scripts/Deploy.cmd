@echo off
cls
color 4f
rem diskpart /s X:\listvolume.txt
echo ===============================================
echo      Deploy Image
echo ===============================================
echo.
rem echo Before proceeding, use diskpart to identify the disk number
rem echo you want to deploy to (e.g., 0 for the first internal disk).
rem echo.
rem set /p targetDiskNum=Enter the DISK NUMBER to be wiped and deployed to (e.g., 0):
rem set /p sourceDrive=Enter the letter of the drive containing the image files (e.g., E):
rem cls

rem echo.
echo  Please select an option:
echo.
echo  1. Deploy the Base 21H2 Image
echo  2. Deploy the WS620 21H2 Image
echo  3. Deploy the WS650 21H2 Image
echo  4. Return to main menu
echo.
echo ===============================================
set /p choice="Enter your choice (1, 2, 3, or 4): "

if "%choice%"=="1" goto BASE
if "%choice%"=="2" goto 620
if "%choice%"=="3" goto 650
if "%choice%"=="4" goto EOF

cls
:BASE
echo ===========================================
rem echo  WARNING: DISK %targetDiskNum% WILL BE COMPLETELY ERASED.
echo  WARNING: DISK 0 WILL BE COMPLETELY ERASED.
echo ===========================================
echo.
echo  Image Source:   %~d0\RecoveryBase21H2
rem echo  Target Disk:    Disk %targetDiskNum%
echo  Target Disk:    Disk 0
echo.
echo ===========================================
echo  Press Ctrl+C to abort, or any other key to continue.
pause
echo.
rem echo --- Partitioning Disk %targetDiskNum%... ---
echo --- Partitioning Disk 0... ---
diskpart /s X:\nuke.txt
echo.
echo --- Copying recovery files... ---
call %~dp0\Recovery.cmd /21H2
echo.
echo --- Applying image from %~d0\RecoveryBase21H2... ---
DISM /Apply-Image /ImageFile:R:\Recovery\install.swm /SWMFile:R:\Recovery\install*.swm /Index:1 /ApplyDir:W:\ /checkintegrity
rem DISM /Apply-Image /ImageFile:%sourceDrive%:\RecoveryBase21H2\install.swm /SWMFile:%sourceDrive%:\RecoveryBase21H2\install*.swm /Index:1 /ApplyDir:W:\ /checkintegrity

echo.
echo --- Creating boot files... ---
bcdboot W:\Windows /s S: /f UEFI
echo.
echo --- Configuring Windows OS to 'see' the recovery image location... ---
rem === In the System partition, set the location of the Windows partition ===
reagentc /setosimage /path R:\Recovery /target W:\Windows /index 1
rem // Point the offline Windows OS to the new recovery image location
reagentc.exe /setreimage /path T:\Recovery\WindowsRE /target W:\Windows
rem // Enable the recovery environment
reagentc.exe /enable /target W:\Windows
echo.
echo --- Deployment finished! Returning to the menu... ---
choice /c 1 /n /t 5 /d 1 > nul
goto EOF

:620
echo ===========================================
rem echo  WARNING: DISK %targetDiskNum% WILL BE COMPLETELY ERASED.
echo  WARNING: DISK 0 WILL BE COMPLETELY ERASED.
echo ===========================================
echo.
echo  Image Source:   %~d0\Recovery620
rem echo  Target Disk:    Disk %targetDiskNum%
echo  Target Disk:    Disk 0
echo.
echo ===========================================
echo  Press Ctrl+C to abort, or any other key to continue.
pause
echo.
rem echo --- Partitioning Disk %targetDiskNum%... ---
echo --- Partitioning Disk 0... ---
diskpart /s X:\nuke.txt
echo.
echo --- Copying recovery files... ---
call %~dp0\Recovery.cmd /620
echo.
echo --- Applying image from %~d0\Recovery620... ---
DISM /Apply-Image /ImageFile:R:\Recovery\install.swm /SWMFile:R:\Recovery\install*.swm /Index:1 /ApplyDir:W:\ /checkintegrity
rem DISM /Apply-Image /ImageFile:%sourceDrive%:\RecoveryBase21H2\install.swm /SWMFile:%sourceDrive%:\RecoveryBase21H2\install*.swm /Index:1 /ApplyDir:W:\ /checkintegrity

echo.
echo --- Creating boot files... ---
bcdboot W:\Windows /s S: /f UEFI
echo.
echo --- Configuring Windows OS to 'see' the recovery image location... ---
rem === In the System partition, set the location of the Windows partition ===
reagentc /setosimage /path R:\Recovery /target W:\Windows /index 1
rem // Point the offline Windows OS to the new recovery image location
reagentc.exe /setreimage /path T:\Recovery\WindowsRE /target W:\Windows
rem // Enable the recovery environment
reagentc.exe /enable /target W:\Windows
echo.
echo --- Deployment finished! Returning to the menu... ---
choice /c 1 /n /t 5 /d 1 > nul
goto EOF

:650
echo ===========================================
rem echo  WARNING: DISK %targetDiskNum% WILL BE COMPLETELY ERASED.
echo  WARNING: DISK 0 WILL BE COMPLETELY ERASED.
echo ===========================================
echo.
echo  Image Source:   %~d0\Recovery650
rem echo  Target Disk:    Disk %targetDiskNum%
echo  Target Disk:    Disk 0
echo.
echo ===========================================
echo  Press Ctrl+C to abort, or any other key to continue.
pause
echo.
rem echo --- Partitioning Disk %targetDiskNum%... ---
echo --- Partitioning Disk 0... ---
diskpart /s X:\nuke.txt
echo.
echo --- Copying recovery files... ---
call %~dp0\Recovery.cmd /650
echo.
echo --- Applying image from %~d0\Recovery650... ---
DISM /Apply-Image /ImageFile:R:\Recovery\install.swm /SWMFile:R:\Recovery\install*.swm /Index:1 /ApplyDir:W:\ /checkintegrity
rem DISM /Apply-Image /ImageFile:%sourceDrive%:\RecoveryBase21H2\install.swm /SWMFile:%sourceDrive%:\RecoveryBase21H2\install*.swm /Index:1 /ApplyDir:W:\ /checkintegrity

echo.
echo --- Creating boot files... ---
bcdboot W:\Windows /s S: /f UEFI

echo.
echo --- Configuring Windows OS to 'see' the recovery image location... ---
rem === In the System partition, set the location of the Windows partition ===
reagentc /setosimage /path R:\Recovery /target W:\Windows /index 1
rem // Point the offline Windows OS to the new recovery image location
reagentc.exe /setreimage /path T:\Recovery\WindowsRE /target W:\Windows
rem // Enable the recovery environment
reagentc.exe /enable /target W:\Windows
echo.
echo --- Deployment finished! Returning to the menu... ---
choice /c 1 /n /t 5 /d 1 > nul
goto EOF

:EOF
call %~dp0\Menu.cmd /reboot