@echo off
title SOLADAS CLONE SUITE (FULL DUMP)
color 0B
cls

setlocal
set "SCRIPT_DIR=%~dp0"
set "EFI_FILE=%SCRIPT_DIR%clone_config.ini"
set "WIN_FILE=%SCRIPT_DIR%windows_clone.ini"

echo ==========================================
echo    GERADOR DE IDENTIDADE COMPLETA (PC 1)
echo ==========================================
echo.
echo Salvando arquivos em: %SCRIPT_DIR%
echo.

:: 1. GERA CONFIG DO EFI
echo [1] Capturando dados da BIOS/Placa-Mae para EFI...

powershell -NoProfile -Command ^
 "$serial = (Get-WmiObject Win32_BaseBoard).SerialNumber.Trim();" ^
 "$uuid   = (Get-WmiObject Win32_ComputerSystemProduct).UUID.Trim();" ^
 "$bios   = (Get-WmiObject Win32_BIOS).SMBIOSBIOSVersion.Trim();" ^
 "$content = '[CONFIG]' + [Environment]::NewLine + 'Mode=CLONE' + [Environment]::NewLine + 'TargetSerial=' + $serial + [Environment]::NewLine + 'TargetUUID=' + $uuid + [Environment]::NewLine + 'TargetBios=' + $bios;" ^
 "Set-Content -Path '%EFI_FILE%' -Value $content -Encoding Ascii -Force"

:: 2. GERA CONFIG DO WINDOWS
echo [2] Capturando Disco e MAC para o Loader...

powershell -NoProfile -Command ^
 "$disk = (Get-WmiObject Win32_LogicalDisk -Filter \"DeviceID='C:'\").VolumeSerialNumber;" ^
 "$diskFmt = $disk.Substring(0,4) + '-' + $disk.Substring(4,4);" ^
 "$macRaw = (Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | Select-Object -First 1).MACAddress;" ^
 "$mac = $macRaw -replace ':','';" ^
 "$content = 'TargetDisk=' + $diskFmt + [Environment]::NewLine + 'TargetMAC=' + $mac;" ^
 "Set-Content -Path '%WIN_FILE%' -Value $content -Encoding Ascii -Force"

echo.
echo [SUCESSO] Arquivos gerados em:
echo     %EFI_FILE%
echo     %WIN_FILE%
echo.
pause
