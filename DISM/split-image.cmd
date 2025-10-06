@echo off
dism /split-image /imagefile:C:\images\install.wim /swmfile:C:\images\install.swm /filesize:4000 /checkintegrity
