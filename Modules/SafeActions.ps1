# Rivero Optimizer - safe action dispatcher
# Windows PowerShell 5.1+. This module is read-only: it never changes Windows settings.

function Invoke-RiveroTweak {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Id,
        [Parameter(Mandatory)][ValidateSet('PC')][string]$Mode
    )

    switch ($Id) {
        'SYS-OS-INFO' {
            $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
            return [pscustomobject]@{
                Id = $Id; Status = 'OK'; Title = 'Información de Windows'
                Details = @("Edición: $($os.Caption)", "Versión: $($os.Version)", "Compilación: $($os.BuildNumber)")
            }
        }
        'SYS-HARDWARE-INFO' {
            $cpu = Get-CimInstance -ClassName Win32_Processor -ErrorAction Stop | Select-Object -First 1
            $computer = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
            $gpu = @(Get-CimInstance -ClassName Win32_VideoController -ErrorAction SilentlyContinue | ForEach-Object { $_.Name })
            return [pscustomobject]@{
                Id = $Id; Status = 'OK'; Title = 'Información del hardware'
                Details = @("Procesador: $($cpu.Name)", "Memoria RAM: $([math]::Round($computer.TotalPhysicalMemory / 1GB, 1)) GB", "Gráficos: $($gpu -join ', ')")
            }
        }
        'SYS-POWER-STATUS' {
            $plans = @(powercfg.exe /getactivescheme 2>&1)
            $battery = Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue | Select-Object -First 1
            $batteryText = if ($null -eq $battery) { 'No se detectó batería.' } else { "Estado de batería: $($battery.Status); carga: $($battery.EstimatedChargeRemaining)%" }
            return [pscustomobject]@{
                Id = $Id; Status = 'OK'; Title = 'Estado de energía'
                Details = @("Plan activo: $($plans -join ' ')", $batteryText)
            }
        }
        'PC-STARTUP-AUDIT' {
            $items = New-Object System.Collections.Generic.List[string]
            $runPaths = @(
                'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run',
                'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run',
                'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run'
            )
            foreach ($path in $runPaths) {
                if (Test-Path -LiteralPath $path) {
                    $properties = Get-ItemProperty -LiteralPath $path -ErrorAction SilentlyContinue
                    foreach ($property in $properties.PSObject.Properties) {
                        if ($property.Name -notlike 'PS*') {
                            $items.Add("$($property.Name): $($property.Value)")
                        }
                    }
                }
            }
            if ($items.Count -eq 0) { $items.Add('No se encontraron entradas en las claves Run consultadas.') }
            return [pscustomobject]@{
                Id = $Id; Status = 'OK'; Title = 'Análisis de programas de inicio'
                Details = $items.ToArray()
            }
        }
        'PC-POWER-GUIDE' {
            return [pscustomobject]@{
                Id = $Id; Status = 'MANUAL'; Title = 'Revisar plan de energía del PC'
                Details = @('Abre Configuración > Sistema > Energía.', 'Revisa el plan actual antes de modificarlo.', 'Rivero no fuerza automáticamente Alto rendimiento.')
            }
        }
        'SECURITY-PRESERVE' {
            return [pscustomobject]@{
                Id = $Id; Status = 'MANUAL'; Title = 'Conservar protecciones de Windows'
                Details = @('Mantén Microsoft Defender, Firewall, UAC, BitLocker, Secure Boot y Windows Update activados.')
            }
        }
        default { throw "ID de ajuste no reconocido o no permitido: $Id" }
    }
}
