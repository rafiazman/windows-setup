# This script provisions a fresh Windows 11 install with the software I use
# on a daily basis in addition to applying my preferred settings.
#
# Written by Rafi Azman

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

function Show-Confirm-Prompt {
    Write-Host ""
    Write-Host "Press any key to continue..."
    [void][System.Console]::ReadKey($true)
}

function Invoke-Task {
    param (
        $FileName
    )
    $base_url = "https://raw.githubusercontent.com/rafiazman/windows-setup/master/tasks"
    Invoke-WebRequest -UseBasicParsing "$base_url/$FileName.ps1" | Invoke-Expression
}

function Show-Menu {
    param (
        [string]$Title = 'Windows Setup Script'
    )
    
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1. Apply registry tweaks"
    Write-Host "2. Install apps (requires internet connection)"
    Write-Host "3. Set up Cloud Drive"
    Write-Host ""
    Write-Host "Enter 'q' to quit."
    Write-Host ""
}

if (!$isAdmin) {
    Write-Host ""
    Write-Host "ERROR: Please re-execute this script from an elevated/administrator PowerShell window."
    break
    exit 1
}

do {
    Show-Menu

    Write-Host -NoNewline "Please make a selection: "
    $key = $Host.UI.RawUI.ReadKey()
    Write-Host ""
    switch ($key.Character) {
        1 {
            Write-Host "Applying personal registry tweaks..."
            Invoke-Task "apply-reg-tweaks"
            Write-Host "Personal registry tweaks applied."
            Show-Confirm-Prompt
        } 
        2 {
            Invoke-Task "install-apps"
        }
        3 {
            Invoke-Task "setup-cloud-drive"
        }
        Q {
            break
        }
        default {
            Write-Host "Invalid option selected."
            Show-Confirm-Prompt
        }
    }
}
until ($key.Character -eq 'Q')
exit 1