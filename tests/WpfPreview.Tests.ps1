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

    It 'exposes the controls currently connected to real actions' {
        [xml]$document = $script:XamlMatch.Groups[1].Value
        $names = @(
            $document.SelectNodes('//*') | ForEach-Object {
                $_.Attributes | Where-Object { $_.LocalName -eq 'Name' } | ForEach-Object { $_.Value }
            }
        )
        foreach ($name in @('RunButton', 'UndoButton', 'StatusText', 'SearchBox',
            'TweakOsInfo', 'TweakHardwareInfo', 'TweakPowerInfo', 'TweakStartupAudit',
            'TweakPcPowerGuide', 'TweakSecurityGuide', 'TweakFileExtensions',
            'TweakGameMode', 'TweakDarkMode')) {
            $names | Should -Contain $name
        }
    }

    It 'connects each reversible preference to its apply and restore handlers' {
        $script:UiSource | Should -Match 'Modules/ReversibleActions\.ps1'
        $script:UiSource | Should -Match 'Invoke-RiveroDarkModeTweak'
        $script:UiSource | Should -Match 'Undo-RiveroDarkModeTweak'
        $script:UiSource | Should -Match 'Invoke-RiveroFileExtensionsTweak'
        $script:UiSource | Should -Match 'Undo-RiveroFileExtensionsTweak'
        $script:UiSource | Should -Match 'Invoke-RiveroReversibleTweak'
        $script:UiSource | Should -Match 'Undo-RiveroReversibleTweak'
    }

    It 'disables unfinished controls instead of presenting them as working' {
        $script:UiSource | Should -Match 'En desarrollo: todavía no ejecuta ninguna acción'
        $script:UiSource | Should -Match "'TweakDarkMode'"
    }

    It 'keeps the application limited to the PC profile' {
        $script:UiSource | Should -Match '\$selectedMode = ''PC'''
        $script:UiSource | Should -Not -Match 'Header="Laptop"'
    }
}
