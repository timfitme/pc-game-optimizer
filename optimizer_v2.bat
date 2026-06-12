@echo off
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Run as Administrator!
    pause
    exit /b
)

echo.
echo  +==========================================+
echo  ^|        PC Game Optimizer v2.0            ^|
echo  ^|   Level 2 + 3  /  Universal              ^|
echo  +==========================================+
echo.

:: ==========================================
:: BLOCK 1 - DISABLE UNNECESSARY WINDOWS SERVICES
:: ==========================================
echo [1/8] Disabling unnecessary Windows services...

for %%s in (
    SysMain
    WSearch
    DiagTrack
    dmwappushservice
    RetailDemo
    MapsBroker
    PhoneSvc
    PrintNotify
    Fax
    XblAuthManager
    XblGameSave
    XboxNetApiSvc
    XboxGipSvc
    wisvc
    wbiosrvc
    WbioSrvc
    RemoteRegistry
    TrkWks
    WMPNetworkSvc
) do (
    sc stop %%s >nul 2>&1
    sc config %%s start= disabled >nul 2>&1
)

echo     [OK] Services disabled

:: ==========================================
:: BLOCK 2 - VISUAL EFFECTS
:: ==========================================
echo [2/8] Disabling visual effects...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d "0" /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v AlwaysHibernateThumbnails /t REG_DWORD /d 0 /f >nul

echo     [OK] Visual effects disabled

:: ==========================================
:: BLOCK 3 - MSI MODE (reduces latency)
:: ==========================================
echo [3/8] Configuring MSI Mode for devices...

for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /k /f "MSISupported" 2^>nul ^| findstr "HKEY"') do (
    reg add "%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v MSISupported /t REG_DWORD /d 1 /f >nul 2>&1
)

echo     [OK] MSI Mode applied

:: ==========================================
:: BLOCK 4 - TIMERS AND SCHEDULER
:: ==========================================
echo [4/8] Configuring system timers...

bcdedit /set useplatformtick yes >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1

:: Scheduler priorities for games
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d High /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d High /f >nul

echo     [OK] Timers configured

:: ==========================================
:: BLOCK 5 - POWER PLAN (custom)
:: ==========================================
echo [5/8] Applying custom power plan...

powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -h off >nul
powercfg -change -standby-timeout-ac 0 >nul
powercfg -change -hibernate-timeout-ac 0 >nul
powercfg -change -monitor-timeout-ac 0 >nul

:: CPU - minimum 100% on high performance
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg -setactive SCHEME_CURRENT >nul

echo     [OK] Power plan applied

:: ==========================================
:: BLOCK 6 - NETWORK (Nagle, TCP, DNS)
:: ==========================================
echo [6/8] Network optimization...

netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global chimney=disabled >nul
netsh int tcp set global ecncapability=disabled >nul
netsh int tcp set global timestamps=disabled >nul
netsh int tcp set supplemental internet congestionprovider=ctcp >nul 2>&1

for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /k /f "" 2^>nul ^| findstr "HKEY"') do (
    reg add "%%i" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%i" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
)

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheTtl /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxNegativeCacheTtl /t REG_DWORD /d 0 /f >nul

echo     [OK] Network optimized

:: ==========================================
:: BLOCK 7 - GAME MODE AND GPU
:: ==========================================
echo [7/8] Configuring Game Mode and GPU...

reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul

:: Hardware-accelerated GPU scheduling (Windows 10 2004+)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul

:: Variable Refresh Rate
reg add "HKCU\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v DirectXUserGlobalSettings /t REG_SZ /d "VRROptimizeEnable=1;" /f >nul

echo     [OK] GPU configured

:: ==========================================
:: BLOCK 8 - LEVEL 3: Spectre/Meltdown OFF
:: ==========================================
echo [8/8] Level 3: Disabling Spectre/Meltdown patches...
echo       (+5-10%% CPU, especially on older CPUs)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f >nul

echo     [OK] Patches disabled

:: ==========================================
echo.
echo  +==========================================+
echo  ^|   Done! Restart your PC for effect.     ^|
echo  +==========================================+
echo.
pause
