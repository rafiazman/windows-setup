function Install-Exe {
    param (
        $Uri
    )
    
    $OutFile = Split-Path $Uri -Leaf
    Invoke-WebRequest -Uri $Uri -OutFile $OutFile
    Start-Process -Wait -FilePath ".\$OutFile" -Argument "/silent" -PassThru
    Remove-Item ".\$OutFile"
}
function Install-Apps {
    $winget_apps = @(
        'Eugeny.Tabby'
        'Microsoft.PowerToys'
        'Fork.Fork'
        'Klocman.BulkCrapUninstaller'
        'Bitwarden.Bitwarden'
        '7zip.7zip'
        'GIMP.GIMP'
        'gurnec.HashCheckShellExtension'
        'REALiX.HWiNFO'
        'Kopia.KopiaUI'
        'LibreWolf.LibreWolf'
        'Betterbird.Betterbird'
        'Obsidian.Obsidian'
        'PDFsam.PDFsam'
        'ProtonTechnologies.ProtonVPN'
        'qBittorrent.qBittorrent'
        'SyncTrayzor.SyncTrayzor'
        'WinDirStat.WinDirStat'
        'Spotify.Spotify'
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

    foreach ($app in $winget_apps) {
        winget install --id $app -e -s winget
    }
    foreach ($app in $msstore_apps) {
        winget install --id $app -e -s msstore
    }

    # Visual Studio Code
    # https://github.com/microsoft/winget-cli/discussions/1798#discussioncomment-4374698
    winget install Microsoft.VisualStudioCode --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders,addtopath"'

    # Barrier v2.3.4 -- does not have the Windows display scale issue that affects moving mouse from Windows -> Linux
    Install-Exe "https://github.com/debauchee/barrier/releases/download/v2.3.4/BarrierSetup-2.3.4-release.exe"

    # Hurl browser picker
    Install-Exe "https://github.com/U-C-S/Hurl/releases/download/v0.7.1/Hurl_Installer.exe"

    # SmoothScroll
    Install-Exe "https://www.smoothscroll.net/win/download/SmoothScroll_Setup.exe"

    # spicetify
    Invoke-WebRequest -useb "https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.ps1" | Invoke-Expression
    Invoke-WebRequest -useb "https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.ps1" | Invoke-Expression
}

function Merge-Reg-File {
    param (
        $Path
    )
    Invoke-Command { reg import $Path *>&1 | Out-Null }
}

Install-Apps
Merge-Reg-File ".\registry-tweaks\fix-windows-explorer-stealing-cpu.reg"
