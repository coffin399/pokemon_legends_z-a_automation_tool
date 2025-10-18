@echo off
chcp 932 >nul
setlocal

echo.
echo [ステップ 4/5] usbipd-win のインストール
echo -----------------------------------------

where usbipd >nul 2>&1
if %errorlevel% equ 0 (
    echo [完了] usbipd-winは既にインストールされています。
    exit /b 0
)

echo usbipd-winを自動インストール中...
powershell -Command "if (Get-Command winget -ErrorAction SilentlyContinue) { winget install --id dorssel.usbipd-win --silent --accept-source-agreements --accept-package-agreements } else { Write-Host '[エラー] wingetが見つかりません'; exit 1 }"

if %errorlevel% neq 0 (
    echo [注意] 自動インストールに失敗しました。手動でインストールしてください。
    echo 1. https://github.com/dorssel/usbipd-win/releases を開く
    echo 2. 最新の .msi ファイルをダウンロードしてインストール
    start https://github.com/dorssel/usbipd-win/releases
    echo.
    echo インストール後、もう一度 setup_all.bat を実行してください。
    exit /b 1
)

echo [完了] usbipd-winのインストールが完了しました。
exit /b 0