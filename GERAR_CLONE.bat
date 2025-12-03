@echo off
title SOLADAS CLONE SUITE V3.1 (SAFE DUMP)
color 0B
cls
echo ==========================================
echo    GERADOR DE IDENTIDADE COMPLETA (PC 1)
echo ==========================================
echo.

:: Define os caminhos dos arquivos
set "EFI_FILE=%~dp0clone_config.ini"
set "WIN_FILE=%~dp0windows_clone.ini"

:: --- VERIFICAÇÃO DE SEGURANÇA ---
if exist "%EFI_FILE%" goto ARQUIVOS_EXISTEM
if exist "%WIN_FILE%" goto ARQUIVOS_EXISTEM

:: --- SE NÃO EXISTIREM, GERA ---
goto GERAR_AGORA

:ARQUIVOS_EXISTEM
color 0E
echo [AVISO] Os arquivos de clone JA EXISTEM nesta pasta!
echo.
echo 1. clone_config.ini (Encontrado? %EFI_FILE%)
echo 2. windows_clone.ini (Encontrado? %WIN_FILE%)
echo.
echo [!] O script parou para nao sobrescrever seu backup.
echo     Se quiser gerar novos, delete os arquivos .ini antigos manualmente.
echo.
pause
exit

:GERAR_AGORA
echo [1] Arquivos limpos. Iniciando captura...
echo.

:: 1. GERA CONFIG DO EFI (PEN DRIVE)
echo [>] Capturando dados da BIOS/Placa-Mae para EFI...
powershell -NoProfile -Command ^
    "$serial = (Get-WmiObject Win32_BaseBoard).SerialNumber.Trim();" ^
    "$uuid   = (Get-WmiObject Win32_ComputerSystemProduct).UUID.Trim();" ^
    "$bios   = (Get-WmiObject Win32_BIOS).SMBIOSBIOSVersion.Trim();" ^
    "$content = '[CONFIG]' + [Environment]::NewLine + 'Mode=CLONE' + [Environment]::NewLine + 'TargetSerial=' + $serial + [Environment]::NewLine + 'TargetUUID=' + $uuid + [Environment]::NewLine + 'TargetBios=' + $bios;" ^
    "Set-Content -Path '%EFI_FILE%' -Value $content -Encoding Ascii"

:: 2. GERA CONFIG DO WINDOWS (LOADER)
echo [>] Capturando Disco e MAC para o Loader...
powershell -NoProfile -Command ^
    "$disk = (Get-WmiObject Win32_LogicalDisk -Filter \"DeviceID='C:'\").VolumeSerialNumber;" ^
    "$diskFmt = $disk.Substring(0,4) + '-' + $disk.Substring(4,4);" ^
    "$macRaw = (Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | Select-Object -First 1).MACAddress;" ^
    "$mac = $macRaw -replace ':','';" ^
    "$content = 'TargetDisk=' + $diskFmt + [Environment]::NewLine + 'TargetMAC=' + $mac;" ^
    "Set-Content -Path '%WIN_FILE%' -Value $content -Encoding Ascii"

color 0A
echo.
echo [SUCESSO] Identidade clonada e salva!
echo.
echo     [EFI]    %EFI_FILE%
echo     [LOADER] %WIN_FILE%
echo.
pause