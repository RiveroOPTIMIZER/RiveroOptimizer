
# ============================================================
# RIVERO OPTIMIZER 0.3.0
# Windows Performance Toolkit
# Modern WPF Interface
# ============================================================

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$script:Version = "0.3.0"
$script:Device = "PC"

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

    return @{
        Windows = $os.Caption
        CPU = ($cpu.Name -join ", ")
        RAM = "$([math]::Round($computer.TotalPhysicalMemory / 1GB, 1)) GB"
        GPU = ($gpu.Name -join ", ")
        Architecture = $os.OSArchitecture
    }
}

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Rivero Optimizer"
        Height="720" Width="1120"
        MinHeight="650" MinWidth="950"
        WindowStartupLocation="CenterScreen"
        Background="#0B1020"
        Foreground="White"
        FontFamily="Segoe UI">

    <Window.Resources>
        <Style x:Key="NavButton" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#AAB4CC"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="14,12"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Margin" Value="0,3"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="Border"
                                Background="{TemplateBinding Background}"
                                CornerRadius="9"
                                Padding="{TemplateBinding Padding}">
                            <ContentPresenter/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="Border"
                                        Property="Background" Value="#1C2942"/>
                                <Setter Property="Foreground" Value="White"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="ActionButton" TargetType="Button">
            <Setter Property="Background" Value="#1677FF"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="18,11"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="Border"
                                Background="{TemplateBinding Background}"
                                CornerRadius="8"
                                Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center"
                                              VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter TargetName="Border"
                                        Property="Background" Value="#3991FF"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="245"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <!-- MENU LATERAL -->
        <Border Grid.Column="0" Background="#10182B">
            <DockPanel Margin="18">
                <StackPanel DockPanel.Dock="Top">
                    <TextBlock Text="RIVERO"
                               FontSize="25"
                               FontWeight="Bold"
                               Foreground="#3991FF"/>
                    <TextBlock Text="OPTIMIZER"
                               FontSize="11"
                               Foreground="#8492AA"
                               Margin="2,0,0,25"/>

                    <TextBlock Text="DISPOSITIVO"
                               Foreground="#8492AA"
                               FontSize="11"
                               Margin="0,0,0,8"/>

                    <ComboBox x:Name="DeviceBox"
                              Height="36"
                              Background="#1B2942"
                              Foreground="White"
                              SelectedIndex="0"
                              Margin="0,0,0,22">
                        <ComboBoxItem Content="PC"/>
                        <ComboBoxItem Content="LAPTOP"/>
                    </ComboBox>

                    <TextBlock Text="MENÚ PRINCIPAL"
                               Foreground="#8492AA"
                               FontSize="11"
                               Margin="0,0,0,8"/>

                    <Button x:Name="HomeButton"
                            Content="⌂   Inicio"
                            Style="{StaticResource NavButton}"/>

                    <TextBlock Text="OPTIMIZACIÓN"
                               Foreground="#8492AA"
                               FontSize="11"
                               Margin="0,20,0,8"/>

                    <StackPanel x:Name="CategoryMenu"/>
                </StackPanel>

                <StackPanel DockPanel.Dock="Bottom">
                    <Border Background="#1B2942"
                            CornerRadius="9"
                            Padding="12"
                            Margin="0,15,0,0">
                        <StackPanel>
                            <TextBlock Text="RIVERO OPTIMIZER"
                                       FontWeight="Bold"/>
                            <TextBlock Text="Versión 0.3.0"
                                       Foreground="#8492AA"
                                       FontSize="11"
                                       Margin="0,5,0,0"/>
                        </StackPanel>
                    </Border>
                </StackPanel>
            </DockPanel>
        </Border>

        <!-- CONTENIDO -->
        <Grid Grid.Column="1" Margin="30">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>

            <StackPanel Grid.Row="0">
                <TextBlock Text="Panel de control"
                           FontSize="27"
                           FontWeight="Bold"/>
                <TextBlock x:Name="Subtitle"
                           Text="Bienvenido a Rivero Optimizer"
                           Foreground="#8492AA"
                           Margin="0,5,0,22"/>
            </StackPanel>

            <UniformGrid Grid.Row="1" Columns="3" Margin="0,0,0,20">
                <Border Background="#15223A" CornerRadius="12"
                        Padding="15" Margin="0,0,10,0">
                    <StackPanel>
                        <TextBlock Text="DISPOSITIVO"
                                   Foreground="#8492AA"
                                   FontSize="11"/>
                        <TextBlock x:Name="DeviceInfo"
                                   Text="PC"
                                   FontSize="20"
                                   FontWeight="Bold"
                                   Margin="0,7,0,0"/>
                    </StackPanel>
                </Border>

                <Border Background="#15223A" CornerRadius="12"
                        Padding="15" Margin="5,0">
                    <StackPanel>
                        <TextBlock Text="MEMORIA RAM"
                                   Foreground="#8492AA"
                                   FontSize="11"/>
                        <TextBlock x:Name="RamInfo"
                                   Text="Detectando..."
                                   FontSize="20"
                                   FontWeight="Bold"
                                   Margin="0,7,0,0"/>
                    </StackPanel>
                </Border>

                <Border Background="#15223A" CornerRadius="12"
                        Padding="15" Margin="10,0,0,0">
                    <StackPanel>
                        <TextBlock Text="ESTADO"
                                   Foreground="#8492AA"
                                   FontSize="11"/>
                        <TextBlock Text="Preparado"
                                   FontSize="20"
                                   FontWeight="Bold"
                                   Foreground="#55D69E"
                                   Margin="0,7,0,0"/>
                    </StackPanel>
                </Border>
            </UniformGrid>

            <Border Grid.Row="2"
                    Background="#111C31"
                    CornerRadius="14"
                    Padding="24">
                <StackPanel>
                    <TextBlock x:Name="PageTitle"
                               Text="Bienvenido"
                               FontSize="23"
                               FontWeight="Bold"/>

                    <TextBlock x:Name="PageDescription"
                               Text="Selecciona una categoría del menú lateral."
                               Foreground="#AAB4CC"
                               TextWrapping="Wrap"
                               Margin="0,8,0,22"/>

                    <Border Background="#1B2942"
                            CornerRadius="10"
                            Padding="18">
                        <StackPanel>
                            <TextBlock Text="INFORMACIÓN"
                                       FontWeight="Bold"
                                       Foreground="#3991FF"/>
                            <TextBlock x:Name="DetailText"
                                       Text="Rivero está listo para configurar tu equipo."
                                       Foreground="#D3DCEE"
                                       TextWrapping="Wrap"
                                       Margin="0,10,0,0"/>
                        </StackPanel>
                    </Border>

                    <StackPanel Orientation="Horizontal"
                                Margin="0,22,0,0">
                        <Button x:Name="InfoButton"
                                Content="Información del sistema"
                                Style="{StaticResource ActionButton}"
                                Margin="0,0,10,0"/>
                        <Button x:Name="BackupButton"
                                Content="Guardar diagnóstico"
                                Style="{StaticResource ActionButton}"/>
                    </StackPanel>
                </StackPanel>
            </Border>

            <TextBlock Grid.Row="3"
                       Text="Rivero Optimizer  •  Inspirado en WinUtil y Sophia Script"
                       Foreground="#65748E"
                       FontSize="11"
                       Margin="0,15,0,0"/>
        </Grid>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$names = @(
    "DeviceBox", "DeviceInfo", "RamInfo", "CategoryMenu",
    "HomeButton", "PageTitle", "PageDescription",
    "DetailText", "InfoButton", "BackupButton", "Subtitle"
)

$ui = @{}
foreach ($name in $names) {
    $ui[$name] = $window.FindName($name)
}

$categories = @(
    "Ajustes esenciales",
    "Rendimiento",
    "Juegos",
    "Privacidad",
    "Aplicaciones",
    "Avanzado",
    "Personalizado"
)

function Set-RiveroPage {
    param([string]$Category)

    $device = $ui.DeviceBox.SelectedItem.Content.ToString()
    $script:Device = $device

    $ui.DeviceInfo.Text = $device
    $ui.PageTitle.Text = $Category
    $ui.Subtitle.Text = "$device  /  $Category"
    $ui.PageDescription.Text = "Configuración de $Category para $device."
    $ui.DetailText.Text = "El catálogo de ajustes de esta categoría todavía está en desarrollo. No se han realizado cambios en Windows."
}

foreach ($category in $categories) {
    $button = New-Object System.Windows.Controls.Button
    $button.Content = "    $category"
    $button.Style = $window.FindResource("NavButton")
    $button.Tag = $category

    $button.Add_Click({
        Set-RiveroPage -Category $this.Tag
    }.GetNewClosure())

    [void]$ui.CategoryMenu.Children.Add($button)
}

$ui.HomeButton.Add_Click({
    $ui.PageTitle.Text = "Bienvenido"
    $ui.Subtitle.Text = "Panel principal de Rivero Optimizer"
    $ui.PageDescription.Text = "Selecciona una categoría para comenzar."
    $ui.DetailText.Text = "El motor de optimización se conectará en la siguiente fase."
})

$ui.DeviceBox.Add_SelectionChanged({
    $ui.DeviceInfo.Text = $ui.DeviceBox.SelectedItem.Content.ToString()
})

$ui.InfoButton.Add_Click({
    $info = Get-RiveroInfo
    $message = @"
WINDOWS: $($info.Windows)

PROCESADOR: $($info.CPU)

MEMORIA RAM: $($info.RAM)

GRÁFICOS: $($info.GPU)

ARQUITECTURA: $($info.Architecture)
"@
    [System.Windows.MessageBox]::Show($message, "Información del sistema")
})

$ui.BackupButton.Add_Click({
    try {
        $folder = Join-Path $env:ProgramData "RiveroOptimizer\Backups"
        New-Item -ItemType Directory -Path $folder -Force | Out-Null

        $file = Join-Path $folder (
            "Diagnostico_{0}.json" -f (Get-Date -Format "yyyyMMdd_HHmmss")
        )

        Get-RiveroInfo |
            ConvertTo-Json -Depth 4 |
            Set-Content -Path $file -Encoding UTF8

        [System.Windows.MessageBox]::Show(
            "Diagnóstico guardado en:`n$file",
            "Rivero Optimizer"
        )
    }
    catch {
        [System.Windows.MessageBox]::Show(
            $_.Exception.Message,
            "Error"
        )
    }
})

$detected = Get-RiveroDevice
$ui.DeviceBox.SelectedIndex = if ($detected -eq "LAPTOP") { 1 } else { 0 }

$info = Get-RiveroInfo
$ui.RamInfo.Text = $info.RAM

[void]$window.ShowDialog()
