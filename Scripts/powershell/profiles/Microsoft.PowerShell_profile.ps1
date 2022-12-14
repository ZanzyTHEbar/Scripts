### PowerShell template profile 
### Version 1.03 - Tim Sneath <tim@sneath.org>
### From https://gist.github.com/timsneath/19867b12eee7fd5af2ba
###
### This file should be stored in $PROFILE.CurrentUserAllHosts
### If $PROFILE.CurrentUserAllHosts doesn't exist, you can make one with the following:
###    PS> New-Item $PROFILE.CurrentUserAllHosts -ItemType File -Force
### This will create the file and the containing subdirectory if it doesn't already 
###
### As a reminder, to enable unsigned script execution of local scripts on client Windows, 
### you need to run this line (or similar) from an elevated PowerShell prompt:
###   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
### This is the default policy on Windows Server 2012 R2 and above for server Windows. For 
### more information about execution policies, run Get-Help about_Execution_Policies.

# Import Terminal Icons
Import-Module -Name Terminal-Icons

# Find out if the current user identity is elevated (has admin rights)
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# If so and the current host is a command line, then change to red color 
# as warning to user that they are operating in an elevated context
# Useful shortcuts for traversing directories
function cd... { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

function Xargs { param( $Cmd ) process { $args += , $_ } end { & $Cmd @args } }

# Compute file hashes - useful for checking successful downloads 
function md5 { Get-FileHash -Algorithm MD5 $args }
function sha1 { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Quick shortcut to start notepad
function n { notepad $args }

# Drive shortcuts
function HKLM: { Set-Location HKLM: }
function HKCU: { Set-Location HKCU: }
function Env: { Set-Location Env: }

# Creates drive shortcut for Work Folders, if current user account is using it
if (Test-Path "$env:USERPROFILE\Work Folders") {
    New-PSDrive -Name Work -PSProvider FileSystem -Root "$env:USERPROFILE\Work Folders" -Description "Work Folders"
    function Work: { Set-Location Work: }
}

# Set up command prompt and window title. Use UNIX-style convention for identifying 
# whether user is elevated (root) or not. Window title shows current version of PowerShell
# and appends [ADMIN] if appropriate for easy taskbar identification
function prompt { 
    if ($isAdmin) {
        "[" + (Get-Location) + "] # " 
    }
    else {
        "[" + (Get-Location) + "] $ "
    }
}

$Host.UI.RawUI.WindowTitle = "PowerShell {0}" -f $PSVersionTable.PSVersion.ToString()
if ($isAdmin) {
    $Host.UI.RawUI.WindowTitle += " [ADMIN]"
}

# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    }
    else {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

# Simple function to start a new elevated process. If arguments are supplied then 
# a single command is started with admin rights; if not then a new admin instance
# of PowerShell is started.
function admin {
    if ($args.Count -gt 0) {   
        $argList = "& '" + $args + "'"
        Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $argList
    }
    else {
        Start-Process "$psHome\powershell.exe" -Verb runAs
    }
}

# Set UNIX-like aliases for the admin command, so sudo <command> will run the command
# with elevated rights. 
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin


# Make it easy to edit this profile once it's installed
function Edit-Profile {
    if ($host.Name -match "ise") {
        $psISE.CurrentPowerShellTab.Files.Add($profile.CurrentUserAllHosts)
    }
    else {
        notepad $profile.CurrentUserAllHosts
    }
}

# We don't need these any more; they were just temporary variables to get to $isAdmin. 
# Delete them to prevent cluttering up the user profile. 
Remove-Variable identity
Remove-Variable principal

Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    try { if (Get-Command $command) { RETURN $true } }
    Catch { Write-Host "$command does not exist"; RETURN $false }
    Finally { $ErrorActionPreference = $oldPreference }
} 
#
# Aliases
#
# If your favorite editor is not here, add an elseif and ensure that the directory it is installed in exists in your $env:Path
#
if (Test-CommandExists nvim) {
    $EDITOR = 'nvim'
}
elseif (Test-CommandExists pvim) {
    $EDITOR = 'pvim'
}
elseif (Test-CommandExists vim) {
    $EDITOR = 'vim'
}
elseif (Test-CommandExists vi) {
    $EDITOR = 'vi'
}
elseif (Test-CommandExists code) {
    #VS Code
    $EDITOR = 'code'
}
elseif (Test-CommandExists notepad) {
    #fallback to notepad since it exists on every windows machine
    $EDITOR = 'notepad'
}
Set-Alias -Name vim -Value $EDITOR


function ll { Get-ChildItem -Path $pwd -File }
function g { Set-Location $HOME\Documents\Github }
function gcom {
    git add .
    git commit -m "$args"
}
function lazyg {
    git add .
    git commit -m "$args"
    git push
}
Function Get-PubIP {
 (Invoke-WebRequest http://ifconfig.me/ip ).Content
}
function uptime {
    #Windows Powershell    
    Get-WmiObject win32_operatingsystem | Select-Object csname, @{LABEL = 'LastBootUpTime';
        EXPRESSION                                                      = { $_.ConverttoDateTime($_.lastbootuptime) }
    }

    #Powershell Core / Powershell 7+ (Uncomment the below section and comment out the above portion)

    <#
        $bootUpTime = Get-WmiObject win32_operatingsystem | Select-Object lastbootuptime
        $plusMinus = $bootUpTime.lastbootuptime.SubString(21,1)
        $plusMinusMinutes = $bootUpTime.lastbootuptime.SubString(22, 3)
        $hourOffset = [int]$plusMinusMinutes/60
        $minuteOffset = 00
        if ($hourOffset -contains '.') { $minuteOffset = [int](60*[decimal]('.' + $hourOffset.ToString().Split('.')[1]))}       
          if ([int]$hourOffset -lt 10 ) { $hourOffset = "0" + $hourOffset + $minuteOffset.ToString().PadLeft(2,'0') } else { $hourOffset = $hourOffset + $minuteOffset.ToString().PadLeft(2,'0') }
        $leftSplit = $bootUpTime.lastbootuptime.Split($plusMinus)[0]
        $upSince = [datetime]::ParseExact(($leftSplit + $plusMinus + $hourOffset), 'yyyyMMddHHmmss.ffffffzzz', $null)
        Get-WmiObject win32_operatingsystem | Select-Object @{LABEL='Machine Name'; EXPRESSION={$_.csname}}, @{LABEL='Last Boot Up Time'; EXPRESSION={$upsince}}
        #>


    #Works for Both (Just outputs the DateTime instead of that and the machine name)
    # net statistics workstation | Select-String "since" | foreach-object {$_.ToString().Replace('Statistics since ', '')}
        
}
function reload-profile {
    & $profile
}
function find-file($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${place_path}\${_}"
    }
}
function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}
function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | select-string $regex
        return
    }
    $input | select-string $regex
}
function touch($file) {
    "" | Out-File $file -Encoding ASCII
}
function df {
    get-volume
}
function sed($file, $find, $replace) {
        (Get-Content $file).replace("$find", $replace) | Set-Content $file
}
function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}
function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}
function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}
function pgrep($name) {
    Get-Process $name
}

function GetSystemPowerShellPath {
    $psPath = $PSHOME
    if ($null -eq $psPath) {
        $psPath = (Get-Command powershell).Source
    }
    return $psPath
}

function GetUserPowerShellPath {
    $path = ""
    try {
        if ($PSVersionTable.PSEdition -eq "Core" ) { 
            if ((Test-Path -Path ($env:userprofile + "\Documents\Powershell"))) {
                $path = $env:userprofile + "\Documents\Powershell"
            }
        }
        elseif ($PSVersionTable.PSEdition -eq "Desktop") {
            if ((Test-Path -Path ($env:userprofile + "\Documents\WindowsPowerShell"))) {
                $path = $env:userprofile + "\Documents\WindowsPowerShell"
            }
        }
    }
    catch {
        throw $_.Exception.Message
    }
    return $path
}

function winutil {
    try {
        $powershell = GetUserPowerShellPath
        $winutil = $powershell + "\Scripts\winutil.ps1"
        if ((Test-Path -Path $winutil -PathType Leaf)) {
            Write-Host "Launching WinUtil by @Chris Titus Tech" -ForegroundColor Green
            & $winutil
        }
        else {
            $message = "winutil not found - Please install it to " + $winutil + " from:"
            Write-Host $message -ForegroundColor Green
            Write-Host "@ZanyTHEbar Scripts Github Repo" -ForegroundColor Blue
            start "https://github.com/ZanzyTHEbar/Scripts/blob/master/Scripts/powershell/utilities/winutil.ps1"
        }   
    }
    catch {
        throw $_.Exception.Message
    }
}

function god_mode($directory) {
    try {
        $path = $directory + "\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
        if ((Test-Path -Path $path -PathType Leaf)) {
            Write-Host "Starting God Mode" -ForegroundColor Gold
            ii $path
        }
        else {
            $message = "God Mode not enabled - enabling it to: " + $path
            Write-Host $message -ForegroundColor Green
            New-Item -Path $path -ItemType directory -Force
            Write-Host "God Mode enabled" -ForegroundColor Blue
            ii $path
        }   
    }
    catch {
        throw $_.Exception.Message
    }
}

function robo_copy($source, $destination) {
    try {
        $powershell = GetUserPowerShellPath
        $robocopy = $powershell + "\Scripts\robo_copy.ps1"
        if ((Test-Path -Path $robocopy -PathType Leaf)) {
            Write-Host "Launching Custom RoboCopy by @ZanzyTHEbar" -ForegroundColor Green
            & $robocopy $source $destination
        }
        else {
            $message = "Custom RoboCopy not found - Please install it to " + $robocopy + " from:"
            Write-Host $message -ForegroundColor Green
            Write-Host "@ZanyTHEbar Scripts Github Repo" -ForegroundColor Blue
            start "https://github.com/ZanzyTHEbar/Scripts/blob/master/Scripts/powershell/utilities/robo_copy.ps1"
        }   
    }
    catch {
        throw $_.Exception.Message
    }
}

function healthcheck {
    try {
        $CurrentWindowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $CurrentWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($CurrentWindowsIdentity)
        $CurrentWindowsPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
        if ($CurrentWindowsPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
            (DISM.exe /Online /Cleanup-image /Scanhealth | Out-Null).Content
            (DISM.exe /Online /Cleanup-image /Restorehealth | Out-Null).Content
            (DISM.exe /online /cleanup-image /startcomponentcleanup | Out-Null).Content
            (sfc /scannow | Out-Null).Content
            Write-Host "Healthcheck complete" -ForegroundColor Green
            Write-Host "Please restart your system for the changes to take effect" -ForegroundColor Green
            Write-Host "@ZanyTHEbar Scripts Github Repo" -ForegroundColor Blue
        }
        else {
            $Esc = [char]0x1b
            $message = "Insufficient permissions to run this command. Please type $Esc[94;3madmin, sudo or su$Esc[0m $Esc[33mto elevate yourself and run this script again$Esc[0m"
            Write-Warning $message
        }
    }
    catch {
        throw $_.Exception.Message
    }
}

## Final Line to set prompt
oh-my-posh --init --shell pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
