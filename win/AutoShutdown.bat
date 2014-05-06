@echo off
REM ---
REM AutoShutdown.bat
REM Shuts down Windows after a user specified interval
REM by Julian Neytchev https://github.com/dobriak
REM ---
REM How many minutes before shutdown? (Default:60)
SET MINUTES=60
SET /P MINUTES=Snooze minutes (60): %=%
REM Convert to seconds
SET /A SECONDS = 60*%MINUTES%
shutdown /s /t %SECONDS%
