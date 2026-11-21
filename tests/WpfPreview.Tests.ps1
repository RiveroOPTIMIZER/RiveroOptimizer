BeforeAll {
    $script:UiPath = Join-Path $PSScriptRoot '../RiveroOptimizer-WPF-Preview.ps1'
    $script:UiSource = Get-Content -LiteralPath $script:UiPath -Raw
    $script:XamlMatch = [regex]::Match($script:UiSource, '(?s)\[xml\]\$xaml\s*=\s*@"\r?\n(.*?)\r?\n"@')
}

Describe 'Rivero WPF preview integrity' {
    It 'contains a well-formed XAML window' {
        $script:XamlMatch.Success | Should -BeTrue
        { [xml]$document = $script:XamlMatch.Groups[1].Value } | Should -Not -Throw
    }

    It 'exposes the controls required by the safe action runner' {
        [xml]$document = $script:XamlMatch.Groups[1].Value
        $names = @($document.SelectNodes('//*[@Name]') | ForEach-Object { $_.GetAttribute('Name') })
        foreach ($name in @('RunButton', 'UndoButton', 'StatusText', 'DeviceMode', 'SearchBox',
            'TweakOsInfo', 'TweakHardwareInfo', 'TweakPowerInfo', 'TweakBatteryGuide',
            'TweakThermalGuide', 'TweakPcPowerGuide', 'TweakSecurityGuide')) {
            $names | Should -Contain $name
        }
    }

    It 'loads the safe action module and keeps undo unavailable without mutations' {
        $script:UiSource | Should -Match 'Modules/SafeActions\.ps1'
        $script:UiSource | Should -Match '\$undo\.IsEnabled\s*=\s*\$false'
        $script:UiSource | Should -Match 'Invoke-RiveroTweak'
    }
}
