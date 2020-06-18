# manage-kiss.ps1
# Manage or install KISSlicer version

. "$PSScriptRoot\helpfunctions.ps1" $PSCommandPath $args "KISSlicer Manager"

$kiss_path = "C:\Fablicator\KISSlicer"
$kiss_repo = "https://github.com/Fablicator/Fablicator-Software-Dist.git"

function Update-KISS {
    Set-Location $kiss_path
    & ".\Scripts\ps\update.ps1"
    Set-Location $PSScriptRoot
}

function Load-KISSDefaults {
    Set-Location $kiss_path
    & ".\Scripts\ps\loaddefaults.ps1"
    Set-Location $PSScriptRoot
}

function Install-KISS {
    Write-Host "What kind of machine do you have?"
    Write-Host ""
    Write-Host "    'mx'    - Fablicator MX"
    Write-Host "    'sx'    - Fablicator SX"
    Write-Host "    'fm1'   - Fablicator FM-1"
    Write-Host ""
    do{ 
        $machine_type = Read-Host "Enter choice"
        if ($machine_type -match '(mx|sx|fm1)') {
            $kiss_repo_branch = "kisslicer-$machine_type"
            git clone $kiss_repo --branch $kiss_repo_branch $kiss_path
            pause
            Load-KISSDefaults
            break
        }
    }while($true)
}

# Check that KISSlicer is in the right place
Clear-Page
if(Test-Path -Path $kiss_path) {
    if(!(Test-Path -Path "$kiss_path\.git")) {
        Write-Host "KISSlicer found at '$kiss_path', but it's not managed."
        Write-Host ""
        Write-Host "This installation can be replaced with the latest version, which will allow the manager to:"
        Write-Host "    - Update to any new versions available"
        Write-Host "    - Load default values"
        Write-Host ""
        Write-Host "(The old version will be zipped to '$kiss_path\KISS_bak.zip')"
        Write-Host ""
        $replace_install = Prompt-YesNo "Would you like to replace this installation with the latest one?"
        if($replace_install) {
            Compress-Archive -Path $kiss_path -DestinationPath "$kiss_path\..\KISS_bak.zip"
            Remove-Item -Path $kiss_path -Recurse
            Clear-Page
            Install-KISS
        }
    }
}else{
    Write-Host "KISSlicer not found at '$kiss_path'."
    $install_kiss = Prompt-YesNo "Would you like to install KISSlicer?"
    Clear-Page
    if($install_kiss) {
        Install-KISS
    }else{
        Write-Host "Cannot manage KISSlicer"
        Start-Sleep -Seconds 1
        exit
    }
}

## Main KISSlicer menu
do {
    Clear-Page
    Write-Host "Enter the letter for the following option"
    Write-Host ""
    Write-Host "    'u' - Update KISSlicer"
    Write-Host "    'l' - Load KISSlicer defaults"
    Write-Host "    '.' - Go back to main menu" -ForegroundColor Red
    Write-Host ""

    do {
        $opt = Read-Host "Enter choice"
    
        if($opt -match 'u') {
            Update-KISS
            break
        }elseif($opt -match 'l') {
            Load-Defaults
            Clear-Page
            Write-Host "Default profiles loaded"
            Start-Sleep -Seconds 1
            break
        }elseif($opt -match '.') {
            exit
        }
    } while ($true)
} while ($true)