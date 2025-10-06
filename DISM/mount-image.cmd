@echo off
REM Replace C:\images with the path of your choosing

dism /mount-image /imagefile:C:\images\boot.wim /index:1 /mountdir:C:\images\mount /checkintegrity
