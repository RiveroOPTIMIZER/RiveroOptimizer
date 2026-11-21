<#
Rivero Optimizer - Device profile helpers
Compatible with Windows PowerShell 5.1+
These functions only inspect hardware and classify the selected profile.
They do not change Windows settings.
#>

function Get-RiveroDeviceProfile {
    [CmdletBinding()]
    param(
        [ValidateSet('Auto', 'PC', 'LAPTOP')]
        [string]$Mode = 'Auto'
    )

    $detected = 'UNKNOWN'
    $confidence = 'LOW'
    $reason = 'No se pudo determinar el tipo de equipo con suficiente confianza.'

    if ($Mode -ne 'Auto') {
        return [pscustomobject]@{
            Mode = $Mode
            Detected = $Mode
            Confidence = 'USER'
            Reason = 'Selección manual del usuario.'
            IsPortable = ($Mode -eq 'LAPTOP')
        }
    }

    try {
        $enclosure = Get-CimInstance -ClassName Win32_SystemEnclosure -ErrorAction Stop |
            Select-Object -First 1
        $chassis = @($enclosure.ChassisTypes | ForEach-Object { [int]$_ })
        $portableTypes = @(8, 9, 10, 14, 30, 31, 32)
        $desktopTypes = @(3, 4, 5, 6, 7, 15, 16, 35, 36)

        if ($chassis | Where-Object { $_ -in $portableTypes }) {
            $detected = 'LAPTOP'
            $confidence = 'HIGH'
            $reason = 'El tipo de chasis informa un equipo portátil.'
        }
        elseif ($chassis | Where-Object { $_ -in $desktopTypes }) {
            $detected = 'PC'
            $confidence = 'HIGH'
            $reason = 'El tipo de chasis informa un equipo de escritorio.'
        }
        else {
            $battery = Get-CimInstance -ClassName Win32_Battery -ErrorAction SilentlyContinue |
                Select-Object -First 1
            if ($null -ne $battery) {
                $detected = 'LAPTOP'
                $confidence = 'MEDIUM'
                $reason = 'Se detectó una batería; confirma el modo antes de aplicar ajustes.'
            }
        }
    }
    catch {
        $reason = 'Falló la consulta de hardware. Elige PC o LAPTOP manualmente.'
    }

    [pscustomobject]@{
        Mode = $detected
        Detected = $detected
        Confidence = $confidence
        Reason = $reason
        IsPortable = ($detected -eq 'LAPTOP')
    }
}

function Get-RiveroDeviceSafetyPolicy {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('PC', 'LAPTOP')]
        [string]$Mode
    )

    $protected = @(
        'Microsoft Defender',
        'Firewall de Windows',
        'UAC',
        'BitLocker',
        'Secure Boot',
        'Windows Update',
        'Protecciones térmicas del fabricante'
    )

    $blockedForLaptop = @(
        'Desactivar suspensión o hibernación',
        'Forzar Alto rendimiento o Ultimate Performance como perfil predeterminado',
        'Desactivar ahorro de energía del adaptador inalámbrico',
        'Desactivar servicios de gestión térmica del fabricante'
    )

    [pscustomobject]@{
        DeviceMode = $Mode
        ProtectedComponents = $protected
        BlockedTweaks = if ($Mode -eq 'LAPTOP') { $blockedForLaptop } else { @() }
        AllowAutomaticPowerPlanChanges = $false
        RequiresExplicitConfirmationForDestructiveActions = $true
    }
}
