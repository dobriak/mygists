@echo off
rem Post processing script for SABnzbd
set NASNAME=192.168.1.2
rem ping the nas just in case, exit if not online
ping %NASNAME% | find "TTL" > nul
IF ERRORLEVEL 1 GOTO ENDERROR
 
SET NASPATH=\\%NASNAME%\usb_storage\new
SET LOGFILE="%~d0%~p0\postprocessing.log"
 
echo. >> %LOGFILE%
echo %DATE% %TIME% Started processing %2 >> %LOGFILE%
echo %DATE% %TIME% ROBOCOPY /E /MOVE "%1" %NASPATH%\%~3 >> %LOGFILE%
 
ROBOCOPY /E /MOVE "%1" %NASPATH%\%~3
echo %DATE% %TIME% Finished processing %2 >> %LOGFILE%
exit 0
 
:ENDERROR
echo %DATE% %TIME% Error: Could not ping %NASNAME% , exiting. >> %LOGFILE%
exit 1
