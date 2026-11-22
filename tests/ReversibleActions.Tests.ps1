BeforeAll {
    . "$PSScriptRoot/../Modules/ReversibleActions.ps1"
}

Describe 'Rivero reversible action allow-list' {
    It 'rejects action IDs outside the allow-list' {
        { Invoke-RiveroReversibleTweak -Id 'ARBITRARY-REGISTRY-CHANGE' -Confirm:$false } | Should -Throw
    }

    It 'rejects file extension actions outside the Game Mode allow-list' {
        { Invoke-RiveroReversibleTweak -Id 'PC-FILE-EXTENSIONS' -Confirm:$false } | Should -Throw
    }

    It 'refuses to restore file extensions without a backup' {
        Mock Get-RiveroFileExtensionsBackupPath { Join-Path $TestDrive 'missing-file-extensions.json' }
        { Undo-RiveroFileExtensionsTweak -Confirm:$false } | Should -Throw
    }

    It 'refuses to restore dark mode without a backup' {
        Mock Get-RiveroDarkModeBackupPath { Join-Path $TestDrive 'missing-dark-mode.json' }
        { Undo-RiveroDarkModeTweak -Confirm:$false } | Should -Throw
    }

    It 'rejects undo IDs outside the Game Mode allow-list' {
        { Undo-RiveroReversibleTweak -Id 'ARBITRARY-REGISTRY-CHANGE' -Confirm:$false } | Should -Throw
    }

    It 'exposes a dedicated allow-listed dark mode action' {
        (Get-Command Invoke-RiveroDarkModeTweak -ErrorAction Stop).Name | Should -Be 'Invoke-RiveroDarkModeTweak'
        (Get-Command Undo-RiveroDarkModeTweak -ErrorAction Stop).Name | Should -Be 'Undo-RiveroDarkModeTweak'
    }
}
