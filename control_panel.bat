@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

:menu
cls
echo.
echo ========================================
echo   Switch マクロ コントロールパネル
echo ========================================
echo.

:: マクロ状態確認
wsl -d Ubuntu-22.04 -e bash -c "pgrep -f switch_macro.py > /dev/null" >nul 2>&1
if %errorlevel% equ 0 (
    echo 状態: マクロ実行中
) else (
    echo 状態: マクロ停止中
)

:: Bluetooth状態確認
wsl -d Ubuntu-22.04 -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'" >nul 2>&1
if %errorlevel% equ 0 (
    echo Bluetooth: 接続済み
) else (
    echo Bluetooth: 未接続
)

echo.
echo ========================================
echo.
echo [1] マクロ開始 (通常モード)
echo [2] マクロ停止
echo [3] Bluetooth再接続
echo [4] 接続テスト
echo [5] 状態確認
echo [0] 終了
echo.
echo ========================================
echo.

set /p choice="選択 (0-5): "

if "%choice%"=="1" goto start_macro
if "%choice%"=="2" goto stop_macro
if "%choice%"=="3" goto reconnect_bt
if "%choice%"=="4" goto test_connection
if "%choice%"=="5" goto menu
if "%choice%"=="0" goto end

echo 無効な選択です
timeout /t 2 >nul
goto menu

:start_macro
cls
echo.
echo ========================================
echo   マクロ開始
echo ========================================
echo.
echo Switchで「持ちかた/順番を変える」を開いてください
echo.
pause

echo マクロを起動中...
start "Switch Macro" wsl -d Ubuntu-22.04 -e bash -c "cd ~/switch-macro && sudo python3 src/switch_macro.py"
timeout /t 2 >nul
echo.
echo ? マクロを起動しました
echo    新しいウィンドウで実行中です
echo.
pause
goto menu

:stop_macro
cls
echo.
echo ========================================
echo   マクロ停止
echo ========================================
echo.
wsl -d Ubuntu-22.04 -e bash -c "sudo pkill -f switch_macro.py"
echo マクロを停止しました
echo.
pause
goto menu

:reconnect_bt
cls
echo.
echo ========================================
echo   Bluetooth再接続
echo ========================================
echo.

:: reconnect_bluetooth.batを呼び出し
if exist "reconnect_bluetooth.bat" (
    call reconnect_bluetooth.bat
) else (
    echo reconnect_bluetooth.bat が見つかりません
    echo.
    echo 手動で再接続してください:
    echo   1. PowerShell（管理者）を開く
    echo   2. usbipd attach --wsl --busid [BUSID]
)
echo.
pause
goto menu

:test_connection
cls
echo.
echo ========================================
echo   接続テスト
echo ========================================
echo.

echo [1/3] Bluetooth確認...
wsl -d Ubuntu-22.04 -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ? Bluetooth OK
) else (
    echo   ? Bluetooth NG - 再接続が必要です
)

echo [2/3] NXBT確認...
wsl -d Ubuntu-22.04 -e bash -c "which nxbt" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ? NXBT OK
) else (
    echo   ? NXBT NG - 再インストールが必要です
)

echo [3/3] マクロファイル確認...
wsl -d Ubuntu-22.04 -e bash -c "test -f ~/switch-macro/src/switch_macro.py" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ? マクロファイル OK
) else (
    echo   ? マクロファイル NG - ファイルが見つかりません
)

echo.
echo テスト完了
pause
goto menu

:end
echo.
echo 終了します
exit /b 0