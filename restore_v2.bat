@echo off
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Run as Administrator!
    pause
    exit /b
)

echo.
echo  +==========================================+
echo  ^|     Restore default Windows settings    ^|
echo  +==========================================+
echo.

echo [1/5] Restoring services...
for %%s in (SysMain WSearch DiagTrack XblAuthManager XblGameSave XboxNetApiSvc) do (
    sc config %%s start= auto >nul 2>&1
    sc start %%s >nul 2>&1
)
echo     [OK]

echo [2/5] Restoring visual effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f >nul
echo     [OK]

echo [3/5] Restoring power plan...
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul
powercfg -h on >nul
echo     [OK]

echo [4/5] Restoring Spectre/Meltdown patches...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /f >nul 2>&1
echo     [OK]

echo [5/5] Restoring Game DVR...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul
echo     [OK]

echo.
echo  Default settings restored.
echo  Restart your PC.
echo.
pause
