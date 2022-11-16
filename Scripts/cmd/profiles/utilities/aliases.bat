@echo off
  echo.
  for /f "tokens=1,* delims= " %%a in ("%*") do set ALL_BUT_FIRST=%%b
  echo @echo off > %~dp0\%1.bat
  echo echo. >> %~dp0\%1.bat
  echo %ALL_BUT_FIRST% %%* >> %~dp0\%1.bat
  echo Created alias for %1=%ALL_BUT_FIRST%

REM This bat script will create an alias for the command you specify.
REM For example, if you want to create an alias for the command "dir", you would type:
REM   alias ls dir
REM or another example, if you want to create an alias for the command "dir /s", you would type:
REM   alias ls -l dir /s