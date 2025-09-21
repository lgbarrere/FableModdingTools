@echo off
setlocal enabledelayedexpansion

:: === Global constants for default paths ===
set "DEFAULT_DIR_TLC=C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters"
set "DEFAULT_DIR_ANNIV=C:\Program Files (x86)\Steam\steamapps\common\Fable Anniversary"
set "EXPLORER_DEFAULT=%~dp0"
set "OUTPUT_DIR=%EXPLORER_DEFAULT%\FEMan"

:: === Global variables for loaded or set paths by user ===
set "fabletlc="
set "fableanni="
set "fableexplorer="

:: === Initializations ===
call :require_admin
call :init_directories
call :load_paths
call :save_default_explorer

:mainmenu
cls
call :show_logo
echo.
echo Fable TLC location: %fabletlc%
echo Fable Anniversary location: %fableanni%
echo Fable Explorer location: %fableexplorer%
echo.
echo     MANAGE FABLE VERSIONS
echo     ----------------------
echo     1) Install symlinks
echo     2) Remove symlinks
echo     3) Editing TLC
echo     4) Editing Chicken
echo     5) Editing Heroic
echo     6) Launch FE Explorer
echo     7) Make a backup of TLC folder
echo     8) Set directories
echo     9) Load default directories
echo     L) Load saved directories
echo     D) Delete symlinks and saved directories
echo     E) Enable mods (take ownership, etc.)
echo     C) Launch ChocolateBox
echo     Q) Quit
echo.
set /P "userinp=Make your selection: "
set "userinp=%userinp:~0,1%"
if /I "%userinp%"=="1" goto INSTALL
if /I "%userinp%"=="2" goto REMOVE
if /I "%userinp%"=="3" goto TLC
if /I "%userinp%"=="4" goto CHICKEN
if /I "%userinp%"=="5" goto HEROIC
if /I "%userinp%"=="6" goto LAUNCH
if /I "%userinp%"=="7" goto BACKUP_TLC
if /I "%userinp%"=="8" goto SETDIR
if /I "%userinp%"=="9" goto DEFDIRS
if /I "%userinp%"=="L" goto LOADDIRS
if /I "%userinp%"=="D" goto DELALL
if /I "%userinp%"=="E" goto ENABLEMODS
if /I "%userinp%"=="C" goto LAUNCHCBOX
if /I "%userinp%"=="Q" goto QUIT
echo Invalid selection. Try again...
pause
goto mainmenu

:: === Fonctions / Labels ===

:require_admin
    rem Check if this script is in Admin mode, otherwise restart as Admin
    @color 0c
    fsutil dirty query %systemdrive% >nul 2>&1
    if errorlevel 1 (
        echo Admin premissions required to use this script, please accept to reload.
        pause
        powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
        goto QUIT rem Close this non-admin script
    )
    rem Already Admin, continuing
    goto :eof

:init_directories
    rem Make a directory to save paths if missing
    if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"
    goto :eof

:load_paths
    rem Load configured paths if any
    if exist "%OUTPUT_DIR%\tlc.txt" set /p fabletlc=<"%OUTPUT_DIR%\tlc.txt"
    if exist "%OUTPUT_DIR%\anni.txt" set /p fableanni=<"%OUTPUT_DIR%\anni.txt"
    if exist "%OUTPUT_DIR%\explorerDIR.txt" set /p fableexplorer=<"%OUTPUT_DIR%\explorerDIR.txt"
    goto :eof

:save_default_explorer
    rem Save defaut path to Fable Explorer if missing
    if not defined fableexplorer (
        set "fableexplorer=!EXPLORER_DEFAULT!"
        echo !fableexplorer!>"%OUTPUT_DIR%\explorerDIR.txt"
        echo !fableexplorer!
        pause
    )
    goto :eof

:show_logo
    mode con: cols=100 lines=40
    color 0a
    title FEMan - Fable Symlinker
    echo.
    echo    `.://:-..--...-        `:+:`         `.://-......`      `-:::..```        `.::/-......`.-`-`
    echo      .sy+         .`      .s-:y-          :fs:     `-+:.     /yy.              :yh/      `  -
    echo      .sy:         `      .s. .:h-         :uh.      -yd:     /sy`              :yy.         `
    echo      .sy/````     `     -s`   `:y:        :ci.````./+/-      /sy`              :yy-```
    echo      .sy+-..```        -s-`....-:y:       :kt.`````..-:-`    /sy`              :sy:.```
    echo      .sy:             :o-......`.:y:      :sy.        :/oh.   /sy`          `   .+o-
    echo      .sy:           `++          `:y/     :os+`     `.shit`   /ss.          -    .-/.
    echo     `.+o:`         `+o.`          -/o.   `:+/damn:---//-`   `:+///:--:::-./-     `.::-.`````
    echo                                           `````````         `  ``````````
    echo ----------------------------------------------
    goto :eof

:cleanfolder
    rem Remove all symlinks, folders and files from the native game
    echo Cleaning game folder: %DEFAULT_DIR_TLC%
    rmdir /s /q "%DEFAULT_DIR_TLC%\data" >nul 2>&1
    del /q "%DEFAULT_DIR_TLC%\Fable.exe" >nul 2>&1
    del /q "%DEFAULT_DIR_TLC%\user.ini" >nul 2>&1
    del /q "%DEFAULT_DIR_TLC%\userst.ini" >nul 2>&1
    echo Cleaning done
    goto :eof

:createsymlink
    rem Usage: call :createsymlink "target_fullpath" "link_fullpath"
    if exist "%~2" (
        echo Link exists, deleting previous: "%~2"
        del /f /q "%~2" >nul 2>&1
    )
    echo Creating symlink "%~2" -> "%~1"
    mklink "%~2" "%~1"
    goto :eof

:savedir
    rem Usage: call :savedir path fileName
    set "path=%~1"
    set "fileName=%~2"

    rem Use delayed expansions to avoid issues with paths containing whitespaces
    if exist "!path!\" (
        echo !OUTPUT_DIR!\!fileName!
        echo !path!>"!OUTPUT_DIR!\!fileName!"
    ) else (
        echo The path !path! was not found, the save file cannot be edited
    )

    goto :eof

:install_symlinks
    rem Install all necessary folders and symlinks to mod TLC
    rem Remove the previous content first
    call :cleanfolder

    rem Make all necessary folders
    mkdir "%DEFAULT_DIR_TLC%\data\CompiledDefs" >nul 2>&1
    mkdir "%DEFAULT_DIR_TLC%\data\graphics\pc" >nul 2>&1
    mkdir "%DEFAULT_DIR_TLC%\data\lang\English" >nul 2>&1
    mkdir "%DEFAULT_DIR_TLC%\data\Levels" >nul 2>&1
    mkdir "%DEFAULT_DIR_TLC%\data\Misc\pc" >nul 2>&1

    rem Create all necessary symlinks
    call :createsymlink "%fabletlc%\data\graphics\graphics.big" "%DEFAULT_DIR_TLC%\data\graphics\graphics.big"
    call :createsymlink "%fabletlc%\data\graphics\pc\frontend.big" "%DEFAULT_DIR_TLC%\data\graphics\pc\frontend.big"
    call :createsymlink "%fabletlc%\data\graphics\pc\textures.big" "%DEFAULT_DIR_TLC%\data\graphics\pc\textures.big"
    call :createsymlink "%fabletlc%\data\lang\English\text.big" "%DEFAULT_DIR_TLC%\data\lang\English\text.big"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion_RT.stb" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion_RT.stb"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion.wad" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.wad"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion"
    call :createsymlink "%fabletlc%\data\Misc\pc\effects.big" "%DEFAULT_DIR_TLC%\data\Misc\pc\effects.big"
    call :createsymlink "%fabletlc%\Fable.exe" "%DEFAULT_DIR_TLC%\Fable.exe"
    call :createsymlink "%fabletlc%\user.ini" "%DEFAULT_DIR_TLC%\user.ini"
    call :createsymlink "%fabletlc%\userst.ini" "%DEFAULT_DIR_TLC%\userst.ini"
    call :createsymlink "%fabletlc%\data\Levels\creature_hub.lev" "%DEFAULT_DIR_TLC%\data\Levels\creature_hub.lev"
    call :createsymlink "%fabletlc%\data\Levels\creature_hub.tng" "%DEFAULT_DIR_TLC%\data\Levels\creature_hub.tng"

    echo Symlinks installed
    pause
    goto mainmenu

:: === Fonctions called from the main menu ===

:INSTALL
    if not defined fabletlc (
        echo Please set the Fable TLC directory first.
        pause
        goto mainmenu
    )
    call :install_symlinks
    goto mainmenu

:REMOVE
    call :cleanfolder
    echo Symlinks removed
    pause
    goto mainmenu

:TLC
    rem Link to TLC for simple edition
    call :cleanfolder
    mkdir "%DEFAULT_DIR_TLC%\data\CompiledDefs" >nul 2>&1

    call :createsymlink "%fabletlc%\user.ini" "%DEFAULT_DIR_TLC%\user.ini"
    call :createsymlink "%fabletlc%\userst.ini" "%DEFAULT_DIR_TLC%\userst.ini"
    call :createsymlink "%fabletlc%\data\CompiledDefs\frontend.bin" "%DEFAULT_DIR_TLC%\data\CompiledDefs\frontend.bin"
    call :createsymlink "%fabletlc%\data\CompiledDefs\game.bin" "%DEFAULT_DIR_TLC%\data\CompiledDefs\game.bin"
    call :createsymlink "%fabletlc%\data\CompiledDefs\names.bin" "%DEFAULT_DIR_TLC%\data\CompiledDefs\names.bin"
    call :createsymlink "%fabletlc%\data\CompiledDefs\script.bin" "%DEFAULT_DIR_TLC%\data\CompiledDefs\script.bin"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion.bwd" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.bwd"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion.gtg" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.gtg"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion.wad" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.wad"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion.wld" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.wld"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion"
    echo Editing TLC files set up
    pause
    goto mainmenu

:CHICKEN
    rem Link to Anniversary Chicken mode
    call :cleanfolder
    mkdir "%DEFAULT_DIR_TLC%\data\CompiledDefs" >nul 2>&1

    call :createsymlink "%fableanni%\user.ini" "%DEFAULT_DIR_TLC%\user.ini"
    call :createsymlink "%fableanni%\userst.ini" "%DEFAULT_DIR_TLC%\userst.ini"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\frontend.bin" "%DEFAULT_DIR_TLC%\data\CompiledDefs\frontend.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\game.bin" "%DEFAULT_DIR_TLC%\data\CompiledDefs\game.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\names.bin" "%DEFAULT_DIR_TLC%\data\CompiledDefs\names.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\script.bin" "%DEFAULT_DIR_TLC%\data\CompiledDefs\script.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels" "%DEFAULT_DIR_TLC%\data\Levels"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\creature_hub.lev" "%DEFAULT_DIR_TLC%\data\Levels\creature_hub.lev"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\creature_hub.tng" "%DEFAULT_DIR_TLC%\data\Levels\creature_hub.tng"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.bwd" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.bwd"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.gtg" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.gtg"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.wad" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.wad"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.wld" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.wld"
    echo Editing Chicken mode set up
    pause
    goto mainmenu

:HEROIC
    rem Link to Anniversary Heroic mode
    call :cleanfolder
    mkdir "%DEFAULT_DIR_TLC%\data\CompiledDefs" >nul 2>&1

    call :createsymlink "%fableanni%\user.ini" "%DEFAULT_DIR_TLC%\user.ini"
    call :createsymlink "%fableanni%\userst.ini" "%DEFAULT_DIR_TLC%\userst.ini"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\frontend.bin" "%DEFAULT_DIR_TLC%\data\CompiledDefs\frontend.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\gamehard.bin" "%DEFAULT_DIR_TLC%\data\CompiledDefs\game.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\names.bin" "%DEFAULT_DIR_TLC%\data\CompiledDefs\names.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\scripthard.bin" "%DEFAULT_DIR_TLC%\data\CompiledDefs\script.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels" "%DEFAULT_DIR_TLC%\data\Levels"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\creature_hub.lev" "%DEFAULT_DIR_TLC%\data\Levels\creature_hub.lev"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\creature_hub.tng" "%DEFAULT_DIR_TLC%\data\Levels\creature_hub.tng"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.bwd" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.bwd"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.gtg" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.gtg"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.wad" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.wad"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.wld" "%DEFAULT_DIR_TLC%\data\Levels\FinalAlbion.wld"
    echo Editing Heroic mode set up
    pause
    goto mainmenu

:LAUNCH
    if exist "%fableexplorer%\FableExplorer.exe" (
        cd /d %fableexplorer%
        start "" "FableExplorer.exe"
    ) else (
        echo Fable Explorer path could not be found.
        echo Please set it with options 8 or 9 from the main menu.
        pause
    )
    goto mainmenu

:BACKUP_TLC
    cls
    rem Check the game folder exists
    if not exist "%fabletlc%\" (
        echo Fable - The Lost Chapters folder not found
        echo Please set it from the main menu
        pause
        goto mainmenu
    )

    rem Extract parent folder from %fabletlc%
    echo Creating backup of Fable - The Lost Chapters...
    for %%I in ("%fabletlc%") do set "PARENT_DIR=%%~dpI"
    set "PARENT_DIR=%PARENT_DIR:~0,-1%"

    rem Set path for the backup
    set "gameDirBackup=%PARENT_DIR%\Fable - TLC"

    rem Check no backup exists, otherwise clean it
    if exist "%gameDirBackup%\" (
        echo Backup folder already exists, deleting it...
        rmdir /s /q "%gameDirBackup%" >nul 2>&1
        if exist "%gameDirBackup%\" (
            echo Failed to delete existing backup
            echo A backup file might be in use, operation aborted
            echo The corrupted backup is located at "%gameDirBackup%"
            pause
            goto mainmenu
        ) else (
            echo Previous backup deleted
        )
    )

    rem Copy the game folder in the backup folder
    echo Copying "%fabletlc%" to "%gameDirBackup%", please wait...
    xcopy "%fabletlc%" "%gameDirBackup%\" /E /I /H /K /Y >nul
    echo Backup completed successfully

    pause
    goto mainmenu

:SETDIR
    cls
    echo Setting directories:
    echo 1) Fable TLC
    echo 2) Fable Anniversary
    echo 3) Fable Explorer
    echo B) Back to main menu
    set /p "userinp=Your choice: "
    set "userinp=%userinp:~0,1%"
    if /I "%userinp%"=="1" goto SET_TLC
    if /I "%userinp%"=="2" goto SET_ANNIV
    if /I "%userinp%"=="3" goto SET_EXPLORER
    if /I "%userinp%"=="B" goto mainmenu
    echo Invalid or unsupported.
    pause
    goto SETDIR

:SET_TLC
    cls
    echo Enter custom path for Fable TLC (without trailing backslash):
    set /p "fabletlc=Path: "
    call :savedir "%fabletlc%" tlc.txt
    echo TLC directory set to %fabletlc%
    pause
    goto mainmenu

:SET_ANNIV
    cls
    echo Enter custom path for Fable Anniversary (without trailing backslash):
    set /p "fableanni=Path: "
    call :savedir "%fableanni%" anni.txt
    echo Anniversary directory set to %fableanni%
    pause
    goto mainmenu

:SET_EXPLORER
    cls
    echo Enter custom path for Fable Explorer (without trailing backslash):
    set /p "fableexplorer=Path: "
    call :savedir "%fableexplorer%" explorerDIR.txt
    echo Explorer directory set to %fableexplorer%
    pause
    goto mainmenu

:DEFDIRS
    rem Reset to defaults
    set "fabletlc=%DEFAULT_DIR_TLC%"
    set "fableanni=%DEFAULT_DIR_ANNIV%"
    set "fableexplorer=%EXPLORER_DEFAULT%"
    call :savedir "%fabletlc%" tlc.txt
    call :savedir "%fableanni%" anni.txt
    call :savedir "%fableexplorer%" explorerDIR.txt
    echo Default directories loaded.
    pause
    goto mainmenu

:LOADDIRS
    call :load_paths
    echo Saved directories loaded:
    echo TLC: %fabletlc%
    echo Anniversary: %fableanni%
    echo Explorer: %fableexplorer%
    pause
    goto mainmenu

:DELALL
    rem Delete symlinks and folders
    call :cleanfolder
    del /q "%OUTPUT_DIR%\tlc.txt" >nul 2>&1
    del /q "%OUTPUT_DIR%\anni.txt" >nul 2>&1
    del /q "%OUTPUT_DIR%\explorerDIR.txt" >nul 2>&1
    echo All symlinks & saved directories deleted.
    pause
    goto mainmenu

:ENABLEMODS
    rem Respectively become owner, grant all rights and remove "Read-Only" attribute

    echo Enabling modifications...
    rem Allow modding for Fable TLC
    if exist "%fabletlc%\" (
        takeown /f "%fabletlc%" /r
        icacls "%fabletlc%" /grant "%USERNAME%":F /t
        attrib -r "%fabletlc%\*.*" /s /d
    ) else (
        echo The path to Fable TLC is not correct, consider to set it from the main menu
        pause
    )

    rem Allow modding for Fable Anniversary
    if exist "%fableanni%\" (
        takeown /f "%fableanni%" /r
        icacls "%fableanni%" /grant "%USERNAME%":F /t
        attrib -r "%fableanni%\*.*" /s /d
    ) else (
        echo The path to Fable Anniversary is not correct, consider to set it from the main menu
        pause
    )

    echo Operation complete
    pause
    goto mainmenu

:LAUNCHCBOX
    if defined fableexplorer (
        cd /d "%fableexplorer%"
        copy /Y "%fableexplorer%\default_xuserst.ini" "%fableanni%\WellingtonGame\FableData\Build"
        start "" "ChocolateBox-x64.exe"
    ) else (
        echo Explorer path non défini, utilisez SETDIR pour définir.
    )
    goto mainmenu

:QUIT
    endlocal
    exit

:: "D:\Program Files (x86)\Steam\steamapps\common\Fable The Lost Chapters"
:: "D:\Program Files (x86)\Steam\steamapps\common\Fable Anniversary"
:: New-Item -ItemType Junction -Path "D:\Program Files (x86)\Steam\steamapps\common\Fable The Lost Chapters\data\Levels\FinalAlbion" -Target "D:\Program Files (x86)\Steam\steamapps\common\Fable Anniversary\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion"
