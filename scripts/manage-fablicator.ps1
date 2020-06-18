# manage-fablicator.ps1
# Manage or install Fablicator Interface

. "$PSScriptRoot\helpfunctions.ps1" $PSCommandPath $args "Fablicator Interface Manager"

$software_path = "C:\Fablicator\Fablicator"
$software_repo = "https://github.com/Fablicator/Fablicator-Software-Dist.git"
$software_branch = "fablicator-interface"

function Update-Software {
    Set-Location $software_path
    & ".\Scripts\ps\update.ps1"
    Set-Location $PSScriptRoot
}

function Load-DefaultConfig {
    Set-Location $software_path
    & ".\Scripts\ps\loaddefaults.ps1"
    Set-Location $PSScriptRoot
}

function Install-Software {
    git clone $software_repo --branch $software_branch $software_path
    Load-DefaultConfig
}

# Check that KISSlicer is in the right place
Clear-Page
if(Test-Path -Path $software_path) {
    if(!(Test-Path -Path "$software_path\.git")) {
        Write-Host "Fablicator Interface found at '$software_path', but it's not managed."
        Write-Host ""
        Write-Host "This installation can be replaced with the latest version, which will allow the manager to:"
        Write-Host "    - Update to any new versions available"
        Write-Host "    - Load default values"
        Write-Host ""
        Write-Host "(The old version will be zipped to '$software_path\Fablicator_bak.zip')"
        Write-Host ""
        $replace_install = Prompt-YesNo "Would you like to replace this installation with the latest one?"
        if($replace_install) {
            Compress-Archive -Path $software_path -DestinationPath "$software_path\..\Fablicator_bak.zip"
            Remove-Item -Path $software_path -Recurse
            Clear-Page
            Install-Software
        }
    }
}else{
    Write-Host "Fablicator Interface not found at '$software_path'."
    $should_install = Prompt-YesNo "Would you like to install Fablicator Interface?"
    Clear-Page
    if($should_install) {
        Install-Software
    }else{
        Write-Host "Cannot manage Fablicator Interface"
        Start-Sleep -Seconds 1
        exit
    }
}

## Main menu
do {
    Clear-Page
    Write-Host "Enter the letter for the following option"
    Write-Host ""
    Write-Host "    'u' - Update Fablicator Interface"
    Write-Host "    'l' - Load default config"
    Write-Host "    '.' - Go back to main menu" -ForegroundColor Red
    Write-Host ""

    do {
        $opt = Read-Host "Enter choice"
    
        if($opt -match 'u') {
            Update-Software
            break
        }elseif($opt -match 'l') {
            Load-DefaultConfig
            break
        }elseif($opt -match '.') {
            exit
        }
    } while ($true)
} while ($true)