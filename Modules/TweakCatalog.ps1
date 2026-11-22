<#
Rivero Optimizer - catalog loader and device filtering
Windows PowerShell 5.1+
Loads metadata only; this module does not apply system changes.
#>

function Import-RiveroTweakCatalog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "No se encontró el catálogo: $Path"
    }

    $raw = Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
    $catalog = $raw | ConvertFrom-Json -ErrorAction Stop

    if ([int]$catalog.schemaVersion -ne 1) {
        throw "Versión de catálogo no compatible: $($catalog.schemaVersion)"
    }

    $ids = @{}
    foreach ($tweak in @($catalog.tweaks)) {
        foreach ($field in @('id', 'name', 'category', 'description', 'devices', 'risk', 'actionType')) {
            if ($null -eq $tweak.$field -or [string]::IsNullOrWhiteSpace([string]$tweak.$field)) {
                throw "El ajuste '$($tweak.id)' no contiene el campo obligatorio '$field'."
            }
        }

        if ($ids.ContainsKey([string]$tweak.id)) {
            throw "ID de ajuste duplicado: $($tweak.id)"
        }
        $ids[[string]$tweak.id] = $true

        if ($tweak.actionType -notin @('diagnostic', 'manual', 'reversible')) {
            throw "Tipo de acción no permitido en este catálogo: $($tweak.actionType)"
        }

        if ($tweak.risk -notin @('low', 'medium', 'high')) {
            throw "Nivel de riesgo no válido en $($tweak.id)."
        }

        foreach ($device in @($tweak.devices)) {
            if ($device -notin @('PC', 'BOTH')) {
                throw "Compatibilidad de dispositivo no válida en $($tweak.id): $device"
            }
        }
    }

    return $catalog
}

function Get-RiveroAvailableTweaks {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('PC')]
        [string]$Mode,

        [Parameter(Mandatory)]
        [object]$Catalog
    )

    @($Catalog.tweaks | Where-Object {
        ($_.devices -contains 'BOTH') -or ($_.devices -contains $Mode)
    })
}

function Get-RiveroTweakById {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Id,
        [Parameter(Mandatory)][object]$Catalog
    )

    @($Catalog.tweaks | Where-Object { $_.id -eq $Id }) | Select-Object -First 1
}
