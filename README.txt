============================================
   PC Game Optimizer v1.0
   User Guide
============================================
FILES:
──────
optimizer_v2.bat   — main script (run first)
restore_v2.bat     — reverts all changes
README.txt         — this guide
 
HOW TO RUN:
──────────────
1. Right-click on the .bat file
2. Select “Run as administrator”
3. Wait for completion (~1 minute)
4. Restart your PC
 
WHAT optimizer_v2.bat DOES:
─────────────────────────────
[1] Windows Services     — disables ~20 unnecessary background services
                         (Xbox, Search, Telemetry, Fax, etc.)
 
[2] Visual Effects — removes animations, transparency, and Aero Peek
                         frees up CPU/GPU resources
 
[3] MSI Mode           — reduces device interrupt latency
                         particularly noticeable on the network and GPU
 
[4] Timers            — disables dynamic tick, configures
                         the scheduler for gaming tasks
 
[5] Power Plan       — CPU always at 100%, no throttling,
                         sleep and hibernation disabled
 
[6] Network               — Nagle off, TCP optimization, fast DNS
                         effect: -5..15 ms ping
 
[7] GPU                — Hardware GPU Scheduling, VRR, Game Mode,
                         Game DVR disabled
 
[8] Level 3          — disabling Spectre/Meltdown patches
                         effect: +5-10% CPU on loaded tasks

ROLLBACK:
──────
Run restore_v2.bat — everything will return to the way it was.
 
COMPATIBILITY:
──────────────
Windows 10 (1903+) and Windows 11
Graphics card: any (NVIDIA / AMD / Intel)
 
NOTE:
───────────
The script does not install any third-party programs.
All changes are limited to the registry and system services.
