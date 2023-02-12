$winget_apps = @(
    'Bitwarden.Bitwarden'
    'LibreWolf.LibreWolf'
    'ProtonTechnologies.ProtonVPN'
    '7zip.7zip'
    'Betterbird.Betterbird'
    'Eugeny.Tabby'
    'Microsoft.PowerToys'
    'Fork.Fork'
    'Klocman.BulkCrapUninstaller'
    'GIMP.GIMP'
    'gurnec.HashCheckShellExtension'
    'REALiX.HWiNFO'
    'Kopia.KopiaUI'
    'Obsidian.Obsidian'
    'qBittorrent.qBittorrent'
    'SyncTrayzor.SyncTrayzor'
    'WinDirStat.WinDirStat'
    'Ferdium.Ferdium'
)
$msstore_apps = @(
    # Phone Link
    '9NMPJ99VJBWV'
    # Yubico Authenticator
    '9NFNG39387K0'
    # mpv.net
    '9N64SQZTB3LM'
)

function Install-Exe {
    param (
        $Uri
    )
    
    $OutFile = Split-Path $Uri -Leaf
    Write-Host "Downloading $Uri"
    Invoke-WebRequest -Uri $Uri -OutFile "$env:temp\$OutFile"
    Write-Host "$OutFile downloaded."

    Write-Host "Executing $OutFile install..."
    Start-Process -Wait -FilePath ".\$OutFile" -Argument "/silent" -PassThru
    Write-Host "$OutFile install attempted."
}
function Install-WinGet-Apps {
    foreach ($app in $winget_apps) {
        winget install -e -h --id $app -s winget --accept-package-agreements --accept-source-agreements
        Write-Host ""
    }
    foreach ($app in $msstore_apps) {
        winget install $app -s msstore
        Write-Host ""
    }

    # Visual Studio Code
    # https://github.com/microsoft/winget-cli/discussions/1798#discussioncomment-4374698
    winget install --id Microsoft.VisualStudioCode -e -h -s winget --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders,addtopath"' --accept-package-agreements --accept-source-agreements    
    Write-Host ""

    Show-Confirm-Prompt
}

function Install-Spotify {
    winget install --id "Spotify.Spotify" -e -h -s winget --accept-package-agreements --accept-source-agreements
    # spicetify
    Invoke-WebRequest -useb "https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.ps1" | Invoke-Expression
    Invoke-WebRequest -useb "https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.ps1" | Invoke-Expression
}

$before = Get-ChildItem -Path "$env:HOMEPATH\Desktop" -file -filter *.lnk

Install-WinGet-Apps

# Barrier v2.3.4 -- does not have the Windows display scale issue that affects moving mouse from Windows -> Linux
# Install-Exe "https://github.com/debauchee/barrier/releases/download/v2.3.4/BarrierSetup-2.3.4-release.exe"

# Hurl browser picker
# Install-Exe "https://github.com/U-C-S/Hurl/releases/download/v0.7.1/Hurl_Installer.exe"

# SmoothScroll
# Install-Exe "https://www.smoothscroll.net/win/download/SmoothScroll_Setup.exe"

$after = Get-ChildItem -Path $user_location
$linksToDelete = $after | Where-Object { $before -NotContains $_ }
foreach ($link in $linksToDelete) {
    Remove-Item $link
}