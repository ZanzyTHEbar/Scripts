# Set up CMD profile with Oh-My-Posh

This readme will guide you through the process of setting up a CMD profile with Oh-My-Posh and using the currently selected theme for powershell in cmd.

## Install

> **Note**: if you already have `oh-my-posh` setup for powershell - you can skip running the `setup.ps1` script
that just set's up `oh-my-posh` and installs icons

First, navigate to the [powershell/profiles](./Scripts/powershell/profiles) directory and run the `setup.ps1` script as administrator. This will install the required dependencies and set up the profile.

Next, navigate to the [cmd/profiles](./Scripts/cmd/profiles) directory and run the `exe` for `clink`. This will allow `cmd` to use `the oh-my-posh` profile.

Setting up the profiles this way will allow you to use the same theme in both `powershell` and `cmd`.

> **Warning**: You must have scripting enabled on your machine to run the `setup.ps1` script. You can enable this by running `Set-ExecutionPolicy UnRestricted` in an elevated powershell window.
> answer Y to all the options, then run `Set-ExecutionPolicy UnRestricted -Force`.
> **Note**: When installing `CLINK` ensure that you check the `autostart` option.

## Steps

1. Move the [.inputrc](.inputrc) file to your user profile directory `C:/Users/(user)/.inputrc`.
2. Move the [oh-my-posh.lua](oh-my-posh.lua) file to your the clink scripts directory `C:\Users\(user)\AppData\Local\clink`.
3. Restart the CMD terminal for the changes to take effect.
4. Right click on the title bar of the CMD terminal and select `Properties`.
5. Go to the `Font` tab and select `Caskadyia Nerd Font`.

   - if you have not installed the font, you can download it from [here](/Scripts/powershell/profiles/fonts/).

## Useful Links

- [Clink Documentation](https://chrisant996.github.io/clink/clink.html#getting-started)
