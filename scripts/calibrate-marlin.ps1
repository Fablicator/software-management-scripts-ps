. "$PSScriptRoot\helpfunctions.ps1" $PSCommandPath $args "Marlin Calibration"

$marlin_path = "C:\Fablicator\Marlin"
$marlin_repo = "https://github.com/Fablicator/Marlin.git"
$marlin_branch = "fablicator-1.1.x-stable"

function Run-MainMenu {
    Clear-Page
    Write-Host "Enter the letter for the following option"
    Write-Host ""
    Write-Host "    'z' - Calibrate Z axis (Bed height)"
    Write-Host "    'x' - Calibrate X axis"
    Write-Host "    '.' - Go back to Marlin manager" -ForegroundColor Red
    Write-Host ""

    do {
        $opt = (Get-Host).UI.RawUI.ReadKey().Character;
        if ($opt -match 'z') {
            Run-ExtScript "$marlin_path\Scripts\ps\" "z_calibration.ps1"
            break
        }elseif ($opt -match 'x') {
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

while(Run-MainMenu){}