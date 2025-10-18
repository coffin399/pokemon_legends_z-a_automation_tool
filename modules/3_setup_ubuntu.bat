@echo off
chcp 932 >nul
setlocal

echo.
echo [ステップ 3/5] Ubuntu環境のセットアップ
echo -----------------------------------------

if not exist "%~dp0distro.tmp" (
    echo [エラー] ディストリビューション情報ファイルが見つかりません。
    exit /b 1
)
set /p WSL_DISTRO=<"%~dp0distro.tmp"

echo [INFO] 対象ディストリビューション: %WSL_DISTRO%
echo [設定中] sudo権限をパスワードなしで実行できるように設定...
wsl -d "%WSL_DISTRO%" bash -c "echo '$(whoami) ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/90-nopasswd-$(whoami) > /dev/null && sudo chmod 0440 /etc/sudoers.d/90-nopasswd-$(whoami)"

echo [設定反映] WSLを再起動中...
wsl --shutdown
timeout /t 3 /nobreak >nul

echo [実行中] マクロ関連ファイルをWSL内に転送中...
set "PROJECT_ROOT=%~dp0..\"
set "WSL_PATH=%PROJECT_ROOT:\=/%"
wsl -d "%WSL_DISTRO%" bash -c "mkdir -p ~/switch-macro && cp -rf '%WSL_PATH%/'* ~/switch-macro/ 2>/dev/null || true"
if %errorlevel% neq 0 ( echo [エラー] ファイル転送に失敗しました。 & exit /b 1 )
echo [完了] ファイル転送が完了しました。

echo [実行中] Python環境と必要なパッケージをインストール中...(10~20分)
wsl -d "%WSL_DISTRO%" bash -c "chmod +x ~/switch-macro/scripts/*.sh && cd ~/switch-macro && bash scripts/install_dependencies.sh"
if %errorlevel% neq 0 ( echo [エラー] Python環境の構築に失敗しました。 & exit /b 1 )

echo [完了] Ubuntu環境のセットアップが完了しました。
exit /b 0