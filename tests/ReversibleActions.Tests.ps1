BeforeAll {
    . "$PSScriptRoot/../Modules/ReversibleActions.ps1"
}

Describe 'Rivero reversible action allow-list' {
    It 'rejects action IDs outside the allow-list' {
        { Invoke-RiveroReversibleTweak -Id 'ARBITRARY-REGISTRY-CHANGE' -Confirm:$false } | Should -Throw
    }

    It 'rejects undo IDs outside the allow-list' {
        { Undo-RiveroReversibleTweak -Id 'ARBITRARY-REGISTRY-CHANGE' -Confirm:$false } | Should -Throw
    }
}
