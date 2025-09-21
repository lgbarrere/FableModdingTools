@echo off
setlocal enabledelayedexpansion

:: === Variables globales ===
set "GAME_DIR_NATIVE=C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters"
set "GAME_DIR_TLC=C:\Program Files (x86)\Microsoft Games\Fable - TLC"
set "GAME_DIR_ANNIV=C:\Program Files (x86)\Steam\steamapps\common\Fable Anniversary"
set "EXPLORER_DEFAULT=%~dp0"
set "OUTPUT_DIR=%EXPLORER_DEFAULT%\FEMan"

:: Variables de chemins dynamiques (chargés ou définis par l’utilisateur)
set "fabletlc="
set "fableanni="
set "fableexplorer="

:: === Initialisation ===
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
echo     7) Rename TLC folder (backup)
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
if /I "%userinp%"=="7" goto RENAME
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

:: === Fonctions / Labels utilitaires ===

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
    rem Make save directories if required
    if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"
    goto :eof

:save_default_explorer
    rem Sauvegarde le chemin par défaut de Fable Explorer
    if not defined fableexplorer (
        set "fableexplorer=!EXPLORER_DEFAULT!"
        echo !fableexplorer!>"%OUTPUT_DIR%\explorerDIR.txt"
        echo !fableexplorer!
        pause
    )
    goto :eof

:load_paths
    rem Chargement des chemins sauvegardés s’ils existent
    if exist "%OUTPUT_DIR%\tlc.txt" set /p fabletlc=<"%OUTPUT_DIR%\tlc.txt"
    if exist "%OUTPUT_DIR%\anni.txt" set /p fableanni=<"%OUTPUT_DIR%\anni.txt"
    if exist "%OUTPUT_DIR%\explorerDIR.txt" set /p fableexplorer=<"%OUTPUT_DIR%\explorerDIR.txt"
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
    echo Cleaning game folder: %GAME_DIR_NATIVE%
    rmdir /s /q "%GAME_DIR_NATIVE%\data" >nul 2>&1
    del /q "%GAME_DIR_NATIVE%\Fable.exe" >nul 2>&1
    del /q "%GAME_DIR_NATIVE%\user.ini" >nul 2>&1
    del /q "%GAME_DIR_NATIVE%\userst.ini" >nul 2>&1
    echo Cleaning done
    goto :eof

:createsymlink
    rem Usage : call :createsymlink "target_fullpath" "link_fullpath"
    if exist "%~2" (
        echo Link exists, deleting previous: "%~2"
        del /f /q "%~2" >nul 2>&1
    )
    echo Creating symlink "%~2" -> "%~1"
    mklink "%~2" "%~1"
    goto :eof

:savedir
    rem Usage : call :savedir path fileName
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

    rem Créer les dossiers nécessaires
    mkdir "%GAME_DIR_NATIVE%\data\CompiledDefs" >nul 2>&1
    mkdir "%GAME_DIR_NATIVE%\data\graphics\pc" >nul 2>&1
    mkdir "%GAME_DIR_NATIVE%\data\lang\English" >nul 2>&1
    mkdir "%GAME_DIR_NATIVE%\data\Levels" >nul 2>&1
    mkdir "%GAME_DIR_NATIVE%\data\Misc\pc" >nul 2>&1

    rem Créer les symlinks requis (exemples basés sur ton script original)
    call :createsymlink "%fabletlc%\data\graphics\graphics.big" "%GAME_DIR_NATIVE%\data\graphics\graphics.big"
    call :createsymlink "%fabletlc%\data\graphics\pc\frontend.big" "%GAME_DIR_NATIVE%\data\graphics\pc\frontend.big"
    call :createsymlink "%fabletlc%\data\graphics\pc\textures.big" "%GAME_DIR_NATIVE%\data\graphics\pc\textures.big"
    call :createsymlink "%fabletlc%\data\lang\English\text.big" "%GAME_DIR_NATIVE%\data\lang\English\text.big"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion_RT.stb" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion_RT.stb"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion.wad" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.wad"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion"
    call :createsymlink "%fabletlc%\data\Misc\pc\effects.big" "%GAME_DIR_NATIVE%\data\Misc\pc\effects.big"
    call :createsymlink "%fabletlc%\Fable.exe" "%GAME_DIR_NATIVE%\Fable.exe"
    call :createsymlink "%fabletlc%\user.ini" "%GAME_DIR_NATIVE%\user.ini"
    call :createsymlink "%fabletlc%\userst.ini" "%GAME_DIR_NATIVE%\userst.ini"
    call :createsymlink "%fabletlc%\data\Levels\creature_hub.lev" "%GAME_DIR_NATIVE%\data\Levels\creature_hub.lev"
    call :createsymlink "%fabletlc%\data\Levels\creature_hub.tng" "%GAME_DIR_NATIVE%\data\Levels\creature_hub.tng"

    echo Symlinks installed
    pause
    goto mainmenu

:: === Actions du menu ===

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
    rem Edition simple : liens vers les fichiers de TLC
    call :cleanfolder
    mkdir "%GAME_DIR_NATIVE%\data\CompiledDefs" >nul 2>&1

    call :createsymlink "%fabletlc%\user.ini" "%GAME_DIR_NATIVE%\user.ini"
    call :createsymlink "%fabletlc%\userst.ini" "%GAME_DIR_NATIVE%\userst.ini"
    call :createsymlink "%fabletlc%\data\CompiledDefs\frontend.bin" "%GAME_DIR_NATIVE%\data\CompiledDefs\frontend.bin"
    call :createsymlink "%fabletlc%\data\CompiledDefs\game.bin" "%GAME_DIR_NATIVE%\data\CompiledDefs\game.bin"
    call :createsymlink "%fabletlc%\data\CompiledDefs\names.bin" "%GAME_DIR_NATIVE%\data\CompiledDefs\names.bin"
    call :createsymlink "%fabletlc%\data\CompiledDefs\script.bin" "%GAME_DIR_NATIVE%\data\CompiledDefs\script.bin"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion.bwd" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.bwd"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion.gtg" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.gtg"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion.wad" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.wad"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion.wld" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.wld"
    call :createsymlink "%fabletlc%\data\Levels\FinalAlbion" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion"
    echo Editing TLC files set up
    pause
    goto mainmenu

:CHICKEN
    rem Lie certains fichiers d’Anniversary pour le mode Chicken (exemple)
    call :cleanfolder
    mkdir "%GAME_DIR_NATIVE%\data\CompiledDefs" >nul 2>&1
    rem puis les symlinks spécifiques
    call :createsymlink "%fableanni%\user.ini" "%GAME_DIR_NATIVE%\user.ini"
    call :createsymlink "%fableanni%\userst.ini" "%GAME_DIR_NATIVE%\userst.ini"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\frontend.bin" "%GAME_DIR_NATIVE%\data\CompiledDefs\frontend.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\game.bin" "%GAME_DIR_NATIVE%\data\CompiledDefs\game.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\names.bin" "%GAME_DIR_NATIVE%\data\CompiledDefs\names.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\script.bin" "%GAME_DIR_NATIVE%\data\CompiledDefs\script.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels" "%GAME_DIR_NATIVE%\data\Levels"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\creature_hub.lev" "%GAME_DIR_NATIVE%\data\Levels\creature_hub.lev"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\creature_hub.tng" "%GAME_DIR_NATIVE%\data\Levels\creature_hub.tng"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.bwd" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.bwd"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.gtg" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.gtg"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.wad" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.wad"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.wld" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.wld"
    echo Editing Chicken mode set up
    pause
    goto mainmenu

:HEROIC
    rem Mode héroïque, symlinks spécifiques
    call :cleanfolder
    mkdir "%GAME_DIR_NATIVE%\data\CompiledDefs" >nul 2>&1
    rem puis les symlinks spécifiques
    call :createsymlink "%fableanni%\user.ini" "%GAME_DIR_NATIVE%\user.ini"
    call :createsymlink "%fableanni%\userst.ini" "%GAME_DIR_NATIVE%\userst.ini"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\frontend.bin" "%GAME_DIR_NATIVE%\data\CompiledDefs\frontend.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\gamehard.bin" "%GAME_DIR_NATIVE%\data\CompiledDefs\game.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\names.bin" "%GAME_DIR_NATIVE%\data\CompiledDefs\names.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\scripthard.bin" "%GAME_DIR_NATIVE%\data\CompiledDefs\script.bin"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels" "%GAME_DIR_NATIVE%\data\Levels"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\creature_hub.lev" "%GAME_DIR_NATIVE%\data\Levels\creature_hub.lev"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\creature_hub.tng" "%GAME_DIR_NATIVE%\data\Levels\creature_hub.tng"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.bwd" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.bwd"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.gtg" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.gtg"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.wad" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.wad"
    call :createsymlink "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.wld" "%GAME_DIR_NATIVE%\data\Levels\FinalAlbion.wld"
    echo Editing Heroic mode set up
    pause
    goto mainmenu

:RENAME
    cd /d "%~dp0"
    echo Renaming native game folder to backup TLC folder...
    if exist "%GAME_DIR_TLC%" (
        echo TLC backup folder already exists, skipping rename.
    ) else (
        rename "%GAME_DIR_NATIVE%" "Fable - TLC"
        mkdir "%GAME_DIR_NATIVE%"
    )
    echo Rename done.
    pause
    goto mainmenu

:SETDIR
    cls
    echo Setting directories:
    echo 1) Fable TLC
    echo 2) Fable Anniversary
    echo 3) Fable Explorer
    echo 4) Back to main menu
    set /p "userinp=Your choice: "
    set "userinp=%userinp:~0,1%"
    if /I "%userinp%"=="1" goto SET_TLC
    if /I "%userinp%"=="2" goto SET_ANNIV
    if /I "%userinp%"=="3" goto SET_EXPLORER
    if /I "%userinp%"=="4" goto mainmenu
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
    rem Reset to défaults
    set "fabletlc=%GAME_DIR_TLC%"
    set "fableanni=%GAME_DIR_ANNIV%"
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
    rem Supprime symlinks + dossiers de sauvegarde
    call :cleanfolder
    del /q "%OUTPUT_DIR%\tlc.txt" >nul 2>&1
    del /q "%OUTPUT_DIR%\anni.txt" >nul 2>&1
    del /q "%OUTPUT_DIR%\explorerDIR.txt" >nul 2>&1
    echo All symlinks & saved directories deleted.
    pause
    goto mainmenu

:ENABLEMODS
    rem Prendre possession et donner les bonnes permissions
    echo Enabling modifications...
    takeown /f "%GAME_DIR_NATIVE%" /r /d Y
    icacls "%GAME_DIR_NATIVE%" /grant %USERNAME%:F /t
    if defined fabletlc (
        takeown /f "%fabletlc%" /r /d Y
        icacls "%fabletlc%" /grant %USERNAME%:F /t
    )
    if defined fableanni (
        takeown /f "%fableanni%" /r /d Y
        icacls "%fableanni%" /grant %USERNAME%:F /t
    )
    echo Attributes read-only removed.
    attrib -r "%GAME_DIR_NATIVE%\*.*" /s >nul 2>&1
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
:: http://www.youtube.com/Yudansha79
