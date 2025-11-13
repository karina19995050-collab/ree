@echo off
echo Установка Chrome как браузера по умолчанию для HTML файлов...
echo.

REM Запуск PowerShell скрипта
powershell.exe -ExecutionPolicy Bypass -File "%~dp0set_chrome_default.ps1"

pause

