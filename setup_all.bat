@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

REM ========================================================
REM ポケモンLEGENDS Z-A 自動金策マクロ
REM 完全自動ワンクリックセットアップ (メインコントローラー)
REM ========================================================

REM 管理者権限チェック
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 管理者権限が必要です。自動で昇格します...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    timeout /t 2 >nul
    exit /b
)

cls
echo.
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃                                                      ┃
echo ┃     ポケモンLEGENDS Z-A 自動金策マクロ                 ┃
echo ┃       完全自動ワンクリックセットアップ                      ┃
echo ┃                                                      ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.
echo [OK] 管理者権限で実行中
echo.
echo ★ このセットアップは完全自動です！
echo    あなたがすることは「Y」を押すだけ！
echo.
echo ========================================================
echo このセットアップではマクロに必要な環境を自動で構築します:
echo ========================================================
echo   1. WSL2 (Windows上でLinuxを動かす仕組み) のインストール
echo   2. Ubuntu (Linuxの一種) のインストール
echo   3. Python (マクロを動かすプログラム言語) 環境の構築
echo   4. 必要なパッケージのインストール
echo   5. usbipd-win (PCとSwitchを繋ぐツール) のインストール
echo.
echo ========================================================
echo.

choice /c YN /m "セットアップを開始しますか？" /t 60 /d N
if %errorLevel% equ 2 (
    echo.
    echo セットアップをキャンセルしました。
    goto :normal_exit
)

REM --- 各ステップのバッチファイルを順番に呼び出す ---

echo.
echo.
echo ========================================================
echo [メイン] ステップ1: WSL2のインストールを開始します...
echo ========================================================
call "%~dp0modules\1_install_wsl.bat"
if %errorlevel% neq 0 goto :error_exit

echo.
echo ========================================================
echo [メイン] ステップ2: Ubuntuのインストールを開始します...
echo ========================================================
call "%~dp0modules\2_install_ubuntu.bat"
if %errorlevel% neq 0 goto :error_exit

echo.
echo ========================================================
echo [メイン] ステップ3: Ubuntu環境のセットアップを開始します...
echo ========================================================
call "%~dp0modules\3_setup_ubuntu.bat"
if %errorlevel% neq 0 goto :error_exit

echo.
echo ========================================================
echo [メイン] ステップ4: usbipd-winのインストールを開始します...
echo ========================================================
call "%~dp0modules\4_install_usbipd.bat"
if %errorlevel% neq 0 goto :error_exit

echo.
echo ========================================================
echo [メイン] ステップ5: 最終案内を表示します...
echo ========================================================
call "%~dp0modules\5_show_next_steps.bat"

goto :normal_exit

:error_exit
echo.
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃                                                      ┃
echo ┃         エラーが発生したため、処理を中断しました ?           ┃
echo ┃                                                      ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.
echo 上記のログを確認し、エラーの原因を取り除いてから
echo もう一度この setup_all.bat を実行してください。
echo.
goto :end

:normal_exit
echo.
echo [メイン] 全てのセットアッププロセスが完了しました。
echo.

:end
echo 何かキーを押すと終了します...
pause >nul
exit /b 0