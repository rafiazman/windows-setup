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

function Print-Menu {
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
    Print-Menu
    Write-Host -NoNewline "Please make a selection: "

    $key = $Host.UI.RawUI.ReadKey()
    switch ($key.Character) {
        1 {
            Write-Host "Applying personal registry tweaks..."
            Invoke-Remote-Script "apply-reg-tweaks.ps1"
            Write-Host "Personal registry tweaks applied."

            Write-Host " "

            Write-Host "Applying taskbar tweaks..."
            Invoke-Remote-Script "CustomizeTaskbar.ps1"
            Write-Host "Taskbar tweaks applied ."

            Write-Host " "

            Write-Host "Registry tweaks applied!"
            Read-Host -Prompt "Press Enter to continue"
        } 
        2 {
            Invoke-Remote-Script "install-apps.ps1"
        }
        Q {
            Write-Host " "
            break
        }
        default {
            Write-Host "Invalid option selected."
            Read-Host -Prompt "Press Enter to continue"
        }
    }
}
until ($key.Character -eq 'Q')