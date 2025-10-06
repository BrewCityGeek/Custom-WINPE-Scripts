# Custom-WINPE-Scripts
These are custom scripts\environments that I compiled to deploy Windows 10 LTSC 21H2 to some Micros devices.

Place the Scripts folder on the root of the WinPE drive. The startnet.cmd within boot.wim will need to be modified to run the custom menu.

These were devised from the following interaction with Gemini:

You can create a custom Windows Recovery Drive that automatically runs diskpart commands and applies your split .swm image by creating a bootable Windows PE (Preinstallation Environment) drive with a custom script. Here's how you can do it:

1. Prepare Your Tools and Files
First, you'll need to gather a few things:

A USB flash drive: Make sure it's large enough to hold your split .swm files and the Windows PE environment. 8GB or larger is recommended.

Your split .swm image files: Have them ready on your computer.

The Windows Assessment and Deployment Kit (ADK): You'll need to download and install this from Microsoft's website. Make sure to install the "Deployment Tools" and the "Windows Preinstallation Environment" components.

2. Create a Bootable Windows PE Drive
Once you have the ADK installed, you can create the base for your recovery drive:

Open the Deployment and Imaging Tools Environment: Search for this in the Start menu and run it as an administrator.

Create a working directory for Windows PE: Use the following command, replacing "C:\WinPE_amd64" with your desired location:

Bash

copype amd64 C:\WinPE_amd64
Mount the Windows PE image: This will allow you to add your files to it.

Bash

Dism /Mount-Image /ImageFile:"C:\WinPE_amd64\media\sources\boot.wim" /index:1 /MountDir:"C:\WinPE_amd64\mount"
3. Add Your Image and Create the Automation Scripts
Now, you'll add your split .swm files and the scripts that will automate the recovery process.

Copy your .swm files: Create a folder inside the mounted Windows PE directory and copy your .swm files into it.

Bash

mkdir C:\WinPE_amd64\mount\Images
xcopy E:\sources\*.swm C:\WinPE_amd64\mount\Images
(Replace "E:\sources\*.swm" with the actual path to your .swm files.)

Create a diskpart script: In a text editor like Notepad, create a file named diskpart.txt. This file will contain the commands to prepare the hard drive. Here's an example that cleans the disk, creates an EFI partition, and a main partition:

select disk 0
clean
convert gpt
create partition efi size=100
format quick fs=fat32 label="System"
assign letter=s
create partition msr size=16
create partition primary
format quick fs=ntfs label="Windows"
assign letter=w
exit
Save this file.

Create the main automation script: In a text editor, create a new file and save it as startnet.cmd. This is the script that will automatically run when Windows PE boots. It will execute your diskpart script and then apply the image.

Code snippet

@echo off
rem Run the diskpart script to partition the drive
diskpart /s X:\diskpart.txt

rem Apply the split image
Dism /apply-image /imagefile:X:\Images\install.swm /SWMFile:X:\Images\install*.swm /index:1 /applydir:W:\

rem Create boot files
W:\Windows\System32\bcdboot W:\Windows /s S: /f UEFI

rem Reboot the system
wpeutil reboot
Important: Notice that the paths in startnet.cmd start with X:. This is because when you boot into Windows PE, the PE environment runs from a virtual RAM disk that is assigned the drive letter X:.

Copy the scripts to your mounted image:

Bash

copy C:\path\to\diskpart.txt C:\WinPE_amd64\mount\
copy C:\path\to\startnet.cmd C:\WinPE_amd64\mount\Windows\System32\
(Replace "C:\path\to..." with the actual paths to your script files.) The startnet.cmd file needs to be in the System32 folder to run automatically.

4. Finalize and Create the Bootable USB
Now, you'll unmount the image and create the bootable USB drive.

Unmount the Windows PE image:

Bash

Dism /Unmount-Image /MountDir:"C:\WinPE_amd64\mount" /commit
Create the bootable USB drive: Use the MakeWinPEMedia command. Replace "F:" with the drive letter of your USB flash drive.

Bash

MakeWinPEMedia /UFD C:\WinPE_amd64 F:
Now you have a bootable USB drive that, when you boot from it, will automatically partition the hard drive and apply your split Windows image. 🚀
