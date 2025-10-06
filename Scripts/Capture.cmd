@echo off
setlocal enabledelayedexpansion
cls
diskpart /s X:\listvolume.txt
echo ===============================================
echo      Capture Image
echo ===============================================
echo.
set /p sourceDrive=Enter the letter of the drive to CAPTURE (e.g., C): 
set /p destDrive=Enter the letter of the drive to SAVE the image to (e.g., E): 
set /p imageName=Enter a descriptive name for the image (e.g., "Windows 11 Master"): 

cls
echo ===========================================
echo  Please confirm the following details:
echo ===========================================
echo.
echo  Capturing FROM:   %sourceDrive%:\
echo  Saving TO:        %destDrive%:\Images\Image.wim
echo  Image Name:     "%imageName%"
echo.
echo ===========================================
pause

if not exist %destDrive%:\Images mkdir %destDrive%:\Images

echo.
echo Starting image capture...
DISM /Capture-Image /ImageFile:%destDrive%:\Images\Install.wim /CaptureDir:%sourceDrive%:\ /Name:"%imageName%" /Compress:max /CheckIntegrity
echo.
echo --- Capture process finished. ---

rem //--- NEW SECTION: Ask the user if they want to split the image ---//
echo.
set /p splitChoice="Do you want to split this image into smaller files (for FAT32 drives)? (Y/N): "
if /i "%splitChoice%"=="Y" (
    echo.
    set splitSize=4000
    set /p splitSize=Enter the max file size in MB [Default is 4000]: 
    echo --- Splitting image with max size !splitSize! MB... ---
    DISM /Split-Image /ImageFile:%destDrive%:\Images\Install.wim /SWMFile:%destDrive%:\Images\Install.swm /FileSize:!splitSize! /checkintegrity
    echo.
    echo --- Image splitting complete. ---
    echo.
    set /p deleteImageFile="Do you want to delete the original WIM file? (Y/N): "
		if /i "!deleteImageFile!"=="Y" (
		    echo.
		    echo --- Deleting source .wim file... ---
		    DEL /p /f %destDrive%:\Images\Install.wim
		    echo --- Source .wim file has been deleted.
		    echo.
		) else (
		    echo original WIM file will not be touched
		)
) else (
    echo.
)
echo.
endlocal
pause