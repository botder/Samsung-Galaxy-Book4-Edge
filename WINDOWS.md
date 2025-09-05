# Windows 11 for Arm64

This document lists websites where you can download an ISO for *Windows 11 for Arm64*, and how to extract files from the ISO.

## Download a Windows.iso

> [!TIP]  
> If you don't know what ISO to use, then just use the ISO provided by Microsoft on their website. You can always upgrade the installed edition with a [generic edition key](https://github.com/dorian-osly/wgkl) (should also work during installation). If you are looking for Windows 11 IoT Enterprise, then use the ISO from archive.isdn.network.

> [!NOTE]  
> UUP dump does not provide an ISO file directly. You will receive a script that will build the ISO file for you, automatically. You can customize the script to a degree, for example, to integrate available updates.

> [!WARNING]  
> Good luck with the UUP dump releases, because the Windows Setup always failed for me. If you really want to try out UUP dump, then make sure to edit the included `ConvertConfig.ini`. You have to set `wim2swm=1`, `UpdtBootFiles=1`, and `vwim2swm=1` to make the final ISO compatible with a FAT32 USB flash drive, and to use the new UEFI CA 2023 boot files (see KB5053484).

> [!TIP]  
> You can use the *UUP dump* script to automatically install drivers. Edit the included `ConvertConfig.ini` and set `AddDrivers=1`. Create the subdirectory `Drivers\ALL` and then copy the contents of your driver pack there.

- [Microsoft: Download Windows 11 for Arm-based PCs](https://www.microsoft.com/en-gb/software-download/windows11arm64)  
    <sup>Official download from Microsoft for Windows 11 Arm64.</sup>

- [UUP dump: Latest Public Release build](https://uupdump.net/fetchupd.php?arch=arm64&ring=retail)  
    <sup>Latest updated build for regular users.</sup>

- [UUP dump: Latest Release Preview build](https://uupdump.net/fetchupd.php?arch=arm64&ring=rp)  
    <sup>Reliable builds for previewing the next release. Ideal for trying out upcoming releases.</sup>

- [UUP dump: Latest Beta Channel build](https://uupdump.net/fetchupd.php?arch=arm64&ring=wis)  
    <sup>Reliable builds with most upcoming features available. Ideal for early adopters.</sup>

- [UUP dump: Latest Dev Channel build](https://uupdump.net/fetchupd.php?arch=arm64&ring=wif)  
    <sup>Somewhat unreliable builds with new ideas and long lead features. Ideal for enthusiasts.</sup>

- [UUP dump: Latest Canary Channel build](https://uupdump.net/fetchupd.php?arch=arm64&ring=canary)  
    <sup>Somewhat unstable builds with latest platform changes and early features. Ideal for highly technical users.</sup>

- [archive.isdn.network](https://archive.isdn.network/artifacts/)  
    <sup>Here you can find the Windows 11 IoT Enterprise LTSC 2024 for Arm64, and other *.iso files.</sup>

- [macOS: CrystalFetch](https://github.com/TuringSoftware/CrystalFetch)  
    <sup>macOS UI for creating Windows installer ISO from UUPDump.</sup>

## Extract files from a Windows.iso

- Using Windows Explorer:

    1. Mount your Windows.iso using Windows Explorer.

        You can right-click on your ISO file, and select `Open with > Windows Explorer` in the context menu.

    2. Copy all files from the mounted drive to the target directory.

- Using [7-Zip](https://www.7-zip.org):

    1. Open your Windows.iso using 7-Zip File Manager.

        You can right-click on your ISO file, and select `Open with > 7-Zip File Manager` in the context menu.  
        You can also use `7-Zip > Open archive` or `7-Zip > Extract files...`.
    
    2. Extract the files to the target directory.
