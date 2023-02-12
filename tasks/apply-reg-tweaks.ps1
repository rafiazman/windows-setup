Write-Host "Applying personal registry tweaks..."

# Apply Dark Theme at App-Level
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name AppsUseLightTheme -Value 0 -Type Dword -Force
# Apply Dark Theme at System-Level
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name SystemUsesLightTheme -Value 0 -Type Dword -Force

# Remove Recommended section from Start Menu
if (!(Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer)) {
    [void](New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer)
}
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name HideRecommendedSection -Value 1 -Type Dword -Force

# Fix Windows Explorer hogging CPU usage
# https://christitus.com/windows-explorer-stealing-cpu/
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\input' -Name IsInputAppPreloadEnabled -Value 0 -Type Dword -Force
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Dsh' -Name IsPrelaunchEnabled -Value 0 -Type Dword -Force

# Move Windows 11 Start Menu to left side
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarAl -Value 0 -Type Dword -Force
# Remove Widgets from Start Menu
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarDa -Value 0 -Type Dword -Force
# Remove Search from Start Menu
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name SearchboxTaskbarMode -Value 0 -Type Dword -Force
# Remove Task View from Start Menu
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name ShowTaskViewButton -Value 0 -Type Dword -Force
# Remove Chat from Start Menu
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarMn -Value 0 -Type Dword -Force

# Remove default wallpaper
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop\' -Name WallPaper -value ""

# Unpin all applications on taskbar
Write-Host "Unpinning Apps..."
$TaskbarAppList = (New-Object -Com Shell.Application).NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()
foreach ($App in $TaskbarAppList) {
    $App.Verbs() | ForEach-Object { if ($_.Name -eq "Unpin from tas&kbar") { Write-Host "Unpinning "$App.Name; $_.DoIt() } }
}
Write-Host ""

# Restart explorer.exe
# Stop-Process -Name explorer -Force

# Put focus back on powershell window via alt+tab
# https://stackoverflow.com/a/54608116
# $wshell = New-Object -ComObject wscript.shell
# $wshell.SendKeys('%{TAB}')

Write-Host "Personal registry tweaks applied."
Show-Confirm-Prompt "Press any key to reboot..."
Restart-Computer