:: Author: Yaranorgoth
@echo off
setlocal enabledelayedexpansion

:: === Global constants for default paths ===
set "DEFAULT_DIR_FTLC_CD=%ProgramFiles(x86)%\Microsoft Games\Fable - The Lost Chapters"
set "DEFAULT_DIR_FTLC_STEAM=%ProgramFiles(x86)%\Steam\steamapps\common\Fable The Lost Chapters"
set "DEFAULT_DIR_FA=%ProgramFiles(x86)%\Steam\steamapps\common\Fable Anniversary"
set "ROOT_DIR=%~dp0"
set "CONFIG_DIR=%ROOT_DIR%\config"
set "CONFIG_FTLC=FTLC_path.txt"
set "CONFIG_FA=FA_path.txt"
set "CONFIG_MOD=MOD_path.txt"

:: === Global variables for loaded or set paths by the user ===
set "ftlcPath="
set "faPath="
set "modPath="

:: === Initializations ===
call :require_admin
call :init_configs
call :load_paths

:mainmenu
cls
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
echo ----------------------------------------------------------------------------------------------------
echo.
echo Fable TLC location: %ftlcPath%
echo Fable Anniversary location: %faPath%
echo Mod release location: %modPath%
echo.
echo     MOD SETUP OPTIONS TO USE IN ORDER
echo     ---------------------------------
echo     1) Set directories
echo     2) Backup Fable TLC
echo     3) Enable mods
echo     4) Make FTLC-FA symlink
echo.
echo     EXTRA OPTIONS
echo     ---------------------------------
echo     D) Load default directories
echo     C) Launch ChocolateBox
echo     E) Launch Fable Explorer
echo     R) Prepare FA mod release
echo     Q) Quit
echo.
set /P "userinp=Make your selection: "
set "userinp=%userinp:~0,1%"
if /I "%userinp%"=="1" goto SETDIR
if /I "%userinp%"=="2" goto BACKUP
if /I "%userinp%"=="3" goto ENABLEMODS
if /I "%userinp%"=="4" goto SYMLINK
if /I "%userinp%"=="D" goto DEFAULT
if /I "%userinp%"=="C" goto CHOCOLATEBOX
if /I "%userinp%"=="E" goto FABLEEXPLORER
if /I "%userinp%"=="R" goto RELEASE
if /I "%userinp%"=="Q" goto QUIT
echo Invalid selection, try again...
pause
goto mainmenu

:: === Fonctions / Labels ===

:require_admin
    rem Usage: call :require_admin
    rem Check if this script is in Admin mode, otherwise restart as Admin
    color 0c
    fsutil dirty query %systemdrive% >nul 2>&1
    if errorlevel 1 (
        echo Admin premissions required to use this script, please agree to restart
        pause
        powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
        goto QUIT rem Close this non-admin script
    )
    rem Already Admin, continuing
    title Fable Anniversary Symlinker
    mode con: cols=100 lines=40
    color 0a
    goto :eof

:init_configs
    rem Usage: call :init_configs
    rem Make a directory to save paths if missing
    if not exist "%CONFIG_DIR%\" mkdir "%CONFIG_DIR%"
    goto :eof

:load_paths
    rem Usage: call :load_paths
    rem Load configured paths if any
    if exist "%CONFIG_DIR%\%CONFIG_FTLC%" set /p ftlcPath=<"%CONFIG_DIR%\%CONFIG_FTLC%"
    if exist "%CONFIG_DIR%\%CONFIG_FA%" set /p faPath=<"%CONFIG_DIR%\%CONFIG_FA%"
    if exist "%CONFIG_DIR%\%CONFIG_MOD%" set /p modPath=<"%CONFIG_DIR%\%CONFIG_MOD%"
    goto :eof

:savedir
    rem Usage: call :savedir path fileName
    set "path=%~1"
    set "fileName=%~2"

    rem Use delayed expansions to avoid issues with paths containing whitespaces
    if exist "!path!\" (
        echo !path!>"!CONFIG_DIR!\!fileName!"
    ) else (
        echo The path !path! was not found, the save file cannot be edited
    )

    goto :eof

:: === Fonctions called from the main menu ===

:SET_TLC
    cls
    echo Enter custom path for Fable TLC (without ending backslash):
    set /p "userInput=Path: "

    if exist "!userInput!\" (
        set "ftlcPath=!userInput!"
        call :savedir "!ftlcPath!" "!CONFIG_FTLC!"
        echo TLC directory set to !ftlcPath!
    ) else (
        echo The specified directory does not exist, please try again...
        pause
        goto SETDIR
    )

    pause
    goto mainmenu

:SET_ANNIV
    cls
    echo Enter custom path for Fable Anniversary (without ending backslash):
    set /p "userInput=Path: "

    if exist "!userInput!\" (
        set "faPath=!userInput!"
        call :savedir "!faPath!" "!CONFIG_FA!"
        echo Anniversary directory set to !faPath!
    ) else (
        echo The specified directory does not exist, please try again...
    )

    pause
    goto SETDIR

:SET_MOD
    cls
    echo Enter custom path for your FA mod release (without ending backslash):
    set /p "userInput=Path: "

    set "modPath=!userInput!"
    echo !modPath!>"!CONFIG_DIR!\!CONFIG_MOD!"
    echo Mod release directory set to !modPath!

    pause
    goto SETDIR

:SETDIR
    cls
    echo Setting directories:
    echo 1) Fable TLC
    echo 2) Fable Anniversary
    echo 3) FA Mod release
    echo B) Back to main menu
    set /p "userinp=Your choice: "
    set "userinp=%userinp:~0,1%"
    if /I "%userinp%"=="1" goto SET_TLC
    if /I "%userinp%"=="2" goto SET_ANNIV
    if /I "%userinp%"=="3" goto SET_MOD
    if /I "%userinp%"=="B" goto mainmenu
    echo Invalid selection, try again...
    pause
    goto SETDIR

:BACKUP
    cls
    rem Check the game folder exists
    if not exist "!ftlcPath!\" (
        echo Path to Fable - The Lost Chapters not found, please set it from the main menu
        pause
        goto mainmenu
    )

    rem Extract parent folder from %ftlcPath%
    echo Creating backup of Fable - The Lost Chapters...
    for %%I in ("%ftlcPath%") do set "PARENT_DIR=%%~dpI"
    set "PARENT_DIR=%PARENT_DIR:~0,-1%"

    rem Set path for the backup
    set "gameDirBackup=%PARENT_DIR%\Fable - TLC"

    rem Check no backup exists, otherwise clean it
    if exist "!gameDirBackup!\" (
        echo Backup folder already exists, deleting it...
        rmdir /s /q "!gameDirBackup!" >nul 2>&1
        if exist "!gameDirBackup!\" (
            echo Failed to delete existing backup
            echo A backup file might be in use, operation aborted
            echo The corrupted backup is located at "!gameDirBackup!"
            pause
            goto mainmenu
        ) else (
            echo Previous backup deleted
        )
    )

    rem Copy the game folder in the backup folder
    echo.
    echo Copying "%ftlcPath%" to "%gameDirBackup%"
    echo Please wait, this operation can take a while...
    xcopy "%ftlcPath%" "%gameDirBackup%\" /E /I /H /K /Y >nul
    echo Backup completed successfully

    pause
    goto mainmenu

:ENABLEMODS
    rem Respectively become owner, grant all rights and remove "Read-Only" attribute
    cls
    echo Enabling modifications...

    rem Allow modding for Fable TLC
    if exist "!ftlcPath!\" (
        takeown /f "!ftlcPath!" /r
        icacls "!ftlcPath!" /grant "%USERNAME%":F /t
        attrib -r "!ftlcPath!\*.*" /s /d
    ) else (
        echo The path to Fable TLC is not correct, consider to set it from the main menu
        echo.
        pause
    )

    rem Allow modding for Fable Anniversary
    if exist "!faPath!\" (
        takeown /f "!faPath!" /r
        icacls "!faPath!" /grant "%USERNAME%":F /t
        attrib -r "!faPath!\*.*" /s /d
    ) else (
        echo The path to Fable Anniversary is not correct, consider to set it from the main menu
        echo.
        pause
    )

    echo Operation complete
    pause
    goto mainmenu

:SYMLINK
    rem Check the path to FTLC exists
    cls
    set isMissingPath=0

    if not exist "!ftlcPath!\" (
        echo Fable TLC folder not found, please set it from the main menu
        pause
        set isMissingPath=1
    )

    rem Check the path to FA exists
    if not exist "!faPath!\" (
        echo Fable Anniversary folder not found, please set it from the main menu
        pause
        set isMissingPath=1
    )

    rem Go back to the main menu if a path is missing
    if %isMissingPath%==1 (
        goto mainmenu
    )

    rem Make a junction from Fable TLC and Anniversary
    echo Making a junction...
    set "junctionPath=%ftlcPath%\data\Levels\FinalAlbion"
    set "targetPath=%faPath%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion"

    rem Check the path to the jonction already exists
    if exist "!junctionPath!\" (
        rem Check if the path lead to a junction (not a folder)
        dir "!junctionPath!" | findstr /i "<JUNCTION>" >nul
        if %errorlevel%==0 (
            echo The junction already exists
            echo Replacing by a new junction...
            rmdir "!junctionPath!"
        ) else (
            echo The path exists but it is a folder
            echo Replacing by a junction...
            rmdir /S /Q "!junctionPath!"
        )
    )

    mklink /J "%junctionPath%" "%targetPath%" >nul
    echo Junction created for Fable TLC ^<^<===^>^> Fable Anniversary
    pause
    goto mainmenu

:DEFAULT
    rem Reset to defaults
    cls

    rem Check the default path to TLC (CD version) exists
    echo Loading default paths
    if exist "!DEFAULT_DIR_FTLC_CD!\" (
        set "ftlcPath=!DEFAULT_DIR_FTLC_CD!"
        call :savedir "!ftlcPath!" "!CONFIG_FTLC!" >nul
    ) else (
        echo The CD version of Fable TLC was not found at the default location:
        echo !DEFAULT_DIR_FTLC_CD!
        echo Trying to use the Steam version...
        echo.

        rem Check the default path to TLC (Steam version) exists
        if exist "!DEFAULT_DIR_FTLC_STEAM!" (
            set "ftlcPath=!DEFAULT_DIR_FTLC_STEAM!"
            call :savedir "!ftlcPath!" "!CONFIG_FTLC!" >nul
        ) else (
            echo The Steam version of Fable TLC was not found at the default location:
            echo !DEFAULT_DIR_FTLC_STEAM!
            echo.
        )
    )

    if exist "!DEFAULT_DIR_FA!" (
        set "faPath=!DEFAULT_DIR_FA!"
        call :savedir "!faPath!" "!CONFIG_FA!" >nul
    ) else (
        echo Fable Anniversary was not found at the default location:
        echo !DEFAULT_DIR_FA!
        echo.
    )

    echo Loading operations finished
    pause
    goto mainmenu

:CHOCOLATEBOX
    rem Launch ChocolateBox
    if exist "!faPath!\" (
        copy /Y "!ROOT_DIR!\tools\Chocolate Box\default_xuserst.ini" "!faPath!\WellingtonGame\FableData\Build" >nul
    )
    start "" "%ROOT_DIR%\tools\Chocolate Box\ChocolateBox.exe"
    goto mainmenu

:FABLEEXPLORER
    rem Launch Fable Explorer
    rem Move where FableExplorer.exe is to make it detect def.xml dependency
    cd /d %ROOT_DIR%\tools\FableExplorer
    start "" "FableExplorer.exe"
    goto mainmenu

:RELEASE
    rem Copy the mod files as a new release
    cls
    echo Saving the mod as a new release...

    rem Check modPath is defined
    if "!modPath!"=="" (
        echo The mod release path is empty, please set it from the main menu
        pause
        goto mainmenu
    )

    rem Check the path to FA exists
    if not exist "!faPath!\" (
        echo Fable Anniversary folder not found, please set it from the main menu
        pause
        goto mainmenu
    )

    rem Create the necessary mod folder if missing
    if exist "!modPath!\WellingtonGame\" (
        echo A mod release already exists, deleting it...
        rmdir /s /q "!modPath!\WellingtonGame" >nul 2>&1
        if exist "!modPath!\WellingtonGame\" (
            echo Failed to delete existing mod release
            echo A mod release file might be in use, operation aborted
            echo The corrupted mod release is located at "!modPath!\WellingtonGame"
            pause
            goto mainmenu
        ) else (
            echo Previous mod release deleted
        )
    )

    rem Copy the mod files
    set "relativeDefsPath=WellingtonGame\FableData\Build\Data\CompiledDefs\Development"
    set "faSrcDefs=%faPath%\%relativeDefsPath%"
    set "modDstDefs=%modPath%\%relativeDefsPath%"
    mkdir "%modDstDefs%"
    copy /Y "%faSrcDefs%\names.bin" "%modDstDefs%\"
    copy /Y "%faSrcDefs%\game.bin" "%modDstDefs%\"
    copy /Y "%faSrcDefs%\gamehard.bin" "%modDstDefs%\"
    copy /Y "%faSrcDefs%\script.bin" "%modDstDefs%\"
    copy /Y "%faSrcDefs%\scripthard.bin" "%modDstDefs%\"

    rem Copy the FinalAlbion folder
    xcopy /E /Y /I "%faPath%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion" "%modPath%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion\"

    echo Mod release done
    pause
    goto mainmenu

:QUIT
    endlocal
    exit
