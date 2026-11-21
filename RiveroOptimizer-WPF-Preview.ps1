# Rivero Optimizer - WPF UI preview
# Windows PowerShell 5.1+. UI-only: no Windows settings are changed.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Rivero Optimizer | Preview" Height="790" Width="1420"
        MinHeight="650" MinWidth="1050" WindowStartupLocation="CenterScreen"
        Background="#171D2A" Foreground="#F3F4F6" FontFamily="Segoe UI">
  <Window.Resources>
    <SolidColorBrush x:Key="Panel" Color="#202B3D"/>
    <SolidColorBrush x:Key="Green" Color="#22C55E"/>
    <Style TargetType="Button">
      <Setter Property="Foreground" Value="#F3F4F6"/>
      <Setter Property="Background" Value="#263449"/>
      <Setter Property="BorderBrush" Value="#64748B"/>
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
    <Border DockPanel.Dock="Top" Background="#202B3D" Padding="12">
      <Grid>
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="Auto"/><ColumnDefinition Width="*"/>
          <ColumnDefinition Width="Auto"/><ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        <TextBlock Text="◆" Foreground="#22C55E" FontSize="28" VerticalAlignment="Center" Margin="5,0,18,0"/>
        <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Center">
          <Button Content="Instalar" Width="105"/>
          <Button Content="Ajustes" Width="105" Background="#315A43"/>
          <Button Content="Configuración" Width="125"/>
          <Button Content="Actualizaciones" Width="125"/>
          <Button Content="Crear Windows 11" Width="145"/>
        </StackPanel>
        <TextBox x:Name="SearchBox" Grid.Column="2" Width="230" Height="27" Margin="10,0"
                 VerticalContentAlignment="Center" Background="#17202D" Foreground="#F3F4F6"
                 BorderBrush="#64748B" ToolTip="Buscar ajustes"/>
        <ComboBox x:Name="DeviceMode" Grid.Column="3" Width="115" Height="27" SelectedIndex="0"
                  VerticalContentAlignment="Center" Background="#263449" Foreground="#111827">
          <ComboBoxItem Content="PC"/><ComboBoxItem Content="Laptop"/>
        </ComboBox>
      </Grid>
    </Border>
    <Border DockPanel.Dock="Bottom" Background="#202B3D" Padding="8">
      <DockPanel>
        <TextBlock x:Name="StatusText" Text="Vista previa: no se aplican cambios en Windows."
                   Foreground="#86EFAC" VerticalAlignment="Center"/>
        <StackPanel DockPanel.Dock="Right" Orientation="Horizontal">
          <Button x:Name="RunButton" Content="Ejecutar ajustes" Width="180"/>
          <Button x:Name="UndoButton" Content="Deshacer ajustes seleccionados" Width="225"/>
        </StackPanel>
      </DockPanel>
    </Border>
    <TabControl Background="#171D2A" BorderBrush="#475569" Margin="8">
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
            <Grid.ColumnDefinitions><ColumnDefinition Width="1.05*"/><ColumnDefinition Width="1fr"/></Grid.ColumnDefinitions>
            <ScrollViewer Grid.Column="0" VerticalScrollBarVisibility="Auto" Margin="0,0,8,0">
              <StackPanel Background="#202B3D" Margin="0,0,5,0">
                <TextBlock Text="Ajustes esenciales" Foreground="#86B6FF" FontFamily="Consolas" FontSize="15" Margin="10,8"/>
                <CheckBox Content="Desactivar historial de actividad"/>
                <CheckBox Content="Optimización de distribución: revisar configuración"/>
                <CheckBox Content="Ejecutar limpieza de disco"/>
                <CheckBox Content="Activar clic derecho para finalizar tareas"/>
                <CheckBox Content="Desactivar descubrimiento automático de carpetas"/>
                <CheckBox Content="Revisar aplicaciones de inicio"/>
                <CheckBox Content="Crear punto de restauración"/>
                <CheckBox Content="Revisar servicios configurados manualmente"/>
                <CheckBox Content="Eliminar archivos temporales"/>
                <CheckBox Content="Revisar Widgets"/>
                <TextBlock Text="Ajustes avanzados   ·   PRECAUCIÓN" Foreground="#86B6FF" FontSize="15" Margin="10,18,5,8"/>
                <CheckBox Content="Revisar aplicaciones en segundo plano"/>
                <CheckBox Content="Revisar almacenamiento reservado"/>
                <CheckBox Content="Revisar configuración IPv6"/>
                <CheckBox Content="Revisar componentes opcionales de Windows"/>
                <CheckBox Content="Mostrar información de privacidad"/>
              </StackPanel>
            </ScrollViewer>
            <ScrollViewer Grid.Column="1" VerticalScrollBarVisibility="Auto">
              <StackPanel Background="#202B3D" Margin="5,0,0,0">
                <TextBlock Text="Personalizar preferencias" Foreground="#86B6FF" FontFamily="Consolas" FontSize="15" Margin="10,8"/>
                <CheckBox Content="Modo oscuro de Windows" IsChecked="True"/>
                <CheckBox Content="Mostrar extensiones de archivo" IsChecked="True"/>
                <CheckBox Content="Mostrar archivos ocultos" IsChecked="True"/>
                <CheckBox Content="Modo Juego" IsChecked="True"/>
                <CheckBox Content="Desactivar sugerencias de pantalla de bloqueo"/>
                <CheckBox Content="Mostrar pantalla de inicio detallada"/>
                <CheckBox Content="Aceleración del mouse"/>
                <CheckBox Content="Bloqueo numérico al iniciar"/>
                <CheckBox Content="Mostrar porcentaje de batería"/>
                <CheckBox Content="Centrar iconos de la barra de tareas"/>
                <CheckBox Content="Mantener protecciones de Windows" IsChecked="True" IsEnabled="False"/>
                <CheckBox Content="Mantener protección térmica del fabricante" IsChecked="True" IsEnabled="False"/>
              </StackPanel>
            </ScrollViewer>
          </Grid>
        </Grid>
      </TabItem>
      <TabItem Header="Instalar"><TextBlock Text="Catálogo de aplicaciones: integración pendiente." Margin="20"/></TabItem>
      <TabItem Header="Configuración"><TextBlock Text="Configuración de Windows: integración pendiente." Margin="20"/></TabItem>
      <TabItem Header="Actualizaciones"><TextBlock Text="Administración de actualizaciones: integración pendiente." Margin="20"/></TabItem>
      <TabItem Header="Crear Windows 11"><TextBlock Text="Creador de medios: integración pendiente." Margin="20"/></TabItem>
    </TabControl>
  </DockPanel>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)
$run = $window.FindName('RunButton')
$undo = $window.FindName('UndoButton')
$status = $window.FindName('StatusText')
$mode = $window.FindName('DeviceMode')
$run.Add_Click({ [System.Windows.MessageBox]::Show('Esta vista previa solo muestra la interfaz. Todavía no aplica ajustes.','Rivero Optimizer') | Out-Null })
$undo.Add_Click({ [System.Windows.MessageBox]::Show('No hay cambios que revertir en esta vista previa.','Rivero Optimizer') | Out-Null })
$mode.Add_SelectionChanged({ if ($mode.SelectedItem) { $status.Text = "Perfil seleccionado: $($mode.SelectedItem.Content) · Vista previa solamente." } })
$window.ShowDialog() | Out-Null
