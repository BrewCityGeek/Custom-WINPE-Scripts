@echo off
wpeinit

rem //--- Find the USB drive by looking for the Scripts folder ---//
for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%i:\Scripts\Menu.cmd ( set USBDrive=%%i:)

echo %USBDrive%

rem //--- Run the main menu script ---//
call "%USBDrive%\Scripts\Menu.cmd"
