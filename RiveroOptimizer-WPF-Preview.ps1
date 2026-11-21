# Rivero Optimizer - WPF UI preview
# Windows PowerShell 5.1+. UI-only: no Windows settings are changed.
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
      <Setter Property="Margin" Value="5,3"/>
      <Setter Property="Foreground" Value="#F3F4F6"/>
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
        <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
          <Button Content="Ajustes" Width="105" Background="#22C55E"/>
          <Button Content="Configuración" Width="125"/>
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
        <TextBlock x:Name="StatusText" Text="Perfil PC · Diagnósticos y guías seguras; Windows no se modifica."
                   Foreground="#86EFAC" VerticalAlignment="Center"/>
        <StackPanel DockPanel.Dock="Right" Orientation="Horizontal">
          <Button x:Name="RunButton" Content="Ejecutar seleccionados" Width="180"/>
          <Button x:Name="UndoButton" Content="Deshacer ajustes seleccionados" Width="225"/>
        </StackPanel>
      </DockPanel>
    </Border>
    <TabControl Background="#0B0F0C" BorderBrush="#26352A" Margin="8">
      <TabItem Header="Ajustes">
        <Grid Margin="8">
          <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/></Grid.RowDefinitions>
          <StackPanel Grid.Row="0" Orientation="Horizontal" Margin="0,4,0,10">
            <TextBlock Text="Selecciones recomendadas:" Foreground="#86EFAC" VerticalAlignment="Center" Margin="4,0,12,0"/>
            <Button Content="Estándar" Width="180"/><Button Content="Mínimo" Width="180"/>
            <Button Content="Avanzado" Width="180"/><Button Content="Limpiar" Width="180"/>
            <Button Content="Seleccionar instalados" Width="190"/>
            <Button Content="Quitar AppX" Width="150"/>
          </StackPanel>
          <Grid Grid.Row="1">
            <Grid.ColumnDefinitions><ColumnDefinition Width="1.05*"/><ColumnDefinition Width="*"/></Grid.ColumnDefinitions>
            <ScrollViewer Grid.Column="0" VerticalScrollBarVisibility="Auto" Margin="0,0,8,0">
              <StackPanel Background="#111813" Margin="0,0,5,0">
                <TextBlock Text="Ajustes esenciales" Foreground="#86EFAC" FontFamily="Consolas" FontSize="15" Margin="10,8"/>
                <CheckBox Content="Desactivar historial de actividad" Tag="BOTH"/>
                <CheckBox Content="Optimización de distribución: revisar configuración" Tag="BOTH"/>
                <CheckBox Content="Ejecutar limpieza de disco" Tag="BOTH"/>
                <CheckBox Content="Activar clic derecho para finalizar tareas" Tag="BOTH"/>
                <CheckBox Content="Desactivar descubrimiento automático de carpetas" Tag="BOTH"/>
                <CheckBox Content="Revisar aplicaciones de inicio" Tag="BOTH"/>
                <CheckBox Content="Información de Windows" Name="TweakOsInfo" Tag="BOTH" IsChecked="True"/>
                <CheckBox Content="Información del hardware" Name="TweakHardwareInfo" Tag="BOTH" IsChecked="True"/>
                <CheckBox Content="Estado de energía" Name="TweakPowerInfo" Tag="BOTH" IsChecked="True"/>
                <CheckBox Content="Crear punto de restauración" Tag="BOTH" IsEnabled="False"/>
                <CheckBox Content="Revisar servicios configurados manualmente" Tag="BOTH"/>
                <CheckBox Content="Eliminar archivos temporales" Tag="BOTH"/>
                <CheckBox Content="Revisar Widgets" Tag="BOTH"/>
                <TextBlock Text="Ajustes avanzados   ·   PRECAUCIÓN" Foreground="#86EFAC" FontSize="15" Margin="10,18,5,8"/>
                <CheckBox Content="Revisar aplicaciones en segundo plano" Tag="BOTH"/>
                <CheckBox Content="Revisar almacenamiento reservado" Tag="PC"/>
                <CheckBox Content="Revisar configuración IPv6" Tag="BOTH"/>
                <CheckBox Content="Revisar componentes opcionales de Windows" Tag="BOTH"/>
                <CheckBox Content="Mostrar información de privacidad" Tag="BOTH"/>
              </StackPanel>
            </ScrollViewer>
            <ScrollViewer Grid.Column="1" VerticalScrollBarVisibility="Auto">
              <StackPanel Background="#111813" Margin="5,0,0,0">
                <TextBlock Text="Personalizar preferencias" Foreground="#86EFAC" FontFamily="Consolas" FontSize="15" Margin="10,8"/>
                <CheckBox Content="Modo oscuro de Windows" IsChecked="True" Tag="BOTH"/>
                <CheckBox Content="Mostrar extensiones de archivo" IsChecked="True" Tag="BOTH"/>
                <CheckBox Content="Mostrar archivos ocultos" IsChecked="True" Tag="BOTH"/>
                <CheckBox Content="Modo Juego" IsChecked="True" Tag="BOTH"/>
                <CheckBox Content="Revisar plan de energía de escritorio" Tag="PC"/>
                <CheckBox Content="Revisar inicio rápido y estado de energía" Tag="PC"/>
                <CheckBox Content="Desactivar sugerencias de pantalla de bloqueo" Tag="BOTH"/>
                <CheckBox Content="Mostrar pantalla de inicio detallada" Tag="BOTH"/>
                <CheckBox Content="Aceleración del mouse" Tag="BOTH"/>
                <CheckBox Content="Bloqueo numérico al iniciar" Tag="BOTH"/>
                <CheckBox Content="Revisar plan de energía del PC" Name="TweakPcPowerGuide" Tag="PC"/>
                <CheckBox Content="Conservar protecciones de Windows" Name="TweakSecurityGuide" Tag="BOTH" IsChecked="True"/>
                <CheckBox Content="Centrar iconos de la barra de tareas" Tag="BOTH"/>
                <CheckBox Content="Mantener protecciones de Windows" IsChecked="True" IsEnabled="False" Tag="BOTH"/>
              </StackPanel>
            </ScrollViewer>
          </Grid>
        </Grid>
      </TabItem>
      <TabItem Header="Configuración">
        <StackPanel Margin="24" Background="#111813">
          <TextBlock Text="Configuración de Rivero Optimizer" Foreground="#86EFAC" FontSize="18" Margin="12,12"/>
          <TextBlock Text="Información y contacto" Foreground="#86EFAC" FontSize="15" Margin="12,8"/>
          <TextBlock Text="TikTok: davii.cf" FontSize="17" Margin="12,6"/>
          <TextBlock Text="Discord: desgastarte" FontSize="17" Margin="12,6"/>
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
$catalogPath = Join-Path $PSScriptRoot 'Catalog/shared/safe-starter.json'
foreach ($requiredPath in @($modulePath, $catalogModulePath, $catalogPath)) {
  if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
    throw "Falta un componente necesario de Rivero Optimizer: $requiredPath"
  }
}
. $modulePath
. $catalogModulePath
$catalog = Import-RiveroTweakCatalog -Path $catalogPath
$undo.IsEnabled = $false
$undo.Content = 'Sin cambios para deshacer'
$run.Add_Click({
  try {
    $selectedMode = 'PC'
    $actionMap = @{
      TweakOsInfo = 'SYS-OS-INFO'
      TweakHardwareInfo = 'SYS-HARDWARE-INFO'
      TweakPowerInfo = 'SYS-POWER-STATUS'
      TweakPcPowerGuide = 'PC-POWER-GUIDE'
      TweakSecurityGuide = 'SECURITY-PRESERVE'
    }
    $output = New-Object System.Collections.Generic.List[string]
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
    $status.Text = "Listo: se ejecutaron diagnósticos y guías para PC. No se modificó Windows."
  }
  catch {
    [System.Windows.MessageBox]::Show($_.Exception.Message, 'Rivero Optimizer - Error') | Out-Null
    $status.Text = 'Ocurrió un error. No se aplicaron cambios.'
  }
})
$undo.Add_Click({
  [System.Windows.MessageBox]::Show('Esta versión solo ejecuta diagnósticos y guías manuales. No hay cambios del sistema que revertir.', 'Rivero Optimizer') | Out-Null
})
function Get-VisualChildren([System.Windows.DependencyObject]$Parent) {
  if ($null -eq $Parent) { return }
  for ($i = 0; $i -lt [System.Windows.Media.VisualTreeHelper]::GetChildrenCount($Parent); $i++) {
    $child = [System.Windows.Media.VisualTreeHelper]::GetChild($Parent, $i)
    $child
    Get-VisualChildren $child
  }
}
function Set-DeviceVisibility {
  $selected = 'PC'
  foreach ($control in (Get-VisualChildren $window)) {
    if ($control -is [System.Windows.Controls.CheckBox] -and $control.Tag) {
      $target = [string]$control.Tag
      $deviceMatch = ($target -eq 'BOTH' -or $target -eq $selected.ToUpperInvariant())
      $query = [string]$search.Text
      $searchMatch = [string]::IsNullOrWhiteSpace($query) -or ([string]$control.Content).IndexOf($query, [System.StringComparison]::OrdinalIgnoreCase) -ge 0
      $control.Visibility = if ($deviceMatch -and $searchMatch) { 'Visible' } else { 'Collapsed' }
    }
  }
  $status.Text = "Perfil PC: ajustes disponibles para ordenador de escritorio. Interfaz en español; sin cambios en Windows."
}
$search.Add_TextChanged({ Set-DeviceVisibility })
Set-DeviceVisibility
# Solo se habilitan controles que tienen una acción real y validada en el catálogo.
$supportedControlNames = @(
  'TweakOsInfo',
  'TweakHardwareInfo',
  'TweakPowerInfo',
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
