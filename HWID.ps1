Clear-Host
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "      VERIFICADOR DE HWID (POWERSHELL)    " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1] PLACA MAE (O SEU ALVO PRINCIPAL)" -ForegroundColor Yellow
Get-CimInstance Win32_BaseBoard | Format-List SerialNumber, Manufacturer, Product

Write-Host "[2] BIOS" -ForegroundColor Yellow
Get-CimInstance Win32_BIOS | Format-List SerialNumber, Manufacturer

Write-Host "[3] UUID DO SISTEMA" -ForegroundColor Yellow
Get-CimInstance Win32_ComputerSystemProduct | Format-List UUID

Write-Host "[4] DISCO (HD/SSD)" -ForegroundColor Yellow
Get-CimInstance Win32_DiskDrive | Format-List Model, SerialNumber

Write-Host "[5] ENDERECO MAC" -ForegroundColor Yellow
Get-NetAdapter | Select-Object Name, MacAddress, Status | Format-Table -AutoSize

Read-Host "Pressione ENTER para sair..."