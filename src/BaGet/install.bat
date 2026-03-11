@echo off
chcp 65001 >nul
setlocal

:: 請以系統管理員身分執行此腳本
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 請右鍵「以系統管理員身分執行」install.bat
    pause
    exit /b 1
)

set "SVC_NAME=BaGet"
set "EXE_PATH=%~dp0BaGet.exe"

if not exist "%EXE_PATH%" (
    echo 找不到 BaGet.exe，請在發佈輸出目錄執行此腳本。
    pause
    exit /b 1
)

:: 若已存在則先移除
sc query "%SVC_NAME%" >nul 2>&1
if %errorLevel% equ 0 (
    echo 服務已存在，正在停止並刪除...
    sc stop "%SVC_NAME%"
    timeout /t 3 /nobreak >nul
    sc delete "%SVC_NAME%"
    timeout /t 2 /nobreak >nul
)

echo 正在安裝服務...
sc create "%SVC_NAME%" binPath= "\"%EXE_PATH%\"" start= auto DisplayName= "BaGet NuGet Server"
if %errorLevel% neq 0 (
    echo 安裝失敗
    pause
    exit /b 1
)

echo 安裝完成。若要啟動請執行: net start BaGet
pause
exit /b 0
