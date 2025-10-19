@echo off
rem 文字コードをShift_JIS(日本語Windows標準)に設定
chcp 932 >nul
setlocal enabledelayedexpansion

cls
echo.
echo ========================================
echo   Bluetooth再接続ヘルパー for WSL
echo ========================================
echo.

:: --- 設定 ---
set WSL_DISTRO_NAME=Ubuntu-22.04

:: --- BUSID設定の読み込み/保存 ---
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
echo まず、利用可能なUSBデバイスを確認します...
echo.
usbipd list
echo.
echo 上記リストから、Bluetoothアダプタの「BUSID」を確認してください。
echo 例: 2-3, 1-4 など
echo.
set /p busid="BUSIDを入力してください: "

:: 入力されたBUSIDをファイルに保存
echo !busid!>"%config_file%"
echo.
echo [完了] BUSIDを保存しました (次回から自動入力されます)
echo.

:attach
echo ----------------------------------------
echo [%busid%] Bluetoothアダプタをバインド中...
echo.

:: バインド処理
usbipd bind --busid %busid% >nul 2>&1
rem ★改善点1: bindコマンドの成否をチェック
if %errorlevel% neq 0 (
    echo [失敗] デバイスのバインドに失敗しました。
    echo ・BUSIDが間違っていませんか？
    echo ・このスクリプトを「管理者として実行」していますか？
    goto end
)

echo バインド完了。WSLに接続します...
rem タイミング問題を避けるための短い待機
timeout /t 2 >nul

:: アタッチ処理
usbipd attach --wsl --busid %busid%

if %errorlevel% equ 0 (
    echo.
    echo [完了] 接続コマンドの実行が完了しました。
    echo.

    rem ★改善点3: なぜ待つのかコメントを追加
    rem WSLがデバイスを認識し、Bluetoothサービスが初期化するのを待つ
    echo Bluetoothアダプタの初期化を待っています... (5秒)
    timeout /t 5 >nul

    :: WSL内でBluetoothの状態を確認
    echo Bluetoothの状態をWSL内で確認中...
    echo.
    echo --- hciconfig の実行結果 ---
    wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig"
    echo ---------------------------
    echo.

    rem ★改善点2: hciconfigのどこを見るか説明を追加
    echo 上記結果に「UP RUNNING」と表示されていれば正常です。
    echo.

    wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'"
    if !errorlevel! equ 0 (
        echo [成功] Bluetooth接続が有効になりました！
        echo これでWSL内の 'bluetoothctl' などが使用できます。
    ) else (
        echo [警告] Bluetooth接続を自動で確認できませんでした。
        echo.
        echo 以下のコマンドをWSL内で手動で実行して、状態を確認してください:
        echo   wsl -d %WSL_DISTRO_NAME%
        echo   sudo service bluetooth restart
        echo   hciconfig
    )

) else (
    echo.
    echo [失敗] WSLへの接続に失敗しました。
    echo.
    echo トラブルシューティング:
    echo 1. BUSIDが正しいか確認してください。
    echo 2. PowerShell (またはコマンドプロンプト) を「管理者として実行」していますか？
    echo 3. 'usbipd-win' が正しくインストールされていますか？
)

:end
echo.
pause