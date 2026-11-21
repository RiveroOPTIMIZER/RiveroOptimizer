
# ============================================================
# RIVERO OPTIMIZER
# Version: 0.2.0
# Windows Performance Toolkit
# Credits: Chris Titus Tech WinUtil / Sophia Script
# ============================================================

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$script:RiveroVersion = "0.2.0"
$script:RiveroBackupPath = Join-Path $env:ProgramData "RiveroOptimizer\Backups"
$script:DeviceMode = "AUTO"
$script:SelectedDevice = "PC"

$script:Categories = @(
    "Essential Tweaks",
    "Performance",
    "Gaming",
    "Privacy",
    "Debloat",
    "Advanced",
    "Custom"
)

function Get-RiveroDevice {
    $battery = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue

    if ($battery) {
        return "LAPTOP"
    }

    return "PC"
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
        RAM_GB = [math]::Round($computer.TotalPhysicalMemory / 1GB, 2)
        GPU = ($gpu.Name -join ", ")
        Architecture = $os.OSArchitecture
        Device = Get-RiveroDevice
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

    Get-RiveroSystemInfo |
        ConvertTo-Json -Depth 5 |
        Set-Content -Path $file -Encoding UTF8

    return $file
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

DEVICE: $($info.Device)
ARCHITECTURE: $($info.Architecture)
"@

    [System.Windows.Forms.MessageBox]::Show(
        $message,
        "RIVERO SYSTEM INFORMATION",
        "OK",
        "Information"
    ) | Out-Null
}

function Show-RiveroCategory {
    param(
        [string]$Device,
        [string]$Category,
        [string]$Profile
    )

    $message = @"
DEVICE: $Device
CATEGORY: $Category
PROFILE: $Profile

The tweak catalog will be connected in the next development stage.
No system changes have been made.
"@

    [System.Windows.Forms.MessageBox]::Show(
        $message,
        "RIVERO OPTIMIZER",
        "OK",
        "Information"
    ) | Out-Null
}

function Show-RiveroWindow {

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "RIVERO OPTIMIZER v$script:RiveroVersion"
    $form.Size = New-Object System.Drawing.Size(950, 650)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [Drawing.Color]::FromArgb(15, 20, 30)
    $form.ForeColor = [Drawing.Color]::White
    $form.FormBorderStyle = "FixedSingle"
    $form.MaximizeBox = $false

    # HEADER
    $title = New-Object Windows.Forms.Label
    $title.Text = "RIVERO OPTIMIZER"
    $title.Font = New-Object Drawing.Font(
        "Segoe UI", 24, [Drawing.FontStyle]::Bold
    )
    $title.ForeColor = [Drawing.Color]::FromArgb(56, 189, 248)
    $title.Location = New-Object Drawing.Point(25, 20)
    $title.Size = New-Object Drawing.Size(500, 45)
    $form.Controls.Add($title)

    $subtitle = New-Object Windows.Forms.Label
    $subtitle.Text = "WINDOWS PERFORMANCE TOOLKIT"
    $subtitle.Location = New-Object Drawing.Point(30, 70)
    $subtitle.Size = New-Object Drawing.Size(400, 25)
    $subtitle.ForeColor = [Drawing.Color]::Silver
    $form.Controls.Add($subtitle)

    # DEVICE DETECTION
    $detected = Get-RiveroDevice

    $deviceLabel = New-Object Windows.Forms.Label
    $deviceLabel.Text = "DETECTED DEVICE: $detected"
    $deviceLabel.Location = New-Object Drawing.Point(650, 25)
    $deviceLabel.Size = New-Object Drawing.Size(260, 25)
    $deviceLabel.ForeColor = [Drawing.Color]::LightGreen
    $form.Controls.Add($deviceLabel)

    # DEVICE SELECTION
    $deviceTitle = New-Object Windows.Forms.Label
    $deviceTitle.Text = "SELECT DEVICE"
    $deviceTitle.Location = New-Object Drawing.Point(30, 125)
    $deviceTitle.Size = New-Object Drawing.Size(250, 25)
    $form.Controls.Add($deviceTitle)

    $deviceBox = New-Object Windows.Forms.ComboBox
    $deviceBox.Location = New-Object Drawing.Point(30, 155)
    $deviceBox.Size = New-Object Drawing.Size(260, 30)
    $deviceBox.DropDownStyle = "DropDownList"

    [void]$deviceBox.Items.Add("AUTO DETECT")
    [void]$deviceBox.Items.Add("PC")
    [void]$deviceBox.Items.Add("LAPTOP")

    $deviceBox.SelectedIndex = 0
    $form.Controls.Add($deviceBox)

    # PROFILE
    $profileTitle = New-Object Windows.Forms.Label
    $profileTitle.Text = "OPTIMIZATION PROFILE"
    $profileTitle.Location = New-Object Drawing.Point(330, 125)
    $profileTitle.Size = New-Object Drawing.Size(250, 25)
    $form.Controls.Add($profileTitle)

    $profileBox = New-Object Windows.Forms.ComboBox
    $profileBox.Location = New-Object Drawing.Point(330, 155)
    $profileBox.Size = New-Object Drawing.Size(260, 30)
    $profileBox.DropDownStyle = "DropDownList"

    [void]$profileBox.Items.Add("STANDARD")
    [void]$profileBox.Items.Add("AGGRESSIVE")
    [void]$profileBox.Items.Add("EXPERT")

    $profileBox.SelectedIndex = 0
    $form.Controls.Add($profileBox)

    # CATEGORY LIST
    $categoryTitle = New-Object Windows.Forms.Label
    $categoryTitle.Text = "OPTIMIZATION CATEGORIES"
    $categoryTitle.Font = New-Object Drawing.Font(
        "Segoe UI", 15, [Drawing.FontStyle]::Bold
    )
    $categoryTitle.Location = New-Object Drawing.Point(30, 225)
    $categoryTitle.Size = New-Object Drawing.Size(400, 35)
    $form.Controls.Add($categoryTitle)

    $categoryList = New-Object Windows.Forms.ListBox
    $categoryList.Location = New-Object Drawing.Point(30, 270)
    $categoryList.Size = New-Object Drawing.Size(400, 190)
    $categoryList.BackColor = [Drawing.Color]::FromArgb(25, 32, 45)
    $categoryList.ForeColor = [Drawing.Color]::White
    $categoryList.Font = New-Object Drawing.Font("Segoe UI", 11)

    foreach ($category in $script:Categories) {
        [void]$categoryList.Items.Add($category)
    }

    $form.Controls.Add($categoryList)

    # OPEN CATEGORY
    $openButton = New-Object Windows.Forms.Button
    $openButton.Text = "OPEN CATEGORY"
    $openButton.Location = New-Object Drawing.Point(30, 475)
    $openButton.Size = New-Object Drawing.Size(190, 45)
    $form.Controls.Add($openButton)

    $openButton.Add_Click({
        if ($categoryList.SelectedIndex -lt 0) {
            [Windows.Forms.MessageBox]::Show(
                "Select a category first.",
                "RIVERO"
            ) | Out-Null
            return
        }

        $device = $deviceBox.SelectedItem.ToString()

        if ($device -eq "AUTO DETECT") {
            $device = Get-RiveroDevice
        }

        $script:SelectedDevice = $device

        Show-RiveroCategory `
            -Device $device `
            -Category $categoryList.SelectedItem.ToString() `
            -Profile $profileBox.SelectedItem.ToString()
    })

    # SYSTEM INFORMATION
    $infoButton = New-Object Windows.Forms.Button
    $infoButton.Text = "SYSTEM INFORMATION"
    $infoButton.Location = New-Object Drawing.Point(500, 270)
    $infoButton.Size = New-Object Drawing.Size(200, 45)
    $form.Controls.Add($infoButton)
    $infoButton.Add_Click({ Show-RiveroInfo })

    # BACKUP
    $backupButton = New-Object Windows.Forms.Button
    $backupButton.Text = "CREATE BACKUP"
    $backupButton.Location = New-Object Drawing.Point(500, 330)
    $backupButton.Size = New-Object Drawing.Size(200, 45)
    $form.Controls.Add($backupButton)

    $backupButton.Add_Click({
        try {
            $path = New-RiveroBackup

            [Windows.Forms.MessageBox]::Show(
                "System information saved:`n$path",
                "RIVERO BACKUP",
                "OK",
                "Information"
            ) | Out-Null
        }
        catch {
            [Windows.Forms.MessageBox]::Show(
                $_.Exception.Message,
                "BACKUP ERROR"
            ) | Out-Null
        }
    })

    # CREDITS
    $credits = New-Object Windows.Forms.Label
    $credits.Text = "Inspired by Chris Titus Tech WinUtil and Sophia Script"
    $credits.Location = New-Object Drawing.Point(30, 550)
    $credits.Size = New-Object Drawing.Size(650, 25)
    $credits.ForeColor = [Drawing.Color]::Silver
    $credits.Font = New-Object Drawing.Font("Segoe UI", 8)
    $form.Controls.Add($credits)

    $version = New-Object Windows.Forms.Label
    $version.Text = "RIVERO v$script:RiveroVersion"
    $version.Location = New-Object Drawing.Point(790, 550)
    $version.Size = New-Object Drawing.Size(120, 25)
    $version.ForeColor = [Drawing.Color]::FromArgb(56, 189, 248)
    $form.Controls.Add($version)

    [void]$form.ShowDialog()
}

try {
    Show-RiveroWindow
}
catch {
    [Windows.Forms.MessageBox]::Show(
        $_.Exception.Message,
        "RIVERO OPTIMIZER ERROR",
        "OK",
        "Error"
    ) | Out-Null
}
