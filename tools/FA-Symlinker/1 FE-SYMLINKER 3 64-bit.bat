set FEman=
@echo off
SET fableexplorer=%cd%
del %Output%\explorerDIR.txt
echo %fableexplorer%>%Output%\explorerDIR.txt
@color 0c
title Waiting for admin privileges...
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
echo. Waiting for admin privileges...
@echo off
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
cls
cd C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
@echo off
mkdir %USERPROFILE%\Documents\FEMan
mkdir %USERPROFILE%\Documents\FEMan\Directories
cls
set Output="%USERPROFILE%\Documents\FEMan\Directories"
goto autoloaddirs

:MAINMENU
mkdir "C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters"
clear
cd C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
@echo off
@color 0a
title FEMan 64-bit
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

:currentdir
echo Fable TLC: %fabletlc%
echo Fable Anniversary: %fableanni%
echo Fable Explorer: %fableexplorer%
pause
goto mainmenu

cd %feman%
:delall
rmdir /s /q data
del Fable.exe
cd %output%
del "%output%"
echo.All files removed
pause
goto mainmenu

:defdirs
set fabletlc= C:\Program Files (x86)\Microsoft Games\Fable - TLC
set fableanni= C:\Program Files (x86)\Steam\steamapps\common\Fable Anniversary
set fableexplorer=
goto mainmenu

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

:INSTALL
cd C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
rmdir /s /q data
cd C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
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
del Fable.exe
echo.Symlinks removed
mkdir data
mkdir data\CompiledDefs
mkdir data\graphics
mkdir data\graphics\pc
mkdir data\lang\English
mkdir data\Levels
mkdir data\Misc\pc
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

:REMOVE
rmdir /s /q data
cd C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
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
del Fable.exe
echo.Symlinks removed
pause
GOTO MAINMENU

:TLC
del /q data\CompiledDefs\*
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

:CHICKEN
del /q data\CompiledDefs\*
del /q data\Levels\*
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

:HEROIC
del /q data\CompiledDefs\*
del /q data\Levels\*
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

:QUIT
exit

:rename
cd C:\Program Files (x86)\Microsoft Games
rename "Fable - The Lost Chapters" "Fable - TLC"
mkdir "C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters"
pause
goto mainmenu

:LAUNCH
@echo off
cd %fableexplorer%
start FableExplorer.exe
exit

:LAUNCHCBOX
@echo off
cd %fableexplorer%
copy "%fableexplorer%\default_xuserst.ini" "%fableanni%\WellingtonGame\FableData\Build"
start ChocolateBox-x64.exe
exit

:SETDIR
cd %output%
mode con: cols=90 lines=15
echo.  
echo.	Set Directory
echo.	---------------------
echo.	1.) Fable TLC
echo.	2.) Fable Anniversary
echo.	3.) Fable Explorer

:choice1
set /p userinp=    ^   Make your selection: 
set userinp=%userinp:~0,1%
if /i "%userinp%"=="1" goto ftlcSETDIR
if /i "%userinp%"=="2" goto faSETDIR
if /i "%userinp%"=="3" goto feSETDIR
echo.Try Again...
pause
GOTO mainmenu


:ftlcSETDIR
mode con: cols=90 lines=15
echo	Where is Fable TLC located? Current location: %fabletlc%
echo.	---------------------
echo.	1.) Custom
echo.	2.) Microsoft Games (incompatible with this script)
echo.	3.) Microsoft Games\Fable - TLC (Renamed TLC folder) (if you input 7 at the main menu)
set /p userinp=    ^   Make your selection: 
set userinp=%userinp:~0,1%
if /i "%userinp%"=="1" goto customdir1
if /i "%userinp%"=="2" goto micdir
if /i "%userinp%"=="3" goto renamedtlcdir
echo.Try Again...
goto ftlcSETDIR
:renamedtlcdir
SET fabletlc=C:\Program Files (x86)\Microsoft Games\Fable - TLC
del %Output%\tlc.txt
REM 
echo %fabletlc%>%Output%\tlc.txt
echo saved to text file: %output% (loadable in main menu)
echo Fable TLC directory set to %fabletlc%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu
:micdir
SET fabletlc=C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
del %Output%\tlc.txt
echo %fabletlc%>%Output%\tlc.txt
echo saved to text file: %output% (loadable in main menu)
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu
:customdir1
echo paste in exact directory without backslash at the end.
echo Example 1: C:\Program Files (x86)\Microsoft Games\Fable - The Lost Chapters
echo Example 2: C:\Games
SET /P fabletlc= Please enter an input: 
del %Output%\tlc.txt
echo %fabletlc%>%Output%\tlc.txt
echo saved to text file: %output% (loadable in main menu)
echo Fable TLC directory set to %fabletlc%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu

:faSETDIR
mode con: cols=90 lines=15
echo	Where is Fable Anniversary located? Current location: %fableanni%
echo.	---------------------
echo.	1.) Custom
echo.	2.) Steam 
set /p userinp=    ^   Make your selection: 
set userinp=%userinp:~0,1%
if /i "%userinp%"=="1" goto customdir
if /i "%userinp%"=="2" goto steamdir
echo.Try Again...
goto faSETDIR
:steamdir
SET fableanni=C:\Program Files (x86)\Steam\steamapps\common\Fable Anniversary
del %Output%\anni.txt
echo %fableanni%>%Output%\anni.txt
echo saved to text file: %output% (loadable in main menu)
echo Fable Anniversary directory set to %fableanni%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu
:customdir
SET /P fableanni= Please enter an input: 
del %Output%\anni.txt
echo %fableanni%>%Output%\anni.txt
echo saved to text file: %output% (loadable in main menu)
echo Fable Anniversary directory set to %fableanni%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu

:feSETDIR
mode con: cols=90 lines=15
echo	Where is Fable Explorer located? Current location: %fableexplorer%
echo	Only set this directory if you want to launch FE from MS-DOS (cmd) (this script)
echo	Tip: Right click the application and open file location to reveal directory. Should start with C:\ and end without a backslash
echo.	---------------------
echo.	1.) Custom
echo.	2.) C:\Program Files (x86)\FableTLCMod\FableExplorer
echo.	3.) C:\Program Files (x86)\FableTLCMod\ShadowNet
set /p userinp=    ^   Make your selection: 
set userinp=%userinp:~0,1%
if /i "%userinp%"=="1" goto customdir2
if /i "%userinp%"=="2" goto fedir
if /i "%userinp%"=="3" goto shadownetdir
echo.Try Again...
goto ftlcSETDIR
:fedir
SET fableexplorer=C:\Program Files (x86)\FableTLCMod\FableExplorer
del %Output%\explorerDIR.txt
echo %fableexplorer%>%Output%\explorerDIR.txt
echo saved to text file: %output% (loadable in main menu)
echo Set directory: %fableexplorer%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu
:shadownetdir
SET fableexplorer=C:\Program Files (x86)\FableTLCMod\ShadowNet
del %Output%\explorerDIR.txt
echo %fableexplorer%>%Output%\explorerDIR.txt
echo saved to text file: %output% (loadable in main menu)
echo Set directory: %fableexplorer%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu
:customdir2
echo paste in exact directory without backslash at the end.
echo Example: C:\Program Files (x86)\FableTLCMod\FableExplorer
SET /P fableexplorer= Please enter an input: 
del %Output%\explorerDIR.txt
echo %fableexplorer%>%Output%\explorerDIR.txt
echo saved to text file: %output% (loadable in main menu)
echo Set directory: %fableexplorer%
echo Now install symlinks (remove then install if necessary) and choose which game to edit.
pause
goto mainmenu