# This script provisions a fresh Windows 11 install with the software I use
# on a daily basis in addition to applying my preferred settings.
#
# Written by Rafi Azman

$base_url = "https://raw.githubusercontent.com/rafiazman/windows-setup/master"

function Test-Administrator {  
    [OutputType([bool])]
    param()
    process {
        [Security.Principal.WindowsPrincipal]$user = [Security.Principal.WindowsIdentity]::GetCurrent();
        return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
    }
}

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
    
    Write-Host "1: Apply registry tweaks"
    Write-Host "2: Install apps (requires internet connection)"
    Write-Host "Q: Press 'Q' to quit."
    Write-Host " "
}

if (-not (Test-Administrator)) {
    # TODO: define proper exit codes for the given errors 
    Write-Error "This script must be executed as Administrator.";
    exit 1;
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
