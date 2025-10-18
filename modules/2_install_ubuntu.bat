@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

:check_ubuntu
echo.
echo [ステップ 2/5] Ubuntu 22.04の確認とインストール
echo -----------------------------------------
echo [確認中] インストール済みのLinuxを確認...
wsl -l -v

set "UBUNTU_FOUND=0"
set "WSL_DISTRO="
for /f "tokens=1" %%i in ('wsl -l -v 2^>nul ^| findstr /i "Ubuntu"') do (
    set "TEMP_DISTRO=%%i"
    set "TEMP_DISTRO=!TEMP_DISTRO:*=!"
    set "WSL_DISTRO=!TEMP_DISTRO!"
    set "UBUNTU_FOUND=1"
)

if %UBUNTU_FOUND% equ 1 (
    echo [完了] Ubuntuが検出されました: %WSL_DISTRO%
    echo %WSL_DISTRO% > "%~dp0distro.tmp"
    exit /b 0
)

echo [検出結果] Ubuntuが見つかりませんでした。自動インストールを開始します。
echo.
echo    ★★★★★【重要】★★★★★
echo    これから表示される新しいウィンドウの指示に従って
echo    【ユーザー名】と【パスワード】を設定してください。
echo    設定が完了すると、ウィンドウは自動で閉じます。
echo    ★★★★★★★★★★★★★★
echo.
pause

start "Ubuntu 22.04 LTS のインストール" /wait wsl --install Ubuntu-22.04

if %errorlevel% neq 0 (
    echo [エラー] Ubuntuのインストールに失敗しました。
    exit /b 1
)

echo [完了] Ubuntuのインストールが完了しました。再度確認します...
timeout /t 2 >nul
goto :check_ubuntu