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
echo   2. Ubuntu 22.04のインストール（自動設定）
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

REM WSL2をデフォルトに設定
wsl --set-default-version 2 >nul 2>&1

REM ============================================
REM ステップ2: Ubuntu 22.04の完全自動インストール
REM ============================================

echo [ステップ 2/5] Ubuntu 22.04の自動インストール
echo -----------------------------------------

wsl -l -v | findstr "Ubuntu-22.04" >nul 2>&1
if %errorLevel% neq 0 (
    echo Ubuntu 22.04を自動インストール中...
    echo.
    echo [ダウンロード] ダウンロード中...（数分かかります）
    echo.

    REM 方法1: wsl --install を試す
    wsl --install -d Ubuntu-22.04 >nul 2>&1

    if %errorLevel% neq 0 (
        echo [方法1失敗] Microsoft Storeからダウンロードします...

        REM 方法2: wingetでインストール
        powershell -Command "winget install -e --id Canonical.Ubuntu.2204 --silent --accept-source-agreements --accept-package-agreements" >nul 2>&1

        if !errorLevel! neq 0 (
            echo [方法2失敗] 直接ダウンロードします...

            REM 方法3: 直接Appxパッケージをダウンロードしてインストール
            powershell -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://aka.ms/wslubuntu2204' -OutFile '%TEMP%\Ubuntu2204.appx' -UseBasicParsing; Add-AppxPackage '%TEMP%\Ubuntu2204.appx'"

            if !errorLevel! neq 0 (
                echo.
                echo [エラー] 全ての自動インストール方法が失敗しました
                echo.
                echo 手動でインストールしてください:
                echo 1. Microsoft Storeを開く
                echo 2. "Ubuntu 22.04" を検索
                echo 3. インストール
                echo 4. インストール後、このスクリプトを再実行
                echo.

                choice /c YN /m "今すぐMicrosoft Storeを開きますか？"
                if !errorLevel! equ 1 (
                    start ms-windows-store://pdp/?ProductId=9PN20MSR04DW
                    echo.
                    echo インストール後、何かキーを押してください
                    pause

                    REM 再度確認
                    wsl -l -v | findstr "Ubuntu-22.04" >nul 2>&1
                    if !errorLevel! neq 0 (
                        echo [エラー] Ubuntu 22.04が見つかりません
                        pause
                        exit /b 1
                    )
                ) else (
                    pause
                    exit /b 1
                )
            )
        )
    )

    echo [待機中] インストール完了を待っています...
    timeout /t 10 /nobreak >nul

    REM インストールが完了するまで待機（最大60秒）
    set WAIT_COUNT=0
    :wait_ubuntu_install
    wsl -l -v | findstr "Ubuntu-22.04" >nul 2>&1
    if %errorLevel% neq 0 (
        set /a WAIT_COUNT+=1
        if !WAIT_COUNT! gtr 20 (
            echo [タイムアウト] Ubuntu 22.04のインストールを確認できませんでした
            echo.
            echo 手動で確認してください:
            echo wsl -l -v
            echo.
            pause
            exit /b 1
        )
        timeout /t 3 /nobreak >nul
        goto wait_ubuntu_install
    )

    echo [完了] Ubuntu 22.04が見つかりました
    echo.
    echo [重要] 初回起動を行います
    echo ※ Ubuntuのウィンドウが開きます
    echo ※ ユーザー名とパスワードを設定してください:
    echo.
    echo   ユーザー名: switchuser
    echo   パスワード: （何も入力せずEnter × 2回でもOK）
    echo.
    echo ※ 設定が完了したら、Ubuntuのウィンドウを閉じてください
    echo.

    pause

    REM Ubuntuを起動（ユーザーに設定させる）
    start wsl -d Ubuntu-22.04

    echo.
    echo Ubuntuのウィンドウでユーザー設定を完了してください
    echo 設定完了後、Ubuntuのウィンドウを閉じて、
    echo 何かキーを押して続行してください
    echo.
    pause

    REM WSLをシャットダウン
    wsl --shutdown
    timeout /t 3 /nobreak >nul

    echo.
    echo [設定] sudo権限を自動化中...

    REM パスワードなしsudoを設定
    wsl -d Ubuntu-22.04 bash -c "echo '$(whoami) ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/$(whoami) > /dev/null 2>&1 && sudo chmod 0440 /etc/sudoers.d/$(whoami) 2>/dev/null"

    echo [完了] Ubuntu 22.04のインストールと設定が完了しました

) else (
    echo [完了] Ubuntu 22.04が既にインストールされています

    REM 既存のインストールでもパスワードなしsudoを設定
    wsl -d Ubuntu-22.04 bash -c "echo '$(whoami) ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/$(whoami) > /dev/null 2>&1 && sudo chmod 0440 /etc/sudoers.d/$(whoami) 2>/dev/null" >nul 2>&1
    echo [設定] sudo権限を自動化しました
)

REM WSLを一度シャットダウンして設定を反映
echo [設定反映] WSLを再起動中...
wsl --shutdown
timeout /t 3 /nobreak >nul

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
wsl -d Ubuntu-22.04 bash -c "mkdir -p ~/switch-macro"

if %errorLevel% neq 0 (
    echo [エラー] フォルダ作成に失敗しました
    pause
    exit /b 1
)

echo ファイルをコピー中...
wsl -d Ubuntu-22.04 bash -c "cp -r '%CURRENT_DIR:\=/%'/src ~/switch-macro/ 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "cp -r '%CURRENT_DIR:\=/%'/scripts ~/switch-macro/ 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "cp -r '%CURRENT_DIR:\=/%'/macros ~/switch-macro/ 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "cp '%CURRENT_DIR:\=/%'/requirements.txt ~/switch-macro/ 2>/dev/null || true"

REM 実行権限を付与
wsl -d Ubuntu-22.04 bash -c "chmod +x ~/switch-macro/scripts/*.sh 2>/dev/null || true"

echo [完了] ファイルの転送が完了しました
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

wsl -d Ubuntu-22.04 bash -c "cd ~/switch-macro && bash scripts/install_dependencies.sh"

if %errorLevel% neq 0 (
    echo.
    echo [エラー] インストールに失敗しました
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
echo [完了] Python環境のセットアップが完了しました
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
echo    wsl -d Ubuntu-22.04
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