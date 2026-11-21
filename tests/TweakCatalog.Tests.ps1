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

    It 'shows shared and laptop-only items in laptop mode' {
        $items = @(Get-RiveroAvailableTweaks -Mode LAPTOP -Catalog $script:Catalog)
        ($items.id -contains 'LAPTOP-BATTERY-GUIDE') | Should -BeTrue
        ($items.id -contains 'PC-POWER-GUIDE') | Should -BeFalse
        ($items.id -contains 'SYS-OS-INFO') | Should -BeTrue
    }

    It 'shows shared and PC-only items in PC mode' {
        $items = @(Get-RiveroAvailableTweaks -Mode PC -Catalog $script:Catalog)
        ($items.id -contains 'PC-POWER-GUIDE') | Should -BeTrue
        ($items.id -contains 'LAPTOP-BATTERY-GUIDE') | Should -BeFalse
        ($items.id -contains 'SYS-OS-INFO') | Should -BeTrue
    }

    It 'does not expose executable script payloads in the starter catalog' {
        foreach ($item in $script:Catalog.tweaks) {
            $item.actionType | Should -BeIn @('diagnostic', 'manual')
            $item.PSObject.Properties.Name | Should -Not -Contain 'applyScript'
            $item.PSObject.Properties.Name | Should -Not -Contain 'undoScript'
        }
    }
}
