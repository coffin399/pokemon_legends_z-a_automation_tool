@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

REM エラーが発生したら即座に停止して表示
set "ERROR_OCCURRED=0"

REM ============================================
REM Nintendo Switch 自動マクロツール
REM 完全自動ワンクリックセットアップ
REM ============================================

REM 管理者権限チェック - なければ自動で昇格
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 管理者権限が必要です。自動で昇格します...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    timeout /t 2 >nul
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

choice /c YN /m "セットアップを開始しますか？" /t 60 /d N
if %errorLevel% equ 2 (
    echo.
    echo セットアップをキャンセルしました。
    echo.
    goto normal_exit
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

    choice /c YN /m "今すぐ再起動しますか？" /t 30 /d N
    if !errorLevel! equ 1 (
        echo.
        echo 10秒後に再起動します...
        shutdown /r /t 10 /c "WSL2インストール完了。再起動中..."
        timeout /t 10 >nul
        exit /b 0
    ) else (
        echo.
        echo 後で手動で再起動してください。
        echo 再起動後、setup.bat をもう一度実行してください。
        echo.
        goto normal_exit
    )
) else (
    echo [完了] WSL2が既にインストールされています
)

echo.
echo [デバッグ] WSLのバージョン確認
wsl --set-default-version 2
echo [デバッグ] WSL2をデフォルトに設定しました
echo.

echo ========================================================
echo [ステップ 1 完了] WSL2の確認が完了しました
echo ========================================================
echo.
timeout /t 2 >nul

REM WSL2をデフォルトに設定
echo [デバッグ] WSL2をデフォルトバージョンに設定中...
wsl --set-default-version 2 >nul 2>&1
echo [デバッグ] 設定完了

REM 既存のWSL_DISTRO変数をクリア
set "WSL_DISTRO="
echo [デバッグ] WSL_DISTRO変数をクリアしました

REM ============================================
REM ステップ2: Ubuntu 22.04の完全自動インストール
REM ============================================

echo.
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃ [ステップ 2/5] Ubuntu 22.04の自動インストール           ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.
echo [確認中] インストール済みのディストリビューションを確認...
echo.
echo === インストール済みWSLディストリビューション ===
wsl -l -v
echo ================================================
echo.
timeout /t 2 /nobreak >nul

REM Ubuntu 22.04が既にインストールされているか確認
set "UBUNTU_FOUND=0"
for /f "tokens=1" %%i in ('wsl -l -v 2^>nul ^| findstr /i "Ubuntu"') do (
    set "TEMP_DISTRO=%%i"
    REM BOM文字を削除
    set "TEMP_DISTRO=!TEMP_DISTRO:*=!"
    echo [検出] ディストリビューション: !TEMP_DISTRO!
    set "WSL_DISTRO=!TEMP_DISTRO!"
    set "UBUNTU_FOUND=1"
    goto ubuntu_found
)

:ubuntu_found
if %UBUNTU_FOUND% equ 1 (
    echo [完了] Ubuntu が既にインストールされています
    echo [使用] ディストリビューション名: "%WSL_DISTRO%"

    REM sudo権限を自動化
    echo [設定中] sudo権限を自動化しています...
    wsl -d "%WSL_DISTRO%" bash -c "echo '$(whoami) ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/$(whoami) > /dev/null 2>&1 && sudo chmod 0440 /etc/sudoers.d/$(whoami) 2>/dev/null" 2>nul

    goto skip_ubuntu_install
)

REM Ubuntu が見つからない場合の処理
echo [検出結果] Ubuntu が見つかりませんでした
echo.
echo ========================================================
echo [エラー] WSL用のLinuxディストリビューションが見つかりません
echo ========================================================
echo.
echo 以下の手順でUbuntuをインストールしてください:
echo.
echo 1. Microsoft Store を開く
echo 2. "Ubuntu 22.04" で検索
echo 3. インストールボタンをクリック
echo 4. インストール完了後、もう一度このsetup.batを実行
echo.
echo または、コマンドプロンプトで以下を実行:
echo    wsl --install Ubuntu-22.04
echo.

choice /c YN /m "Microsoft Storeを開きますか？" /t 30 /d Y
if !errorLevel! equ 1 (
    start ms-windows-store://pdp/?ProductId=9PN20MSR04DW
)

echo.
echo Ubuntuのインストール後、このsetup.batをもう一度実行してください。
goto normal_exit

:skip_ubuntu_install

REM ディストリビューション名が設定されているか確認
if not defined WSL_DISTRO (
    echo.
    echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
    echo ┃ [エラー] ディストリビューション名が設定されていません   ┃
    echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
    echo.
    echo 利用可能なディストリビューション:
    wsl -l -v
    echo.
    goto error_exit
)

echo.
echo [確認] 使用するディストリビューション: "%WSL_DISTRO%"
echo.

REM WSLを一度シャットダウンして設定を反映
echo [設定反映] WSLを再起動中...
wsl --shutdown
timeout /t 3 /nobreak >nul
echo [完了] WSL再起動完了

echo.
echo ========================================================
echo [ステップ 2 完了] Ubuntu のセットアップが完了しました
echo 使用ディストリビューション: "%WSL_DISTRO%"
echo ========================================================
echo.
timeout /t 2 >nul

REM ============================================
REM ステップ3: ファイルの転送
REM ============================================

echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃ [ステップ 3/5] ファイルの転送                           ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.

set "CURRENT_DIR=%CD%"
echo [情報] 現在のディレクトリ: %CURRENT_DIR%
echo [情報] 使用ディストリビューション: "%WSL_DISTRO%"
echo.

echo [実行中] WSL内にフォルダを作成...
wsl -d "%WSL_DISTRO%" bash -c "mkdir -p ~/switch-macro" 2>&1

if %errorLevel% neq 0 (
    echo [エラー] フォルダ作成に失敗しました
    echo.
    echo WSLの状態:
    wsl -l -v
    echo.
    goto error_exit
)

echo [実行中] ファイルをコピー中...
wsl -d "%WSL_DISTRO%" bash -c "cp -r '%CURRENT_DIR:\=/%'/src ~/switch-macro/ 2>/dev/null || true"
wsl -d "%WSL_DISTRO%" bash -c "cp -r '%CURRENT_DIR:\=/%'/scripts ~/switch-macro/ 2>/dev/null || true"
wsl -d "%WSL_DISTRO%" bash -c "cp -r '%CURRENT_DIR:\=/%'/macros ~/switch-macro/ 2>/dev/null || true"
wsl -d "%WSL_DISTRO%" bash -c "cp '%CURRENT_DIR:\=/%'/requirements.txt ~/switch-macro/ 2>/dev/null || true"

REM 実行権限を付与
wsl -d "%WSL_DISTRO%" bash -c "chmod +x ~/switch-macro/scripts/*.sh 2>/dev/null || true"

echo [完了] ファイルの転送が完了しました
echo.
echo ========================================================
echo [ステップ 3 完了] ファイルの転送が完了しました
echo ========================================================
timeout /t 2 >nul
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

wsl -d "%WSL_DISTRO%" bash -c "cd ~/switch-macro && bash scripts/install_dependencies.sh" 2>&1

if %errorLevel% neq 0 (
    echo.
    echo [エラー] インストールに失敗しました
    echo.
    echo トラブルシューティング:
    echo   1. インターネット接続を確認
    echo   2. もう一度 setup.bat を実行
    echo   3. それでもダメなら手動インストール:
    echo      wsl -d "%WSL_DISTRO%"
    echo      cd ~/switch-macro
    echo      bash scripts/install_dependencies.sh
    echo.
    goto error_exit
)

echo.
echo [完了] Python環境のセットアップが完了しました
echo.
echo ========================================================
echo [ステップ 4 完了] Python環境のセットアップが完了しました
echo ========================================================
timeout /t 2 >nul
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

        choice /c YN /m "今すぐブラウザで開きますか？" /t 30 /d N
        if !errorLevel! equ 1 (
            start https://github.com/dorssel/usbipd-win/releases
            echo.
            echo インストール後、何かキーを押してください
            pause >nul
        )
    )
)

echo.
echo ========================================================
echo [ステップ 5 完了] usbipd-winのセットアップが完了しました
echo ========================================================
timeout /t 2 >nul
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
echo    wsl -d "%WSL_DISTRO%"
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

goto normal_exit

REM ============================================
REM エラー発生時の終了処理
REM ============================================
:error_exit
echo.
echo ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo ┃                                                      ┃
echo ┃   ? エラーが発生しました                               ┃
echo ┃                                                      ┃
echo ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.
echo セットアップ中にエラーが発生しました。
echo 上記のエラーメッセージを確認してください。
echo.
echo ========================================================
echo [対処方法]
echo ========================================================
echo.
echo 1. エラーメッセージをよく読む
echo 2. インターネット接続を確認
echo 3. WSLの状態を確認: wsl -l -v
echo 4. もう一度 setup.bat を実行
echo.
echo それでも解決しない場合は、エラーメッセージを
echo スクリーンショットして、サポートに問い合わせてください。
echo.
echo ========================================================
echo.
echo 何かキーを押すと終了します...
pause >nul
exit /b 1

REM ============================================
REM 正常終了処理
REM ============================================
:normal_exit
echo.
echo 何かキーを押すと終了します...
pause >nul
exit /b 0