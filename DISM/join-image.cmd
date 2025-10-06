@echo off
REM Replace C:\images with your directory

dism /export-image /sourceimagefile:c:\images\install.swm /swmfile:c:\images\install*.swm /sourceindex:1 /destinationimagefile:c:\images\install.wim
