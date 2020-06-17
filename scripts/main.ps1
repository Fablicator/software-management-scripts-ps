# main.ps1
# Main menu for the script, used to acess the different managers

. "$PSScriptRoot\helpfunctions.ps1" $PSCommandPath $args "Main Menu"

do {
    Clear-Page
    Write-Host "Enter the letter for the following option"
    Write-Host ""
    Write-Host "    'k' - Manage KISSlicer"
    Write-Host "    'f' - Manage Fablicator Interface"
    Write-Host "    'm' - Manage Marlin"
    Write-Host ""

    do {
        $opt = Read-Host "Enter choice"
    
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
    } while ($true)
} while ($true)