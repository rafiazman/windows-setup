$app_list = @(
    'Clipchamp.Clipchamp_yxz26nhyzhsrt'
    'MicrosoftTeams_8wekyb3d8bbwe'
    'Microsoft.GetHelp_8wekyb3d8bbwe'
    'Microsoft.Getstarted_8wekyb3d8bbwe'
    'Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe'
    'Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe'
    'Microsoft.ZuneMusic_8wekyb3d8bbwe'
    'Microsoft.ZuneVideo_8wekyb3d8bbwe'
    'Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe'
)

foreach ($app in $app_list) {
    winget uninstall --id $app
    Write-Host ""
}
