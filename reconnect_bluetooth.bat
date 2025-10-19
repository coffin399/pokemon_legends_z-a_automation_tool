@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

cls
echo.
echo ========================================
echo   Bluetooth再接続ヘルパー
echo ========================================
echo.

:: 保存されたBUSIDを読み込む
set "config_file=%~dp0.busid_config"
set "saved_busid="

if exist "%config_file%" (
    set /p saved_busid=<"%config_file%"
)

if defined saved_busid (
    echo 前回のBUSID: %saved_busid%
    echo.
    set /p use_saved="このBUSIDを使用しますか？ (Y/N): "

    if /i "!use_saved!"=="Y" (
        set "busid=!saved_busid!"
        goto attach
    )
)

echo.
echo まず、Bluetoothアダプタを確認します...
echo.
usbipd list
echo.
echo 上記のリストから、Bluetoothアダプタの「BUSID」を確認してください
echo 例: 2-3, 1-4 など
echo.
set /p busid="BUSIDを入力してください: "

:: BUSIDを保存
echo !busid!>"%config_file%"
echo.
echo [完了] BUSIDを保存しました（次回から自動入力されます）
echo.

:attach
echo Bluetoothアダプタをバインド中...
echo.

:: バインド
usbipd bind --busid %busid% >nul 2>&1

echo バインド完了。接続中...
timeout /t 2 >nul

:: アタッチ
usbipd attach --wsl --busid %busid%

if %errorlevel% equ 0 (
    echo.
    echo [完了] 接続コマンド実行完了
    echo.

    :: 接続待機（遅延追加）
    echo Bluetoothアダプタの初期化を待っています...
    timeout /t 5 >nul

    :: WSL内で確認
    echo Bluetooth状態を確認中...
    echo.
    wsl -d Ubuntu-22.04 -e bash -c "hciconfig 2>/dev/null"
    echo.

    wsl -d Ubuntu-22.04 -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'" >nul 2>&1
    if !errorlevel! equ 0 (
        echo [成功] Bluetooth接続OK
    ) else (
        echo [警告] Bluetooth接続を確認できませんでした
        echo.
        echo 手動で確認してください:
        echo   wsl -d Ubuntu-22.04
        echo   sudo service bluetooth restart
        echo   hciconfig
    )


) else (
    echo.
    echo [失敗] 接続に失敗しました
    echo.
    echo トラブルシューティング:
    echo 1. BUSIDが正しいか確認してください
    echo 2. PowerShellを管理者として実行していますか？
    echo 3. usbipd-winがインストールされていますか？
    echo.
    echo 手動で試す場合:
    echo   usbipd list
    echo   usbipd bind --busid %busid%
    echo   usbipd attach --wsl --busid %busid%
)

echo.
pause