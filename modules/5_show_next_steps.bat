@echo off
chcp 932 >nul
setlocal

if not exist "%~dp0distro.tmp" (
    set "WSL_DISTRO=Ubuntu-22.04"
) else (
    set /p WSL_DISTRO=<"%~dp0distro.tmp"
)

cls
echo.
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃                                                      ┃
echo ┃      ★☆★ セットアップがすべて完了しました！ ★☆★        ┃
echo ┃                                                      ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.
echo おめでとうございます！
echo これで、自動マクロを実行する準備が整いました。
echo.
echo ========================================================
echo [次のステップ] 最後にPCとSwitchを接続します
echo ========================================================
echo.
echo ▼ Bluetooth設定（初回のみ、3分で完了）
echo.
echo 1. PowerShellを管理者として開く
echo    （Windowsキー → "PowerShell" → 右クリック → 管理者として実行）
echo.
echo 2. 以下のコマンドを実行:
echo.
echo    usbipd list
echo.
echo 3. Bluetoothアダプタの行を探す（例）:
echo    2-3    8087:0025  Intel(R) Wireless Bluetooth(R)
echo    ↑この「2-3」をメモ (BUSIDといいます)
echo.
echo 4. 以下のコマンドを実行（2-3は自分のBUSIDに変更）:
echo.
echo    usbipd bind --busid 2-3
echo    usbipd attach --wsl --busid 2-3
echo.
echo 5. 接続確認:
echo    wsl -d "%WSL_DISTRO%" hciconfig
echo    ↑「hci0」が表示されれば成功です！
echo.
echo ========================================================
echo [使い方]
echo ========================================================
echo.
echo ● 接続テスト（推奨） → test_connection.bat をダブルクリック
echo ● 金策マクロ実行     → run_macro.bat をダブルクリック
echo.
echo ========================================================
echo.
echo   Happy Z-A Life!!
echo.
echo ========================================================
echo.

REM 一時ファイルを削除
del "%~dp0distro.tmp" 2>nul

exit /b 0