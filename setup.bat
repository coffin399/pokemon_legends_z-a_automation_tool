@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

REM ============================================
REM Nintendo Switch 自動マクロツール
REM 完全自動ワンクリックセットアップ
REM ============================================

REM 管理者権限チェック - なければ自動で昇格
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 管理者権限が必要です。自動で昇格します...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃                                                      ┃
echo ┃     Nintendo Switch マクロツール                       ┃
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
echo このセットアップでは以下を自動で行います:
echo ========================================================
echo   1. WSL2のインストール
echo   2. Ubuntu 22.04のインストール（完全自動）
echo   3. Python環境の構築
echo   4. 必要なパッケージのインストール
echo   5. usbipd-winのインストール
echo.
echo [所要時間] 約20-30分（初回のみ）
echo [注意] インターネット接続が必要です
echo.
echo ========================================================
echo.

choice /c YN /m "セットアップを開始しますか？"
if %errorLevel% equ 2 (
    echo.
    echo セットアップをキャンセルしました。
    pause
    exit /b 0
)

echo.
echo ========================================================
echo >> 自動セットアップ開始
echo ========================================================
echo.
echo ※ これから全て自動で進みます
echo ※ コーヒーでも飲んでお待ちください！
echo.

REM ============================================
REM ステップ1: WSL2のインストール確認
REM ============================================

echo [ステップ 1/5] WSL2のインストール確認
echo -----------------------------------------

wsl --status >nul 2>&1
if %errorLevel% neq 0 (
    echo WSL2が見つかりません。今からインストールします...
    echo.
    echo [ダウンロード] WSL2をインストール中...（数分かかります）

    REM WSL2のワンコマンドインストール
    wsl --install --no-distribution

    if %errorLevel% neq 0 (
        echo.
        echo [注意] 自動インストールに失敗しました。
        echo 手動でWSL機能を有効化します...

        REM 手動で機能を有効化
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    )

    echo.
    echo [完了] WSL2のインストールが完了しました
    echo.
    echo ========================================================
    echo [重要] PCの再起動が必要です！
    echo ========================================================
    echo.
    echo 再起動後、このファイル（setup.bat）をもう一度
    echo 【ダブルクリック】してください。
    echo.
    echo ※ 2回目は自動で続きから始まります（何も入力不要）
    echo.
    echo ========================================================
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
    echo [完了] WSL2が既にインストールされています
)

echo.
echo ========================================================
pause
echo.

REM WSL2をデフォルトに設定
wsl --set-default-version 2 >nul 2>&1

REM ============================================
REM ステップ2: Ubuntu 22.04の完全自動インストール
REM ============================================

echo [ステップ 2/5] Ubuntu 22.04の自動インストール
echo -----------------------------------------

wsl -l -v | findstr /C:"Ubuntu-22.04" /C:"Ubuntu 22.04" >nul 2>&1
if %errorLevel% neq 0 (
    echo Ubuntu 22.04が見つかりません。
    echo.

    REM 他のUbuntuディストリビューションがあるか確認
    wsl -l -v | findstr "Ubuntu" >nul 2>&1
    if %errorLevel% equ 0 (
        echo.
        echo [発見] 別のUbuntuディストリビューションが見つかりました:
        echo.
        wsl -l -v | findstr "Ubuntu"
        echo.
        echo ========================================================
        echo [選択] どちらを使用しますか？
        echo ========================================================
        echo.
        echo 1. 既存のUbuntuを使用する（推奨・即完了）
        echo    → 既にあるUbuntuをそのまま使います
        echo.
        echo 2. Ubuntu 22.04を新規インストールする（5-10分）
        echo    → 新しくUbuntu 22.04をインストールします
        echo.

        choice /c 12 /m "選択してください"

        if !errorLevel! equ 1 (
            echo.
            echo [選択] 既存のUbuntuを使用します
            echo.

            REM 既存のUbuntuディストリビューション名を取得
            for /f "tokens=1" %%i in ('wsl -l -v ^| findstr "Ubuntu" ^| findstr /v "docker"') do (
                set "DISTRO_NAME=%%i"
                goto found_distro
            )

            :found_distro
            echo [検出] ディストリビューション: !DISTRO_NAME!
            echo.

            REM sudo権限を自動化
            echo [設定] sudo権限を自動化中...
            wsl -d !DISTRO_NAME! bash -c "echo '$(whoami) ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/$(whoami) > /dev/null 2>&1 && sudo chmod 0440 /etc/sudoers.d/$(whoami) 2>/dev/null"

            echo [完了] 既存のUbuntuの設定が完了しました

            REM 以降の処理で使用するディストリビューション名を変更
            set "WSL_DISTRO=!DISTRO_NAME!"

            goto skip_ubuntu_install
        )
    )

    echo [完全自動インストール] Ubuntu 22.04をインストールします
    echo.
    echo ※ 完全に自動で進みます（入力不要）
    echo ※ 5-10分お待ちください...
    echo.

    REM WSLをクリーンアップ
    echo [準備] WSLをシャットダウン中...
    wsl --shutdown >nul 2>&1
    timeout /t 3 /nobreak >nul

    REM 一時フォルダを作成
    set "TEMP_DIR=%TEMP%\ubuntu_install"
    if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

    echo [ダウンロード] Ubuntu 22.04 をダウンロード中...（数分かかります）
    echo              ※ ダウンロードサイズ: 約450MB
    echo.

    REM PowerShellでAppxパッケージをダウンロード
    powershell -Command "$ProgressPreference = 'SilentlyContinue'; try { Invoke-WebRequest -Uri 'https://aka.ms/wslubuntu2204' -OutFile '%TEMP_DIR%\Ubuntu2204.appx' -UseBasicParsing -TimeoutSec 600; exit 0 } catch { exit 1 }"

    if %errorLevel% neq 0 (
        echo [エラー] ダウンロードに失敗しました
        echo.
        echo 別の方法を試します...

        REM 代替URL
        powershell -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://wslstorestorage.blob.core.windows.net/wslblob/Ubuntu2204-221101.AppxBundle' -OutFile '%TEMP_DIR%\Ubuntu2204.appx' -UseBasicParsing" >nul 2>&1

        if !errorLevel! neq 0 (
            echo [エラー] 全てのダウンロード方法が失敗しました
            echo インターネット接続を確認してください
            echo.
            echo ========================================================
            echo [エラー発生] インターネット接続を確認してください
            echo ========================================================
            pause
            exit /b 1
        )
    )

    echo [完了] ダウンロード完了
    echo.
    echo [インストール] Ubuntu 22.04をインストール中...

    REM Appxパッケージをインストール
    powershell -Command "Add-AppxPackage '%TEMP_DIR%\Ubuntu2204.appx'" >nul 2>&1

    if %errorLevel% neq 0 (
        echo [注意] 通常インストールに失敗しました
        echo        管理者権限で再試行中...
        powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList '-Command Add-AppxPackage ''%TEMP_DIR%\Ubuntu2204.appx'''" -Wait
    )

    echo [待機中] インストール完了を確認中...
    timeout /t 5 /nobreak >nul

    REM インストール確認（最大30秒待機）
    set WAIT_COUNT=0
    :wait_ubuntu_install
    wsl -l -v | findstr /C:"Ubuntu-22.04" /C:"Ubuntu 22.04" >nul 2>&1
    if %errorLevel% neq 0 (
        set /a WAIT_COUNT+=1
        if !WAIT_COUNT! gtr 10 (
            echo [エラー] Ubuntu 22.04のインストールを確認できませんでした
            echo.
            echo インストール状態を確認:
            wsl -l -v
            echo.
            echo ========================================================
            echo [エラー発生] インストールが完了しませんでした
            echo ========================================================
            pause
            exit /b 1
        )
        timeout /t 3 /nobreak >nul
        goto wait_ubuntu_install
    )

    echo [完了] Ubuntu 22.04のインストールが確認されました
    echo.

    REM ディストリビューション名を検出（バージョン表記が異なる可能性があるため）
    for /f "tokens=1" %%i in ('wsl -l -v ^| findstr /C:"Ubuntu-22.04" /C:"Ubuntu 22.04"') do (
        set "DETECTED_DISTRO=%%i"
        goto found_installed_distro
    )
    :found_installed_distro

    echo [検出] ディストリビューション名: !DETECTED_DISTRO!
    echo.
    echo [自動設定] 完全自動でユーザーを作成します...
    echo.

    REM まずrootでアクセスしてユーザーを作成
    echo [作成] ユーザー switchuser を作成中...
    wsl -d !DETECTED_DISTRO! -u root -- bash -c "useradd -m -s /bin/bash switchuser 2>/dev/null || echo 'ユーザーは既に存在します'"

    echo [設定] sudo権限を付与中...
    wsl -d !DETECTED_DISTRO! -u root -- bash -c "usermod -aG sudo switchuser 2>/dev/null"
    wsl -d !DETECTED_DISTRO! -u root -- bash -c "mkdir -p /etc/sudoers.d && echo 'switchuser ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/switchuser && chmod 0440 /etc/sudoers.d/switchuser"

    echo [設定] デフォルトユーザーを設定中...
    wsl -d !DETECTED_DISTRO! -u root -- bash -c "echo -e '[user]\ndefault=switchuser' > /etc/wsl.conf"

    REM ubuntu2204.exe が存在する場合はそれも使う
    where ubuntu2204.exe >nul 2>&1
    if %errorLevel% equ 0 (
        ubuntu2204.exe config --default-user switchuser >nul 2>&1
    )

    REM WSLを再起動して設定を反映
    echo [再起動] WSLを再起動して設定を反映中...
    wsl --shutdown
    timeout /t 3 /nobreak >nul

    echo [完了] Ubuntu 22.04の完全自動インストールが完了しました
    echo         ユーザー名: switchuser（パスワード不要）
    echo.

    REM 一時ファイルを削除
    if exist "%TEMP_DIR%\Ubuntu2204.appx" del /q "%TEMP_DIR%\Ubuntu2204.appx" >nul 2>&1

    set "WSL_DISTRO=!DETECTED_DISTRO!"

:skip_ubuntu_install

) else (
    echo [完了] Ubuntu 22.04が既にインストールされています

    REM ディストリビューション名を検出
    for /f "tokens=1" %%i in ('wsl -l -v ^| findstr /C:"Ubuntu-22.04" /C:"Ubuntu 22.04"') do (
        set "WSL_DISTRO=%%i"
        goto found_existing_distro
    )
    :found_existing_distro

    echo [検出] ディストリビューション名: !WSL_DISTRO!

    REM 既存のインストールでもパスワードなしsudoを設定
    wsl -d !WSL_DISTRO! bash -c "echo '$(whoami) ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/$(whoami) > /dev/null 2>&1 && sudo chmod 0440 /etc/sudoers.d/$(whoami) 2>/dev/null" >nul 2>&1
    echo [設定] sudo権限を自動化しました
)

REM WSLを一度シャットダウンして設定を反映
echo [設定反映] WSLを再起動中...
wsl --shutdown
timeout /t 3 /nobreak >nul

echo.
echo ========================================================
echo [ステップ 2 完了] Ubuntu 22.04のセットアップが完了しました
echo ========================================================
pause
echo.

REM ============================================
REM ステップ3: ファイルの転送
REM ============================================

echo [ステップ 3/5] ファイルの転送
echo -----------------------------------------

set "CURRENT_DIR=%CD%"
echo [フォルダ] 現在のディレクトリ: %CURRENT_DIR%
echo.

echo WSL内にフォルダを作成中...
wsl -d %WSL_DISTRO% bash -c "mkdir -p ~/switch-macro"

if %errorLevel% neq 0 (
    echo [エラー] フォルダ作成に失敗しました
    echo.
    echo ========================================================
    echo [エラー発生] WSLの状態を確認してください
    echo ========================================================
    pause
    exit /b 1
)

echo ファイルをコピー中...
wsl -d %WSL_DISTRO% bash -c "cp -r '%CURRENT_DIR:\=/%'/src ~/switch-macro/ 2>/dev/null || true"
wsl -d %WSL_DISTRO% bash -c "cp -r '%CURRENT_DIR:\=/%'/scripts ~/switch-macro/ 2>/dev/null || true"
wsl -d %WSL_DISTRO% bash -c "cp -r '%CURRENT_DIR:\=/%'/macros ~/switch-macro/ 2>/dev/null || true"
wsl -d %WSL_DISTRO% bash -c "cp '%CURRENT_DIR:\=/%'/requirements.txt ~/switch-macro/ 2>/dev/null || true"

REM 実行権限を付与
wsl -d %WSL_DISTRO% bash -c "chmod +x ~/switch-macro/scripts/*.sh 2>/dev/null || true"

echo [完了] ファイルの転送が完了しました
echo.
echo ========================================================
echo [ステップ 3 完了] ファイルの転送が完了しました
echo ========================================================
pause
echo.

REM ============================================
REM ステップ4: 依存関係の自動インストール
REM ============================================

echo [ステップ 4/5] Python環境のセットアップ
echo -----------------------------------------
echo.
echo [パッケージ] 必要なパッケージをインストール中...
echo    ※ この処理には10~20分かかります
echo    ※ 完全自動なので何も入力不要です
echo    ※ じっくりお待ちください...
echo.

wsl -d %WSL_DISTRO% bash -c "cd ~/switch-macro && bash scripts/install_dependencies.sh"

if %errorLevel% neq 0 (
    echo.
    echo [エラー] インストールに失敗しました
    echo.
    echo トラブルシューティング:
    echo   1. インターネット接続を確認
    echo   2. もう一度 setup.bat を実行
    echo   3. それでもダメなら手動インストール:
    echo      wsl -d %WSL_DISTRO%
    echo      cd ~/switch-macro
    echo      bash scripts/install_dependencies.sh
    echo.
    echo ========================================================
    echo [エラー発生] エラーログを確認してください
    echo ========================================================
    pause
    exit /b 1
)

echo.
echo [完了] Python環境のセットアップが完了しました
echo.
echo ========================================================
echo [ステップ 4 完了] Python環境のセットアップが完了しました
echo ========================================================
pause
echo.

REM ============================================
REM ステップ5: usbipd-winの自動インストール
REM ============================================

echo [ステップ 5/5] usbipd-win のインストール
echo -----------------------------------------
echo.

REM usbipd-winがインストール済みか確認
where usbipd >nul 2>&1
if %errorLevel% equ 0 (
    echo [完了] usbipd-winは既にインストールされています
    echo.
) else (
    echo usbipd-winを自動インストール中...
    echo.

    REM PowerShellでwingetを使ってインストール
    powershell -Command "if (Get-Command winget -ErrorAction SilentlyContinue) { winget install --id dorssel.usbipd-win --silent --accept-source-agreements --accept-package-agreements } else { Write-Host '[エラー] wingetが見つかりません' }"

    if !errorLevel! equ 0 (
        echo [完了] usbipd-winのインストールが完了しました
    ) else (
        echo [注意] 自動インストールに失敗しました
        echo.
        echo 手動インストールが必要です:
        echo 1. https://github.com/dorssel/usbipd-win/releases
        echo 2. 最新の .msi ファイルをダウンロードしてインストール
        echo.

        choice /c YN /m "今すぐブラウザで開きますか？"
        if !errorLevel! equ 1 (
            start https://github.com/dorssel/usbipd-win/releases
            echo.
            echo インストール後、何かキーを押してください
            pause
        )
    )
)

echo.
echo ========================================================
echo [ステップ 5 完了] usbipd-winのセットアップが完了しました
echo ========================================================
pause
echo.

REM ============================================
REM セットアップ完了
REM ============================================

cls
echo.
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃                                                      ┃
echo ┃   ★ セットアップが完了しました！ ★                        ┃
echo ┃                                                      ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.
echo おめでとうございます！
echo 自動セットアップが正常に完了しました。
echo.
echo ========================================================
echo [次のステップ] あと1つだけ手動設定があります
echo ========================================================
echo.
echo ▼ Bluetooth設定（1回だけ、3分で完了）
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
echo    ↑この「2-3」をメモ
echo.
echo 4. 以下のコマンドを実行（2-3は自分のBUSIDに変更）:
echo.
echo    usbipd bind --busid 2-3
echo    usbipd attach --wsl --busid 2-3
echo.
echo 5. 確認:
echo    wsl -d %WSL_DISTRO%
echo    hciconfig
echo    ↑「hci0」が表示されればOK！
echo.
echo ========================================================
echo [使い方]
echo ========================================================
echo.
echo ● 接続テスト（推奨）
echo   → test_connection.bat をダブルクリック
echo.
echo ● マクロ実行
echo   → run_macro.bat をダブルクリック
echo.
echo ========================================================
echo.
echo   Happy Gaming!!
echo.
echo ========================================================
echo.

pause