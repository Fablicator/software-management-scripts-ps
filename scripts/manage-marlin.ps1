# manage-marlin.ps1
# Manage Marlin firmware installation

. "$PSScriptRoot\helpfunctions.ps1" $PSCommandPath $args "Marlin Firmware Manager"

$marlin_path = "C:\Fablicator\Marlin"
$marlin_repo = "https://github.com/Fablicator/Marlin.git"
$marlin_branch = "fablicator-1.1.x-stable"

function Write-Firmware {
    Clear-Page
    Write-HostCenter "!!!! WARNING !!!!"
    Write-Host ""
    Write-HostCenter "This will upload the current version of the Marlin Firmware"
    Write-Host ""
    Write-HostCenter "Please ensure the cablibration is correct or your machine may be damaged."
    Write-HostCenter "(If you just updated the firmware, the calibration should be the same.)"
    Write-Host ""
    Write-HostCenter "This process will close the Fablicator Interface if it's runnning!"
    Write-Host ""
    Write-HostCenter "!!!! WARNING !!!!"
    Write-Host ""
    Write-Host ""
    $should_write = Prompt-YesNo "Would you like to upload the firmware to the control board?"
    if($should_write) {
        Run-ExtScript "$marlin_path\Scripts\ps\" "upload.ps1"
    }
}
function Update-Marlin {
    Run-ExtScript "$marlin_path\Scripts\ps\" "update.ps1"
    Write-Firmware
}

function Calibrate-Marlin {
    Run-ExtScript "$PSScriptRoot" "calibrate-marlin.ps1"
}

function Install-Marlin {
    git clone $marlin_repo --branch $marlin_branch $marlin_path
    Load-Defaults
}

function Check-Install {
    Clear-Page
    if(Test-Path -Path $marlin_path) {
        if(Test-Path -Path "$marlin_path\.git") {
            return $true
        }else{
            Write-Host "Marlin found at '$marlin_path', but it's not managed."
            Write-Host ""
            Write-Host "This installation can be replaced with the latest version, which will allow the manager to:"
            Write-Host "    - Update to any new versions available"
            Write-Host "    - Load default values"
            Write-Host ""
            Write-Host "(The old version will be zipped to '$marlin_path\Marlin_bak.zip')"
            Write-Host ""
            $replace_install = Prompt-YesNo "Would you like to replace this installation with the latest one?"
            if($replace_install) {
                Compress-Archive -Path $marlin_path -DestinationPath "$marlin_path\..\Marlin_bak.zip"
                Remove-Item -Path $marlin_path -Recurse
                Clear-Page
                Install-Marlin
                return $true
            }
        }
    }else{
        Write-Host "Marlin not found at '$marlin_path'."
        $install_kiss = Prompt-YesNo "Would you like to install Marlin?"
        Clear-Page
        if($install_kiss) {
            Install-Marlin
            return $true
        }
    }
    Write-Host "Cannot manage Marlin"
    Start-Sleep -Seconds 1
    return $false
}

function Run-MainMenu {
    Clear-Page
    Write-Host "Press one of the keys to make a choice: "
    Write-Host ""
    Write-Host "    'u' - Update firmware"
    Write-Host ""
    Write-Host "    'w' - Write firmware to control board"
    Write-Host ""
    Write-Host "    'c' - Change calibration"
    Write-Host ""
    Write-Host "    '.' - Go back to main menu" -ForegroundColor Red
    Write-Host ""

    do {
        $opt = (Get-Host).UI.RawUI.ReadKey().Character;
        if($opt -match 'u') {
            Update-Marlin
            break
        }elseif ($opt -match 'c') {
            Calibrate-Marlin
            break
        }elseif ($opt -match '.') {
            return $false
        }elseif ($opt -match 'w') {
            Write-Firmware
            break
        }
        Start-Sleep 0.5
    }while($true)

    return $true
}


if(!(Check-Install)){
    exit
}

while(Run-MainMenu){}