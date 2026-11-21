BeforeAll {
    . "$PSScriptRoot/../Modules/ReversibleActions.ps1"
}

Describe 'Rivero reversible action allow-list' {
    It 'rejects action IDs outside the allow-list' {
        { Invoke-RiveroReversibleTweak -Id 'ARBITRARY-REGISTRY-CHANGE' -Confirm:$false } | Should -Throw
    }

    It 'rejects file extension actions outside the allow-list' {
        { Invoke-RiveroReversibleTweak -Id 'PC-FILE-EXTENSIONS' -Confirm:$false } | Should -Throw
    }

    It 'rejects unknown file extension undo requests' {
        { Undo-RiveroFileExtensionsTweak -Confirm:$false -WhatIf } | Should -Throw
    }

    It 'rejects undo IDs outside the allow-list' {
        { Undo-RiveroReversibleTweak -Id 'ARBITRARY-REGISTRY-CHANGE' -Confirm:$false } | Should -Throw
    }
}
