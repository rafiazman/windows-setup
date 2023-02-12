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
    Invoke-WebRequest -useb "$base_url/$FileName.ps1" | Invoke-Expression
}