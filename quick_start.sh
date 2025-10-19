#!/bin/bash

# エラーが発生した場合はスクリプトを終了する
set -e

# --- 色付け用の変数 ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- ヘッダー表示 ---
clear
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN} Nintendo Switch マクロ環境 (nxbt)         ${NC}"
echo -e "${GREEN} ワンクリックセットアップ for Ubuntu       ${NC}"
echo -e "${GREEN}============================================${NC}"
echo

# --- 動作環境チェック ---
echo -e "${BLUE}[動作環境チェック]${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3がインストールされていません${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
echo -e "Python: ${GREEN}${PYTHON_VERSION}${NC}"

if ! command -v bluetoothctl &> /dev/null; then
    echo -e "${YELLOW}⚠️  Bluetoothツールがインストールされていません（後でインストールします）${NC}"
else
    echo -e "Bluetooth: ${GREEN}利用可能${NC}"
fi
echo

# --- sudo権限の事前確認 ---
echo -e "${YELLOW}システムパッケージのインストールには管理者権限が必要です。${NC}"
echo -e "${YELLOW}パスワードの入力を求められる場合があります。${NC}"
sudo -v

# sudoのタイムスタンプを更新し続ける
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- ステップ1: 依存関係のインストール ---
echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}[ステップ 1/5] システムパッケージをインストール${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "必要なパッケージを確認・インストールします..."
echo

sudo apt update -qq

# 必要なパッケージリスト
PACKAGES=(
    python3
    python3-pip
    python3-venv
    bluez
    libbluetooth-dev
    libhidapi-dev
    git
    libcairo2-dev
    pkg-config
    python3-dev
    gir1.2-gtk-3.0
    libgirepository1.0-dev
    libgirepository-2.0-0
    libgirepository-2.0-dev
    gobject-introspection
    libglib2.0-dev
    meson
    ninja-build
    python3-gi
    python3-gi-cairo
    python3-dbus
    libdbus-1-dev
    libdbus-glib-1-dev
)

echo "インストール対象パッケージ:"
for pkg in "${PACKAGES[@]}"; do
    echo "  - $pkg"
done
echo

sudo apt install -y "${PACKAGES[@]}"

echo
echo -e "${GREEN}✅ システムパッケージのインストールが完了しました${NC}"

# --- ステップ2: Bluetoothサービスの設定 ---
echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}[ステップ 2/5] Bluetoothサービスの設定${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Bluetoothサービスの有効化
echo "Bluetoothサービスを有効化しています..."
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# rfkillでブロックされていないか確認・解除
if command -v rfkill &> /dev/null; then
    echo "Bluetoothのブロックを解除しています..."
    sudo rfkill unblock bluetooth
fi

# Bluetoothサービスの状態確認
if systemctl is-active --quiet bluetooth; then
    echo -e "${GREEN}✅ Bluetoothサービスが正常に動作しています${NC}"
else
    echo -e "${RED}❌ Bluetoothサービスの起動に失敗しました${NC}"
    exit 1
fi

# --- ステップ3: プロジェクトディレクトリの準備 ---
echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}[ステップ 3/5] プロジェクトディレクトリの準備${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# このスクリプトがあるディレクトリをプロジェクトディレクトリとする
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$PROJECT_DIR"

echo "プロジェクトディレクトリ: ${BLUE}$PROJECT_DIR${NC}"

# 必要なディレクトリを作成
mkdir -p "$PROJECT_DIR/src"
mkdir -p "$PROJECT_DIR/macros"
mkdir -p "$PROJECT_DIR/logs"

echo -e "${GREEN}✅ ディレクトリ構造を作成しました${NC}"

# --- ステップ4: Python仮想環境のセットアップ ---
echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}[ステップ 4/5] Python仮想環境のセットアップ${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# 仮想環境の作成
if [ -d ".venv" ]; then
    echo -e "${YELLOW}既存の仮想環境が見つかりました: .venv${NC}"
    read -p "削除して再作成しますか？ (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "既存の仮想環境を削除中..."
        rm -rf .venv
        echo -e "${GREEN}削除完了${NC}"
    else
        echo "既存の仮想環境を使用します"
    fi
fi

if [ ! -d ".venv" ]; then
    echo "Python仮想環境を作成しています..."
    python3 -m venv .venv

    # 作成確認
    if [ -d ".venv" ]; then
        echo -e "${GREEN}✅ 仮想環境を作成しました: $(pwd)/.venv${NC}"
        ls -la .venv/ | head -5
    else
        echo -e "${RED}❌ 仮想環境の作成に失敗しました${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}既存の仮想環境を使用します: $(pwd)/.venv${NC}"
fi

echo

# 仮想環境を有効化
echo "仮想環境を有効化しています..."
if [ ! -f ".venv/bin/activate" ]; then
    echo -e "${RED}❌ 仮想環境のactivateスクリプトが見つかりません${NC}"
    echo "ディレクトリ構造:"
    ls -la .venv/
    exit 1
fi

source .venv/bin/activate

# 有効化確認
if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "${RED}❌ 仮想環境の有効化に失敗しました${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 仮想環境を有効化しました: $VIRTUAL_ENV${NC}"
echo

# pipのアップグレード
echo "pipをアップグレードしています..."
pip install --upgrade pip -q

# --- ステップ5: Pythonライブラリのインストール ---
echo
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}[ステップ 5/5] Pythonライブラリのインストール${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo "必要なライブラリをインストールしています..."
echo "  - nxbt (Nintendo Switch Bluetooth ライブラリ)"
echo

# システムパッケージへのシンボリックリンクを作成する関数
create_system_links() {
    PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
    VENV_SITE_PACKAGES="$PROJECT_DIR/.venv/lib/python${PYTHON_VERSION}/site-packages"

    echo "システムパッケージへのリンクを作成しています..."

    # PyGObject (gi)
    if [ -d "/usr/lib/python3/dist-packages/gi" ]; then
        ln -sf /usr/lib/python3/dist-packages/gi "$VENV_SITE_PACKAGES/" 2>/dev/null || true
        echo "  ✓ gi (PyGObject)"
    fi

    # Cairo
    if [ -d "/usr/lib/python3/dist-packages/cairo" ]; then
        ln -sf /usr/lib/python3/dist-packages/cairo "$VENV_SITE_PACKAGES/" 2>/dev/null || true
        echo "  ✓ cairo"
    fi

    # dbus-python
    if [ -d "/usr/lib/python3/dist-packages/dbus" ]; then
        ln -sf /usr/lib/python3/dist-packages/dbus "$VENV_SITE_PACKAGES/" 2>/dev/null || true
        echo "  ✓ dbus"
    fi

    # _dbus_bindings と _dbus_glib_bindings (.so ファイル)
    for file in /usr/lib/python3/dist-packages/_dbus*.so; do
        if [ -f "$file" ]; then
            ln -sf "$file" "$VENV_SITE_PACKAGES/" 2>/dev/null || true
            echo "  ✓ $(basename $file)"
        fi
    done

    # .egg-info も必要な場合がある
    for dir in /usr/lib/python3/dist-packages/dbus*.egg-info; do
        if [ -d "$dir" ]; then
            ln -sf "$dir" "$VENV_SITE_PACKAGES/" 2>/dev/null || true
        fi
    done
}

# まずシステムパッケージへのリンクを作成
create_system_links

echo
echo -e "${GREEN}✅ システムパッケージ版のPyGObjectとdbusを使用します${NC}"
echo

# nxbtをインストール（--no-build-isolationと--no-depsを使用してdbus-pythonのビルドを回避）
echo "nxbtをインストール中..."

# まず依存関係を確認
echo "nxbtの依存関係を確認中..."

# システムパッケージでカバーできない依存関係のみインストール
pip install blessed pynput

# nxbtを依存関係チェックなしでインストール（システムのdbus-pythonを使用）
pip install --no-deps nxbt

echo
echo -e "${YELLOW}注意: nxbtはシステムのdbus-pythonを使用します${NC}"

echo
echo -e "${GREEN}✅ Pythonライブラリのインストールが完了しました${NC}"

# インストール確認
echo
echo "インストールされたパッケージ:"
pip list | grep -E "nxbt"
echo
echo "システムパッケージ (リンク済み):"
python3 -c "import gi; print(f'  - PyGObject: {gi.__version__}')" 2>/dev/null || echo "  - PyGObject: OK"
python3 -c "import dbus; print(f'  - dbus-python: {dbus.__version__}')" 2>/dev/null || echo "  - dbus-python: OK"

deactivate

# --- 起動スクリプトの作成 ---
echo
echo -e "${BLUE}起動スクリプトを作成しています...${NC}"

cat > "$PROJECT_DIR/run_macro.sh" << 'EOF'
#!/bin/bash

# 色付け用の変数
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# プロジェクトディレクトリに移動
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$PROJECT_DIR"

# 仮想環境の確認
if [ ! -d ".venv" ]; then
    echo -e "${RED}❌ 仮想環境が見つかりません${NC}"
    echo "先にセットアップスクリプトを実行してください"
    exit 1
fi

# 仮想環境を有効化
source .venv/bin/activate

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN} Nintendo Switch マクロ実行環境${NC}"
echo -e "${GREEN}============================================${NC}"
echo

# 引数チェック
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}使い方: $0 <マクロスクリプト.py>${NC}"
    echo
    echo "利用可能なマクロ:"
    if [ -d "macros" ] && [ "$(ls -A macros/*.py 2>/dev/null)" ]; then
        ls -1 macros/*.py | sed 's/^/  - /'
    else
        echo "  (まだマクロが作成されていません)"
    fi
    exit 1
fi

MACRO_SCRIPT="$1"

if [ ! -f "$MACRO_SCRIPT" ]; then
    echo -e "${RED}❌ ファイルが見つかりません: $MACRO_SCRIPT${NC}"
    exit 1
fi

echo -e "マクロスクリプト: ${GREEN}$MACRO_SCRIPT${NC}"
echo

# マクロを実行
python3 "$MACRO_SCRIPT"

deactivate
EOF

chmod +x "$PROJECT_DIR/run_macro.sh"

# コントロールパネルの作成
cat > "$PROJECT_DIR/control_panel.sh" << 'EOF'
#!/bin/bash

# --- 色付け用の変数 ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- 設定 ---
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
MACRO_DIR="$PROJECT_DIR/macros"

# --- 関数定義 ---

# 状態表示
display_status() {
    echo "========================================"
    echo "  Nintendo Switch マクロ コントロールパネル"
    echo "========================================"
    echo

    # 実行中のマクロを確認
    RUNNING_MACROS=$(pgrep -fa "python.*macros/.*\.py" | wc -l)
    if [ "$RUNNING_MACROS" -gt 0 ]; then
        echo -e "状態      : ${GREEN}[実行中]${NC} マクロ実行中 (${RUNNING_MACROS}個)"
        echo "実行中のマクロ:"
        pgrep -fa "python.*macros/.*\.py" | sed 's/^/  - /'
    else
        echo -e "状態      : ${YELLOW}[停止中]${NC} マクロ停止中"
    fi

    echo

    # Bluetooth状態確認
    if systemctl is-active --quiet bluetooth; then
        if command -v hciconfig &> /dev/null && hciconfig 2>/dev/null | grep -q "UP RUNNING"; then
            echo -e "Bluetooth : ${GREEN}[接続済]${NC} アダプタ有効"
        else
            echo -e "Bluetooth : ${YELLOW}[動作中]${NC} サービス起動中"
        fi
    else
        echo -e "Bluetooth : ${RED}[未接続]${NC} サービス停止中"
    fi

    # 仮想環境の確認
    if [ -d "$PROJECT_DIR/.venv" ]; then
        echo -e "仮想環境  : ${GREEN}[OK]${NC} .venv 存在"
    else
        echo -e "仮想環境  : ${RED}[NG]${NC} .venv が見つかりません"
    fi

    echo
    echo "========================================"
    echo
    echo "[1] マクロを選択して実行"
    echo "[2] 実行中のマクロを停止"
    echo "[3] Bluetooth再起動"
    echo "[4] 環境チェック"
    echo "[5] 状態を更新"
    echo "[0] 終了"
    echo
    echo "========================================"
}

# マクロ選択と実行
start_macro() {
    clear
    echo "========================================"
    echo "  マクロ選択"
    echo "========================================"
    echo

    # macrosディレクトリのPythonファイルを検索
    if [ ! -d "$MACRO_DIR" ]; then
        echo -e "${RED}[エラー] macrosディレクトリが見つかりません${NC}"
        read -p "Enterキーを押してメニューに戻ります..."
        return
    fi

    # .pyファイルを配列に格納
    mapfile -t MACROS < <(find "$MACRO_DIR" -maxdepth 1 -name "*.py" -type f | sort)

    if [ ${#MACROS[@]} -eq 0 ]; then
        echo -e "${YELLOW}[警告] 実行可能なマクロが見つかりません${NC}"
        echo "macros/ ディレクトリに .py ファイルを配置してください"
        echo
        read -p "Enterキーを押してメニューに戻ります..."
        return
    fi

    echo "利用可能なマクロ:"
    echo
    for i in "${!MACROS[@]}"; do
        MACRO_NAME=$(basename "${MACROS[$i]}")
        echo "  [$((i+1))] $MACRO_NAME"
    done
    echo "  [0] キャンセル"
    echo
    read -p "実行するマクロを選択 (0-${#MACROS[@]}): " choice

    if [ "$choice" = "0" ]; then
        return
    fi

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#MACROS[@]} ]; then
        echo -e "${RED}[エラー] 無効な選択です${NC}"
        sleep 2
        return
    fi

    SELECTED_MACRO="${MACROS[$((choice-1))]}"
    echo
    echo -e "選択されたマクロ: ${GREEN}$(basename "$SELECTED_MACRO")${NC}"
    echo
    echo "Switchで「コントローラー」→「持ちかた/順番を変える」を開いてください"
    read -p "準備ができたらEnterキーを押してください..."

    echo "マクロを新しいウィンドウで起動中..."

    # 仮想環境の確認
    if [ ! -f "$PROJECT_DIR/.venv/bin/activate" ]; then
        echo -e "${RED}[エラー] 仮想環境が見つかりません${NC}"
        echo "先に setup.sh を実行してください"
        read -p "Enterキーを押してメニューに戻ります..."
        return
    fi

    # 新しいターミナルで実行
    if command -v gnome-terminal &> /dev/null; then
        gnome-terminal -- bash -c "cd '$PROJECT_DIR' && source .venv/bin/activate && python3 '$SELECTED_MACRO'; echo; echo 'マクロが終了しました。このウィンドウを閉じてください。'; read"
    elif command -v xterm &> /dev/null; then
        xterm -hold -e "cd '$PROJECT_DIR' && source .venv/bin/activate && python3 '$SELECTED_MACRO'" &
    else
        echo -e "${YELLOW}[警告] ターミナルエミュレータが見つかりません${NC}"
        echo "このターミナルで実行します..."
        cd "$PROJECT_DIR"
        source .venv/bin/activate
        python3 "$SELECTED_MACRO"
        read -p "Enterキーを押してメニューに戻ります..."
        return
    fi

    sleep 2
    echo
    echo -e "${GREEN}[完了] マクロを起動しました${NC}"
    echo "   新しいターミナルウィンドウで実行中です"
    echo
    read -p "Enterキーを押してメニューに戻ります..."
}

# マクロ停止
stop_macro() {
    clear
    echo "========================================"
    echo "  マクロ停止"
    echo "========================================"
    echo

    # 実行中のマクロを検索
    MACRO_PIDS=$(pgrep -f "python.*macros/.*\.py")

    if [ -z "$MACRO_PIDS" ]; then
        echo -e "${YELLOW}[情報] 実行中のマクロはありません${NC}"
    else
        echo "実行中のマクロ:"
        pgrep -fa "python.*macros/.*\.py"
        echo
        read -p "これらのマクロを停止しますか？ (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            pkill -f "python.*macros/.*\.py"
            echo -e "${GREEN}[完了] マクロを停止しました${NC}"
        else
            echo "キャンセルしました"
        fi
    fi
    echo
    read -p "Enterキーを押してメニューに戻ります..."
}

# Bluetooth再起動
reconnect_bt() {
    clear
    echo "========================================"
    echo "  Bluetooth再起動"
    echo "========================================"
    echo
    echo "Bluetoothサービスを再起動します..."
    sudo systemctl restart bluetooth

    if [ $? -eq 0 ]; then
        echo "サービス再起動コマンドを送信しました"
        echo "アダプタの初期化を待っています... (3秒)"
        sleep 3

        if command -v hciconfig &> /dev/null; then
            echo
            echo "--- Bluetoothアダプタ情報 ---"
            hciconfig
            echo "----------------------------"
            echo
        fi

        if systemctl is-active --quiet bluetooth; then
            echo -e "${GREEN}[成功] Bluetoothサービスが起動しました${NC}"
        else
            echo -e "${RED}[失敗] Bluetoothサービスの起動に失敗しました${NC}"
        fi
    else
        echo -e "${RED}[エラー] Bluetoothサービスの再起動に失敗しました${NC}"
    fi
    echo
    read -p "Enterキーを押してメニューに戻ります..."
}

# 環境チェック
run_test() {
    clear
    echo "========================================"
    echo "  環境チェック"
    echo "========================================"
    echo

    # 1. プロジェクトディレクトリ
    echo -n "[1/6] プロジェクトディレクトリ... "
    if [ -d "$PROJECT_DIR" ]; then
        echo -e "${GREEN}[OK]${NC} $PROJECT_DIR"
    else
        echo -e "${RED}[NG]${NC}"
    fi

    # 2. Python仮想環境
    echo -n "[2/6] Python仮想環境... "
    if [ -f "$PROJECT_DIR/.venv/bin/activate" ]; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[NG] .venvが見つかりません${NC}"
    fi

    # 3. NXBT
    echo -n "[3/6] NXBTライブラリ... "
    if [ -f "$PROJECT_DIR/.venv/bin/python3" ]; then
        if "$PROJECT_DIR/.venv/bin/python3" -c "import nxbt" 2>/dev/null; then
            echo -e "${GREEN}[OK]${NC}"
        else
            echo -e "${RED}[NG] nxbtがインポートできません${NC}"
        fi
    else
        echo -e "${RED}[NG] Python実行ファイルが見つかりません${NC}"
    fi

    # 4. マクロディレクトリ
    echo -n "[4/6] マクロディレクトリ... "
    if [ -d "$MACRO_DIR" ]; then
        MACRO_COUNT=$(find "$MACRO_DIR" -maxdepth 1 -name "*.py" -type f | wc -l)
        echo -e "${GREEN}[OK]${NC} $MACRO_COUNT 個のマクロ"
    else
        echo -e "${RED}[NG] macros/が見つかりません${NC}"
    fi

    # 5. Bluetoothサービス
    echo -n "[5/6] Bluetoothサービス... "
    if systemctl is-active --quiet bluetooth; then
        echo -e "${GREEN}[OK] 実行中${NC}"
    else
        echo -e "${RED}[NG] 停止中${NC}"
    fi

    # 6. Bluetoothアダプタ
    echo -n "[6/6] Bluetoothアダプタ... "
    if command -v hciconfig &> /dev/null; then
        if hciconfig 2>/dev/null | grep -q "UP RUNNING"; then
            echo -e "${GREEN}[OK] 有効${NC}"
        else
            echo -e "${YELLOW}[警告] 無効${NC}"
        fi
    else
        echo -e "${YELLOW}[?] hciconfigが利用できません${NC}"
    fi

    echo
    echo "チェック完了"
    read -p "Enterキーを押してメニューに戻ります..."
}

# --- メインループ ---
while true; do
    clear
    display_status
    read -p "選択 (0-5): " choice

    case $choice in
        1) start_macro ;;
        2) stop_macro ;;
        3) reconnect_bt ;;
        4) run_test ;;
        5) continue ;;
        0) break ;;
        *)
            echo -e "${RED}無効な選択です。再入力してください${NC}"
            sleep 2
            ;;
    esac
done

clear
echo "終了します。"
EOF

chmod +x "$PROJECT_DIR/control_panel.sh"

# LとRボタンマクロの作成
cat > "$PROJECT_DIR/macros/press_lr.py" << 'EOF'
#!/usr/bin/env python3
"""
Nintendo Switch LとRボタンを押すマクロ

Switchに接続してLとRボタンを同時に押す操作を実行します。
"""

import nxbt
import time

def main():
    print("🎮 Nintendo Switch マクロを開始します")
    print()

    # NXBTインスタンスの作成
    nx = nxbt.Nxbt()

    print("📡 利用可能なBluetoothアダプタ:")
    adapters = nx.get_available_adapters()
    for i, adapter in enumerate(adapters):
        print(f"  [{i}] {adapter}")
    print()

    if not adapters:
        print("❌ Bluetoothアダプタが見つかりません")
        return

    # Pro Controllerとして接続
    print("🔗 Nintendo Switchに接続中...")
    print("   Switch本体で「コントローラー」→「持ちかた/順番を変える」を開いてください")
    print()

    controller_index = nx.create_controller(
        nxbt.PRO_CONTROLLER,
        adapter_path=adapters[0]
    )

    nx.wait_for_connection(controller_index)
    print("✅ 接続に成功しました！")
    print()

    # LとRボタンを同時に押す
    print("🎮 LとRボタンを押します...")
    nx.press_buttons(controller_index, [nxbt.Buttons.L, nxbt.Buttons.R])
    time.sleep(0.5)
    nx.release_buttons(controller_index, [nxbt.Buttons.L, nxbt.Buttons.R])

    print()
    print("✅ マクロが完了しました")

    # 接続を解除
    nx.remove_controller(controller_index)
    print("👋 接続を解除しました")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n⚠️  ユーザーによって中断されました")
    except Exception as e:
        print(f"\n❌ エラーが発生しました: {e}")
EOF

chmod +x "$PROJECT_DIR/macros/press_lr.py"

# READMEの作成
cat > "$PROJECT_DIR/README.md" << 'EOF'
# Nintendo Switch マクロ環境

このプロジェクトは、Ubuntu上でNintendo Switchに対してBluetoothでコントローラーとして接続し、
自動操作（マクロ）を実行するための環境です。

## 📁 ディレクトリ構造

```
.
├── setup.sh           # セットアップスクリプト（最初に1回実行）
├── run_macro.sh       # マクロ実行スクリプト
├── macros/            # マクロスクリプトを配置するディレクトリ
│   └── press_lr.py    # LとRボタンを押すマクロ
├── src/               # 自作のPythonモジュール用
├── logs/              # ログファイル用
└── .venv/             # Python仮想環境（自動作成）
```

## 🚀 使い方

### 1. セットアップ（初回のみ）

```bash
chmod +x setup.sh
./setup.sh
```

### 2. Switch本体の準備

1. Switch本体で「設定」→「コントローラーとセンサー」→「コントローラー」を開く
2. 「持ちかた/順番を変える」画面を開く
3. この状態でマクロを実行すると、自動的に接続されます

### 3. マクロの実行

```bash
./run_macro.sh macros/press_lr.py
```

## 📝 マクロの作成

`macros/` ディレクトリにPythonスクリプトを作成してください。
`press_lr.py` を参考にすると良いでしょう。

### 基本的な使い方

```python
import nxbt
import time

nx = nxbt.Nxbt()
controller_index = nx.create_controller(nxbt.PRO_CONTROLLER)
nx.wait_for_connection(controller_index)

# ボタンを押す
nx.press_buttons(controller_index, [nxbt.Buttons.A])
time.sleep(0.1)
nx.release_buttons(controller_index, [nxbt.Buttons.A])

nx.remove_controller(controller_index)
```

### 利用可能なボタン

- `nxbt.Buttons.A`, `B`, `X`, `Y`
- `nxbt.Buttons.L`, `R`, `ZL`, `ZR`
- `nxbt.Buttons.PLUS`, `MINUS`, `HOME`, `CAPTURE`
- `nxbt.Buttons.DPAD_UP`, `DPAD_DOWN`, `DPAD_LEFT`, `DPAD_RIGHT`
- `nxbt.Buttons.L_STICK`, `R_STICK` (スティック押し込み)

## 🔧 トラブルシューティング

### 接続できない場合

1. Bluetoothが有効になっているか確認
   ```bash
   systemctl status bluetooth
   ```

2. 他のコントローラーとの接続を切断

3. Switch本体を再起動

### 権限エラーが出る場合

```bash
sudo usermod -a -G bluetooth $USER
# ログアウトして再ログインが必要
```

## 📚 参考リンク

- [nxbt GitHub](https://github.com/Brikwerk/nxbt)
- [nxbt ドキュメント](https://github.com/Brikwerk/nxbt/wiki)

## ⚠️ 注意事項

- このツールは教育・研究目的で使用してください
- ゲームの利用規約を遵守してください
- オンライン対戦での使用は控えてください
EOF

# --- 完了メッセージ ---
echo
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}   🎉 セットアップが完了しました！ 🎉${NC}"
echo -e "${GREEN}============================================${NC}"
echo
echo -e "${BLUE}📂 作成されたファイル・ディレクトリ:${NC}"
echo "  - .venv/             (Python仮想環境)"
echo "  - macros/            (マクロスクリプト)"
echo "  - src/               (自作モジュール)"
echo "  - logs/              (ログファイル)"
echo "  - run_macro.sh       (マクロ実行スクリプト)"
echo "  - control_panel.sh   (コントロールパネル)"
echo "  - README.md          (ドキュメント)"
echo
echo -e "${BLUE}📍 プロジェクトディレクトリ:${NC}"
echo "  ${GREEN}$PROJECT_DIR${NC}"
echo
if [ -d ".venv" ]; then
    echo -e "${GREEN}✅ 仮想環境: 作成済み${NC}"
else
    echo -e "${RED}❌ 仮想環境: 未作成${NC}"
fi
echo
echo -e "${YELLOW}📋 次のステップ:${NC}"
echo
echo "1. Switch本体で以下の操作を行ってください:"
echo "   「設定」→「コントローラーとセンサー」→「コントローラー」"
echo "   →「持ちかた/順番を変える」画面を開く"
echo
echo "2. コントロールパネルを起動:"
echo -e "   ${GREEN}./control_panel.sh${NC}"
echo
echo "   または、直接マクロを実行:"
echo -e "   ${GREEN}./run_macro.sh macros/press_lr.py${NC}"
echo
echo -e "${BLUE}📖 詳細はREADME.mdを参照してください${NC}"
echo
echo -e "${GREEN}============================================${NC}"
echo