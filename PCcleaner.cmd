@echo off
title Ultimate PC-Tuning


:: Adminrechte prüfen
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo [!] Bitte als Administrator ausfuehren!
    pause
    exit
)

:: Schnellstart
echo ###############################################
echo ####   STARTE ULTIMATIVE SYSTEMOPTIMIERUNG ####
echo ###############################################

:: [1] TEMP-Dateien löschen
echo [1] TEMP-Dateien loeschen...
del /s /f /q %temp%\* >nul
del /s /f /q C:\Windows\Temp\* >nul

:: [2] DNS-Cache löschen
echo [2] DNS-Cache leeren...
ipconfig /flushdns

:: [3] Windows Update-Cache löschen
echo [3] Windows Update Cache loeschen...
net stop wuauserv >nul
net stop bits >nul
rd /s /q %windir%\SoftwareDistribution
net start wuauserv >nul
net start bits >nul

:: [4] Cleanmgr vorbereiten und ausführen
echo [4] Datentraegerbereinigung vorbereiten...
cleanmgr /sageset:1 >nul
cleanmgr /sagerun:1 >nul

:: [5] Systemdateien prüfen
echo [5] Systemdateien pruefen (sfc)...
sfc /scannow

:: [6] CHKDSK planen
echo [6] CHKDSK planen (wird beim Neustart ausgefuehrt)...
echo y | chkdsk C: /F /R

:: [7] HDD Defragmentierung
echo [7] Defragmentierung starten...
defrag C: /O

:: [8] Autostarts anzeigen (manuell prüfen)
echo [8] Autostarts anzeigen...
wmic startup get caption,command

:: [9] Überflüssige Apps entfernen
echo [9] Unerwuenschte Windows-Apps entfernen...
PowerShell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *zune* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *bing* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *solitaire* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *skype* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *getstarted* | Remove-AppxPackage"

:: [10] Xbox-Dienste deaktivieren
echo [10] Xbox Dienste deaktivieren...
PowerShell -Command "Stop-Service XboxGipSvc -ErrorAction SilentlyContinue"
PowerShell -Command "Set-Service XboxGipSvc -StartupType Disabled"

:: [11] Telemetrie deaktivieren
echo [11] Telemetrie deaktivieren...
sc stop DiagTrack
sc config DiagTrack start= disabled
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

:: [12] Weitere überflüssige Dienste deaktivieren
echo [12] Weitere nicht benoetigte Dienste deaktivieren...
sc config XblAuthManager start= disabled
sc config XblGameSave start= disabled
sc config WMPNetworkSvc start= disabled

:: [13] Energieprofil auf „Ultimative Leistung“ setzen
echo [13] Energieprofil auf ULTIMATIVE LEISTUNG setzen...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
echo Energieprofil wurde gesetzt.

:: [14] Windows-Animationen deaktivieren
echo [14] Windows-Animationen & visuelle Effekte deaktivieren...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f

:: Fertig
echo.
echo ################################################
echo ## ✅ PC-Optimierung abgeschlossen. Neustart empfohlen! ##
echo ################################################
pause
exit
