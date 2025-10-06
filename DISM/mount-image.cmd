REM Replace C:\Winpe_amd64 with the path of your choosing

dism /mount-image /imagefile:C:\Winpe_amd64\boot.wim /index:1 /mountdir:C:\Winpe_amd64\mount /checkintegrity
