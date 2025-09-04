@echo off
setlocal enabledelayedexpansion

call :requires oscdimg || exit /b
call :requires dism || exit /b

set "UNPACK_PROGRAM=C:\Program Files\7-Zip\7z.exe"
if exist "%UNPACK_PROGRAM%" ( goto :has_7zip_program )
echo You do not have 7-Zip installed
echo We assume you unpacked your Windows ISO to the Setup subdirectory
echo.
:has_7zip_program

pushd %~dp0
set "ROOT_DIR=%cd%"
popd

set "DRIVER_PACK_DIR=%ROOT_DIR%\DriverPack"
set "SETUP_DIR=%ROOT_DIR%\Setup"
set "MOUNT_DIR=%ROOT_DIR%\Mount"
set "SOURCE_ISO=%ROOT_DIR%\Source.iso"
set "DESTINATION_ISO=%ROOT_DIR%\Windows.iso"

if exist "%DRIVER_PACK_DIR%" ( goto :has_driver_pack )
echo The DriverPack subdirectory does not exist
echo Create the directory and extract your driver files to it
pause >NUL
exit /b 1
:has_driver_pack

echo [~] Root Dir:        %ROOT_DIR%
echo [~] Mount Dir:       %MOUNT_DIR%
echo [~] Setup Dir:       %SETUP_DIR%
echo [~] Driver Pack Dir: %DRIVER_PACK_DIR%
echo.

::
::
::

if not exist "%MOUNT_DIR%" ( mkdir "%MOUNT_DIR%" )

if not exist "%UNPACK_PROGRAM%" ( goto :check_setup_files )
if not exist "%SOURCE_ISO%" ( goto :check_setup_files )

if exist "%SETUP_DIR%" ( rmdir /s /q "%SETUP_DIR%" >NUL )
call:show mkdir "%SETUP_DIR%" || exit /b
call:show "%UNPACK_PROGRAM%" x -y -o"%SETUP_DIR%" "%SOURCE_ISO%" || exit /b

:check_setup_files
call :requires_wim "sources\boot.wim" || exit /b
call :requires_wim "sources\install.wim" || exit /b

call :show dism /Unmount-Wim /MountDir:"%MOUNT_DIR%" /Discard
call :show dism /Cleanup-Wim

echo [+] Adding drivers to 'sources\boot.wim' index 2
call :try dism /Mount-Wim /WimFile:"%SETUP_DIR%\sources\boot.wim" /Index:2 /MountDir:"%MOUNT_DIR%" || exit /b
call :try dism /Image:"%MOUNT_DIR%" /Add-Driver /Driver:"%DRIVER_PACK_DIR%" /Recurse || exit /b
call :try dism /Unmount-Wim /MountDir:"%MOUNT_DIR%" /Commit || exit /b
echo [+] Done

for /f "tokens=2 delims=: " %%A in ('dism /Get-WimInfo /WimFile:"%SETUP_DIR%\sources\install.wim" ^| find /i "Index"') do (
    set /a INSTALL_INDICES += 1
)

echo [+] Adding drivers to 'sources\install.wim'...
for /L %%J in (1, 1, %INSTALL_INDICES%) do (
    echo [+] ...for sources\install.wim /Index:%%J
    dism /Mount-Wim /WimFile:"%SETUP_DIR%\sources\install.wim" /Index:%%J /MountDir:"%MOUNT_DIR%"
    dism /Image:"%MOUNT_DIR%" /Add-Driver /Driver:"%DRIVER_PACK_DIR%" /Recurse
    dism /Unmount-Wim /MountDir:"%MOUNT_DIR%" /Commit
)

echo [+] Splitting image 'sources\install.wim'...
call :try dism /Split-Image /ImageFile:"%SETUP_DIR%\sources\install.wim" /SWMFile:"%SETUP_DIR%\sources\install.swm" /FileSize:3800 || exit /b
call :try del /s "%SETUP_DIR%\sources\install.wim" >NUL || exit /b
echo [+] Done

echo [+] Building ISO...
if exist "%DESTINATION_ISO%" ( del /q "%DESTINATION_ISO%" >NUL )
call :try oscdimg -u2 -b"%SETUP_DIR%\boot\etfsboot.com" -h "%SETUP_DIR%" "%DESTINATION_ISO%" || exit /b

exit /b 0

::
::
::

:requires <program>
    set "program=%~1"
    where /Q "%program%" && exit /b 0
    echo An essential program '%program%' was not found
    echo You must run this script using the Deployment and Imaging Tools Environment
    exit /b 1

:requires_wim <path>
    set "wim=%~1"
    set "abs=%SETUP_DIR%\%wim%"
    if exist "%abs%" ( exit /b 0 )
    echo An essential Windows installation medium '%wim%' was not found
    echo Ensure that you have extracted any Windows ISO to the correct subdirectory
    exit /b 1

:try <command ...>
    set "command="
    for %%A in (%*) do (
        set command=!command! %%~A
    )
    echo $%command%
    %*
    if %ERRORLEVEL% equ 0 ( exit /b 0 )
    echo Command has failed with exit code %ERRORLEVEL%
    exit /b %ERRORLEVEL%

:show <command ...>
    set "command="
    for %%A in (%*) do (
        set command=!command! %%~A
    )
    echo $%command%
    %* >NUL 2>&1
    if %ERRORLEVEL% equ 0 ( exit /b 0 )
    echo Command has failed with exit code %ERRORLEVEL%
    exit /b %ERRORLEVEL%
