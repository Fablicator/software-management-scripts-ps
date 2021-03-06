# main.ps1
# Main menu for the script, used to acess the different managers

. "$PSScriptRoot\helpfunctions.ps1" $PSCommandPath $args "Main Menu"

do {
    Clear-Page
    Write-Host (Center "Press one of the keys to make a choice: ")
    Write-Host ""
    Write-Host (Center "'k' - Manage KISSlicer           ")
    Write-Host ""
    Write-Host (Center "'f' - Manage Fablicator Interface")
    Write-Host ""
    Write-Host (Center "'m' - Manage Marlin              ")
    Write-Host ""

    do {
        $opt = (Get-Host).UI.RawUI.ReadKey().Character;
    
        if($opt -match 'k') {
            & "$PSScriptRoot\manage-kiss.ps1"
            break 
        }elseif ($opt -match 'm') {
            & "$PSScriptRoot\manage-marlin.ps1"
            break 
        }elseif ($opt -match 'f') {
            & "$PSScriptRoot\manage-fablicator.ps1"
            break 
        }
        Start-Sleep 0.5
    } while ($true)
} while ($true)