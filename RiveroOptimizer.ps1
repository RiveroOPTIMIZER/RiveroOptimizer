
# ============================================================
# RIVERO OPTIMIZER
# Version: 0.1.0
# Windows Performance Toolkit
# Inspired by Chris Titus Tech WinUtil and Sophia Script
# Original authors and licenses must be respected.
# ============================================================

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$script:RiveroVersion = "0.1.0"
$script:RiveroBackupPath = Join-Path $env:ProgramData "RiveroOptimizer\Backups"

function Test-RiveroAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

function Get-RiveroSystemInfo {
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor
    $computer = Get-CimInstance Win32_ComputerSystem
    $gpu = Get-CimInstance Win32_VideoController

    [PSCustomObject]@{
        Windows = $os.Caption
        Version = $os.Version
        Build = $os.BuildNumber
        CPU = ($cpu.Name -join ", ")
        RAM_GB = [math]::Round(
            $computer.TotalPhysicalMemory / 1GB, 2
        )
        GPU = ($gpu.Name -join ", ")
        Architecture = $os.OSArchitecture
        PowerShell = $PSVersionTable.PSVersion.ToString()
    }
}

function Initialize-RiveroBackup {
    if (-not (Test-Path $script:RiveroBackupPath)) {
        New-Item -ItemType Directory `
            -Path $script:RiveroBackupPath -Force | Out-Null
    }
}

function New-RiveroBackup {
    Initialize-RiveroBackup

    $file = Join-Path $script:RiveroBackupPath (
        "SystemInfo_{0}.json" -f (Get-Date -Format "yyyyMMdd_HHmmss")
    )

    $info = Get-RiveroSystemInfo

    $info | ConvertTo-Json -Depth 5 |
        Set-Content -Path $file -Encoding UTF8

    return $file
}

function Write-RiveroLog {
    param([string]$Message)

    Initialize-RiveroBackup

    $log = Join-Path $script:RiveroBackupPath "Rivero.log"

    Add-Content -Path $log -Value (
        "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    )
}

function Show-RiveroInfo {
    $info = Get-RiveroSystemInfo

    $message = @"
WINDOWS: $($info.Windows)
VERSION: $($info.Version)
BUILD: $($info.Build)

CPU: $($info.CPU)
RAM: $($info.RAM_GB) GB
GPU: $($info.GPU)

ARQUITECTURA: $($info.Architecture)
POWERSHELL: $($info.PowerShell)
"@

    [System.Windows.Forms.MessageBox]::Show(
        $message,
        "RIVERO OPTIMIZER - SYSTEM INFO",
        "OK",
        "Information"
    ) | Out-Null
}

function Show-RiveroWindow {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "RIVERO OPTIMIZER v$script:RiveroVersion"
    $form.Size = New-Object System.Drawing.Size(850, 600)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(15, 20, 30)
    $form.ForeColor = [System.Drawing.Color]::White

    $title = New-Object System.Windows.Forms.Label
    $title.Text = "RIVERO OPTIMIZER"
    $title.Font = New-Object System.Drawing.Font("Segoe UI", 23, [System.Drawing.FontStyle]::Bold)
    $title.ForeColor = [System.Drawing.Color]::FromArgb(56, 189, 248)
    $title.Location = New-Object System.Drawing.Point(25, 20)
    $title.Size = New-Object System.Drawing.Size(500, 45)
    $form.Controls.Add($title)

    $subtitle = New-Object System.Windows.Forms.Label
    $subtitle.Text = "WINDOWS PERFORMANCE TOOLKIT"
    $subtitle.Location = New-Object System.Drawing.Point(30, 70)
    $subtitle.Size = New-Object System.Drawing.Size(500, 25)
    $subtitle.ForeColor = [System.Drawing.Color]::Silver
    $form.Controls.Add($subtitle)

    $modeLabel = New-Object System.Windows.Forms.Label
    $modeLabel.Text = "SELECT OPTIMIZATION MODE"
    $modeLabel.Location = New-Object System.Drawing.Point(30, 125)
    $modeLabel.Size = New-Object System.Drawing.Size(300, 25)
    $form.Controls.Add($modeLabel)

    $mode = New-Object System.Windows.Forms.ComboBox
    $mode.Location = New-Object System.Drawing.Point(30, 155)
    $mode.Size = New-Object System.Drawing.Size(300, 35)
    $mode.DropDownStyle = "DropDownList"
    [void]$mode.Items.Add("STANDARD")
    [void]$mode.Items.Add("AGGRESSIVE")
    [void]$mode.Items.Add("EXPERT")
    $mode.SelectedIndex = 0
    $form.Controls.Add($mode)

    $tweaks = New-Object System.Windows.Forms.Label
    $tweaks.Text = "TWEAKS"
    $tweaks.Font = New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Bold)
    $tweaks.Location = New-Object System.Drawing.Point(30, 220)
    $tweaks.Size = New-Object System.Drawing.Size(300, 35)
    $form.Controls.Add($tweaks)

    $infoButton = New-Object System.Windows.Forms.Button
    $infoButton.Text = "SYSTEM INFORMATION"
    $infoButton.Location = New-Object System.Drawing.Point(30, 275)
    $infoButton.Size = New-Object System.Drawing.Size(220, 45)
    $form.Controls.Add($infoButton)
    $infoButton.Add_Click({ Show-RiveroInfo })

    $backupButton = New-Object System.Windows.Forms.Button
    $backupButton.Text = "CREATE BACKUP"
    $backupButton.Location = New-Object System.Drawing.Point(30, 335)
    $backupButton.Size = New-Object System.Drawing.Size(220, 45)
    $form.Controls.Add($backupButton)

    $backupButton.Add_Click({
        try {
            $path = New-RiveroBackup
            Write-RiveroLog "System information backup created."
            [System.Windows.Forms.MessageBox]::Show(
                "Backup created:`n$path",
                "RIVERO RESTORE",
                "OK",
                "Information"
            ) | Out-Null
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show(
                $_.Exception.Message,
                "BACKUP ERROR",
                "OK",
                "Error"
            ) | Out-Null
        }
    })

    $restoreButton = New-Object System.Windows.Forms.Button
    $restoreButton.Text = "RESTORE CENTER"
    $restoreButton.Location = New-Object System.Drawing.Point(30, 395)
    $restoreButton.Size = New-Object System.Drawing.Size(220, 45)
    $form.Controls.Add($restoreButton)

    $restoreButton.Add_Click({
        [System.Windows.Forms.MessageBox]::Show(
            "The full restore engine will be added after the backup and change tracking modules are implemented.",
            "RIVERO RESTORE",
            "OK",
            "Information"
        ) | Out-Null
    })

    $status = New-Object System.Windows.Forms.Label
    $status.Text = "CORE ENGINE INITIALIZED - SAFE DIAGNOSTIC MODE"
    $status.Location = New-Object System.Drawing.Point(30, 510)
    $status.Size = New-Object System.Drawing.Size(750, 25)
    $status.ForeColor = [System.Drawing.Color]::LightGreen
    $form.Controls.Add($status)

    [void]$form.ShowDialog()
}

try {
    Show-RiveroWindow
}
catch {
    [System.Windows.Forms.MessageBox]::Show(
        $_.Exception.Message,
        "RIVERO OPTIMIZER ERROR",
        "OK",
        "Error"
    ) | Out-Null
}
