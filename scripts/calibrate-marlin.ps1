. "$PSScriptRoot\helpfunctions.ps1" $PSCommandPath $args "Marlin Calibration"

$marlin_path = "C:\Fablicator\Marlin"
$marlin_repo = "https://github.com/Fablicator/Marlin.git"
$marlin_branch = "fablicator-1.1.x-stable"

function Warning {
    Clear-Page
    Write-Host (Center "WARNING WARNING WARNING WARNING" ) -ForegroundColor Red
    Write-Host "" 
    Write-Host "" 
    Write-Host (Center "Making a mistake during calibration can cause damage to the machine.") 
    Write-Host "" 
    Write-Host (Center "By calibrating the machine, you are responsible for any damage done.") 
    Write-Host "" 
    Write-Host (Center "Make sure you know what you're doing before calibrating the machine.") 
    Write-Host "" 
    Write-Host "" 
    Write-Host (Center "WARNING WARNING WARNING WARNING" ) -ForegroundColor Red
    Write-Host "" 
    Write-Host "" 
    Write-Host "" 
    
    return Prompt-YesNo "Would you like to calibrate the machine?"
}

function Run-MainMenu {
    Clear-Page
    Write-Host (Center "Press one of the keys to make a choice: ")
    Write-Host ""
    Write-Host (Center "'l' - Load default calibration     ")
    Write-Host ""
    Write-Host (Center "'z' - Calibrate Z axis (Bed height)")
    Write-Host ""
    Write-Host (Center "'x' - Calibrate X axis             ")
    Write-Host ""
    Write-Host (Center "'.' - Go back to Marlin manager    ") -ForegroundColor Red
    Write-Host ""

    do {
        $opt = (Get-Host).UI.RawUI.ReadKey().Character;
        if ($opt -match 'z') {
                Clear-Host
                Run-ExtScript "$marlin_path\Scripts\ps\" "z_calibration.ps1"
            break
        }elseif ($opt -match 'l') {
            Clear-Host
            Run-ExtScript "$marlin_path\Scripts\ps\" "loaddefaults.ps1"
            break
        }elseif ($opt -match 'x') {
                Clear-Host
                Run-ExtScript "$marlin_path\Scripts\ps\" "x_calibration.ps1"
                Calibrate-Marlin
            break
        }elseif ($opt -match '.') {
            return $false
        }
        Start-Sleep 0.5
    }while($true)

    return $true
}

if(!(Warning)) {
    exit
}

while(Run-MainMenu){}