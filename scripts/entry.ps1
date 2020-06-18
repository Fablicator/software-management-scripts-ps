# entry.ps1
# > Check admin privileges
# + Install package manager
# + Install system dependencies
# Exit if dependencies are not satisfied
# Jump to main.ps1

. "$PSScriptRoot\helpfunctions.ps1" $PSCommandPath $args "Dependency Check"

# Set window size
$pshost = Get-Host              # Get the PowerShell Host.
$pswindow = $pshost.UI.RawUI    # Get the PowerShell Host's UI.

$newsize = $pswindow.windowsize # Get the UI's current Window Size.
$newsize.width = 100           # Set the new Window Width to 120 columns.
$newsize.height = 30            # Set the new Window Width to 120 columns.
$pswindow.windowsize = $newsize # Set the new Window Size as active.

$newSize =$psWindow.BufferSize
$newSize.Width = 100
$newSize.Height = 30
$psWindow.BufferSize = $newSize

Clear-Page
# System dependency check

# System dependencies

$env_changed = $false

# Check for git
try{ 
    git --version
    Start-Sleep -Seconds 0.25
}catch{
    Clear-Page
    Write-Host "Git is not installed..."
    Start-Sleep -Seconds 1
    try {
        Choco-Install 'git'
        Clear-Page
        Write-Host "Git installed!"
        $env_changed = $true
        Start-Sleep -Seconds 1
    }
    catch {
        Write-Host "Please download and install Git from -> https://git-scm.com/downloads"
        Write-Host ""
        pause
        exit
    }
}

# Check for Python
try{
    if(python --version) {
        python --version
        Start-Sleep -Seconds 0.25
    }else{
        throw "Python not installed"
    }
}catch{
    Write-Host "Python not installed..."
    try {
        Choco-Install 'python'
        Clear-Page
        Write-Host "Python installed!"
        $env_changed = $true
        Start-Sleep -Seconds 1
    }
    catch {
        Clear-Page
        Write-Host "Please download and install Python from -> https://www.python.org/downloads/"
        Write-Host ""
        pause
        exit
    }
}


if($env_changed) {
    Clear-Page
    Write-Host "Some missing system dependencies have been installed."
    Write-Host ""
    Write-Host "You will need to run this script again for changes to take effect"
    Write-Host ""
    pause
    exit
}

# Check for PlatformIO
try{
    platformio --version
    Start-Sleep -Seconds 0.25
}catch{
    Write-Host "PlatformIO not installed..."
    Write-Host ""
    try {
        Write-Host "Installing PlatformIO..."
        Write-Host ""
        Start-Process powershell "pip install platformio" -Verb RunAs -Wait
        Clear-Page
        Write-Host "PlatformIO installed!"
        Start-Sleep -Seconds 1
    }
    catch {
        Clear-Page
        Write-Host "Something went wrong with the PlatformIO installation"
        pause
        exit
    }
}

Update-Manager

Run-ExtScript $PSScriptRoot "main.ps1"