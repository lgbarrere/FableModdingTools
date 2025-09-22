@echo off
setlocal enabledelayedexpansion

:: === Global constants for default paths ===
set "DEFAULT_DIR_TLC=C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters"
set "DEFAULT_DIR_ANNIV=C:\Program Files (x86)\Steam\steamapps\common\Fable Anniversary"
set "EXPLORER_DEFAULT=%~dp0"
set "OUTPUT_DIR=%EXPLORER_DEFAULT%\config"

:: === Global variables for loaded or set paths by the user ===
set "fabletlc="
set "fableanni="

:: === Initializations ===
call :require_admin
call :init_directories
call :load_paths

:mainmenu
cls
call :show_logo
echo.
echo Fable TLC location: %fabletlc%
echo Fable Anniversary location: %fableanni%
echo.
echo     MANAGE FABLE VERSIONS
echo     ----------------------
echo     1) Set directories
echo     2) Enable mods
echo     3) Make a backup of TLC folder
echo     4) Create symlink
echo     5) Remove symlink
echo     6) Load default directories
echo     C) Launch ChocolateBox
echo     E) Launch Fable Explorer
echo     Q) Quit
echo.
set /P "userinp=Make your selection: "
set "userinp=%userinp:~0,1%"
if /I "%userinp%"=="1" goto SETDIR
if /I "%userinp%"=="2" goto ENABLEMODS
if /I "%userinp%"=="3" goto BACKUP
if /I "%userinp%"=="4" goto INSTALL
if /I "%userinp%"=="5" goto REMOVE
if /I "%userinp%"=="6" goto DEFDIRS
if /I "%userinp%"=="C" goto CHOCOLATEBOX
if /I "%userinp%"=="E" goto EXPLORER
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
    goto :eof

:show_logo
    mode con: cols=100 lines=40
    color 0a
    title Fable Anniversary Symlinker
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

:savedir
    rem Usage: call :savedir path fileName
    set "path=%~1"
    set "fileName=%~2"

    rem Use delayed expansions to avoid issues with paths containing whitespaces
    if exist "!path!\" (
        echo !path!>"!OUTPUT_DIR!\!fileName!"
    ) else (
        echo The path !path! was not found, the save file cannot be edited
    )

    goto :eof

:: === Fonctions called from the main menu ===

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

:SETDIR
    cls
    echo Setting directories:
    echo 1) Fable TLC
    echo 2) Fable Anniversary
    echo B) Back to main menu
    set /p "userinp=Your choice: "
    set "userinp=%userinp:~0,1%"
    if /I "%userinp%"=="1" goto SET_TLC
    if /I "%userinp%"=="2" goto SET_ANNIV
    if /I "%userinp%"=="B" goto mainmenu
    echo Invalid or unsupported
    pause
    goto SETDIR

:ENABLEMODS
    rem Respectively become owner, grant all rights and remove "Read-Only" attribute
    cls
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

:BACKUP
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

:INSTALL
    rem Check %fabletlc\% exists
    cls
    if not exist "%fabletlc%\" (
        echo Fable TLC folder not found, please set it from the main menu
        pause

        rem Check %fabletanni\% exists
        if not exist "%fableanni%\" (
            echo Fable Anniversary folder not found, please set it from the main menu
            pause
            goto mainmenu
        )

        goto mainmenu
    )

    rem Make a junction from Fable TLC and Anniversary
    echo Making a junction...
    set "junctionPath=%fabletlc%\data\Levels\FinalAlbion"
    set "targetPath=%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion"

    rem Check the path to the jonction already exists
    if exist "%junctionPath%\" (
        rem Check if the path lead to a junction (not a folder)
        dir "%junctionPath%" | findstr /i "<JUNCTION>" >nul
        if %errorlevel%==0 (
            echo The junction already exists
            echo Replacement with a new junction...
            rmdir "%junctionPath%"
        ) else (
            echo "%junctionPath%" exists but it is not a junction
            echo Consider making a backup from the menu and remove the folder manually
            echo Operation aborted
            pause
            goto mainmenu
        )
    )

    mklink /J "%junctionPath%" "%targetPath%" >nul
    echo Junction created for Fable TLC ^<^<===^>^> Fable Anniversary
    pause
    goto mainmenu

:REMOVE
    cls
    set "junctionPath=%fabletlc%\data\Levels\FinalAlbion"

    rem Check the path to the jonction exists
    if exist "%junctionPath%\" (
        rem Check if the path lead to a junction (not a folder)
        dir "%junctionPath%" | findstr /i "<JUNCTION>" >nul
        if %errorlevel%==0 (
            echo The junction exists
            echo Deletion of the junction...
            rmdir "%junctionPath%"
            echo Junction removed
        ) else (
            echo The following path exists but it is not a junction:
            echo "%junctionPath%"
            echo Consider making a backup from the main menu and remove the folder manually
            echo Operation aborted
        )
    ) else (
        echo The following path to the junction does not exist:
        echo "%junctionPath%"*
        echo Operation aborted
    )

    pause
    goto mainmenu

:DEFDIRS
    rem Reset to defaults
    cls
    set "fabletlc=%DEFAULT_DIR_TLC%"
    set "fableanni=%DEFAULT_DIR_ANNIV%"
    call :savedir "%fabletlc%" tlc.txt
    call :savedir "%fableanni%" anni.txt
    echo Default directories loaded
    pause
    goto mainmenu

:CHOCOLATEBOX
    copy /Y "%EXPLORER_DEFAULT%\tools\default_xuserst.ini" "%fableanni%\WellingtonGame\FableData\Build"
    start "" "%EXPLORER_DEFAULT%\tools\ChocolateBox.exe"
    goto mainmenu

:EXPLORER
    rem Move where FableExplorer.exe to make it detect def.xml dependency
    cd /d %EXPLORER_DEFAULT%\tools
    start "" "FableExplorer.exe"
    goto mainmenu

:QUIT
    endlocal
    exit
