# Custom PowerShell Scripts

This directory contains custom PowerShell scripts that are used by me on most machines.

## Scripts

### Profiles `setup.ps1`

This script is used to setup the PowerShell profile on a machine. It will create a profile if one does not exist and then add the `Microsoft.PowerShell_profile.ps1` script to the profile.

This script setups necessary environment variables and aliases for the PowerShell profile, as well as installs `chocolatey` and  `oh-my-posh`.

> **Note**: You must manually install the fonts (or whatever font you prefer - the included one is best). The default compatible Nerd font will be downloaded to `C:\\Users\<user>\cove.zip`. To choose a custom font, it is recommended to use this site `https://www.nerdfonts.com/font-downloads`, otherwise the icons will not work properly.

## Setup

You clone this repo and install the profile by running the following command:

```powershell
cd $HOME/Documents/GitHub/Scripts/Scripts/powershell/profiles
./setup.ps1
```

Or you can use the following `one-liner`:

```powershell
irm https://github.com/ZanzyTHEbar/Scripts/raw/main/Scripts/powershell/profiles/setup.ps1 | iex
```

### Manually Install fonts

To manually install the fonts, you will need to open the directory where the fonts are located, selet all of them and right-click.

Click the `install` option.

Once installed, you can proceed to set the font in your terminal(s).

#### Powershell

In powershell, you will need to click on the titlebar, right-click and select `properties`. Then, click the `font` tab and select the preferred font from the ones you just installed.

#### Windows Terminal

In windows terminal, click on the `down arrow` in the top right corner and select `settings`. Then, click the `Default` option under the `Profiles` tab and select the preferred font from the ones you just installed.

#### VSCode

To setup the font and profile in VSCode, you will need to open the `settings.json` file. You can do this by clicking on the `gear` icon in the bottom left corner and selecting `settings`. Then, search for `terminal.integrated.fontFamily` and set it to the preferred font.

If this does not appear, go to the bottom of the file and add the following:

```json
"terminal.integrated.fontFamily": "Caskaydia Cove Nerd Font"
```

You will also need to add the following to the `settings.json` file - in order to set the profile for the integrated terminal (Powershell Extension):

```json
"powershell.enableProfileLoading": true,
"powershell.scriptAnalysis.enable": true,
```

Then, you will need to copy the `Microsoft.VSCode_profile.ps1` file to the following directory:

```bash
C:\Users\{username}\Documents\WindowsPowerShell
```

Restart VSCode and you should be good to go.

### Utilites `robo_copy.ps1`

This script is used to copy files from one directory to another _very quickly_. It uses `robocopy` with the most-ideal common flags already set.

The only two flags that you will need to set are the `source` and `destination` directories.

Once copied to your `$HOME/Documents/WindowsPowerShell/Scripts` directory You can do this by running the following command:

```powershell
robo_copy <source> <destination>
```

### Utilites `winutil_copy.ps1`

This script is used to run the [`WinUtil`](https://github.com/ChrisTitusTech/winutil/) by `Chris Titus`.

This utility offers advanced features for your PC. It is a great tool to use to clean up your PC and make it run faster, as well as simply manage installs of common softwares and features.

There are no flags to set for this script. It will automatically download the latest version of `WinUtil` and run it - it will not install ´WinUtil´ you will need internet to use this command. If you want to install `WinUtil` you can do so by navigating to the url above and downloading the latest version.

Once copied to your `$HOME/Documents/WindowsPowerShell/Scripts` directory You can do this by running the following command:

```powershell
winutil
```
