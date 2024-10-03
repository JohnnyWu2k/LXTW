@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM Define fixed input and output directory names
SET "INPUT_DIR=input"
SET "OUTPUT_DIR=output"

REM Get the directory where the script is located
SET "SCRIPT_DIR=%~dp0"

REM Define full paths for input and output directories
SET "FULL_INPUT=%SCRIPT_DIR%%INPUT_DIR%"
SET "FULL_OUTPUT=%SCRIPT_DIR%%OUTPUT_DIR%"

REM Check if input directory exists
IF NOT EXIST "%FULL_INPUT%" (
    ECHO Error: Input directory does not exist - %FULL_INPUT%
    PAUSE
    EXIT /B 1
)

REM Create output directory if it does not exist
IF NOT EXIST "%FULL_OUTPUT%" (
    MKDIR "%FULL_OUTPUT%"
    ECHO Created output directory: %FULL_OUTPUT%
)

REM Traverse all .tex files in the input directory and its subdirectories
FOR /R "%FULL_INPUT%" %%F IN (*.tex) DO (
    REM Get relative path by removing the input directory path
    SET "REL_PATH=%%F"
    SET "REL_PATH=!REL_PATH:%FULL_INPUT%\=!"

    REM Construct the output file path by replacing .tex with .docx
    SET "OUT_FILE=%FULL_OUTPUT%\!REL_PATH!"
    SET "OUT_FILE=!OUT_FILE:.tex=.docx!"

    REM Get the output file's directory
    SET "OUT_DIR=!OUT_FILE!\.."

    REM Create the output directory if it does not exist
    IF NOT EXIST "!OUT_DIR!" (
        MKDIR "!OUT_DIR!"
        ECHO Created directory: !OUT_DIR!
    )

    REM Execute Pandoc conversion
    ECHO Converting: %%F -> !OUT_FILE!
    pandoc "%%F" -s -o "!OUT_FILE!"
    IF ERRORLEVEL 1 (
        ECHO Conversion failed: %%F
    ) ELSE (
        ECHO Conversion successful: !OUT_FILE!
    )
)

ECHO All conversions completed!
PAUSE
ENDLOCAL
