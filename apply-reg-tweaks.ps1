# Apply Dark Theme at App-Level
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name AppsUseLightTheme -Value 0 -Type Dword -Force
# Apply Dark Theme at System-Level
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name SystemUsesLightTheme -Value 0 -Type Dword -Force

# Remove Recommended section from Start Menu
if (!(Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer)) {
    New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer 
}
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name HideRecommendedSection -Value 1 -Type Dword -Force

# Fix Windows Explorer hogging CPU usage
# Source: https://christitus.com/windows-explorer-stealing-cpu/
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

# Restart explorer.exe
Stop-Process -Name explorer -Force