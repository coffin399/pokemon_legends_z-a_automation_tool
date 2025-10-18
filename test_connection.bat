@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

REM ============================================
REM Nintendo Switch マクロツール
REM 接続テストスクリプト
REM ============================================

echo.
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃                                                      ┃
echo ┃     Nintendo Switch 接続テスト                         ┃
echo ┃                                                      ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.

REM WSLの確認
wsl -l -v | findstr "Ubuntu-22.04" >nul 2>&1
if %errorLevel% neq 0 (
    echo [エラー] Ubuntu-22.04が見つかりません
    echo.
    echo まず setup.bat を実行してセットアップを完了してください。
    echo.
    pause
    exit /b 1
)

echo [OK] WSL環境が見つかりました
echo.
echo このテストでは以下を確認します:
echo   1. Switchへの接続
echo   2. ボタン操作（Aボタンを1回押す）
echo   3. 正常な切断
echo.
echo テスト時間: 約30秒
echo.

pause


echo.
echo >> テスト開始...
echo ========================================================
echo.

REM WSL内でテストスクリプトを実行
wsl -d Ubuntu-22.04 bash -c "cd ~/switch-macro && source .venv/bin/activate && sudo python3 scripts/test_connection.py"

if %errorLevel% equ 0 (
    echo.
    echo ========================================================
    echo [成功] テスト成功！
    echo ========================================================
    echo.
    echo マクロツールは正常に動作します。
    echo run_macro.bat をダブルクリックしてマクロを実行できます。
) else (
    echo.
    echo ========================================================
    echo [失敗] テスト失敗
    echo ========================================================
    echo.
    echo トラブルシューティングを実行することを推奨します。
    echo.
    choice /c YN /m "トラブルシューティングを実行しますか？"
    if !errorLevel! equ 1 (
        wsl -d Ubuntu-22.04 bash ~/switch-macro/scripts/troubleshoot.sh
    )
)

echo.
pause