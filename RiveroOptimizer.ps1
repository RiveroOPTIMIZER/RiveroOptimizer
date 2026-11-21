
# ============================================================
# RIVERO OPTIMIZER 0.4.0
# Interfaz inspirada en Chris Titus Tech WinUtil
# ============================================================

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()

$script:Version = "0.4.0"
$script:Device = "PC"
$script:SelectedCategory = "Todos"

$script:Categories = @(
    "Todos",
    "Ajustes esenciales",
    "Rendimiento",
    "Juegos",
    "Privacidad",
    "Aplicaciones",
    "Avanzado",
    "Personalizado"
)

# Catálogo visual de ejemplo.
# Los ajustes todavía no ejecutan cambios en Windows.

$script:Tweaks = @(
    [PSCustomObject]@{
        Name = "Crear punto de restauración"
        Category = "Ajustes esenciales"
        Description = "Preparar un punto de restauración de Windows."
        Device = "AMBOS"
    },
    [PSCustomObject]@{
        Name = "Optimizar aplicaciones en segundo plano"
        Category = "Rendimiento"
        Description = "Revisar la actividad de aplicaciones en segundo plano."
        Device = "AMBOS"
    },
    [PSCustomObject]@{
        Name = "Optimización para juegos"
        Category = "Juegos"
        Description = "Opciones de configuración relacionadas con juegos."
        Device = "AMBOS"
    },
    [PSCustomObject]@{
        Name = "Administración de energía"
        Category = "Rendimiento"
        Description = "Opciones de energía adaptadas al dispositivo."
        Device = "AMBOS"
    },
    [PSCustomObject]@{
        Name = "Privacidad de Windows"
        Category = "Privacidad"
        Description = "Revisar opciones de privacidad disponibles."
        Device = "AMBOS"
    },
    [PSCustomObject]@{
        Name = "Aplicaciones instaladas"
        Category = "Aplicaciones"
        Description = "Consultar aplicaciones y opciones de administración."
        Device = "AMBOS"
    }
)

function Get-RiveroDevice {
    $battery = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
    if ($battery) { return "LAPTOP" }
    return "PC"
}

function Get-RiveroInfo {
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor
    $computer = Get-CimInstance Win32_ComputerSystem
    $gpu = Get-CimInstance Win32_VideoController

    [PSCustomObject]@{
        Windows = $os.Caption
        CPU = ($cpu.Name -join ", ")
        RAM = "$([math]::Round($computer.TotalPhysicalMemory / 1GB, 1)) GB"
        GPU = ($gpu.Name -join ", ")
        Architecture = $os.OSArchitecture
    }
}

# ------------------------------------------------------------
# VENTANA
# ------------------------------------------------------------

$form = New-Object System.Windows.Forms.Form
$form.Text = "Rivero Optimizer"
$form.Size = New-Object System.Drawing.Size(1120, 760)
$form.MinimumSize = New-Object System.Drawing.Size(950, 650)
$form.StartPosition = "CenterScreen"
$form.BackColor = [Drawing.Color]::FromArgb(25, 29, 37)
$form.ForeColor = [Drawing.Color]::White
$form.Font = New-Object Drawing.Font("Segoe UI", 9)

# ------------------------------------------------------------
# FUNCIONES DE INTERFAZ
# ------------------------------------------------------------

function New-Label {
    param($Text, $X, $Y, $W, $H, $Size = 10, $Color = "White")

    $label = New-Object Windows.Forms.Label
    $label.Text = $Text
    $label.Location = New-Object Drawing.Point($X, $Y)
    $label.Size = New-Object Drawing.Size($W, $H)
    $label.Font = New-Object Drawing.Font("Segoe UI", $Size)
    $label.ForeColor = [Drawing.Color]::$Color
    return $label
}

function New-Button {
    param($Text, $X, $Y, $W, $H)

    $button = New-Object Windows.Forms.Button
    $button.Text = $Text
    $button.Location = New-Object Drawing.Point($X, $Y)
    $button.Size = New-Object Drawing.Size($W, $H)
    $button.FlatStyle = "Flat"
    $button.FlatAppearance.BorderSize = 0
    $button.BackColor = [Drawing.Color]::FromArgb(45, 105, 190)
    $button.ForeColor = [Drawing.Color]::White
    $button.Cursor = "Hand"
    return $button
}

# ------------------------------------------------------------
# ENCABEZADO
# ------------------------------------------------------------

$header = New-Object Windows.Forms.Panel
$header.Dock = "Top"
$header.Height = 75
$header.BackColor = [Drawing.Color]::FromArgb(31, 37, 48)
$form.Controls.Add($header)

$header.Controls.Add((New-Label "RIVERO OPTIMIZER" 20 12 300 30 19 "White"))
$header.Controls.Add((New-Label "WINDOWS PERFORMANCE TOOLKIT" 22 43 300 20 8 "Silver"))

# Selector de dispositivo
$deviceBox = New-Object Windows.Forms.ComboBox
$deviceBox.Location = New-Object Drawing.Point(850, 24)
$deviceBox.Size = New-Object Drawing.Size(220, 28)
$deviceBox.DropDownStyle = "DropDownList"
$deviceBox.Items.AddRange(@("PC", "LAPTOP"))

$detected = Get-RiveroDevice
$deviceBox.SelectedItem = $detected
$script:Device = $detected
$header.Controls.Add($deviceBox)

# ------------------------------------------------------------
# PESTAÑAS SUPERIORES
# ------------------------------------------------------------

$tabs = New-Object Windows.Forms.TabControl
$tabs.Dock = "Fill"
$tabs.Font = New-Object Drawing.Font("Segoe UI", 10)
$tabs.BackColor = [Drawing.Color]::FromArgb(25, 29, 37)
$form.Controls.Add($tabs)

$mainTab = New-Object Windows.Forms.TabPage
$mainTab.Text = "  Ajustes  "
$mainTab.BackColor = [Drawing.Color]::FromArgb(25, 29, 37)

$installTab = New-Object Windows.Forms.TabPage
$installTab.Text = "  Instalación  "
$installTab.BackColor = [Drawing.Color]::FromArgb(25, 29, 37)

$configurationTab = New-Object Windows.Forms.TabPage
$configurationTab.Text = "  Configuración  "
$configurationTab.BackColor = [Drawing.Color]::FromArgb(25, 29, 37)

$updatesTab = New-Object Windows.Forms.TabPage
$updatesTab.Text = "  Actualizaciones  "
$updatesTab.BackColor = [Drawing.Color]::FromArgb(25, 29, 37)

[void]$tabs.TabPages.Add($mainTab)
[void]$tabs.TabPages.Add($installTab)
[void]$tabs.TabPages.Add($configurationTab)
[void]$tabs.TabPages.Add($updatesTab)

# ------------------------------------------------------------
# PANEL LATERAL
# ------------------------------------------------------------

$sidebar = New-Object Windows.Forms.Panel
$sidebar.Location = New-Object Drawing.Point(12, 15)
$sidebar.Size = New-Object Drawing.Size(220, 550)
$sidebar.BackColor = [Drawing.Color]::FromArgb(31, 37, 48)
$mainTab.Controls.Add($sidebar)

$sidebar.Controls.Add((New-Label "CATEGORÍAS" 15 15 180 25 11 "Silver"))

$categoryList = New-Object Windows.Forms.ListBox
$categoryList.Location = New-Object Drawing.Point(10, 48)
$categoryList.Size = New-Object Drawing.Size(200, 350)
$categoryList.BackColor = [Drawing.Color]::FromArgb(31, 37, 48)
$categoryList.ForeColor = [Drawing.Color]::White
$categoryList.BorderStyle = "None"
$categoryList.Font = New-Object Drawing.Font("Segoe UI", 10)

foreach ($category in $script:Categories) {
    [void]$categoryList.Items.Add($category)
}

$categoryList.SelectedIndex = 0
$sidebar.Controls.Add($categoryList)

$sidebar.Controls.Add((New-Label "PERFIL" 15 415 180 25 10 "Silver"))

$profileBox = New-Object Windows.Forms.ComboBox
$profileBox.Location = New-Object Drawing.Point(10, 445)
$profileBox.Size = New-Object Drawing.Size(195, 30)
$profileBox.DropDownStyle = "DropDownList"
$profileBox.Items.AddRange(@("STANDARD", "AGGRESSIVE", "EXPERT"))
$profileBox.SelectedIndex = 0
$sidebar.Controls.Add($profileBox)

# ------------------------------------------------------------
# LISTA DE AJUSTES
# ------------------------------------------------------------

$mainTab.Controls.Add((New-Label "AJUSTES DISPONIBLES" 250 18 400 30 16 "White"))
$mainTab.Controls.Add((New-Label "Selecciona los ajustes que quieras revisar." 252 48 500 25 9 "Silver"))

$searchBox = New-Object Windows.Forms.TextBox
$searchBox.Location = New-Object Drawing.Point(250, 85)
$searchBox.Size = New-Object Drawing.Size(450, 30)
$searchBox.Font = New-Object Drawing.Font("Segoe UI", 10)
$searchBox.BackColor = [Drawing.Color]::FromArgb(40, 47, 60)
$searchBox.ForeColor = [Drawing.Color]::White
$searchBox.BorderStyle = "FixedSingle"
$searchBox.Text = "Buscar ajustes..."
$mainTab.Controls.Add($searchBox)

$tweakPanel = New-Object Windows.Forms.FlowLayoutPanel
$tweakPanel.Location = New-Object Drawing.Point(250, 130)
$tweakPanel.Size = New-Object Drawing.Size(820, 390)
$tweakPanel.AutoScroll = $true
$tweakPanel.FlowDirection = "TopDown"
$tweakPanel.WrapContents = $false
$tweakPanel.BackColor = [Drawing.Color]::FromArgb(25, 29, 37)
$mainTab.Controls.Add($tweakPanel)

function Update-RiveroTweakList {
    $tweakPanel.Controls.Clear()

    $category = [string]$categoryList.SelectedItem
    $search = $searchBox.Text

    foreach ($tweak in $script:Tweaks) {
        if ($category -ne "Todos" -and $tweak.Category -ne $category) {
            continue
        }

        if ($search -ne "Buscar ajustes..." -and
            $tweak.Name -notlike "*$search*" -and
            $tweak.Description -notlike "*$search*") {
            continue
        }

        $card = New-Object Windows.Forms.Panel
        $card.Size = New-Object Drawing.Size(780, 85)
        $card.BackColor = [Drawing.Color]::FromArgb(35, 42, 55)
        $card.Margin = New-Object Windows.Forms.Padding(3, 4, 3, 4)

        $check = New-Object Windows.Forms.CheckBox
        $check.Text = $tweak.Name
        $check.Location = New-Object Drawing.Point(15, 12)
        $check.Size = New-Object Drawing.Size(700, 25)
        $check.ForeColor = [Drawing.Color]::White
        $check.Font = New-Object Drawing.Font("Segoe UI", 10)
        $check.Tag = $tweak
        $card.Controls.Add($check)

        $description = New-Label $tweak.Description 37 42 700 25 8 "Silver"
        $card.Controls.Add($description)

        $tweakPanel.Controls.Add($card)
    }
}

$categoryList.Add_SelectedIndexChanged({
    Update-RiveroTweakList
})

$searchBox.Add_TextChanged({
    Update-RiveroTweakList
})

# ------------------------------------------------------------
# BOTONES DE ACCIÓN
# ------------------------------------------------------------

$applyButton = New-Button "APLICAR AJUSTES" 250 545 180 42
$undoButton = New-Button "DESHACER" 440 545 130 42
$selectButton = New-Button "SELECCIONAR TODO" 580 545 170 42

$mainTab.Controls.Add($applyButton)
$mainTab.Controls.Add($undoButton)
$mainTab.Controls.Add($selectButton)

$applyButton.Add_Click({
    [Windows.Forms.MessageBox]::Show(
        "El motor de aplicación todavía está en desarrollo. No se ha modificado Windows.",
        "Rivero Optimizer"
    ) | Out-Null
})

$undoButton.Add_Click({
    [Windows.Forms.MessageBox]::Show(
        "El sistema de restauración todavía está en desarrollo.",
        "Rivero Optimizer"
    ) | Out-Null
})

$selectButton.Add_Click({
    foreach ($card in $tweakPanel.Controls) {
        foreach ($control in $card.Controls) {
            if ($control -is [Windows.Forms.CheckBox]) {
                $control.Checked = $true
            }
        }
    }
})

# ------------------------------------------------------------
# OTRAS PESTAÑAS
# ------------------------------------------------------------

function Add-PlaceholderPage {
    param($Page, $Title, $Description)

    $label = New-Label $Title 30 35 700 40 19 "White"
    $Page.Controls.Add($label)

    $descriptionLabel = New-Label $Description 32 85 750 70 10 "Silver"
    $Page.Controls.Add($descriptionLabel)
}

Add-PlaceholderPage $installTab "Instalación de aplicaciones" "Aquí se incorporará un catálogo de aplicaciones."
Add-PlaceholderPage $configurationTab "Configuración del sistema" "Herramientas de configuración para PC y Laptop."
Add-PlaceholderPage $updatesTab "Actualizaciones" "Información y controles de actualizaciones de Windows."

$deviceBox.Add_SelectedIndexChanged({
    $script:Device = [string]$deviceBox.SelectedItem
})

# ------------------------------------------------------------
# INICIO
# ------------------------------------------------------------

Update-RiveroTweakList

$form.Add_Shown({
    $form.Activate()
})

[void]$form.ShowDialog()
