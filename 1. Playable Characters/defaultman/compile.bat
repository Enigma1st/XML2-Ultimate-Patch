@echo off
echo Compiling defaultman

REM ***********************************
REM * Section 1 - Establish Variables *
REM ***********************************

REM get console choice from main compiler script
set "consoleChoice=%~1"
goto :consoleChoiceCheck
REM console not selected, main compiler prompt not used, pick console
:consoleChoicePrompt
echo.
echo Console not selected.
echo [1] PC
echo [2] GameCube
echo [3] PlayStation 2
echo [4] PlayStation Portable (PSP)
echo [5] Xbox
CHOICE /C 12345 /M "Which console are you using? "
IF ERRORLEVEL 5 SET consoleChoice=XB & goto :section2
IF ERRORLEVEL 4 SET consoleChoice=PSP & goto :section2
IF ERRORLEVEL 3 SET consoleChoice=PS2 & goto :section2
IF ERRORLEVEL 2 SET consoleChoice=GC & goto :section2
IF ERRORLEVEL 1	SET consoleChoice=PC & goto :section2
REM Checks if console was selected from main compiler script/if main compiler script was used
:consoleChoiceCheck
if "%consoleChoice%"=="" goto :consoleChoicePrompt

REM ***************************
REM * Section 2 - Move Assets *
REM ***************************

:section2
REM Begin compiling assets
echo Compiling assets...
md "0. Staging"
robocopy >nul /e /v "1. Base Assets" "0. Staging"
REM proceed based on console selection
if %consoleChoice%==PC goto :movePC
if %consoleChoice%==GC goto :compileConsole
if %consoleChoice%==PS2 goto :compileConsole
if %consoleChoice%==PSP goto :movePSP
if %consoleChoice%==XB goto :compileConsole

REM PC options
:movePC
robocopy >nul /e /v "2. Default Assets - PC" "0. Staging"
goto :compilePC

REM PSP options
:movePSP
robocopy >nul /e /v "2. Default Assets - PSP" "0. Staging"
goto :compileConsole

REM ******************************
REM * Section 3 - Compile Assets *
REM ******************************

:compileConsole
REM can remove unneeded folders
rmdir /s /q "0. Staging\1. Data Entries"
copy >nul "..\..\0. Compilers" "0. Staging"
REM change directory to 0. Staging folder, run fbbuilder, then change back to main directory
cd "%~dp0\0. Staging"
call fbbuilder.bat
del >nul *.cfg
del >nul enter.vbs
del >nul fbbuilder.bat
md "packages\generated\characters"
for /r %%x in (*.fb) do move >nul "%%x" "packages\generated\characters"
cd ..

REM move files and clean up
robocopy >nul /e /v "0. Staging" "..\..\0. Ready Files\assetsfb Files"
rmdir /s /q "0. Staging"

goto :end

:compilePC
REM can remove unneeded folders
rmdir /s /q "0. Staging\1. Data Entries"
REM copy compilers
copy >nul "..\..\0. Compilers" "0. Staging"
REM change directory to 0. Staging folder and execute scripts
cd "%~dp0\0. Staging"
cmd /c ravenFormatsCompile.bat
del /s >nul *.json
REM clean up extra stuff
del >nul *.cfg
del >nul enter.vbs
del >nul fbbuilder.bat
del >nul ravenFormatsCompile.bat
REM move back to the main folder
cd ..

REM move files and clean up
robocopy >nul /e /v "0. Staging" "..\..\0. Ready Files"
rmdir /s /q "0. Staging"

goto :end

:end
echo Transfer Complete