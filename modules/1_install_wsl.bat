@echo off
chcp 932 >nul
setlocal

echo.
echo [ステップ 1/5] WSL2のインストール確認
echo -----------------------------------------

wsl --status >nul 2>&1
if %errorLevel% equ 0 (
    echo [完了] WSL2は既にインストールされています。
    wsl --set-default-version 2 >nul 2>&1
    echo [INFO] WSL2をデフォルトバージョンに設定しました。
    exit /b 0
)

echo WSL2が見つかりません。今からインストールします...
echo [ダウンロード] WSL2をインストール中...（数分かかります）
wsl --install --no-distribution

if %errorlevel% neq 0 (
    echo [注意] 自動インストールに失敗しました。手動でWSL機能を有効化します...
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
)

echo.
echo [完了] WSL2のインストールが完了しました。
echo.
echo ========================================================
echo [重要] PCの再起動が必要です！
echo ========================================================
echo.
echo 再起動後、もう一度 setup_all.bat を【ダブルクリック】してください。
echo.
echo ========================================================
echo.

choice /c YN /m "今すぐ再起動しますか？" /t 30 /d N
if %errorlevel% equ 1 (
    echo 10秒後に再起動します...
    shutdown /r /t 10 /c "WSL2インストール完了。再起動中..."
) else (
    echo 後で手動で再起動してください。
)

REM 再起動が必要なため、エラーコードを返してメインバッチを一旦停止させる
exit /b 1