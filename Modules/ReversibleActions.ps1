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
        # Best-effort rollback if one of the two registry writes fails.
        foreach ($entry in $values) {
            if ($entry.Existed) {
                if (-not (Test-Path -LiteralPath $registryPath)) {
                    New-Item -Path $registryPath -Force | Out-Null
                }
                New-ItemProperty -LiteralPath $registryPath -Name $entry.Name -PropertyType DWord -Value ([int]$entry.Value) -Force -ErrorAction SilentlyContinue | Out-Null
            }
            elseif (Test-Path -LiteralPath $registryPath) {
                Remove-ItemProperty -LiteralPath $registryPath -Name $entry.Name -ErrorAction SilentlyContinue
            }
        }
        if (-not $keyExists -and (Test-Path -LiteralPath $registryPath)) {
            $remaining = (Get-ItemProperty -LiteralPath $registryPath).PSObject.Properties | Where-Object { $_.Name -notlike 'PS*' }
            if (@($remaining).Count -eq 0) { Remove-Item -LiteralPath $registryPath -Force -ErrorAction SilentlyContinue }
        }
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
    $allowedNames = @('AutoGameModeEnabled', 'AllowAutoGameMode')
    if ($backup.Id -ne $Id -or $backup.RegistryPath -ne 'HKCU:\Software\Microsoft\GameBar') {
        throw 'La copia de seguridad no coincide con el ajuste permitido.'
    }
    foreach ($entry in @($backup.Values)) {
        if ($entry.Name -notin $allowedNames) {
            throw 'La copia contiene un valor de registro no permitido.'
        }
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

function Get-RiveroFileExtensionsBackupPath {
    $directory = Join-Path $env:LOCALAPPDATA 'RiveroOptimizer\Backups'
    if (-not (Test-Path -LiteralPath $directory)) {
        New-Item -Path $directory -ItemType Directory -Force | Out-Null
    }
    Join-Path $directory 'file-extensions.json'
}

function Invoke-RiveroFileExtensionsTweak {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
    param()

    $registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    $valueName = 'HideFileExt'
    $backupPath = Get-RiveroFileExtensionsBackupPath
    if (Test-Path -LiteralPath $backupPath) {
        throw 'Ya existe una copia de seguridad de las extensiones. Deshaz el cambio anterior primero.'
    }

    $keyExists = Test-Path -LiteralPath $registryPath
    $existed = $false
    $oldValue = $null
    if ($keyExists) {
        $key = Get-ItemProperty -LiteralPath $registryPath -ErrorAction Stop
        $property = $key.PSObject.Properties[$valueName]
        if ($null -ne $property) {
            $existed = $true
            $oldValue = [int]$property.Value
        }
    }

    $backup = [pscustomobject]@{
        Id = 'PC-FILE-EXTENSIONS'
        RegistryPath = $registryPath
        KeyExisted = $keyExists
        ValueName = $valueName
        Existed = $existed
        Value = $oldValue
        CreatedUtc = [DateTime]::UtcNow.ToString('o')
    }
    $backup | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $backupPath -Encoding UTF8

    try {
        if ($PSCmdlet.ShouldProcess('Explorador de archivos del usuario actual', 'Mostrar extensiones de archivo')) {
            if (-not $keyExists) { New-Item -Path $registryPath -Force | Out-Null }
            New-ItemProperty -LiteralPath $registryPath -Name $valueName -PropertyType DWord -Value 0 -Force -ErrorAction Stop | Out-Null
        }
        else {
            Remove-Item -LiteralPath $backupPath -Force -ErrorAction SilentlyContinue
            return [pscustomobject]@{ Id = 'PC-FILE-EXTENSIONS'; Status = 'WHATIF'; Details = @('No se modificó Windows.') }
        }
    }
    catch {
        if ($existed) {
            New-ItemProperty -LiteralPath $registryPath -Name $valueName -PropertyType DWord -Value $oldValue -Force -ErrorAction SilentlyContinue | Out-Null
        }
        elseif (Test-Path -LiteralPath $registryPath) {
            Remove-ItemProperty -LiteralPath $registryPath -Name $valueName -ErrorAction SilentlyContinue
        }
        Remove-Item -LiteralPath $backupPath -Force -ErrorAction SilentlyContinue
        throw
    }

    [pscustomobject]@{
        Id = 'PC-FILE-EXTENSIONS'
        Status = 'APPLIED'
        Details = @('Ahora se muestran las extensiones de archivo conocidas.', 'Se guardó una copia para deshacer el cambio.', 'Puede que debas actualizar la ventana del Explorador para verlo.')
    }
}

function Undo-RiveroFileExtensionsTweak {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
    param()

    $backupPath = Get-RiveroFileExtensionsBackupPath
    if (-not (Test-Path -LiteralPath $backupPath -PathType Leaf)) {
        throw 'No existe una copia de seguridad de las extensiones de archivo.'
    }
    $backup = Get-Content -LiteralPath $backupPath -Raw | ConvertFrom-Json -ErrorAction Stop
    if ($backup.Id -ne 'PC-FILE-EXTENSIONS' -or
        $backup.RegistryPath -ne 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -or
        $backup.ValueName -ne 'HideFileExt') {
        throw 'La copia de seguridad de extensiones no coincide con el ajuste permitido.'
    }

    if ($PSCmdlet.ShouldProcess('Explorador de archivos del usuario actual', 'Restaurar visibilidad anterior de extensiones')) {
        if ($backup.Existed) {
            if (-not (Test-Path -LiteralPath $backup.RegistryPath)) {
                New-Item -Path $backup.RegistryPath -Force | Out-Null
            }
            New-ItemProperty -LiteralPath $backup.RegistryPath -Name 'HideFileExt' -PropertyType DWord -Value ([int]$backup.Value) -Force -ErrorAction Stop | Out-Null
        }
        elseif (Test-Path -LiteralPath $backup.RegistryPath) {
            Remove-ItemProperty -LiteralPath $backup.RegistryPath -Name 'HideFileExt' -ErrorAction SilentlyContinue
        }
        if (-not $backup.KeyExisted -and (Test-Path -LiteralPath $backup.RegistryPath)) {
            $remaining = (Get-ItemProperty -LiteralPath $backup.RegistryPath).PSObject.Properties | Where-Object { $_.Name -notlike 'PS*' }
            if (@($remaining).Count -eq 0) { Remove-Item -LiteralPath $backup.RegistryPath -Force }
        }
        Remove-Item -LiteralPath $backupPath -Force
    }

    [pscustomobject]@{ Id = 'PC-FILE-EXTENSIONS'; Status = 'UNDONE'; Details = @('Se restauró la visibilidad anterior de las extensiones.') }
}


# Dark theme preference: current user only, with exact previous-value backup.
function Get-RiveroDarkModeBackupPath {
    $directory = Join-Path $env:LOCALAPPDATA 'RiveroOptimizer\Backups'
    if (-not (Test-Path -LiteralPath $directory)) {
        New-Item -Path $directory -ItemType Directory -Force | Out-Null
    }
    Join-Path $directory 'dark-mode.json'
}

function Invoke-RiveroDarkModeTweak {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
    param()

    $registryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
    $valueNames = @('AppsUseLightTheme', 'SystemUsesLightTheme')
    $backupPath = Get-RiveroDarkModeBackupPath
    if (Test-Path -LiteralPath $backupPath) {
        throw 'Ya existe una copia del modo oscuro. Deshaz el cambio anterior primero.'
    }

    $keyExists = Test-Path -LiteralPath $registryPath
    $values = @()
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
        Id = 'PC-DARK-MODE'
        RegistryPath = $registryPath
        KeyExisted = $keyExists
        Values = $values
        CreatedUtc = [DateTime]::UtcNow.ToString('o')
    }
    $backup | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $backupPath -Encoding UTF8

    try {
        if ($PSCmdlet.ShouldProcess('Tema del usuario actual', 'Activar modo oscuro de Windows')) {
            if (-not $keyExists) { New-Item -Path $registryPath -Force | Out-Null }
            foreach ($name in $valueNames) {
                New-ItemProperty -LiteralPath $registryPath -Name $name -PropertyType DWord -Value 0 -Force -ErrorAction Stop | Out-Null
            }
        }
        else {
            Remove-Item -LiteralPath $backupPath -Force -ErrorAction SilentlyContinue
            return [pscustomobject]@{ Id = 'PC-DARK-MODE'; Status = 'WHATIF'; Details = @('No se modificó Windows.') }
        }
    }
    catch {
        foreach ($entry in $values) {
            if ($entry.Existed) {
                if (-not (Test-Path -LiteralPath $registryPath)) { New-Item -Path $registryPath -Force | Out-Null }
                New-ItemProperty -LiteralPath $registryPath -Name $entry.Name -PropertyType DWord -Value ([int]$entry.Value) -Force -ErrorAction SilentlyContinue | Out-Null
            }
            elseif (Test-Path -LiteralPath $registryPath) {
                Remove-ItemProperty -LiteralPath $registryPath -Name $entry.Name -ErrorAction SilentlyContinue
            }
        }
        if (-not $keyExists -and (Test-Path -LiteralPath $registryPath)) {
            $remaining = (Get-ItemProperty -LiteralPath $registryPath).PSObject.Properties | Where-Object { $_.Name -notlike 'PS*' }
            if (@($remaining).Count -eq 0) { Remove-Item -LiteralPath $registryPath -Force -ErrorAction SilentlyContinue }
        }
        Remove-Item -LiteralPath $backupPath -Force -ErrorAction SilentlyContinue
        throw
    }

    [pscustomobject]@{
        Id = 'PC-DARK-MODE'
        Status = 'APPLIED'
        Details = @('Se activó el tema oscuro para aplicaciones y Windows en el usuario actual.', 'Se guardaron los valores anteriores para poder deshacer el cambio.')
    }
}

function Undo-RiveroDarkModeTweak {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
    param()

    $backupPath = Get-RiveroDarkModeBackupPath
    if (-not (Test-Path -LiteralPath $backupPath -PathType Leaf)) {
        throw 'No existe una copia de seguridad del modo oscuro.'
    }
    $backup = Get-Content -LiteralPath $backupPath -Raw | ConvertFrom-Json -ErrorAction Stop
    $allowedNames = @('AppsUseLightTheme', 'SystemUsesLightTheme')
    if ($backup.Id -ne 'PC-DARK-MODE' -or $backup.RegistryPath -ne 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize') {
        throw 'La copia de seguridad no coincide con el ajuste permitido.'
    }
    foreach ($entry in @($backup.Values)) {
        if ($entry.Name -notin $allowedNames) { throw 'La copia contiene un valor de registro no permitido.' }
    }

    if ($PSCmdlet.ShouldProcess('Tema del usuario actual', 'Restaurar tema anterior de Windows')) {
        $registryPath = [string]$backup.RegistryPath
        foreach ($entry in @($backup.Values)) {
            if ($entry.Existed) {
                if (-not (Test-Path -LiteralPath $registryPath)) { New-Item -Path $registryPath -Force | Out-Null }
                New-ItemProperty -LiteralPath $registryPath -Name ([string]$entry.Name) -PropertyType DWord -Value ([int]$entry.Value) -Force -ErrorAction Stop | Out-Null
            }
            elseif (Test-Path -LiteralPath $registryPath) {
                Remove-ItemProperty -LiteralPath $registryPath -Name ([string]$entry.Name) -ErrorAction SilentlyContinue
            }
        }
        if (-not $backup.KeyExisted -and (Test-Path -LiteralPath $registryPath)) {
            $remaining = (Get-ItemProperty -LiteralPath $registryPath).PSObject.Properties | Where-Object { $_.Name -notlike 'PS*' }
            if (@($remaining).Count -eq 0) { Remove-Item -LiteralPath $registryPath -Force }
        }
        Remove-Item -LiteralPath $backupPath -Force
    }

    [pscustomobject]@{ Id = 'PC-DARK-MODE'; Status = 'UNDONE'; Details = @('Se restauró el tema anterior de Windows.') }
}
