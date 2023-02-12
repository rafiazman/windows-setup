# This script provisions a fresh Windows 11 install with the software I use
# on a daily basis in addition to applying my preferred settings.
#
# Written by Rafi Azman

$base_url = "https://raw.githubusercontent.com/rafiazman/windows-setup/master"
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

function Invoke-Remote-Script {
    param (
        $FileName
    )
    Invoke-WebRequest -useb "$base_url/$FileName" | Invoke-Expression
}

function Show-Menu {
    param (
        [string]$Title = 'Windows Setup Script'
    )
    
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1. Apply registry tweaks"
    Write-Host "2. Install apps (requires internet connection)"
    Write-Host " "
    Write-Host "Enter 'q' to quit."
}

if (!$isAdmin) {
    Write-Host " "
    Write-Host "ERROR: Please re-execute this script from an elevated/administrator PowerShell window."
    break
    exit 1
}

do {
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection) {
        '1' {
            Invoke-Remote-Script "apply-reg-tweaks.ps1"
            Invoke-Remote-Script "CustomizeTaskbar.ps1"
        } '2' {
            Invoke-Remote-Script "install-apps.ps1"
        }
    }
}
until ($selection -eq 'q')