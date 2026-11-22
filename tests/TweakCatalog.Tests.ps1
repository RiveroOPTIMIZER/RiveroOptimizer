<#
Tests for the Rivero catalog loader. Run with Pester 5:
Invoke-Pester ./tests/TweakCatalog.Tests.ps1
#>
BeforeAll {
    . "$PSScriptRoot/../Modules/TweakCatalog.ps1"
    $script:CatalogPath = Join-Path $PSScriptRoot '../Catalog/shared/safe-starter.json'
    $script:Catalog = Import-RiveroTweakCatalog -Path $script:CatalogPath
}

Describe 'Rivero tweak catalog' {
    It 'loads the versioned catalog' {
        $script:Catalog.schemaVersion | Should -Be 1
    }

    It 'exposes only shared and PC-specific items' {
        $items = @(Get-RiveroAvailableTweaks -Mode PC -Catalog $script:Catalog)
        ($items.id -contains 'PC-POWER-GUIDE') | Should -BeTrue
        ($items.id -contains 'SYS-OS-INFO') | Should -BeTrue
        (@($script:Catalog.tweaks | Where-Object { $_.devices -contains 'LAPTOP' }).Count) | Should -Be 0
        { Get-RiveroAvailableTweaks -Mode LAPTOP -Catalog $script:Catalog } | Should -Throw
    }

    It 'rejects laptop-targeted catalog entries' {
        $copy = Get-Content -LiteralPath $script:CatalogPath -Raw | ConvertFrom-Json
        $copy.tweaks[0].devices = @('LAPTOP')
        $tempCatalog = Join-Path $TestDrive 'laptop-catalog.json'
        $copy | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $tempCatalog -Encoding UTF8
        { Import-RiveroTweakCatalog -Path $tempCatalog } | Should -Throw
    }

    It 'includes the four implemented reversible PC preferences' {
        $reversible = @($script:Catalog.tweaks | Where-Object { $_.actionType -eq 'reversible' })
        $reversible.id | Should -Contain 'PC-FILE-EXTENSIONS'
        $reversible.id | Should -Contain 'PC-GAME-MODE'
        $reversible.id | Should -Contain 'PC-DARK-MODE'
        $reversible.id | Should -Contain 'PC-HIDDEN-FILES'
        foreach ($item in $reversible) {
            $item.devices | Should -Contain 'PC'
            $item.defaultSelected | Should -BeFalse
        }
    }

    It 'rejects entries without an explicit subcategory or device target' {
        $copy = Get-Content -LiteralPath $script:CatalogPath -Raw | ConvertFrom-Json
        $copy.tweaks[0].subcategory = ''
        $tempCatalog = Join-Path $TestDrive 'missing-subcategory.json'
        $copy | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $tempCatalog -Encoding UTF8
        { Import-RiveroTweakCatalog -Path $tempCatalog } | Should -Throw

        $copy = Get-Content -LiteralPath $script:CatalogPath -Raw | ConvertFrom-Json
        $copy.tweaks[0].devices = @()
        $tempCatalog = Join-Path $TestDrive 'missing-device.json'
        $copy | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $tempCatalog -Encoding UTF8
        { Import-RiveroTweakCatalog -Path $tempCatalog } | Should -Throw
    }

    It 'does not expose executable script payloads in the starter catalog' {
        foreach ($item in $script:Catalog.tweaks) {
            $item.actionType | Should -BeIn @('diagnostic', 'manual', 'reversible')
            $item.PSObject.Properties.Name | Should -Not -Contain 'applyScript'
            $item.PSObject.Properties.Name | Should -Not -Contain 'undoScript'
        }
    }
}
