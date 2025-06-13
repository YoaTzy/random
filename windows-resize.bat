@echo off

setlocal enabledelayedexpansion
mode con cp select=437 >nul

echo Checking for installer partition...
for /f "tokens=2" %%a in ('echo list vol ^| diskpart ^| findstr /i "\<installer\>"') do (
    echo Found installer volume %%a. Deleting partition...
    (echo select vol %%a & echo delete partition) | diskpart
)

echo Finding system volume to extend...
set "SystemDriveLetter=%SystemDrive:~0,1%"
set "VolumeToExtend="

for /f "tokens=2,3" %%v in ('echo list volume ^| diskpart') do (
    if /i "%%w"=="%SystemDriveLetter%" (
        set "VolumeToExtend=%%v"
    )
)

if defined VolumeToExtend (
    echo System volume found: Volume !VolumeToExtend!. Extending...
    (
        echo select volume !VolumeToExtend!
        echo extend
    ) | diskpart
    echo Extend command sent.
) else (
    echo Could not find system volume with letter %SystemDriveLetter%.
)

echo Deleting self...
del "%~f0"