@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM ============================================
REM Nintendo Switch 自動マクロツール
REM ワンクリックセットアップスクリプト
REM ============================================

REM 管理者権限チェック - なければ自動で昇格
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 管理者権限が必要です。自動で昇格します...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║                                                      ║
echo ║     🎮 Nintendo Switch マクロツール                    ║
echo ║          ワンクリックセットアップ                         ║
echo ║                                                      ║
echo ╚══════════════════════════════════════════════════════╝
echo.
echo ✅ 管理者権限で実行中
echo.
echo このセットアップでは以下を自動で行います:
echo   1. WSL2のインストール
echo   2. Ubuntu 22.04のインストール
echo   3. Python環境の構築
echo   4. 必要なパッケージのインストール
echo   5. Bluetooth設定の案内
echo.
echo ⏱️  所要時間: 約30分（初回のみ）
echo.

choice /c YN /m "セットアップを開始しますか？"
if %errorLevel% equ 2 (
    echo.
    echo セットアップをキャンセルしました。
    pause
    exit /b 0
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🚀 セットアップ開始
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

REM ============================================
REM ステップ1: WSL2のインストール確認
REM ============================================

echo [ステップ 1/6] WSL2のインストール確認
echo ─────────────────────────────────────────

wsl --status >nul 2>&1
if %errorLevel% neq 0 (
    echo WSL2が見つかりません。今からインストールします...
    echo.
    echo 📥 WSL2をインストール中...（数分かかります）

    REM WSL2のワンコマンドインストール（Windows 10 build 19041以降）
    wsl --install --no-distribution

    if %errorLevel% neq 0 (
        echo.
        echo ⚠️ 自動インストールに失敗しました。
        echo 手動でWSL機能を有効化します...

        REM 手動で機能を有効化
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    )

    echo.
    echo ✅ WSL2のインストールが完了しました
    echo.
    echo ⚠️ 【重要】PCの再起動が必要です！
    echo.
    echo 再起動後、このファイル（setup.bat）をもう一度
    echo 【ダブルクリック】してください。
    echo ※ 2回目は自動で続きから始まります
    echo.

    choice /c YN /m "今すぐ再起動しますか？"
    if !errorLevel! equ 1 (
        echo.
        echo 10秒後に再起動します...
        shutdown /r /t 10 /c "WSL2インストール完了。再起動中..."
        pause
        exit /b 0
    ) else (
        echo.
        echo 後で手動で再起動してください。
        echo 再起動後、setup.bat をもう一度実行してください。
        pause
        exit /b 0
    )
) else (
    echo ✅ WSL2が既にインストールされています
)

echo.

REM WSL2をデフォルトに設定
wsl --set-default-version 2 >nul 2>&1

REM ============================================
REM ステップ2: Ubuntu 22.04の自動インストール
REM ============================================

echo [ステップ 2/6] Ubuntu 22.04のインストール
echo ─────────────────────────────────────────

wsl -l -v | findstr "Ubuntu-22.04" >nul 2>&1
if %errorLevel% neq 0 (
    echo Ubuntu 22.04をインストール中...
    echo.
    echo 📥 ダウンロードとインストールを実行中...
    echo    （数分かかります。お待ちください）
    echo.

    REM Ubuntu 22.04をインストール
    wsl --install -d Ubuntu-22.04

    echo.
    echo ✅ Ubuntu 22.04のインストールが完了しました
    echo.
    echo 👤 ユーザー名とパスワードの設定
    echo ─────────────────────────────────────────
    echo.
    echo 新しいウィンドウでUbuntuが起動します。
    echo 以下を入力してください:
    echo.
    echo   ユーザー名: 好きな名前（例: switch）
    echo   パスワード: 好きなパスワード
    echo   ※ パスワードは画面に表示されませんが入力されています
    echo.
    echo 入力が完了したら、Ubuntuのウィンドウを閉じて
    echo このウィンドウに戻ってきてください。
    echo.

    pause

    REM Ubuntuが初期化されるのを待つ
    timeout /t 5 /nobreak >nul

) else (
    echo ✅ Ubuntu 22.04が既にインストールされています
)

echo.

REM ============================================
REM ステップ3: ファイルの転送
REM ============================================

echo [ステップ 3/6] ファイルの転送
echo ─────────────────────────────────────────

set "CURRENT_DIR=%CD%"
echo 📁 現在のディレクトリ: %CURRENT_DIR%
echo.

echo WSL内にフォルダを作成中...
wsl -d Ubuntu-22.04 bash -c "mkdir -p ~/switch-macro"

echo ファイルをコピー中...
wsl -d Ubuntu-22.04 bash -c "cp -r '%CURRENT_DIR:\=/%'/src ~/switch-macro/ 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "cp -r '%CURRENT_DIR:\=/%'/scripts ~/switch-macro/ 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "cp -r '%CURRENT_DIR:\=/%'/macros ~/switch-macro/ 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "cp '%CURRENT_DIR:\=/%'/requirements.txt ~/switch-macro/ 2>/dev/null || true"

REM 実行権限を付与
wsl -d Ubuntu-22.04 bash -c "chmod +x ~/switch-macro/scripts/*.sh 2>/dev/null || true"

echo ✅ ファイルの転送が完了しました
echo.

REM ============================================
REM ステップ4: 依存関係の自動インストール
REM ============================================

echo [ステップ 4/6] Python環境のセットアップ
echo ─────────────────────────────────────────
echo.
echo 📦 必要なパッケージをインストール中...
echo    ※ この処理には5〜15分かかる場合があります
echo    ※ コーヒーでも飲んで待ちましょう ☕
echo.

wsl -d Ubuntu-22.04 bash ~/switch-macro/scripts/install_dependencies.sh

if %errorLevel% neq 0 (
    echo.
    echo ❌ エラー: インストールに失敗しました
    echo.
    echo トラブルシューティング:
    echo   1. インターネット接続を確認
    echo   2. もう一度 setup.bat を実行
    echo   3. それでもダメなら手動インストール:
    echo      wsl -d Ubuntu-22.04
    echo      cd ~/switch-macro
    echo      bash scripts/install_dependencies.sh
    echo.
    pause
    exit /b 1
)

echo.

REM ============================================
REM ステップ5: usbipd-winの自動インストール
REM ============================================

echo [ステップ 5/6] usbipd-win のインストール
echo ─────────────────────────────────────────
echo.

REM usbipd-winがインストール済みか確認
where usbipd >nul 2>&1
if %errorLevel% equ 0 (
    echo ✅ usbipd-winは既にインストールされています
    echo.
) else (
    echo usbipd-winが見つかりません。
    echo.
    echo 📥 usbipd-winをダウンロード中...
    echo.

    REM PowerShellでwingetを使ってインストール
    powershell -Command "if (Get-Command winget -ErrorAction SilentlyContinue) { winget install --id dorssel.usbipd-win --silent --accept-source-agreements --accept-package-agreements } else { Write-Host '⚠️ wingetが見つかりません。手動インストールが必要です' }"

    if !errorLevel! equ 0 (
        echo ✅ usbipd-winのインストールが完了しました
    ) else (
        echo ⚠️ 自動インストールに失敗しました
        echo.
        echo 【手動インストール方法】
        echo 1. 以下のURLを開く:
        echo    https://github.com/dorssel/usbipd-win/releases
        echo.
        echo 2. 最新の .msi ファイルをダウンロード
        echo    （例: usbipd-win_4.0.0.msi）
        echo.
        echo 3. ダウンロードしたファイルをダブルクリックしてインストール
        echo.

        choice /c YN /m "今すぐブラウザで開きますか？"
        if !errorLevel! equ 1 (
            start https://github.com/dorssel/usbipd-win/releases
        )
    )
)

echo.

REM ============================================
REM ステップ6: Bluetooth設定の案内
REM ============================================

echo [ステップ 6/6] Bluetooth設定
echo ─────────────────────────────────────────
echo.
echo ⚠️ 【重要】最後の手動設定
echo.
echo Bluetoothアダプタの接続設定が必要です。
echo 以下の手順を実行してください:
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📋 Bluetooth設定手順
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 1. 【PowerShellを開く】
echo    - Windowsキー を押す
echo    - 「PowerShell」と入力
echo    - 右クリック → 「管理者として実行」
echo.
echo 2. 【Bluetoothアダプタを確認】
echo    PowerShellで以下を入力:
echo.
echo    usbipd list
echo.
echo 3. 【BUSIDをメモ】
echo    Bluetoothアダプタの行を探す（例）:
echo    2-3    8087:0025  Intel(R) Wireless Bluetooth(R)
echo    ↑この「2-3」をメモ
echo.
echo 4. 【接続する】（BUSIDは自分のものに変更）
echo    PowerShellで以下を入力:
echo.
echo    usbipd bind --busid 2-3
echo    usbipd attach --wsl --busid 2-3
echo.
echo 5. 【確認】
echo    PowerShellで以下を入力:
echo.
echo    wsl -d Ubuntu-22.04
echo    hciconfig
echo.
echo    「hci0」が表示されればOK！
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

choice /c YN /m "説明を読みましたか？"

echo.

REM ============================================
REM セットアップ完了
REM ============================================

cls
echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║                                                      ║
echo ║     ✅ セットアップが完了しました！                       ║
echo ║                                                      ║
echo ╚══════════════════════════════════════════════════════╝
echo.
echo 🎉 おめでとうございます！
echo    セットアップが正常に完了しました。
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📋 次のステップ
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 1. 【Bluetooth設定を完了】（まだの場合）
echo    上記の手順に従ってBluetoothアダプタを接続
echo.
echo 2. 【接続テスト】（推奨）
echo    test_connection.bat をダブルクリック
echo    ↑正常に動作するか確認できます
echo.
echo 3. 【マクロ実行】
echo    run_macro.bat をダブルクリック
echo    ↑ZL+A自動連打が始まります
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📚 ドキュメント
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo   README.md       - 詳細な使い方
echo   QUICKSTART.md   - 5分で始める簡単ガイド
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🎮 Happy Gaming!
echo.
pause