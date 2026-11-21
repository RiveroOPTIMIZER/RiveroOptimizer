BeforeAll {
    . "$PSScriptRoot/../Modules/SafeActions.ps1"
}

Describe 'Rivero safe action dispatcher' {
    It 'rejects unknown or executable tweak IDs' {
        { Invoke-RiveroTweak -Id 'RUN-ARBITRARY-CODE' -Mode PC } | Should -Throw
    }

    It 'rejects laptop-only actions in PC mode' {
        { Invoke-RiveroTweak -Id 'LAPTOP-BATTERY-GUIDE' -Mode PC } | Should -Throw
    }

    It 'rejects PC-only actions in laptop mode' {
        { Invoke-RiveroTweak -Id 'PC-POWER-GUIDE' -Mode LAPTOP } | Should -Throw
    }

    It 'returns manual guidance for protected security settings' {
        $result = Invoke-RiveroTweak -Id 'SECURITY-PRESERVE' -Mode PC
        $result.Status | Should -Be 'MANUAL'
        ($result.Details -join ' ') | Should -Match 'Defender'
    }
}
