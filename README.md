# Samsung Galaxy Book4 Edge

This elaborate tutorial guides you through the torturous process of installing the Windows operating system on a [Samsung Galaxy Book4 Edge](https://www.samsung.com/us/computing/galaxy-books/galaxy-book4-edge/) with the [Snapdragon X Plus](https://www.qualcomm.com/products/mobile/snapdragon/laptops-and-tablets/snapdragon-x-plus) (X1P-42-100) central processing unit. This tutorial is probably also applicable to similiar devices with an ARM64 architecture cpu.

> [!IMPORTANT]  
> If you are looking for the previous edition of this tutorial, or in other words, the first edition,
> which required two USB flash drives and a WinPE setup, then switch to the [winpe branch](../../tree/winpe).

> THIS TUTORIAL IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A  PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THIS TUTORIAL OR THE USE OR OTHER DEALINGS IN THIS TUTORIAL.

## Requirements

- A working computer with Windows, or a virtual machine with Windows

- 1x USB flash drive with at least 8 GB capacity

- [Installation media for Windows](WINDOWS.md)

- [Driver Pack for Windows](DRIVERS.md)

- [Windows Assessment and Deployment Kit](ADK.md) (Windows ADK)  

- [Rufus](https://rufus.ie/en/) to create a bootable USB flash drive  
    <sup>This is optional, and [Ventoy](https://www.ventoy.net/en/index.html) does **not** work</sup>

> [!CAUTION]  
> You must be able to plug your USB flash drive to the USB-C slot on the left side of the device. You can use a USB-A to USB-C adapter for this. It will not work with the USB-A slot on the right side of the laptop (though you can get around the initial driver issue window by installing literally any driver, but this is very broken and not recommended).

## Create a bootable USB flash drive

> [!TIP]  
> I created a Batch script to automate this entire process. It adds the drivers to both `boot.wim`, and to every Windows image inside `install.wim`. If you installed [7-Zip](https://www.7-zip.org) to the default directory, then it will also extract the files from your source ISO too. Further information can be found in the [SCRIPT.md](SCRIPT.md) document.

1. Create the directory `C:\WinIso`  
    <sup>The location does *not* matter, but you need at least 20 GB of free space</sup>

2. Create the subdirectories `DriverPack`, `Setup`, `Mount` inside `C:\WinIso`

3. Copy the contents of your [Driver Pack](DRIVERS.md) to `C:\WinIso\DriverPack`  
    <sup>The directory layout inside the subdirectory does not matter</sup>

4. Copy the contents of your [Windows ISO](WINDOWS.md) to `C:\WinIso\Setup`  
    <sup>Inside the subdirectory you should have `sources\install.wim` for example</sup>

5. Start `Deployment and Imaging Tools Environment` as Administrator  
    <sup>You should be able to find it in your start menu</sup>

    [<img src="./images/windows_adk/RunAsAdmin.png" width="50%" />](./images/windows_adk/RunAsAdmin.png)

    If you struggle to find this shortcut, you may run the command behind it:
    ```bat
    cmd.exe /k "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat" 
    ```

6. Add your drivers to the Windows Setup image inside `sources\boot.wim` at index 2

    ```bat
    dism /Mount-Wim /WimFile:"C:\WinIso\Setup\sources\boot.wim" /Index:2 /MountDir:"C:\WinIso\Mount"

    dism /Image:"C:\WinIso\Mount" /Add-Driver /Driver:"C:\WinIso\DriverPack" /Recurse

    dism /Unmount-Wim /MountDir:"C:\WinIso\Mount" /Commit
    ```

7. Check the Windows image indices inside `sources\install.wim`  
    <sup>You need the index for the next step</sup>
    
    ```bat
    dism /Get-WimInfo /WimFile:"C:\WinIso\Setup\sources\install.wim"
    ```

    This command should yield output in this form:

    ```
    Index : 1
    Name : Windows 11 Enterprise LTSC
    Description : Windows 11 Enterprise LTSC
    Size : 20.666.349.645 bytes
    ```

8. Add your drivers to the Windows images inside `sources\install.wim`  
    <sup>You can add drivers to every index, there is no limitation</sup>

    Make sure to replace `/Index:1` with the Windows image index you want to update.

    ```bat
    dism /Mount-Wim /WimFile:"C:\WinIso\Setup\sources\install.wim" /Index:1 /MountDir:"C:\WinIso\Mount"

    dism /Image:"C:\WinIso\Mount" /Add-Driver /Driver:"C:\WinIso\DriverPack" /Recurse

    dism /Unmount-Wim /MountDir:"C:\WinIso\Mount" /Commit
    ```

9. Split your `sources\install.wim` to multiple `sources\install<N>.swm` files  
    <sup>Adding drivers to the install.wim can easily exceed the 4 GB file size limit of FAT32</sup>

    You should also delete the original `install.wim` after this operation, because it will end up
    in the final image, if you don't.

    ```bat
    dism /Split-Image /ImageFile:"C:\WinIso\Setup\sources\install.wim" /SWMFile:"C:\WinIso\Setup\sources\install.swm" /FileSize:3800

    del /s "C:\WinIso\Setup\sources\install.wim"
    ```

10. Rebuild the ISO

    ```bat
    oscdimg -u2 -b"C:\WinIso\Setup\boot\etfsboot.com" -h "C:\WinIso\Setup" "C:\WinIso\Windows.iso"
    ```

11. Flash the ISO

    You are not required to use [Rufus](https://rufus.ie/en/), you can also try to manually flash your USB flash drive, by using diskpart and copying the files over. Read [this manual](MANUAL-FLASH.md) with the steps.

    1. Open Rufus
    2. Click on `SELECT` and open `C:\WinIso\Windows.iso`
    3. Select `Standard Windows Installation` under *Image option*
    4. Select `GPT` and `UEFI (non CSM)` under *Partition scheme* and *Target system*, respectively
    5. Select `FAT32` under *File system*
    6. Click on `START`
    7. If a `Windows User Experience` option window shows up, then toggle the options to your desire, and continue by hitting `OK`
    8. Click on `OK` in the confirmation window, if the correct USB flash drive was selected
    9. Done

12. Done

## Install Windows

1. Power off your target computer

2. Plug in the USB flash drive, and other optional devices like a keyboard and mouse

> [!CAUTION]  
> You must be able to plug your USB flash drive to the USB-C slot on the left side of the device. You can use a USB-A to USB-C adapter for this. It will not work with the USB-A slot on the right side of the laptop (though you can get around the initial driver issue window by installing literally any driver, but this is very broken and not recommended).

3. Power on the computer, and switch to the UEFI/BIOS menu by repeatedly hitting F2 when you see the Samsung boot logo

> [!TIP]  
> If your device keeps booting into Windows, then there are two ways to enter the UEFI menu:  
> **1st Option: Turn of Fast Startup in Windows**
> - Open a command line with Administrator
> - Run `powercfg /h off` to disable hibernation feature
> - Go to [step 1](#install-windows) above
>
> **2nd Option: Reboot into troubleshooting menu**
> - Open your start menu
> - Click on the power icon
> - Hold the `Shift` key and click on `Reboot`
> - Wait until your device reboots into the blue troubleshooting menu.
> - Use arrow keys to select `Troubleshoot` (*Reset your PC or see advanced options*) and then hit enter key.
> - Select `Advanced options` and then hit enter key.
> - Select `UEFI Firmware Settings` and then hit enter key.
> - Hit enter again to reboot

4. Once you're inside the UEFI menu, you should disable Secure Boot and boot the USB flash drive first:

    - Switch to the `Boot` menu
    - **Disable** Secure Boot Control
    - Click on `Boot Device Priority >`
    - Select your WinPE USB flash drive next to `Boot Option #1`
    - Hit the *Save* button on the right side
    - Confirm the changes by hitting *OK*

5. Your device should boot into the Windows Setup

6. If everything went well, then the Setup won't ask for further drivers and request you to select the language and keyboard layout

7. In a newer version of the Setup, you should be able to switch back to the older version through a blue text link in the bottom left corner of the Setup window

8. Continue through the Setup, and make sure to select the image/edition with preinstalled drivers

9. Done

## Troubleshooting

### Issues with `dism /Mount-Wim`

If you run into trouble with the DISM commands, or you try to delete the *Mount* directory, but Windows refuses to do so, then run the commands below, to unmount the directory, and to run a clean up.

```bat
dism /Unmount-Wim /MountDir:"C:\WinIso\Mount" /Discard

dism /Cleanup-Wim
```

### Do you have some other issue?

Create a new issue on GitHub and explain the problem. Maybe I can help you, and add the problem to this list.

## Credits

The information presented in this tutorial is primarily based on:

- [Acercandr0/Snapdragon-X-Windows-ARM-reinstall](https://github.com/Acercandr0/Snapdragon-X-Windows-ARM-reinstall) by [Acercandr0](https://github.com/Acercandr0)
- [caccialdo/article.adoc](https://gist.github.com/caccialdo/3b0d0113489ecee456d94c1e9462d755) by [caccialdo](https://github.com/caccialdo), including the comments by other users below that Gist
