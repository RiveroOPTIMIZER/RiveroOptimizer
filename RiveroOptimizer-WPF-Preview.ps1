# Rivero Optimizer - WPF UI preview
# Windows PowerShell 5.1+. Includes read-only diagnostics and four current-user reversible preferences.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Rivero Optimizer" Height="790" Width="1420"
        MinHeight="650" MinWidth="1050" WindowStartupLocation="CenterScreen"
        Background="#0B0F0C" Foreground="#F3F4F6" FontFamily="Segoe UI">
  <Window.Resources>
    <SolidColorBrush x:Key="Panel" Color="#111813"/>
    <SolidColorBrush x:Key="Green" Color="#22C55E"/>
    <Style TargetType="Button">
      <Setter Property="Foreground" Value="#F3F4F6"/>
      <Setter Property="Background" Value="#17221A"/>
      <Setter Property="BorderBrush" Value="#26352A"/>
      <Setter Property="Padding" Value="12,5"/>
      <Setter Property="Margin" Value="3"/>
    </Style>
    <Style TargetType="CheckBox">
      <Setter Property="Margin" Value="6,4"/>
      <Setter Property="Padding" Value="5,3"/>
      <Setter Property="Foreground" Value="#F3F4F6"/>
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="VerticalContentAlignment" Value="Center"/>
    </Style>
    <Style TargetType="GroupBox">
      <Setter Property="Foreground" Value="#86EFAC"/>
      <Setter Property="BorderBrush" Value="#26352A"/>
      <Setter Property="Background" Value="#111813"/>
      <Setter Property="Padding" Value="8"/>
      <Setter Property="Margin" Value="5"/>
    </Style>
    <Style TargetType="TextBlock">
      <Setter Property="Foreground" Value="#F3F4F6"/>
    </Style>
  </Window.Resources>
  <DockPanel>
    <Border DockPanel.Dock="Top" Background="#111813" Padding="12">
      <Grid>
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/>
          <ColumnDefinition Width="Auto"/><ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        <TextBlock Text="◆" Foreground="#22C55E" FontSize="28" VerticalAlignment="Center" Margin="5,0,18,0"/>
        <StackPanel Grid.Column="1" Orientation="Vertical" VerticalAlignment="Center">
          <TextBlock Text="RIVERO OPTIMIZER" Foreground="#86EFAC" FontSize="17" FontWeight="Bold"/>
          <TextBlock Text="WINDOWS PERFORMANCE TOOLKIT" Foreground="#9CA3AF" FontSize="9"/>
        </StackPanel>
        <TextBox x:Name="SearchBox" Grid.Column="2" Width="230" Height="27" Margin="10,0"
                 VerticalContentAlignment="Center" Background="#0B0F0C" Foreground="#F3F4F6"
                 BorderBrush="#26352A" ToolTip="Buscar ajustes en español"/>
        <TextBlock Grid.Column="3" Text="PC" Foreground="#86EFAC" FontSize="16" FontWeight="Bold"
                   VerticalAlignment="Center" Margin="12,0,8,0"/>
      </Grid>
    </Border>
    <Border DockPanel.Dock="Bottom" Background="#111813" Padding="8">
      <DockPanel>
        <StackPanel Orientation="Vertical" VerticalAlignment="Center">
          <TextBlock x:Name="StatusText" Text="PC · Diagnósticos disponibles y cambios reversibles con confirmación."
                     Foreground="#86EFAC"/>
          <TextBlock Text="Basado en Chris Titus Tech WinUtil · Sophia Script por farag2"
                     Foreground="#9CA3AF" FontSize="10"/>
        </StackPanel>
        <StackPanel DockPanel.Dock="Right" Orientation="Horizontal">
          <Button x:Name="RunButton" Content="Ejecutar seleccionados" Width="180"/>
          <Button x:Name="UndoButton" Content="Deshacer ajustes seleccionados" Width="225"/>
        </StackPanel>
      </DockPanel>
    </Border>
    <TabControl Background="#0B0F0C" BorderBrush="#26352A" Margin="8">
      <TabItem Header="Rivero Optimizer">
        <Grid Margin="8">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
          <Border Grid.Row="0" Background="#111813" BorderBrush="#26352A" BorderThickness="1"
                  CornerRadius="5" Padding="10" Margin="0,4,0,10">
            <DockPanel>
              <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                <TextBlock Text="AJUSTES DEL SISTEMA" Foreground="#86EFAC" FontWeight="Bold"
                           VerticalAlignment="Center" Margin="3,0,12,0"/>
                <TextBlock Text="  " Foreground="#9CA3AF" VerticalAlignment="Center"/>
                <WrapPanel x:Name="CategoryPanel" VerticalAlignment="Center">
                  <RadioButton Content="Standard" GroupName="RiveroCategory" IsChecked="True" Margin="5,3" Foreground="#86EFAC"/>
                  <RadioButton Content="Minimal" GroupName="RiveroCategory" Margin="5,3" Foreground="#86EFAC"/>
                  <RadioButton Content="Advanced" GroupName="RiveroCategory" Margin="5,3" Foreground="#86EFAC"/>
                  <RadioButton Content="Desktop" GroupName="RiveroCategory" Margin="5,3" Foreground="#86EFAC"/>
                  <RadioButton Content="Privacy" GroupName="RiveroCategory" Margin="5,3" Foreground="#86EFAC"/>
                  <RadioButton Content="Performance" GroupName="RiveroCategory" Margin="5,3" Foreground="#86EFAC"/>
                  <RadioButton Content="Gaming" GroupName="RiveroCategory" Margin="5,3" Foreground="#86EFAC"/>
                  <RadioButton Content="Network" GroupName="RiveroCategory" Margin="5,3" Foreground="#86EFAC"/>
                  <RadioButton Content="Power" GroupName="RiveroCategory" Margin="5,3" Foreground="#86EFAC"/>
                  <RadioButton Content="Windows" GroupName="RiveroCategory" Margin="5,3" Foreground="#86EFAC"/>
                </WrapPanel>
              </StackPanel>
            </DockPanel>
          </Border>
          <Grid Grid.Row="1">
            <Grid.ColumnDefinitions><ColumnDefinition Width="1.05*"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
            <ScrollViewer Grid.Column="0" VerticalScrollBarVisibility="Auto" Margin="0,0,8,0">
              <StackPanel Background="#111813" Margin="0,0,5,0">
                <TextBlock Text="AJUSTES ESENCIALES" Foreground="#86EFAC" FontFamily="Consolas" FontSize="14" FontWeight="Bold" Margin="10,10,10,6"/>
                <Separator Background="#26352A" Margin="8,0,8,6"/>
                <CheckBox Content="Desactivar historial de actividad" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Optimización de distribución: revisar configuración" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Ejecutar limpieza de disco" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Activar clic derecho para finalizar tareas" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Desactivar descubrimiento automático de carpetas" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Analizar programas de inicio" Name="TweakStartupAudit" Tag="BOTH"/>
                <CheckBox Content="Información de Windows" Name="TweakOsInfo" Tag="BOTH" IsChecked="True"/>
                <CheckBox Content="Información del hardware" Name="TweakHardwareInfo" Tag="BOTH" IsChecked="True"/>
                <CheckBox Content="Estado de energía" Name="TweakPowerInfo" Tag="BOTH" IsChecked="True"/>
                <CheckBox Content="Crear punto de restauración" Tag="BOTH" IsEnabled="False"/>
                <CheckBox Content="Revisar servicios configurados manualmente" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Eliminar archivos temporales" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Revisar Widgets" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <TextBlock Text="AJUSTES AVANZADOS" Foreground="#86EFAC" FontSize="14" FontWeight="Bold" Margin="10,18,5,6"/>
                <Separator Background="#26352A" Margin="8,0,8,6"/>
                <CheckBox Content="Revisar aplicaciones en segundo plano" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Revisar almacenamiento reservado" Tag="PC" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Revisar configuración IPv6" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Revisar componentes opcionales de Windows" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Mostrar información de privacidad" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
              </StackPanel>
            </ScrollViewer>
            <ScrollViewer Grid.Column="1" VerticalScrollBarVisibility="Auto">
              <StackPanel Background="#111813" Margin="5,0,0,0">
                <TextBlock Text="PERSONALIZACIÓN" Foreground="#86EFAC" FontFamily="Consolas" FontSize="14" FontWeight="Bold" Margin="10,10,10,6"/>
                <Separator Background="#26352A" Margin="8,0,8,6"/>
                <CheckBox Content="Activar modo oscuro de Windows (reversible)" Name="TweakDarkMode" IsChecked="False" Tag="PC"/>
                <CheckBox Content="Mostrar extensiones de archivo (reversible)" Name="TweakFileExtensions" Tag="BOTH"/>
                <CheckBox Content="Mostrar archivos y carpetas ocultos (reversible)" Name="TweakHiddenFiles" IsChecked="False" Tag="PC"/>
                <CheckBox Content="Activar Modo Juego de Windows (reversible)" Name="TweakGameMode" IsChecked="False" Tag="BOTH"/>
                <CheckBox Content="Revisar plan de energía de escritorio" Tag="PC" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Revisar inicio rápido y estado de energía" Tag="PC" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Desactivar sugerencias de pantalla de bloqueo" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Mostrar pantalla de inicio detallada" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Aceleración del mouse" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Bloqueo numérico al iniciar" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Revisar plan de energía del PC" Name="TweakPcPowerGuide" Tag="PC"/>
                <CheckBox Content="Conservar protecciones de Windows" Name="TweakSecurityGuide" Tag="BOTH" IsChecked="True"/>
                <CheckBox Content="Centrar iconos de la barra de tareas" Tag="BOTH" IsEnabled="False" ToolTip="En desarrollo: esta opción todavía no ejecuta ninguna acción."/>
                <CheckBox Content="Mantener protecciones de Windows" IsChecked="True" IsEnabled="False" Tag="BOTH"/>
              </StackPanel>
            </ScrollViewer>
          </Grid>
        </Grid>
      </TabItem>
      <TabItem Header="Catálogo WinUtil">
        <ScrollViewer VerticalScrollBarVisibility="Auto">
          <StackPanel x:Name="WinUtilCatalogPanel" Margin="14" Background="#111813">
            <TextBlock Text="CATÁLOGO DE AJUSTES WINUTIL" Foreground="#86EFAC" FontSize="18" FontWeight="Bold" Margin="10,10,10,4"/>
            <TextBlock Text="Listado de referencia. Las opciones se habilitarán en Rivero únicamente después de implementar y revisar cada acción." Foreground="#D1D5DB" TextWrapping="Wrap" Margin="10,0,10,12"/>
          </StackPanel>
        </ScrollViewer>
      </TabItem>
      <TabItem Header="Sophia Script">
        <ScrollViewer VerticalScrollBarVisibility="Auto">
          <StackPanel Margin="24" Background="#111813">
            <TextBlock Text="Sophia Script para Windows" Foreground="#86EFAC" FontSize="20" Margin="12,12"/>
            <TextBlock Text="Módulo independiente · Autor: farag2 · Licencia MIT" Foreground="#D1D5DB" FontSize="12" Margin="12,2"/>
            <TextBlock Text="Esta sección se está preparando como componente separado. No ejecuta scripts externos ni aplica cambios todavía." TextWrapping="Wrap" FontSize="14" Margin="12,12"/>
            <TextBlock Text="Categorías previstas" Foreground="#86EFAC" FontSize="16" Margin="12,12,12,6"/>
            <Border Background="#17221A" CornerRadius="5" Padding="12" Margin="8,4">
              <StackPanel>
                <TextBlock Text="Privacidad y seguridad" FontWeight="Bold"/>
                <TextBlock Text="Revisión de opciones de privacidad sin desactivar protecciones de Windows." Foreground="#D1D5DB" TextWrapping="Wrap" Margin="0,4,0,0"/>
              </StackPanel>
            </Border>
            <Border Background="#17221A" CornerRadius="5" Padding="12" Margin="8,4">
              <StackPanel>
                <TextBlock Text="Aplicaciones y componentes" FontWeight="Bold"/>
                <TextBlock Text="Inventario y recomendaciones; no se desinstalarán componentes automáticamente." Foreground="#D1D5DB" TextWrapping="Wrap" Margin="0,4,0,0"/>
              </StackPanel>
            </Border>
            <Border Background="#17221A" CornerRadius="5" Padding="12" Margin="8,4">
              <StackPanel>
                <TextBlock Text="Personalización de Windows" FontWeight="Bold"/>
                <TextBlock Text="Preferencias visuales y de uso, con cambios reversibles cuando estén implementados." Foreground="#D1D5DB" TextWrapping="Wrap" Margin="0,4,0,0"/>
              </StackPanel>
            </Border>
            <TextBlock Text="Créditos: Sophia Script for Windows — farag2" Foreground="#86EFAC" FontSize="12" Margin="12,18,12,4"/>
            <TextBlock Text="https://github.com/farag2/Sophia-Script-for-Windows" Foreground="#9CA3AF" FontSize="11" Margin="12,0,12,12"/>
          </StackPanel>
        </ScrollViewer>
      </TabItem>
      <TabItem Header="Información">
        <StackPanel Margin="24" Background="#111813">
          <TextBlock Text="Información de Rivero Optimizer" Foreground="#86EFAC" FontSize="20" Margin="12,12"/>
          <TextBlock Text="Proyecto y contacto" Foreground="#86EFAC" FontSize="15" Margin="12,8"/>
          <TextBlock Text="TikTok: davii.cf" FontSize="17" Margin="12,6"/>
          <TextBlock Text="Discord: desgastarte" FontSize="17" Margin="12,6"/>
          <Separator Background="#26352A" Margin="12,16"/>
          <TextBlock Text="Créditos y licencias" Foreground="#86EFAC" FontSize="15" Margin="12,8"/>
          <TextBlock Text="Chris Titus Tech — WinUtil (MIT License)" FontSize="13" Margin="12,4"/>
          <TextBlock Text="Sophia Script — farag2 (MIT License)" FontSize="13" Margin="12,4"/>
          <TextBlock Text="Los avisos completos de terceros están en THIRD-PARTY-NOTICES.md." Foreground="#9CA3AF" TextWrapping="Wrap" FontSize="11" Margin="12,8"/>
        </StackPanel>
      </TabItem>
    </TabControl>
  </DockPanel>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)
$run = $window.FindName('RunButton')
$undo = $window.FindName('UndoButton')
$status = $window.FindName('StatusText')
$search = $window.FindName('SearchBox')
$modulePath = Join-Path $PSScriptRoot 'Modules/SafeActions.ps1'
$catalogModulePath = Join-Path $PSScriptRoot 'Modules/TweakCatalog.ps1'
$reversibleModulePath = Join-Path $PSScriptRoot 'Modules/ReversibleActions.ps1'
$catalogPath = Join-Path $PSScriptRoot 'Catalog/shared/safe-starter.json'
foreach ($requiredPath in @($modulePath, $catalogModulePath, $reversibleModulePath, $catalogPath)) {
  if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
    throw "Falta un componente necesario de Rivero Optimizer: $requiredPath"
  }
}
. $modulePath
. $catalogModulePath
. $reversibleModulePath
$catalog = Import-RiveroTweakCatalog -Path $catalogPath
$referenceCatalogPath = Join-Path $PSScriptRoot 'Catalog/reference/christitus-tweaks.json'
if (Test-Path -LiteralPath $referenceCatalogPath -PathType Leaf) {
  $referenceCatalog = Get-Content -LiteralPath $referenceCatalogPath -Raw | ConvertFrom-Json
  $referencePanel = $window.FindName('WinUtilCatalogPanel')
  foreach ($categoryGroup in ($referenceCatalog.tweaks | Group-Object -Property category)) {
    $groupBox = New-Object System.Windows.Controls.GroupBox
    $groupBox.Header = "$($categoryGroup.Name) ($($categoryGroup.Count))"
    $groupBox.Margin = '6'
    $groupBox.Padding = '8'
    $groupPanel = New-Object System.Windows.Controls.StackPanel
    foreach ($item in $categoryGroup.Group) {
      $itemPanel = New-Object System.Windows.Controls.StackPanel
      $itemPanel.Margin = '4,5,4,8'
      $option = New-Object System.Windows.Controls.CheckBox
      $option.Content = [string]$item.name
      $option.IsEnabled = $false
      $option.Margin = '2,2,2,3'
      $option.FontWeight = 'SemiBold'
      $option.ToolTip = [string]$item.status
      $details = New-Object System.Windows.Controls.TextBlock
      $details.Text = [string]$item.description
      $details.Foreground = [Windows.Media.Brushes]::LightGray
      $details.TextWrapping = 'Wrap'
      $details.Margin = '22,0,8,2'
      $details.FontSize = 11
      $status = New-Object System.Windows.Controls.TextBlock
      $status.Text = "Estado: $($item.status)"
      $status.Foreground = if ([string]$item.status -eq 'Disponible en Rivero') { [Windows.Media.Brushes]::LightGreen } else { [Windows.Media.Brushes]::DarkGray }
      $status.Margin = '22,0,8,0'
      $status.FontSize = 10
      $itemPanel.Children.Add($option) | Out-Null
      $itemPanel.Children.Add($details) | Out-Null
      $itemPanel.Children.Add($status) | Out-Null
      $groupPanel.Children.Add($itemPanel) | Out-Null
    }
    $groupBox.Content = $groupPanel
    $referencePanel.Children.Add($groupBox) | Out-Null
  }
}
$existingGameModeBackup = Get-RiveroGameModeBackupPath
$existingExtensionsBackup = Get-RiveroFileExtensionsBackupPath
$existingDarkModeBackup = Get-RiveroDarkModeBackupPath
$existingHiddenFilesBackup = Get-RiveroHiddenFilesBackupPath
$undo.IsEnabled = (Test-Path -LiteralPath $existingGameModeBackup -PathType Leaf) -or (Test-Path -LiteralPath $existingExtensionsBackup -PathType Leaf) -or (Test-Path -LiteralPath $existingDarkModeBackup -PathType Leaf) -or (Test-Path -LiteralPath $existingHiddenFilesBackup -PathType Leaf)
$undo.Content = if ($undo.IsEnabled) { 'Deshacer cambios' } else { 'Sin cambios para deshacer' }
$run.Add_Click({
  try {
    $selectedMode = 'PC'
    $actionMap = @{
      TweakOsInfo = 'SYS-OS-INFO'
      TweakHardwareInfo = 'SYS-HARDWARE-INFO'
      TweakPowerInfo = 'SYS-POWER-STATUS'
      TweakStartupAudit = 'PC-STARTUP-AUDIT'
      TweakPcPowerGuide = 'PC-POWER-GUIDE'
      TweakSecurityGuide = 'SECURITY-PRESERVE'
    }
    $output = New-Object System.Collections.Generic.List[string]
    $extensionsControl = $window.FindName('TweakFileExtensions')
    if ($extensionsControl.IsChecked) {
      $answer = [System.Windows.MessageBox]::Show(
        'Se mostrarán las extensiones de archivo para tu usuario. Rivero guardará el valor anterior para poder deshacerlo. ¿Continuar?',
        'Confirmar personalización',
        [System.Windows.MessageBoxButton]::YesNo,
        [System.Windows.MessageBoxImage]::Question
      )
      if ($answer -eq [System.Windows.MessageBoxResult]::Yes) {
        $extensionsCatalogItem = Get-RiveroTweakById -Id 'PC-FILE-EXTENSIONS' -Catalog $catalog
        if ($null -eq $extensionsCatalogItem -or $extensionsCatalogItem.actionType -ne 'reversible') { throw 'La acción de extensiones no está validada en el catálogo.' }
        $extensionsResult = Invoke-RiveroFileExtensionsTweak -Confirm:$false
        $output.Add("[$($extensionsResult.Status)] Mostrar extensiones de archivo")
        foreach ($line in $extensionsResult.Details) { $output.Add("  • $line") }
        $extensionsControl.IsChecked = $false
        $undo.IsEnabled = $true
        $undo.Content = 'Deshacer cambios'
      }
    }
    $hiddenFilesControl = $window.FindName('TweakHiddenFiles')
    if ($hiddenFilesControl.IsChecked) {
      $answer = [System.Windows.MessageBox]::Show(
        'Se mostrarán archivos y carpetas ocultos para tu usuario. No se mostrarán archivos protegidos del sistema. Rivero guardará el valor anterior para poder deshacerlo. ¿Continuar?',
        'Confirmar personalización',
        [System.Windows.MessageBoxButton]::YesNo,
        [System.Windows.MessageBoxImage]::Question
      )
      if ($answer -eq [System.Windows.MessageBoxResult]::Yes) {
        $hiddenCatalogItem = Get-RiveroTweakById -Id 'PC-HIDDEN-FILES' -Catalog $catalog
        if ($null -eq $hiddenCatalogItem -or $hiddenCatalogItem.actionType -ne 'reversible') { throw 'La acción de archivos ocultos no está validada en el catálogo.' }
        $hiddenResult = Invoke-RiveroHiddenFilesTweak -Confirm:$false
        $output.Add("[$($hiddenResult.Status)] Mostrar archivos y carpetas ocultos")
        foreach ($line in $hiddenResult.Details) { $output.Add("  • $line") }
        $hiddenFilesControl.IsChecked = $false
        $undo.IsEnabled = $true
        $undo.Content = 'Deshacer cambios'
      }
    }
    $darkModeControl = $window.FindName('TweakDarkMode')
    if ($darkModeControl.IsChecked) {
      $answer = [System.Windows.MessageBox]::Show(
        'Se activará el modo oscuro para Windows y aplicaciones del usuario actual. Rivero guardará los valores anteriores para poder deshacerlos. ¿Continuar?',
        'Confirmar personalización',
        [System.Windows.MessageBoxButton]::YesNo,
        [System.Windows.MessageBoxImage]::Question
      )
      if ($answer -eq [System.Windows.MessageBoxResult]::Yes) {
        $darkCatalogItem = Get-RiveroTweakById -Id 'PC-DARK-MODE' -Catalog $catalog
        if ($null -eq $darkCatalogItem -or $darkCatalogItem.actionType -ne 'reversible') { throw 'El modo oscuro no está validado en el catálogo.' }
        $darkResult = Invoke-RiveroDarkModeTweak -Confirm:$false
        $output.Add("[$($darkResult.Status)] Activar modo oscuro de Windows")
        foreach ($line in $darkResult.Details) { $output.Add("  • $line") }
        $darkModeControl.IsChecked = $false
        $undo.IsEnabled = $true
        $undo.Content = 'Deshacer cambios'
      }
    }
    $gameModeControl = $window.FindName('TweakGameMode')
    if ($gameModeControl.IsChecked) {
      $answer = [System.Windows.MessageBox]::Show(
        'Se activará el Modo Juego para tu usuario. Rivero guardará los valores anteriores para poder deshacer el cambio. ¿Continuar?',
        'Confirmar optimización',
        [System.Windows.MessageBoxButton]::YesNo,
        [System.Windows.MessageBoxImage]::Question
      )
      if ($answer -eq [System.Windows.MessageBoxResult]::Yes) {
        $gameCatalogItem = Get-RiveroTweakById -Id 'PC-GAME-MODE' -Catalog $catalog
        if ($null -eq $gameCatalogItem -or $gameCatalogItem.actionType -ne 'reversible') { throw 'La acción Modo Juego no está validada en el catálogo.' }
        $gameResult = Invoke-RiveroReversibleTweak -Id 'PC-GAME-MODE' -Confirm:$false
        $output.Add("[$($gameResult.Status)] Activar Modo Juego de Windows")
        foreach ($line in $gameResult.Details) { $output.Add("  • $line") }
        $gameModeControl.IsChecked = $false
        $undo.IsEnabled = $true
        $undo.Content = 'Deshacer cambios'
      }
    }
    foreach ($entry in $actionMap.GetEnumerator()) {
      $control = $window.FindName($entry.Key)
      if ($control -and $control.IsChecked -and $control.Visibility -eq 'Visible') {
        $catalogItem = Get-RiveroTweakById -Id $entry.Value -Catalog $catalog
        if ($null -eq $catalogItem) { throw "El ajuste $($entry.Value) no existe en el catálogo validado." }
        $result = Invoke-RiveroTweak -Id $entry.Value -Mode $selectedMode
        $output.Add("[$($result.Status)] $($catalogItem.name)")
        foreach ($line in $result.Details) { $output.Add("  • $line") }
        $output.Add('')
      }
    }
    if ($output.Count -eq 0) { $output.Add('Selecciona al menos un diagnóstico o una guía disponible para este dispositivo.') }
    [System.Windows.MessageBox]::Show(($output -join [Environment]::NewLine), 'Rivero Optimizer') | Out-Null
    $hasReversibleBackup = (Test-Path -LiteralPath (Get-RiveroGameModeBackupPath)) -or (Test-Path -LiteralPath (Get-RiveroFileExtensionsBackupPath)) -or (Test-Path -LiteralPath (Get-RiveroDarkModeBackupPath)) -or (Test-Path -LiteralPath (Get-RiveroHiddenFilesBackupPath))
    $status.Text = if ($hasReversibleBackup) { 'Listo: cambios reversibles guardados para poder deshacer.' } else { 'Listo: diagnósticos y guías completados.' }
  }
  catch {
    [System.Windows.MessageBox]::Show($_.Exception.Message, 'Rivero Optimizer - Error') | Out-Null
    $status.Text = 'Ocurrió un error. Revisa el resultado: algún cambio anterior podría haberse aplicado. Usa Deshacer para restaurar las copias guardadas.'
  }
})
$undo.Add_Click({
  try {
    $gameBackupPath = Get-RiveroGameModeBackupPath
    $extensionsBackupPath = Get-RiveroFileExtensionsBackupPath
    $darkModeBackupPath = Get-RiveroDarkModeBackupPath
    $hiddenFilesBackupPath = Get-RiveroHiddenFilesBackupPath
    $hasGameBackup = Test-Path -LiteralPath $gameBackupPath -PathType Leaf
    $hasExtensionsBackup = Test-Path -LiteralPath $extensionsBackupPath -PathType Leaf
    $hasDarkModeBackup = Test-Path -LiteralPath $darkModeBackupPath -PathType Leaf
    $hasHiddenFilesBackup = Test-Path -LiteralPath $hiddenFilesBackupPath -PathType Leaf
    if (-not ($hasGameBackup -or $hasExtensionsBackup -or $hasDarkModeBackup -or $hasHiddenFilesBackup)) {
      [System.Windows.MessageBox]::Show('No hay cambios reversibles de Rivero para deshacer.', 'Rivero Optimizer') | Out-Null
      return
    }
    $answer = [System.Windows.MessageBox]::Show('Se restaurarán los ajustes reversibles que Rivero haya aplicado (Modo Juego, extensiones, archivos ocultos y/o modo oscuro). ¿Continuar?', 'Confirmar deshacer', [System.Windows.MessageBoxButton]::YesNo, [System.Windows.MessageBoxImage]::Question)
    if ($answer -eq [System.Windows.MessageBoxResult]::Yes) {
      $undoDetails = New-Object System.Collections.Generic.List[string]
      if ($hasHiddenFilesBackup) {
        $result = Undo-RiveroHiddenFilesTweak -Confirm:$false
        foreach ($line in $result.Details) { $undoDetails.Add($line) }
      }
      if ($hasDarkModeBackup) {
        $result = Undo-RiveroDarkModeTweak -Confirm:$false
        foreach ($line in $result.Details) { $undoDetails.Add($line) }
      }
      if ($hasGameBackup) {
        $result = Undo-RiveroReversibleTweak -Id 'PC-GAME-MODE' -Confirm:$false
        foreach ($line in $result.Details) { $undoDetails.Add($line) }
      }
      if ($hasExtensionsBackup) {
        $result = Undo-RiveroFileExtensionsTweak -Confirm:$false
        foreach ($line in $result.Details) { $undoDetails.Add($line) }
      }
      [System.Windows.MessageBox]::Show(($undoDetails -join [Environment]::NewLine), 'Rivero Optimizer') | Out-Null
      $undo.IsEnabled = $false
      $undo.Content = 'Sin cambios para deshacer'
      $status.Text = 'Se restauraron los ajustes reversibles seleccionados.'
    }
  }
  catch {
    [System.Windows.MessageBox]::Show($_.Exception.Message, 'Rivero Optimizer - Error') | Out-Null
  }
})
function Get-VisualChildren([System.Windows.DependencyObject]$Parent) {
  if ($null -eq $Parent) { return }
  for ($i = 0; $i -lt [System.Windows.Media.VisualTreeHelper]::GetChildrenCount($Parent); $i++) {
    $child = [System.Windows.Media.VisualTreeHelper]::GetChild($Parent, $i)
    $child
    Get-VisualChildren $child
  }
}
$categoryPanel = $window.FindName('CategoryPanel')
function Get-RiveroSelectedCategory {
  $selectedRadio = Get-VisualChildren $categoryPanel | Where-Object {
    $_ -is [System.Windows.Controls.RadioButton] -and $_.IsChecked
  } | Select-Object -First 1
  if ($selectedRadio) { return [string]$selectedRadio.Content }
  return 'Standard'
}
function Get-RiveroUiCategory([System.Windows.Controls.CheckBox]$Control) {
  $name = [string]$Control.Name
  $label = [string]$Control.Content
  if ($name -in @('TweakOsInfo','TweakHardwareInfo')) { return 'Windows' }
  if ($name -eq 'TweakPowerInfo' -or $name -eq 'TweakPcPowerGuide' -or $label -match 'energía|potencia') { return 'Power' }
  if ($name -eq 'TweakStartupAudit' -or $label -match 'inicio|rendimiento|segundo plano') { return 'Performance' }
  if ($name -eq 'TweakGameMode' -or $label -match 'juego|gaming') { return 'Gaming' }
  if ($name -eq 'TweakSecurityGuide' -or $label -match 'privacidad|seguridad|protecciones') { return 'Privacy' }
  if ($label -match 'IPv6|red|network') { return 'Network' }
  if ($name -in @('TweakDarkMode','TweakFileExtensions','TweakHiddenFiles') -or $label -match 'mouse|barra de tareas|pantalla|carpetas|extensiones') { return 'Desktop' }
  return 'Advanced'
}
function Set-DeviceVisibility {
  $selected = 'PC'
  $profile = Get-RiveroSelectedCategory
  foreach ($control in (Get-VisualChildren $window)) {
    if ($control -is [System.Windows.Controls.CheckBox] -and $control.Tag) {
      $target = [string]$control.Tag
      $deviceMatch = ($target -eq 'BOTH' -or $target -eq $selected.ToUpperInvariant())
      $query = [string]$search.Text
      $searchMatch = [string]::IsNullOrWhiteSpace($query) -or ([string]$control.Content).IndexOf($query, [System.StringComparison]::OrdinalIgnoreCase) -ge 0
      $uiCategory = Get-RiveroUiCategory -Control $control
      $categoryMatch = switch ($profile) {
        'Standard' { $control.Name -in @('TweakOsInfo','TweakHardwareInfo','TweakPowerInfo','TweakStartupAudit','TweakGameMode','TweakDarkMode','TweakFileExtensions','TweakHiddenFiles','TweakPcPowerGuide','TweakSecurityGuide') }
        'Minimal' { $control.Name -in @('TweakOsInfo','TweakHardwareInfo','TweakPowerInfo','TweakSecurityGuide') }
        'Advanced' { $true }
        default { $uiCategory -eq $profile }
      }
      $control.Visibility = if ($deviceMatch -and $searchMatch -and $categoryMatch) { 'Visible' } else { 'Collapsed' }
    }
  }
  $status.Text = "Perfil PC · $profile · Las opciones en desarrollo están deshabilitadas."
}
$search.Add_TextChanged({ Set-DeviceVisibility })
foreach ($radio in (Get-VisualChildren $categoryPanel | Where-Object { $_ -is [System.Windows.Controls.RadioButton] })) { $radio.Add_Checked({ Set-DeviceVisibility }) }
Set-DeviceVisibility
# Solo se habilitan controles que tienen una acción real y validada en el catálogo.
$supportedControlNames = @(
  'TweakOsInfo',
  'TweakHardwareInfo',
  'TweakPowerInfo',
  'TweakStartupAudit',
  'TweakGameMode',
  'TweakDarkMode',
  'TweakFileExtensions',
  'TweakHiddenFiles',
  'TweakPcPowerGuide',
  'TweakSecurityGuide'
)
foreach ($control in (Get-VisualChildren $window)) {
  if ($control -is [System.Windows.Controls.CheckBox] -and $control.Name -notin $supportedControlNames) {
    $control.IsChecked = $false
    $control.IsEnabled = $false
    $control.ToolTip = 'En desarrollo: todavía no ejecuta ninguna acción.'
  }
}
$window.ShowDialog() | Out-Null
