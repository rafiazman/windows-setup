<#
    Customize Taskbar in Windows 11
    Sassan Fanai / Jörgen Nilsson
    Original: https://raw.githubusercontent.com/Ccmexec/PowerShell/master/Customize%20TaskBar%20and%20Start%20Windows%2011/CustomizeTaskbar.ps1
#>

$RegValueName = "CustomizeTaskbar"
$FullRegKeyName = "HKLM:\SOFTWARE\ccmexec\" 

# Create registry value if it doesn't exist
If (!(Test-Path $FullRegKeyName)) {
    New-Item -Path $FullRegKeyName -type Directory -force 
}

New-ItemProperty $FullRegKeyName -Name $RegValueName -Value "1" -Type STRING -Force

REG LOAD HKLM\Default C:\Users\Default\NTUSER.DAT

Write-Host "Attempting to run: Remove Task View button from Taskbar"
$reg = New-ItemProperty "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value "0" -PropertyType Dword -Force
try { $reg.Handle.Close() } catch {}

Write-Host "Attempting to run: Remove Widgets button from Taskbar"
$reg = New-ItemProperty "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value "0" -PropertyType Dword -Force
try { $reg.Handle.Close() } catch {}

Write-Host "Attempting to run: Remove Chat from Taskbar"
$reg = New-ItemProperty "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value "0" -PropertyType Dword -Force
try { $reg.Handle.Close() } catch {}

Write-Host "Attempting to run: Move Start Menu to left side (0 = Left)"
$reg = New-ItemProperty "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value "0" -PropertyType Dword -Force
try { $reg.Handle.Close() } catch {}

Write-Host "Attempting to run: Remove search from Taskbar"
$RegKey = "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Search"
if (-not(Test-Path $RegKey )) {
    $reg = New-Item $RegKey -Force | Out-Null
    try { $reg.Handle.Close() } catch {}
}
$reg = New-ItemProperty $RegKey -Name "SearchboxTaskbarMode"  -Value "0" -PropertyType Dword -Force
try { $reg.Handle.Close() } catch {}

[GC]::Collect()
REG UNLOAD HKLM\Default

Stop-Process -Name explorer -Force