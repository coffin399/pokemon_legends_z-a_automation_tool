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
usbipd bind --busid %busid% 2>&1 | findstr /C:"already shared" >nul
if %errorlevel% equ 0 (
    echo [情報] デバイスは既にShared状態です。
    goto do_attach
)

usbipd bind --busid %busid% >nul 2>&1
if %errorlevel% neq 0 (
    echo [失敗] デバイスのバインドに失敗しました。
    echo.
    echo トラブルシューティング:
    echo ・BUSIDが間違っていませんか？
    echo ・このスクリプトを「管理者として実行」していますか？
    echo ・Bluetoothデバイスが使用中ではありませんか？
    echo.
    echo 強制バインドを試しますか？ (Y/N)
    set /p force_bind=
    if /i "!force_bind!"=="Y" (
        echo 強制バインド中...
        usbipd bind --busid %busid% --force
        if !errorlevel! neq 0 (
            echo [失敗] 強制バインドも失敗しました。
            goto end
        )
    ) else (
        goto end
    )
)

echo バインド完了。

:do_attach
rem タイミング問題を避けるための短い待機
timeout /t 2 >nul

echo WSLに接続します...
echo.

:: アタッチ処理
usbipd attach --wsl --busid %busid%

if %errorlevel% equ 0 (
    echo.
    echo [完了] 接続コマンドの実行が完了しました。
    echo.

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

    echo 上記結果に「UP RUNNING」と表示されていれば正常です。
    echo.

    wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'"
    if !errorlevel! equ 0 (
        echo [成功] Bluetooth接続が有効になりました！
        echo これでWSL内の 'nxbt' が使用できます。
    ) else (
        echo [警告] Bluetooth接続を自動で確認できませんでした。
        echo.
        echo 以下のコマンドをWSL内で手動で実行して、状態を確認してください:
        echo   wsl -d %WSL_DISTRO_NAME%
        echo   sudo service dbus start
        echo   sudo service bluetooth start
        echo   hciconfig
        echo   hciconfig hci0 up
    )

) else (
    echo.
    echo [失敗] WSLへの接続に失敗しました。
    echo.
    echo トラブルシューティング:
    echo 1. BUSIDが正しいか確認してください。
    echo 2. PowerShell (またはコマンドプロンプト) を「管理者として実行」していますか？
    echo 3. 'usbipd-win' が正しくインストールされていますか？
    echo 4. WSL2が起動していますか？ (wsl -l -v で確認)
    echo 5. デバイスが他のプロセスで使用中ではありませんか？
)

:end
echo.
pause