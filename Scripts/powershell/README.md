# Custom PowerShell Scripts

This directory contains custom PowerShell scripts that are used by me on most machines.

## Scripts

### Profiles `setup.ps1`

This script is used to setup the PowerShell profile on a machine. It will create a profile if one does not exist and then add the `Microsoft.PowerShell_profile.ps1` script to the profile.

This script setups necessary environment variables and aliases for the PowerShell profile, as well as installs `chocolatey` and  `oh-my-posh`.

> **Note**: You must manually install the fonts (or whatever font you prefer - the included one is best). You can find the fonts in the [`fonts`](/Scripts/powershell/profiles/fonts/) directory.

### Manually Install fonts

To manually install the fonts, you will need to open the directory where the fonts are located, selet all of them and right-click.
Click the `install` option.

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
