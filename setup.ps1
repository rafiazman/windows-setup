# This script provisions a fresh Windows 11 install with the software I use
# on a daily basis in addition to applying my preferred settings.
#
# Written by Rafi Azman
$repo_url = "https://raw.githubusercontent.com/rafiazman/windows-setup/master"

Invoke-Expression ". { $(Invoke-RestMethod $repo_url/utils.ps1) } "

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (!$isAdmin) {
    Write-Host ""
    Write-Host "ERROR: Please re-execute this script from an elevated/administrator PowerShell window."
    break
    exit 0
}

function Show-Menu {
    Clear-Host
    Write-Host "================ Bootstrap Windows 11 ================"
    Write-Host ""
    Write-Host "1. Apply registry tweaks"
    Write-Host "2. Remove stock unused apps"
    Write-Host "3. Install apps (requires internet connection)"
    Write-Host "4. Set up Cloud Drive"
    Write-Host ""
    Write-Host "Enter 'q' to quit."
    Write-Host ""
}

do {
    Show-Menu

    Write-Host -NoNewline "Please make a selection: "
    $key = $Host.UI.RawUI.ReadKey()
    Write-Host ""
    Write-Host ""

    switch ($key.Character) {
        1 {
            Invoke-Task "apply-reg-tweaks"
        }
        2 {
            Invoke-Task "remove-apps"
        } 
        3 {
            Invoke-Task "install-apps"
        }
        4 {
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
exit 0