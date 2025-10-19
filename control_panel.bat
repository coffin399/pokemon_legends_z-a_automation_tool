@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

:: --- 設定 ---
set WSL_DISTRO_NAME=Ubuntu-22.04
set "config_file=%~dp0.busid_config"

:menu
cls
echo.
echo ========================================
echo   Nintendo Switch マクロ コントロールパネル
echo ========================================
echo.

:: マクロ状態確認
wsl -d %WSL_DISTRO_NAME% -e bash -c "pgrep -f switch_macro.py > /dev/null" >nul 2>&1
if %errorlevel% equ 0 (
    echo 状態: [実行中] マクロ実行中
) else (
    echo 状態: [停止中] マクロ停止中
)

:: Bluetooth状態確認
wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'" >nul 2>&1
if %errorlevel% equ 0 (
    echo Bluetooth: [接続済] 接続済み
) else (
    echo Bluetooth: [未接続] 未接続
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
start "Switch Macro" wsl -d %WSL_DISTRO_NAME% -e bash -c "cd ~/switch-macro && sudo python3 src/switch_macro.py"
timeout /t 2 >nul
echo.
echo [完了] マクロを起動しました
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
wsl -d %WSL_DISTRO_NAME% -e bash -c "sudo pkill -f switch_macro.py"
echo [完了] マクロを停止しました
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

:: BUSID設定の読み込み
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
        goto do_bind
    )
)

echo.
echo 利用可能なUSBデバイスを確認します...
echo.
usbipd list
echo.
echo 上記リストから、Bluetoothアダプタの「BUSID」を確認してください。
echo 例: 2-3, 1-4 など
echo.
set /p busid="BUSIDを入力してください: "

:: BUSIDを保存
echo !busid!>"%config_file%"
echo.
echo [完了] BUSIDを保存しました
echo.

:do_bind
echo ----------------------------------------
echo [%busid%] Bluetoothアダプタをバインド中...
echo.

:: 既にShared状態かチェック
usbipd bind --busid %busid% 2>&1 | findstr /C:"already shared" >nul
if %errorlevel% equ 0 (
    echo [情報] デバイスは既にShared状態です。
    goto do_attach
)

:: バインド実行
usbipd bind --busid %busid% >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] バインドに失敗しました。強制バインドを試します...
    usbipd bind --busid %busid% --force >nul 2>&1
    if !errorlevel! neq 0 (
        echo [失敗] 強制バインドも失敗しました。
        echo.
        echo トラブルシューティング:
        echo 1. BUSIDが正しいか確認してください
        echo 2. 管理者権限で実行していますか？
        echo.
        pause
        goto menu
    )
)

echo バインド完了。

:do_attach
timeout /t 2 >nul
echo WSLに接続中...
echo.

:: アタッチ実行
usbipd attach --wsl --busid %busid%

if %errorlevel% equ 0 (
    echo.
    echo [完了] 接続コマンドを実行しました
    echo.

    :: 初期化待機
    echo Bluetoothアダプタの初期化中... (5秒)
    timeout /t 5 >nul

    :: 状態確認（UTF-8をShift-JISに変換）
    echo Bluetooth状態を確認中...
    echo.
    echo --- hciconfig の実行結果 ---
    wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | iconv -f UTF-8 -t SHIFT_JIS//TRANSLIT"
    echo ---------------------------
    echo.

    wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'"
    if !errorlevel! equ 0 (
        echo [成功] Bluetooth接続が有効になりました！
    ) else (
        echo [警告] Bluetooth接続を確認できませんでした
        echo.
        echo 手動で以下を試してください:
        echo   wsl -d %WSL_DISTRO_NAME%
        echo   sudo service dbus start
        echo   sudo service bluetooth start
        echo   hciconfig hci0 up
    )
) else (
    echo.
    echo [失敗] WSLへの接続に失敗しました
    echo.
    echo トラブルシューティング:
    echo 1. WSL2が起動していますか？
    echo 2. usbipd-winがインストールされていますか？
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

echo [1/4] WSL接続確認...
wsl -d %WSL_DISTRO_NAME% -e bash -c "echo 'OK'" >nul 2>&1
if %errorlevel% equ 0 (
    echo   [OK] WSL接続 OK
) else (
    echo   [NG] WSL接続 NG - WSLが起動していません
)

echo [2/4] Bluetooth確認...
wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'" >nul 2>&1
if %errorlevel% equ 0 (
    echo   [OK] Bluetooth OK

    :: Bluetoothの詳細情報（Shift-JIS変換）
    wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | head -n 2 | iconv -f UTF-8 -t SHIFT_JIS//TRANSLIT" 2>nul
) else (
    echo   [NG] Bluetooth NG - 再接続が必要です
)

echo [3/4] NXBT確認...
wsl -d %WSL_DISTRO_NAME% -e bash -c "which nxbt" >nul 2>&1
if %errorlevel% equ 0 (
    echo   [OK] NXBT OK
) else (
    echo   [NG] NXBT NG - 再インストールが必要です
)

echo [4/4] マクロファイル確認...
wsl -d %WSL_DISTRO_NAME% -e bash -c "test -f ~/switch-macro/src/switch_macro.py" >nul 2>&1
if %errorlevel% equ 0 (
    echo   [OK] マクロファイル OK
) else (
    echo   [NG] マクロファイル NG - ファイルが見つかりません
)

echo.
echo ========================================
echo   詳細情報
echo ========================================
echo.

:: Bluetoothサービス状態確認
echo Bluetoothサービス状態:
wsl -d %WSL_DISTRO_NAME% -e bash -c "service bluetooth status 2>/dev/null | grep -q 'running' && echo '[実行中] bluetooth service is running' || echo '[停止中] bluetooth service is not running'" 2>nul

echo.
echo テスト完了
pause
goto menu

:end
echo.
echo 終了します
exit /b 0