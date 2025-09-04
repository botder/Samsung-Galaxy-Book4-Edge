# How to manually flash Windows.iso

This document describes how to manually format your USB flash drive, to copy the contents of a Windows.iso to it.

## Format your USB flash drive

1. Open *Command Prompt* as Administrator.  
    You can `Right-Click` on Start-Menu and click on `Terminal (Admin)`.

    [<img src="./images/StartMenuTerminalAsAdmin.png" width="25%" />](./images/StartMenuTerminalAsAdmin.png)

2. Format your USB flash drive manually

> [!IMPORTANT]  
> Use `create partition primary size=30000` below, if your USB flash drive capacity is over 32 GB.

> [!CAUTION]  
> The second command `list disk` is going to show you the available disks on your device, and you must to select the USB flash drive disk in the next command, e.g. `select disk 3`.

    ```bat
    diskpart
    list disk
    select disk x
    clean
    convert MBR
    create partition primary
    format fs=fat32 quick
    assign letter "x"
    exit
    ```

## Copy files to your USB flash drive

> [!IMPORTANT]  
> The FAT32 file system can only store files with up to 4 GB in size. If you follow the main tutorial, then you should be clear to continue, because we've split the `sources\install.wim` file beforehand.

> [!TIP]  
> Your USB flash drive will be mounted as `X:\`, if you ran the commands above.

### From a directory

1. Open your directory with the ISO files.  
    <sup>If you follow the main tutorial, they will be in `C:\WinIso\Setup`</sup>

2. Copy all files from that directory to your USB flash drive.

### From an ISO

- Using Windows Explorer:

    1. Mount your Windows.iso using Windows Explorer.

        You can right-click on your ISO file, and select `Open with > Windows Explorer` in the context menu.

    2. Copy all files from the mounted drive to your USB flash drive.

- Using [7-Zip](https://www.7-zip.org):

    1. Open your Windows.iso using 7-Zip File Manager.

        You can right-click on your ISO file, and select `Open with > 7-Zip File Manager` in the context menu.  
        You can also use `7-Zip > Open archive` or `7-Zip > Extract files...`.
    
    2. Extract the files to your USB flash drive.
