# RIVERO OPTIMIZER 0.5.0-preview - SOLO LECTURA
# Windows PowerShell 5.1+. No aplica ni revierte cambios. No requiere admin.
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()
$Root=Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $Root 'Modules/DeviceProfile.ps1')
. (Join-Path $Root 'Modules/TweakCatalog.ps1')
$catalog=Import-RiveroTweakCatalog -Path (Join-Path $Root 'Catalog/shared/safe-starter.json')
$detectedProfile=Get-RiveroDeviceProfile -Mode Auto
$script:DeviceMode=if($detectedProfile.Mode -in @('PC','LAPTOP')){$detectedProfile.Mode}else{'PC'}
$bg=[Drawing.Color]::FromArgb(11,15,12); $surface=[Drawing.Color]::FromArgb(17,24,19)
$cardColor=[Drawing.Color]::FromArgb(23,34,26); $green=[Drawing.Color]::FromArgb(34,197,94)
$fg=[Drawing.Color]::FromArgb(243,244,246); $muted=[Drawing.Color]::FromArgb(167,179,170)
function New-Label([string]$Text,[int]$X,[int]$Y,[int]$W,[int]$H,[float]$Size=9,[Drawing.Color]$Color=$fg){
 $c=New-Object Windows.Forms.Label; $c.Text=$Text; $c.Location=New-Object Drawing.Point($X,$Y); $c.Size=New-Object Drawing.Size($W,$H); $c.ForeColor=$Color; $c.BackColor=[Drawing.Color]::Transparent; $c.Font=New-Object Drawing.Font('Segoe UI',$Size); return $c
}
$form=New-Object Windows.Forms.Form; $form.Text='Rivero Optimizer | Preview 0.5.0'; $form.Size=New-Object Drawing.Size(1120,760); $form.MinimumSize=New-Object Drawing.Size(980,680); $form.StartPosition='CenterScreen'; $form.BackColor=$bg; $form.ForeColor=$fg; $form.Font=New-Object Drawing.Font('Segoe UI',9)
$header=New-Object Windows.Forms.Panel; $header.Dock='Top'; $header.Height=82; $header.BackColor=$surface; $form.Controls.Add($header)
$header.Controls.Add((New-Label 'RIVERO OPTIMIZER' 22 10 360 34 20 $fg))
$header.Controls.Add((New-Label 'WINDOWS PERFORMANCE TOOLKIT  •  PREVIEW' 24 48 470 20 8 $muted))
$header.Controls.Add((New-Label 'DISPOSITIVO' 760 13 110 18 8 $muted))
$deviceBox=New-Object Windows.Forms.ComboBox; $deviceBox.Location=New-Object Drawing.Point(760,35); $deviceBox.Size=New-Object Drawing.Size(170,28); $deviceBox.DropDownStyle='DropDownList'; $deviceBox.BackColor=$cardColor; $deviceBox.ForeColor=$fg; [void]$deviceBox.Items.AddRange(@('PC','LAPTOP')); $deviceBox.SelectedItem=$script:DeviceMode; $header.Controls.Add($deviceBox)
$tabs=New-Object Windows.Forms.TabControl; $tabs.Dock='Fill'; $tabs.Font=New-Object Drawing.Font('Segoe UI',10); $form.Controls.Add($tabs)
$adjust=New-Object Windows.Forms.TabPage; $adjust.Text='Ajustes'; $adjust.BackColor=$bg
$install=New-Object Windows.Forms.TabPage; $install.Text='Instalación'; $install.BackColor=$bg
$config=New-Object Windows.Forms.TabPage; $config.Text='Configuración'; $config.BackColor=$bg
$updates=New-Object Windows.Forms.TabPage; $updates.Text='Actualizaciones'; $updates.BackColor=$bg
[void]$tabs.TabPages.AddRange(@($adjust,$install,$config,$updates))
$sidebar=New-Object Windows.Forms.Panel; $sidebar.Location=New-Object Drawing.Point(14,14); $sidebar.Size=New-Object Drawing.Size(220,570); $sidebar.BackColor=$surface; $adjust.Controls.Add($sidebar)
$sidebar.Controls.Add((New-Label 'CATEGORÍAS' 14 15 180 22 10 $muted))
$category=New-Object Windows.Forms.ListBox; $category.Location=New-Object Drawing.Point(10,45); $category.Size=New-Object Drawing.Size(198,390); $category.BorderStyle='None'; $category.BackColor=$surface; $category.ForeColor=$fg; $category.Font=New-Object Drawing.Font('Segoe UI',10); [void]$category.Items.Add('Todos')
foreach($c in @($catalog.tweaks|ForEach-Object{$_.category}|Sort-Object -Unique)){[void]$category.Items.Add($c)}
$category.SelectedIndex=0; $sidebar.Controls.Add($category)
$sidebar.Controls.Add((New-Label 'PERFIL' 14 455 180 20 9 $muted)); $sidebar.Controls.Add((New-Label 'Seguro · Solo lectura' 14 480 190 24 9 $green))
$adjust.Controls.Add((New-Label 'AJUSTES DISPONIBLES' 255 18 500 32 17 $fg))
$adjust.Controls.Add((New-Label 'Catálogo filtrado según el dispositivo seleccionado.' 257 50 620 22 9 $muted))
$search=New-Object Windows.Forms.TextBox; $search.Location=New-Object Drawing.Point(255,82); $search.Size=New-Object Drawing.Size(610,30); $search.Font=New-Object Drawing.Font('Segoe UI',10); $search.BackColor=$cardColor; $search.ForeColor=$fg; $search.BorderStyle='FixedSingle'; $adjust.Controls.Add($search)
$list=New-Object Windows.Forms.FlowLayoutPanel; $list.Location=New-Object Drawing.Point(255,125); $list.Size=New-Object Drawing.Size(820,395); $list.AutoScroll=$true; $list.FlowDirection='TopDown'; $list.WrapContents=$false; $list.BackColor=$bg; $adjust.Controls.Add($list)
$status=New-Label 'Modo de prueba: no se realizan cambios en Windows.' 257 530 790 24 9 $green; $adjust.Controls.Add($status)
$diag=New-Object Windows.Forms.Button; $diag.Text='VER DIAGNÓSTICO'; $diag.Location=New-Object Drawing.Point(255,565); $diag.Size=New-Object Drawing.Size(180,38); $diag.FlatStyle='Flat'; $diag.FlatAppearance.BorderSize=0; $diag.BackColor=$green; $diag.ForeColor=$bg; $adjust.Controls.Add($diag)
function Update-Cards {
 $list.SuspendLayout(); $list.Controls.Clear()
 $available=@(Get-RiveroAvailableTweaks -Mode $script:DeviceMode -Catalog $catalog); $selected=[string]$category.SelectedItem; $q=$search.Text.Trim()
 $items=@($available|Where-Object{($selected -eq 'Todos' -or $_.category -eq $selected) -and ([string]::IsNullOrWhiteSpace($q) -or $_.name -like "*$q*" -or $_.description -like "*$q*")})
 foreach($item in $items){
  $p=New-Object Windows.Forms.Panel; $p.Size=New-Object Drawing.Size(780,78); $p.BackColor=$cardColor; $p.Margin=New-Object Windows.Forms.Padding(3,4,3,4)
  $p.Controls.Add((New-Label $item.name 14 9 730 23 10 $fg)); $p.Controls.Add((New-Label $item.description 14 34 730 20 8 $muted))
  $p.Controls.Add((New-Label ("{0}  ·  Riesgo: {1}  ·  {2}" -f $item.category,$item.risk,$item.actionType) 14 55 730 18 7 $green)); $list.Controls.Add($p)
 }
 if($items.Count -eq 0){$list.Controls.Add((New-Label 'No hay ajustes en esta categoría.' 15 15 600 30 10 $muted))}
 $status.Text=("{0} opciones disponibles para {1}. Solo lectura." -f $items.Count,$script:DeviceMode); $list.ResumeLayout()
}
$category.Add_SelectedIndexChanged({Update-Cards}); $search.Add_TextChanged({Update-Cards})
$deviceBox.Add_SelectedIndexChanged({if($deviceBox.SelectedItem -in @('PC','LAPTOP')){$script:DeviceMode=[string]$deviceBox.SelectedItem;Update-Cards}})
$diag.Add_Click({
 try {
  $os=Get-CimInstance Win32_OperatingSystem -ErrorAction Stop; $cpu=Get-CimInstance Win32_Processor -ErrorAction Stop|Select-Object -First 1
  $computer=Get-CimInstance Win32_ComputerSystem -ErrorAction Stop; $gpu=Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue
  $ram=[math]::Round($computer.TotalPhysicalMemory/1GB,1); $gpuNames=(@($gpu|ForEach-Object{$_.Name}) -join ', ')
  $message=@("Windows: $($os.Caption) $($os.Version)","CPU: $($cpu.Name)","RAM: $ram GB","GPU: $gpuNames","Perfil elegido: $script:DeviceMode","Detección automática: $($detectedProfile.Reason)",'',"Esta vista previa no ha modificado el equipo.") -join [Environment]::NewLine
  [Windows.Forms.MessageBox]::Show($message,'Diagnóstico Rivero','OK','Information')|Out-Null
 }catch{[Windows.Forms.MessageBox]::Show("No se pudo leer toda la información: $($_.Exception.Message)",'Diagnóstico Rivero','OK','Warning')|Out-Null}
})
function Add-InfoPage($Page,[string]$Title,[string]$Description){$Page.Controls.Add((New-Label $Title 30 35 760 40 19 $fg));$Page.Controls.Add((New-Label $Description 32 85 820 60 10 $muted));$Page.Controls.Add((New-Label 'Esta sección se habilitará en una siguiente versión.' 32 155 820 30 9 $green))}
Add-InfoPage $install 'Instalación de aplicaciones' 'La interfaz de instalación está reservada para el catálogo de aplicaciones.'
Add-InfoPage $config 'Configuración de Windows' 'Aquí se integrarán opciones compatibles con PC y Laptop.'
Add-InfoPage $updates 'Actualizaciones' 'Aquí se mostrarán controles e información de Windows Update.'
Update-Cards; $form.Add_Shown({$form.Activate()}); [void]$form.ShowDialog()
