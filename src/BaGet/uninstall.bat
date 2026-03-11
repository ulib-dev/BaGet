@echo off
chcp 65001 >nul
setlocal

:: 請以系統管理員身分執行此腳本
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 請右鍵「以系統管理員身分執行」uninstall.bat
    pause
    exit /b 1
)

set "SVC_NAME=BaGet"

sc query "%SVC_NAME%" >nul 2>&1
if %errorLevel% neq 0 (
    echo 服務 "%SVC_NAME%" 不存在
    pause
    exit /b 0
)

echo 正在停止服務...
sc stop "%SVC_NAME%"
timeout /t 3 /nobreak >nul

echo 正在移除服務...
sc delete "%SVC_NAME%"
if %errorLevel% neq 0 (
    echo 移除失敗
    pause
    exit /b 1
)

echo 已解除安裝
pause
exit /b 0
