# Rebuild Windows.iso with Driver Pack

This document describes the usage of the included [rebuild-iso-with-drivers.cmd](rebuild-iso-with-drivers.cmd) Batch script to rebuild a Windows.iso with preinstalled drivers, and then how to flash it to your USB flash drive.

> [!TIP]  
> If you have [7-Zip](https://www.7-zip.org) installed, you can also let the script extract the files, by placing your ISO into the root directory, next to the script: `C:\WinIso\Source.iso`. Then you don't have to extract the ISO yourself. Be aware that the script will delete the `Setup` subdirectory first.

## Create a bootable USB flash drive

1. Create the directory `C:\WinIso`  
    <sup>The location does *not* matter, but you need at least 20 GB of free space</sup>

2. Create the subdirectories `DriverPack`, `Setup` inside `C:\WinIso`

3. Copy the contents of your [Driver Pack](DRIVERS.md) to `C:\WinIso\DriverPack`  
    <sup>The directory layout inside the subdirectory does not matter</sup>

4. Copy the contents of your [Windows ISO](WINDOWS.md) to `C:\WinIso\Setup`  
    <sup>Inside the subdirectory you should have `sources\install.wim` for example</sup>

5. Copy [rebuild-iso-with-drivers.cmd](rebuild-iso-with-drivers.cmd) to `C:\WinIso`

6. Start `Deployment and Imaging Tools Environment` as Administrator  
    <sup>You should be able to find it in your start menu</sup>

    [<img src="./images/windows_adk/RunAsAdmin.png" width="50%" />](./images/windows_adk/RunAsAdmin.png)

    If you struggle to find this shortcut, you may run the command behind it:
    ```bat
    cmd.exe /k "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat" 
    ```

7. Switch to `C:\WinIso`

    ```bat
    cd /d `C:\WinIso`
    ```

8. Run `rebuild-iso-with-drivers.cmd` and wait until its finished

> [!CAUTION]  
> If the script fails, you should definitely recreate the `Setup` subdirectory for a clean rebuild. This is not necessary if you use a `Source.iso` along with `7-Zip`.

9. Flash the ISO

    You are not required to use Rufus, you can also try to manually flash your USB flash drive, by using diskpart and copying the files over. Read [this manual](MANUAL-FLASH.md) with the steps.

    1. Open Rufus
    2. Click on `SELECT` and open `C:\WinIso\Windows.iso`
    3. Select `Standard Windows Installation` under *Image option*
    4. Select `GPT` and `UEFI (non CSM)` under *Partition scheme* and *Target system*, respectively
    5. Select `FAT32` under *File system*
    6. Click on `START`
    7. If a `Windows User Experience` option window shows up, then toggle the options to your desire, and continue by hitting `OK`
    8. Click on `OK` in the confirmation window, if the correct USB flash drive was selected
    9. Done

10. Done, you can [install Windows](README.md#install-windows) now
