@echo off
  echo.
  for /f "tokens=1,* delims= " %%a in ("%*") do set ALL_BUT_FIRST=%%b
  echo @echo off > %~dp0\%1.bat
  echo echo. >> %~dp0\%1.bat
  echo %ALL_BUT_FIRST% %%* >> %~dp0\%1.bat
  echo Created alias for %1=%ALL_BUT_FIRST%
