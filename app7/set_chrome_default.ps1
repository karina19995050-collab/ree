# Скрипт для установки Chrome как браузера по умолчанию для HTML файлов

Write-Host "Поиск Google Chrome..." -ForegroundColor Yellow

# Поиск Chrome в стандартных местах
$chromePaths = @(
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
)

$chromePath = $null
foreach ($path in $chromePaths) {
    if (Test-Path $path) {
        $chromePath = $path
        Write-Host "Chrome найден: $chromePath" -ForegroundColor Green
        break
    }
}

if (-not $chromePath) {
    Write-Host "ОШИБКА: Google Chrome не найден!" -ForegroundColor Red
    Write-Host "Пожалуйста, установите Google Chrome и запустите скрипт снова." -ForegroundColor Red
    pause
    exit
}

Write-Host "`nУстановка Chrome как браузера по умолчанию для HTML файлов..." -ForegroundColor Yellow

# Установка ассоциации для .html
$regPath = "HKCU:\Software\Classes\.html"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "(default)" -Value "ChromeHTML" -Force
Set-ItemProperty -Path $regPath -Name "Content Type" -Value "text/html" -Force
Set-ItemProperty -Path $regPath -Name "PerceivedType" -Value "text" -Force

# Установка ассоциации для .htm
$regPath = "HKCU:\Software\Classes\.htm"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "(default)" -Value "ChromeHTML" -Force
Set-ItemProperty -Path $regPath -Name "Content Type" -Value "text/html" -Force
Set-ItemProperty -Path $regPath -Name "PerceivedType" -Value "text" -Force

# Создание записи ChromeHTML
$regPath = "HKCU:\Software\Classes\ChromeHTML"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "(default)" -Value "Chrome HTML Document" -Force

# Иконка
$regPath = "HKCU:\Software\Classes\ChromeHTML\DefaultIcon"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "(default)" -Value "$chromePath,0" -Force

# Команда открытия
$regPath = "HKCU:\Software\Classes\ChromeHTML\shell\open\command"
if (-not (Test-Path "HKCU:\Software\Classes\ChromeHTML\shell")) {
    New-Item -Path "HKCU:\Software\Classes\ChromeHTML\shell" -Force | Out-Null
}
if (-not (Test-Path "HKCU:\Software\Classes\ChromeHTML\shell\open")) {
    New-Item -Path "HKCU:\Software\Classes\ChromeHTML\shell\open" -Force | Out-Null
}
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
Set-ItemProperty -Path $regPath -Name "(default)" -Value "`"$chromePath`" `"%1`"" -Force

Write-Host "`nГотово! Chrome установлен как браузер по умолчанию для HTML файлов." -ForegroundColor Green
Write-Host "Теперь HTML файлы будут открываться в Chrome и отображаться как 'Chrome HTML Document'" -ForegroundColor Green
Write-Host "`nНажмите любую клавишу для выхода..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

