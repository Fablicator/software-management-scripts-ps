$top_script_path = $args[0]
$top_script_args = $args[1]
$top_script_page_title = $args[2]

function Update-Manager {
    $branch = (git rev-parse --abbrev-ref HEAD)

    git fetch

    $commitcount = (git log $branch..origin/$branch --oneline | Measure-Object).Count

    if(!($commitcount -eq 0)) {
        Clear-Host
        Write-Host "The following updates are available:"
        Write-Host ""
        git log $branch..origin/$branch --oneline
        Write-Host ""
        if(Prompt-YesNo "Would you like to update the software manager?") {
            Clear-Host
            Write-Host "Updating software..."
            git pull origin $branch
            git reset --hard origin/$branch

            Clear-Host
            Write-Host "Update complete!"
            pause
            exit
        }
    }
}

function Prompt-YesNo ($prompt) {
    Write-Host "$prompt [y,n]"
    Write-Host ""
    do {
        $response = Read-Host "-"
        if ($response -match "y") {
            return $true
        }elseif ($response -match "n") {
            return $false
        }
    } while ($true)
}

# function Write-HostCenter { param($Message) Write-Host ("{0}{1}" -f (' ' * (([Math]::Max(0, $Host.UI.RawUI.BufferSize.Width / 2) - [Math]::Floor($Message.Length / 2)))), $Message) }

function Center($Text) {
    return ("{0}{1}" -f (' ' * (([Math]::Max(0, $Host.UI.RawUI.BufferSize.Width / 2) - [Math]::Floor($Text.Length / 2)))), $Text)
}
function Request-RunElevated{  
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "Manager is requesting to be run as admin"
        Write-Host ""
        $run_as_admin = Prompt-YesNo "Would you like to run the manager as admin?"
        if($run_as_admin) {
            Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$top_script_path`" `"$top_script_args`"" -Verb RunAs;
            exit
        }else{
            return $false
        }
    }else{
        return $true
    }
}

function Check-Elevation {
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

function Clear-Page {
    Clear-Host
    Write-Host (Center "###  Fablicator Software Management Script - $top_script_page_title  ###")
    Write-Host ""
    (Get-Host).UI.RawUI.WindowTitle = "Fablicator Software Management Script - $top_script_page_title"
}

function Choco-Install ($pkgname) {
    try {
        Clear-Page
        Write-Host "Installing $pkgname using Chocolatey..."
        Start-Sleep -Seconds 1
        Write-Host ""
        Start-Process choco "install $pkgname -y" -Verb RunAs -Wait
    }catch {
        Write-Host "Chocolatey not installed!"
        Write-Host ""
        Write-Host "Chocolatey is a package manager for Windows that's used to manage and install software packages."
        Write-Host "We can use this to manage system dependencies like Python, Git, etc. from this software management script."
        Write-Host ""
        $install_choco = Prompt-YesNo "Would you like to install Chocolatey?"
        if($install_choco) {
            Start-Process powershell "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" -Verb RunAs -Wait
            Write-Host ""
            Write-Host "Chocolatey installed, re-run this script..."
            Write-Host ""
            pause
            exit
        }else{
            throw "Reject chocolatey install"
        }
    }
}

function Run-ExtScript($path, $file) {
    Set-Location $path
    Start-Process powershell "-ExecutionPolicy Bypass -File $file" -NoNewWindow -Wait
    Set-Location $PSScriptRoot
}

function Prompt-CloseProcess($process_name, $print_name) {
    if(Get-Process "$process_name" -ErrorAction "SilentlyContinue") {
        Write-Host ""
        Write-Host ""
        Write-Host ""
        Write-Host (Center "Please close $print_name")
        Write-Host ""
        Write-Host (Center "Continuing without closing will abort") -ForegroundColor Red
        Write-Host ""
        Pause
        if(Get-Process "$process_name" -ErrorAction "SilentlyContinue") {
            return $false
        }
    }
    return $true
}