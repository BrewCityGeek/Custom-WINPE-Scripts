@echo off

robocopy %~d0\Recovery\WindowsRE T:\Recovery\WindowsRE /E /COPYALL
robocopy %~d0\Recovery\WindowsRE R:\Recovery\WindowsRE /E /COPYALL
robocopy %~d0\RecoveryBoot\ R:\ /E /COPYALL
robocopy %~d0\RecoveryPPKG\ R:\RecoveryPPKG /E /COPYALL

rem //--- Check if a parameter was passed to the script ---//
if /i "%1"=="/21H2" goto 21H2
if /i "%1"=="/620" goto 620
if /i "%1"=="/650" goto 650

:21H2
robocopy %~d0\Recovery21H2\ R:\Recovery /E /COPYALL
goto EOF

:620
robocopy %~d0\Recovery620\ R:\Recovery /E /COPYALL
goto EOF

:650
robocopy %~d0\Recovery650\ R:\Recovery /E /COPYALL
goto EOF

:EOF