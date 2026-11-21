# Tests for Rivero device profile helpers (Pester 5)
BeforeAll {
    . "$PSScriptRoot/../Modules/DeviceProfile.ps1"
}

Describe 'Get-RiveroDeviceProfile' {
    It 'respects a manual PC selection without querying hardware' {
        $result = Get-RiveroDeviceProfile -Mode PC
        $result.Mode | Should -Be 'PC'
        $result.Confidence | Should -Be 'USER'
        $result.IsPortable | Should -BeFalse
    }

    It 'respects a manual laptop selection without querying hardware' {
        $result = Get-RiveroDeviceProfile -Mode LAPTOP
        $result.Mode | Should -Be 'LAPTOP'
        $result.Confidence | Should -Be 'USER'
        $result.IsPortable | Should -BeTrue
    }
}

Describe 'Get-RiveroDeviceSafetyPolicy' {
    It 'protects Windows security components for every device' {
        foreach ($mode in @('PC', 'LAPTOP')) {
            $policy = Get-RiveroDeviceSafetyPolicy -Mode $mode
            $policy.ProtectedComponents | Should -Contain 'Microsoft Defender'
            $policy.ProtectedComponents | Should -Contain 'Firewall de Windows'
            $policy.ProtectedComponents | Should -Contain 'Windows Update'
        }
    }

    It 'blocks laptop-specific power changes' {
        $policy = Get-RiveroDeviceSafetyPolicy -Mode LAPTOP
        $policy.BlockedTweaks | Should -Contain 'Desactivar suspensión o hibernación'
        $policy.AllowAutomaticPowerPlanChanges | Should -BeFalse
    }
}
