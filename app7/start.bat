@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   Запуск приложения "Бросить курить"
echo ========================================
echo.

REM Поиск Chrome в стандартных местах установки
set CHROME_PATH=

REM Проверка стандартных путей установки Chrome
echo Поиск Google Chrome...

if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
    set CHROME_PATH=C:\Program Files\Google\Chrome\Application\chrome.exe
    echo [OK] Chrome найден: C:\Program Files\Google\Chrome\Application\
    goto :found
)

if exist "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" (
    set CHROME_PATH=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
    echo [OK] Chrome найден: C:\Program Files (x86)\Google\Chrome\Application\
    goto :found
)

if exist "%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe" (
    set CHROME_PATH=%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe
    echo [OK] Chrome найден: %LOCALAPPDATA%\Google\Chrome\Application\
    goto :found
)

REM Поиск через реестр
echo Поиск Chrome в реестре...
for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" /ve 2^>nul') do (
    if exist "%%b" (
        set CHROME_PATH=%%b
        echo [OK] Chrome найден через реестр: %%b
        goto :found
    )
)

for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" /ve 2^>nul') do (
    if exist "%%b" (
        set CHROME_PATH=%%b
        echo [OK] Chrome найден через реестр: %%b
        goto :found
    )
)

REM Попытка найти через where команду
where chrome.exe >nul 2>&1
if %errorlevel% == 0 (
    for /f "delims=" %%i in ('where chrome.exe') do (
        if exist "%%i" (
            set CHROME_PATH=%%i
            echo [OK] Chrome найден через PATH: %%i
            goto :found
        )
    )
)

REM Если Chrome не найден
echo.
echo [ОШИБКА] Google Chrome не найден!
echo.
echo Пожалуйста, убедитесь, что Google Chrome установлен.
echo Или укажите путь к Chrome вручную.
echo.
pause
exit /b 1

:found
echo.
echo Открываю приложение в Chrome...
echo.

REM Получаем полный путь к index.html
set "HTML_FILE=%~dp0index.html"

REM Проверяем существование файла
if not exist "!HTML_FILE!" (
    echo [ОШИБКА] Файл index.html не найден!
    echo Ожидаемый путь: !HTML_FILE!
    echo.
    pause
    exit /b 1
)

REM Открываем в Chrome
start "" "!CHROME_PATH!" "!HTML_FILE!"

REM Небольшая задержка для проверки успешности запуска
timeout /t 1 /nobreak >nul

if %errorlevel% == 0 (
    echo [OK] Приложение успешно открыто в Chrome!
    echo.
    echo Закройте это окно или нажмите любую клавишу для выхода...
    pause >nul
) else (
    echo [ОШИБКА] Не удалось открыть приложение.
    pause
)

endlocal

