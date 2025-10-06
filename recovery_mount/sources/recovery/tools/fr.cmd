@echo off
diskpart /s X:\sources\recovery\tools\fr.txt
rem robocopy R:\Recovery\WindowsRE T:\Recovery\WindowsRE /E /COPYALL
xcopy "R:\Recovery\WindowsRE\WinRE.wim" "T:\Recovery\WindowsRE\" /C /E /H /I /Y
DISM /Apply-Image /ImageFile:R:\Recovery\install.swm /SWMFile:R:\Recovery\install*.swm /Index:1 /ApplyDir:W:\ /checkintegrity
echo.
echo --- Creating boot files... ---
bcdboot W:\Windows /s S: /f UEFI
echo.
echo --- Configuring Windows OS to 'see' the recovery image location... ---
reagentc /setosimage /path R:\Recovery /target W:\Windows /index 1
rem // Point the offline Windows OS to the new recovery image location
reagentc.exe /setreimage /path T:\Recovery\WindowsRE /target W:\Windows
rem // Enable the recovery environment
reagentc.exe /enable /target W:\Windows
echo.
echo --- Recovery finished! Rebooting... ---
choice /c 1 /n /t 5 /d 1 > nul
wpeutil reboot