# Rivero Optimizer - reversible, allow-listed Windows preferences
# Windows PowerShell 5.1+. Changes are limited to the current user's Game Bar preferences.

function Get-RiveroGameModeBackupPath {
    $directory = Join-Path $env:LOCALAPPDATA 'RiveroOptimizer\Backups'
    if (-not (Test-Path -LiteralPath $directory)) {
        New-Item -Path $directory -ItemType Directory -Force | Out-Null
    }
    Join-Path $directory 'game-mode.json'
}

function Invoke-RiveroReversibleTweak {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('PC-GAME-MODE')]
        [string]$Id
    )

    $registryPath = 'HKCU:\Software\Microsoft\GameBar'
    $valueNames = @('AutoGameModeEnabled', 'AllowAutoGameMode')
    $backupPath = Get-RiveroGameModeBackupPath

    if (Test-Path -LiteralPath $backupPath) {
        throw 'Ya existe una copia de seguridad del Modo Juego. Deshaz el cambio anterior antes de aplicarlo otra vez.'
    }

    $values = @()
    $keyExists = Test-Path -LiteralPath $registryPath
    foreach ($name in $valueNames) {
        $exists = $false
        $value = $null
        if ($keyExists) {
            $key = Get-ItemProperty -LiteralPath $registryPath -ErrorAction Stop
            $property = $key.PSObject.Properties[$name]
            if ($null -ne $property) {
                $exists = $true
                $value = [int]$property.Value
            }
        }
        $values += [pscustomobject]@{ Name = $name; Existed = $exists; Value = $value }
    }

    $backup = [pscustomobject]@{
        Id = $Id
        RegistryPath = $registryPath
        KeyExisted = $keyExists
        Values = $values
        CreatedUtc = [DateTime]::UtcNow.ToString('o')
    }
    $backup | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $backupPath -Encoding UTF8

    try {
        if ($PSCmdlet.ShouldProcess('Configuración del usuario actual', 'Activar Modo Juego de Windows')) {
            if (-not $keyExists) {
                New-Item -Path $registryPath -Force | Out-Null
            }
            foreach ($name in $valueNames) {
                New-ItemProperty -LiteralPath $registryPath -Name $name -PropertyType DWord -Value 1 -Force | Out-Null
            }
        }
        else {
            Remove-Item -LiteralPath $backupPath -Force -ErrorAction SilentlyContinue
            return [pscustomobject]@{ Id = $Id; Status = 'WHATIF'; Details = @('No se modificó Windows.') }
        }
    }
    catch {
        Remove-Item -LiteralPath $backupPath -Force -ErrorAction SilentlyContinue
        throw
    }

    [pscustomobject]@{
        Id = $Id
        Status = 'APPLIED'
        Details = @('Modo Juego habilitado para el usuario actual.', 'Se guardó una copia para poder deshacer el cambio.', 'Puede ser necesario cerrar y volver a abrir el juego para notar el cambio.')
    }
}

function Undo-RiveroReversibleTweak {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('PC-GAME-MODE')]
        [string]$Id
    )

    $backupPath = Get-RiveroGameModeBackupPath
    if (-not (Test-Path -LiteralPath $backupPath -PathType Leaf)) {
        throw 'No existe una copia de seguridad del Modo Juego para restaurar.'
    }

    $backup = Get-Content -LiteralPath $backupPath -Raw | ConvertFrom-Json -ErrorAction Stop
    if ($backup.Id -ne $Id -or $backup.RegistryPath -ne 'HKCU:\Software\Microsoft\GameBar') {
        throw 'La copia de seguridad no coincide con el ajuste permitido.'
    }

    if ($PSCmdlet.ShouldProcess('Configuración del usuario actual', 'Restaurar estado anterior del Modo Juego')) {
        $registryPath = [string]$backup.RegistryPath
        foreach ($entry in @($backup.Values)) {
            if ($entry.Existed) {
                if (-not (Test-Path -LiteralPath $registryPath)) {
                    New-Item -Path $registryPath -Force | Out-Null
                }
                New-ItemProperty -LiteralPath $registryPath -Name ([string]$entry.Name) -PropertyType DWord -Value ([int]$entry.Value) -Force | Out-Null
            }
            elseif (Test-Path -LiteralPath $registryPath) {
                Remove-ItemProperty -LiteralPath $registryPath -Name ([string]$entry.Name) -ErrorAction SilentlyContinue
            }
        }
        if (-not $backup.KeyExisted -and (Test-Path -LiteralPath $registryPath)) {
            $remaining = (Get-ItemProperty -LiteralPath $registryPath).PSObject.Properties |
                Where-Object { $_.Name -notlike 'PS*' }
            if (@($remaining).Count -eq 0) {
                Remove-Item -LiteralPath $registryPath -Force
            }
        }
        Remove-Item -LiteralPath $backupPath -Force
    }

    [pscustomobject]@{
        Id = $Id
        Status = 'UNDONE'
        Details = @('Se restauraron los valores anteriores del Modo Juego.')
    }
}
