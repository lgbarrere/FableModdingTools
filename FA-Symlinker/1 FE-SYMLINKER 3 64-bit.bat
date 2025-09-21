:: Initialize the script
set FEman=
@echo off
SET fableexplorer=%cd%
del %Output%\explorerDIR.txt
echo %fableexplorer%>%Output%\explorerDIR.txt
@color 0c
title Waiting for admin privileges...
echo %output%
echo %fableexplorer%
echo %cd%
pause

:: Display the Fable logo
mode con: cols=100 lines=40
echo. Fabletlcmod.com
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

:: Wait the user provides admin privileges to allow script execution
echo. Waiting for admin privileges...
@echo off
echo %output%
echo %fableexplorer%
echo %cd%
pause
:: Check the admin privileges are allowed, otherwise restart the script in admin mode
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
cls
echo %cd%
cd C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
echo %cd%
@echo off
echo %output%
echo %fableexplorer%
echo %cd%
pause

:: Save paths to game at "Output"
mkdir %USERPROFILE%\Documents\FEMan
mkdir %USERPROFILE%\Documents\FEMan\Directories
cls
set Output="%USERPROFILE%\Documents\FEMan\Directories"
echo %output%
echo %fableexplorer%
echo %cd%
pause
goto autoloaddirs

:: Check the game folder exists, otherwise create the folder
:MAINMENU
mkdir "C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters"
clear
cd C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
@echo off
@color 0a
title FEMan 64-bit

:: Display the Fable logo
mode con: cols=100 lines=40
echo. Fabletlcmod.com
echo.
echo    `.://:-..--...-        `:+:`         `.://-......`      `-:::..```        `.::/-......`.-`-`
echo      .sy+         .`      .s-:y-          :yy:     `-+:.     /yy.              :yh/      `  -
echo      .sy:         `      .s. .:h-         :yy.      -yd:     /sy`              :yy.         `
echo      .sy/````     `     -s`   `:y:        :ys.````./+/-      /sy`              :yy-```
echo      .sy+-..```        -s-`....-:y:       :yy.`````..-:-`    /sy`              :sy:.```
echo      .sy:             :o-......`.:y:      :sy.        :/o.   /sy`          `   .+o-
echo      .sy:           `++          `:y/     :os+`     `.ohh`   /ss.          -    .-/.
echo     `.+o:`         `+o.`          -/o.   `:+//lol:---//-`   `:+///:--:::-./-     `.::-.`````
echo                                           `````````         `  ``````````
echo ----------------------------------------------

:: Show all paths and options
echo.
echo Fable TLC location: %fabletlc%
echo.
echo Fable Anniversary location: %fableanni%
echo.
echo Fable Explorer location: %fableexplorer%
echo.
echo.	MANAGE FABLE VERSIONS
echo.	---------------------
echo.	1.) Install symlinks
echo.	2.) Remove symlinks
echo.	3.) Editing TLC
echo.	4.) Editing Chicken
echo.	5.) Editing Heroic
echo.	6.) Launch FE
echo.	7.) Rename TLC folder
echo.	q.) Quit
echo.	8.) Set directories
echo.	9.) Load default directories
echo.	L.) Load saved directories
echo.	D.) Delete symlinks and saved directories
echo.	E.) Take ownership of files (enable mods)
echo.	C.) Launch cbox

:: Check what action was chosen
:CHOOSEACTION
set /p userinp=    ^   Make your selection:
set userinp=%userinp:~0,1%
if /i "%userinp%"=="1" goto INSTALL
if /i "%userinp%"=="2" goto REMOVE
if /i "%userinp%"=="3" goto TLC
if /i "%userinp%"=="4" goto CHICKEN
if /i "%userinp%"=="5" goto HEROIC
if /i "%userinp%"=="q" goto QUIT
if /i "%userinp%"=="6" goto LAUNCH
if /i "%userinp%"=="7" goto rename
if /i "%userinp%"=="8" goto SETDIR
if /i "%userinp%"=="9" goto defdirs
if /i "%userinp%"=="L" goto loaddirs
if /i "%userinp%"=="D" goto delall
if /i "%userinp%"=="E" goto enablemods
if /i "%userinp%"=="C" goto launchcbox
echo.Try Again...
pause
GOTO CHOOSEACTION

:enablemods
@echo off
:: In order: become owner, get full access permissions and remove "read-only" attributes to edit the mod on Fable TLC
takeown /f "C:\Program Files\Microsoft Games\Fable - The Lost Chapters" /r /d Y
takeown /f "C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters" /r /d Y
takeown /f "C:\Program Files\Steam\steamapps\common\Fable Anniversary" /r /d Y
takeown /f "C:\Program Files (x86)\Steam\steamapps\common\Fable Anniversary" /r /d Y
icacls "C:\Program Files\Microsoft Games\Fable - The Lost Chapters" /grant %username%:F
icacls "C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters" /grant %username%:F
icacls "C:\Program Files\Steam\steamapps\common\Fable Anniversary" /grant %username%:F
icacls "C:\Program Files (x86)\Steam\steamapps\common\Fable Anniversary" /grant %username%:F
attrib -r "C:\Program Files\Microsoft Games\Fable - The Lost Chapters*.*" /s
attrib -r "C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters*.*" /s
attrib -r "C:\Program Files\Steam\steamapps\common\Fable Anniversary*.*" /s
attrib -r "C:\Program Files (x86)\Steam\steamapps\common\Fable Anniversary*.*" /s
:: Do the same for non-native folder paths (previously set from menus)
takeown /f "C:\Program Files\Microsoft Games\%fabletlc%" /r /d Y
takeown /f "C:\Program Files (x86)\Microsoft Games\%fabletlc%" /r /d Y
takeown /f "C:\Program Files\Steam\steamapps\common\%fableanni%" /r /d Y
takeown /f "C:\Program Files (x86)\Steam\steamapps\common\%fableanni%" /r /d Y
icacls "C:\Program Files\Microsoft Games\%fabletlc%" /grant %username%:F
icacls "C:\Program Files (x86)\Microsoft Games\%fabletlc%" /grant %username%:F
icacls "C:\Program Files\Steam\steamapps\common\%fableanni%" /grant %username%:F
icacls "C:\Program Files (x86)\Steam\steamapps\common\%fableanni%" /grant %username%:F
attrib -r "C:\Program Files\Microsoft Games\%fabletlc%*.*" /s
attrib -r "C:\Program Files (x86)\Microsoft Games\%fabletlc%*.*" /s
attrib -r "C:\Program Files\Steam\steamapps\common\%fableanni%*.*" /s
attrib -r "C:\Program Files (x86)\Steam\steamapps\common\%fableanni%*.*" /s
echo. Done
pause
goto mainmenu

:: TODO: Unused, consider call it, supposed to display the set paths
:currentdir
echo Fable TLC: %fabletlc%
echo Fable Anniversary: %fableanni%
echo Fable Explorer: %fableexplorer%
pause
goto mainmenu

:: TODO: This instruction is out of logic, consider moving it + variable feman never initialized
cd %feman%
:: Remove all symlinks and saved directories
:delall
rmdir /s /q data
del Fable.exe
cd %output%
del "%output%"
echo.All files removed
pause
goto mainmenu

:: Reset all paths to default
:defdirs
set fabletlc= C:\Program Files (x86)\Microsoft Games\Fable - TLC
set fableanni= C:\Program Files (x86)\Steam\steamapps\common\Fable Anniversary
:: TODO: Consider setting this path too instead of emptying it
set fableexplorer=
goto mainmenu

:: Read existing saved paths at "Output"
:autoloaddirs
cd %output%
set /p fabletlc=<tlc.txt
set /p fableanni=<anni.txt
set /p fableexplorer=<explorerDIR.txt
cls
goto mainmenu

:loaddirs
cd %output%
set /p fabletlc=<tlc.txt
set /p fableanni=<anni.txt
set /p fableexplorer=<explorerDIR.txt
echo Fable TLC dir: %fabletlc%
echo Fable Anniversary dir: %fableanni%
echo Fable Explorer dir: %fableexplorer%
echo Directories loaded!
echo Now choose which game to edit
pause
goto mainmenu

:: Create symlinks
:INSTALL
:: Remove previous data from the game folder
cd C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
rmdir /s /q data
:: TODO: Check the following redundant lines can be safely removed (rmdir is better than del for folders)
cd C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
del data
del data\CompiledDefs
del data\graphics
del data\graphics\pc
del data\lang\English
del data\Levels
del data\Misc\pc
:: TODO: The following lines are incorrect, they try to remove files from set and native game folders
:: Check if they can be safely removed or consider spliting them because del takes one argument
del "data\graphics\graphics.big" "%fabletlc%\data\graphics\graphics.big"
del "data\graphics\pc\frontend.big" "%fabletlc%\data\graphics\pc\frontend.big"
del "data\graphics\pc\textures.big" "%fabletlc%\data\graphics\pc\textures.big"
del "data\lang\English\text.big" "%fabletlc%\data\lang\English\text.big"
del "data\Levels\FinalAlbion_RT.stb" "%fabletlc%\data\Levels\FinalAlbion_RT.stb"
del "data\Levels\FinalAlbion.wad" "%fabletlc%\data\Levels\FinalAlbion.wad"
del "data\Levels\FinalAlbion" "%fabletlc%\data\Levels\FinalAlbion"
del "data\Misc\pc\effects.big" "%fabletlc%\data\Misc\pc\effects.big"
del "Fable.exe" "%fabletlc%\Fable.exe"
del "user.ini" "%fabletlc%\user.ini"
del "userst.ini" "%fabletlc%\userst.ini"
del "data\Levels\creature_hub.lev" "%fabletlc%\data\Levels\creature_hub.lev"
del "data\Levels\creature_hub.tng" "%fabletlc%\data\Levels\creature_hub.tng"
:: This line looks fine
del Fable.exe
echo.Symlinks removed
:: Recreate a full tree to make Symlinks
mkdir data
mkdir data\CompiledDefs
mkdir data\graphics
mkdir data\graphics\pc
mkdir data\lang\English
mkdir data\Levels
mkdir data\Misc\pc
:: Make symlinks to Fable TLC
mklink "data\graphics\graphics.big" "%fabletlc%\data\graphics\graphics.big"
mklink "data\graphics\pc\frontend.big" "%fabletlc%\data\graphics\pc\frontend.big"
mklink "data\graphics\pc\textures.big" "%fabletlc%\data\graphics\pc\textures.big"
mklink "data\lang\English\text.big" "%fabletlc%\data\lang\English\text.big"
mklink "data\Levels\FinalAlbion_RT.stb" "%fabletlc%\data\Levels\FinalAlbion_RT.stb"
mklink "data\Levels\FinalAlbion.wad" "%fabletlc%\data\Levels\FinalAlbion.wad"
mklink "data\Levels\FinalAlbion" "%fabletlc%\data\Levels\FinalAlbion"
mklink "data\Misc\pc\effects.big" "%fabletlc%\data\Misc\pc\effects.big"
mklink "Fable.exe" "%fabletlc%\Fable.exe"
mklink "user.ini" "%fabletlc%\user.ini"
mklink "userst.ini" "%fabletlc%\userst.ini"
mklink "data\Levels\creature_hub.lev" "%fabletlc%\data\Levels\creature_hub.lev"
mklink "data\Levels\creature_hub.tng" "%fabletlc%\data\Levels\creature_hub.tng"
echo.Symlinks installed
pause
GOTO MAINMENU

:: Remove all symlinks
:REMOVE
rmdir /s /q data
:: TODO: This line should be above the previous one, check if it can be safely moved
cd C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
:: TODO: Same as remarks as done in :INSTALL
del data
del data\CompiledDefs
del data\graphics
del data\graphics\pc
del data\lang\English
del data\Levels
del data\Misc\pc
del "data\graphics\graphics.big" "%fabletlc%\data\graphics\graphics.big"
del "data\graphics\pc\frontend.big" "%fabletlc%\data\graphics\pc\frontend.big"
del "data\graphics\pc\textures.big" "%fabletlc%\data\graphics\pc\textures.big"
del "data\lang\English\text.big" "%fabletlc%\data\lang\English\text.big"
del "data\Levels\FinalAlbion_RT.stb" "%fabletlc%\data\Levels\FinalAlbion_RT.stb"
del "data\Levels\FinalAlbion.wad" "%fabletlc%\data\Levels\FinalAlbion.wad"
del "data\Levels\FinalAlbion" "%fabletlc%\data\Levels\FinalAlbion"
del "data\Misc\pc\effects.big" "%fabletlc%\data\Misc\pc\effects.big"
del "Fable.exe" "%fabletlc%\Fable.exe"
del "user.ini" "%fabletlc%\user.ini"
del "userst.ini" "%fabletlc%\userst.ini"
del "data\Levels\creature_hub.lev" "%fabletlc%\data\Levels\creature_hub.lev"
del "data\Levels\creature_hub.tng" "%fabletlc%\data\Levels\creature_hub.tng"
:: This line looks fine
del Fable.exe
echo.Symlinks removed
pause
GOTO MAINMENU

:: Make symlinks of compiled files for Fable TLC (mainly used to update the version of Fable)
:TLC
:: Remove previously symlinks of compiled files
del /q data\CompiledDefs\*
:: Make symlinks of compiled files to Fable TLC
mklink "user.ini" "%fabletlc%\user.ini"
mklink "userst.ini" "%fabletlc%\userst.ini"
mklink "data\CompiledDefs\frontend.bin" "%fabletlc%\data\CompiledDefs\frontend.bin"
mklink "data\CompiledDefs\game.bin" "%fabletlc%\data\CompiledDefs\game.bin"
mklink "data\CompiledDefs\names.bin" "%fabletlc%\data\CompiledDefs\names.bin"
mklink "data\CompiledDefs\script.bin" "%fabletlc%\data\CompiledDefs\script.bin"
mklink "data\Levels\FinalAlbion.bwd" "%fabletlc%\data\Levels\FinalAlbion.bwd"
mklink "data\Levels\FinalAlbion.gtg" "%fabletlc%\data\Levels\FinalAlbion.gtg"
mklink "data\Levels\FinalAlbion.wad" "%fabletlc%\data\Levels\FinalAlbion.wad"
mklink "data\Levels\FinalAlbion.wld" "%fabletlc%\data\Levels\FinalAlbion.wld"
mklink "data\Levels\FinalAlbion" "%fabletlc%\data\Levels\FinalAlbion"
echo.Set up to edit TLC
pause
GOTO MAINMENU

:: Make symlinks of compiled files for the Easy game mode of Fable TLC
:CHICKEN
:: Remove all compiled files
del /q data\CompiledDefs\*
del /q data\Levels\*
:: Make symlinks of compiled files to Fable TLC
mklink "user.ini" "%fabletlc%\user.ini"
mklink "userst.ini" "%fabletlc%\userst.ini"
mklink "data\CompiledDefs\frontend.bin" "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\frontend.bin"
mklink "data\CompiledDefs\game.bin" "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\game.bin"
mklink "data\CompiledDefs\names.bin" "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\names.bin"
mklink "data\CompiledDefs\script.bin" "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\script.bin"
mklink "data\Levels" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels"
mklink "data\Levels\FinalAlbion" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion"
mklink "data\Levels\creature_hub.lev" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\creature_hub.lev"
mklink "data\Levels\creature_hub.tng" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\creature_hub.tng"
mklink "data\Levels\FinalAlbion.bwd" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.bwd"
mklink "data\Levels\FinalAlbion.gtg" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.gtg"
mklink "data\Levels\FinalAlbion.wad" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.wad"
mklink "data\Levels\FinalAlbion.wld" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.wld"
echo.Set up to edit Chicken Difficulty
pause
GOTO MAINMENU

:: Make symlinks of compiled files for the Hard game mode of Fable TLC
:HEROIC
:: Remove all compiled files
del /q data\CompiledDefs\*
del /q data\Levels\*
:: Make symlinks of compiled files to Fable TLC
mklink "user.ini" "%fabletlc%\user.ini"
mklink "userst.ini" "%fabletlc%\userst.ini"
mklink "data\CompiledDefs\frontend.bin" "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\frontend.bin"
mklink "data\CompiledDefs\game.bin" "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\gamehard.bin"
mklink "data\CompiledDefs\names.bin" "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\names.bin"
mklink "data\CompiledDefs\script.bin" "%fableanni%\WellingtonGame\FableData\Build\Data\CompiledDefs\Development\scripthard.bin"
mklink "data\Levels\FinalAlbion" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion"
mklink "data\Levels\FinalAlbion.bwd" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.bwd"
mklink "data\Levels\FinalAlbion.gtg" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.gtg"
mklink "data\Levels\FinalAlbion.wad" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.wad"
mklink "data\Levels\FinalAlbion.wld" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\FinalAlbion.wld"
mklink "data\Levels\creature_hub.lev" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\creature_hub.lev"
mklink "data\Levels\creature_hub.tng" "%fableanni%\WellingtonGame\FableData\Build\Data\Levels\creature_hub.tng"
echo.Set up to edit Heroic Difficulty
pause
GOTO MAINMENU

:: Close the script
:QUIT
exit

:: Rename the base game folder by "Fable - TLC" to keep a backup of the game folder
:rename
cd C:\Program Files (x86)\Microsoft Games
:: Rename the folder
rename "Fable - The Lost Chapters" "Fable - TLC"
:: Recreate an empty game folder from Fable TLC to make symlinks later
mkdir "C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters"
pause
goto mainmenu

:: Launch Fable Explorer
:LAUNCH
@echo off
cd %fableexplorer%
echo %output%
echo %fableexplorer%
echo %cd%
pause
start FableExplorer.exe
exit

:: Launch ChocolateBox
:LAUNCHCBOX
@echo off
cd %fableexplorer%
copy "%fableexplorer%\default_xuserst.ini" "%fableanni%\WellingtonGame\FableData\Build"
start ChocolateBox-x64.exe
exit

:: Set paths to Fable games or the Fable Explorer tool
:SETDIR
cd %output%
mode con: cols=90 lines=15
echo.
echo.	Set Directory
echo.	---------------------
echo.	1.) Fable TLC
echo.	2.) Fable Anniversary
echo.	3.) Fable Explorer
:: label to loop again in case the user does not type a supposed choice
:: TODO: Unused, consider fixing the menu below to loop on it
:choice1
set /p userinp=    ^   Make your selection:
:: Get user input but keep the first char only
set userinp=%userinp:~0,1%
if /i "%userinp%"=="1" goto ftlcSETDIR
if /i "%userinp%"=="2" goto faSETDIR
if /i "%userinp%"=="3" goto feSETDIR
echo.Try Again...
pause
GOTO mainmenu

:: Choose an option to set directory for Fable TLC
:ftlcSETDIR
mode con: cols=90 lines=15
echo	Where is Fable TLC located? Current location: %fabletlc%
echo.	---------------------
echo.	1.) Custom
echo.	2.) Microsoft Games (incompatible with this script)
echo.	3.) Microsoft Games\Fable - TLC (Renamed TLC folder) (if you input 7 at the main menu)
:: Get user input but keep the first char only
set /p userinp=    ^   Make your selection:
set userinp=%userinp:~0,1%
if /i "%userinp%"=="1" goto customdir1
if /i "%userinp%"=="2" goto micdir
if /i "%userinp%"=="3" goto renamedtlcdir
echo.Try Again...
goto ftlcSETDIR

:: Automatically set the directory to the renamed one of Fable TLC at option 7 of main menu
:renamedtlcdir
SET fabletlc=C:\Program Files (x86)\Microsoft Games\Fable - TLC
del %Output%\tlc.txt
echo %fabletlc%>%Output%\tlc.txt
echo saved to text file: %output% (loadable in main menu)
echo Fable TLC directory set to %fabletlc%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu

:: Automatically set the directory to the base game Fable TLC from CD ROM
:micdir
SET fabletlc=C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
del %Output%\tlc.txt
echo %fabletlc%>%Output%\tlc.txt
echo saved to text file: %output% (loadable in main menu)
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu

:: Manually set the directory of Fable TLC to a non-native one (ex: using "D:/" instead of "C:/")
:customdir1
:: Wait for user input to get a game path to save
echo paste in exact directory without backslash at the end.
echo Example 1: C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
echo Example 2: C:\Games
SET /P fabletlc= Please enter an input:
:: Save the input path using "Output"
del %Output%\tlc.txt
echo %fabletlc%>%Output%\tlc.txt
echo saved to text file: %output% (loadable in main menu)
echo Fable TLC directory set to %fabletlc%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu

:: Choose an option to set directory for Fable Anniversary
:faSETDIR
mode con: cols=90 lines=15
echo	Where is Fable Anniversary located? Current location: %fableanni%
echo.	---------------------
echo.	1.) Custom
echo.	2.) Steam
:: Get user input but keep the first char only
set /p userinp=    ^   Make your selection:
set userinp=%userinp:~0,1%
if /i "%userinp%"=="1" goto customdir
if /i "%userinp%"=="2" goto steamdir
echo.Try Again...
goto faSETDIR

:: Automatically set the directory to the base game Fable Anniversary from Steam
:steamdir
SET fableanni=C:\Program Files (x86)\Steam\steamapps\common\Fable Anniversary
del %Output%\anni.txt
echo %fableanni%>%Output%\anni.txt
echo saved to text file: %output% (loadable in main menu)
echo Fable Anniversary directory set to %fableanni%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu

:: Manually set the directory of Fable Anniversary to a non-native one (ex: using "D:/" instead of "C:/")
:customdir
:: Wait for user input to get a game path to save
SET /P fableanni= Please enter an input:
:: Save the input path using "Output"
del %Output%\anni.txt
echo %fableanni%>%Output%\anni.txt
echo saved to text file: %output% (loadable in main menu)
echo Fable Anniversary directory set to %fableanni%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu

:: Choose an option to set directory for Fable Explorer
:feSETDIR
mode con: cols=90 lines=15
echo	Where is Fable Explorer located? Current location: %fableexplorer%
echo	Only set this directory if you want to launch FE from MS-DOS (cmd) (this script)
echo	Tip: Right click the application and open file location to reveal directory. Should start with C:\ and end without a backslash
echo.	---------------------
echo.	1.) Custom
echo.	2.) C:\Program Files (x86)\FableTLCMod\FableExplorer
echo.	3.) C:\Program Files (x86)\FableTLCMod\ShadowNet
:: Get user input but keep the first char only
set /p userinp=    ^   Make your selection:
set userinp=%userinp:~0,1%
if /i "%userinp%"=="1" goto customdir2
if /i "%userinp%"=="2" goto fedir
if /i "%userinp%"=="3" goto shadownetdir
echo.Try Again...
goto ftlcSETDIR

:: Automatically set the directory to the base path of Fable Explorer
:fedir
SET fableexplorer=C:\Program Files (x86)\FableTLCMod\FableExplorer
del %Output%\explorerDIR.txt
echo %fableexplorer%>%Output%\explorerDIR.txt
echo saved to text file: %output% (loadable in main menu)
echo Set directory: %fableexplorer%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu

:: Automatically set the directory to the base path of ShadowNet
:shadownetdir
SET fableexplorer=C:\Program Files (x86)\FableTLCMod\ShadowNet
del %Output%\explorerDIR.txt
echo %fableexplorer%>%Output%\explorerDIR.txt
echo saved to text file: %output% (loadable in main menu)
echo Set directory: %fableexplorer%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu

:: Manually set the directory of Fable Explorer to a non-native one (ex: using "D:/" instead of "C:/")
:customdir2
:: Wait for user input to get a game path to save
echo paste in exact directory without backslash at the end.
echo Example: C:\Program Files (x86)\FableTLCMod\FableExplorer
SET /P fableexplorer= Please enter an input:
:: Save the input path using "Output"
del %Output%\explorerDIR.txt
echo %fableexplorer%>%Output%\explorerDIR.txt
echo saved to text file: %output% (loadable in main menu)
echo Set directory: %fableexplorer%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu
