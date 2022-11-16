# Set up CMD profile with Oh-My-Posh

This readme will guide you through the process of setting up a CMD profile with Oh-My-Posh and using the currently selected theme for powershell in cmd.

## Install

Firstly, install [Oh-My-Posh](https://ohmyposh.dev/docs/installation) if you haven't already for the the powershell profile.

Secondly install [Clink](https://chrisant996.github.io/clink/clink.html#getting-started) for cmd support.

> **Note**: When installing `CLINK` ensure that you check the `autostart` option.

## Steps

1. Move the [.inputrc](.inputrc) file to your user profile directory `C:/Users/(user)/.inputrc`.
2. Move the [oh-my-posh.lua](oh-my-posh.lua) file to your the clink scripts directory `C:\Users\(user)\AppData\Local\clink`.
3. Restart the CMD terminal for the changes to take effect.
4. Right click on the title bar of the CMD terminal and select `Properties`.
5. Go to the `Font` tab and select `Caskadyia Nerd Font`.

   - if you have not installed the font, you can download it from [here](/Scripts/powershell/profiles/fonts/).
