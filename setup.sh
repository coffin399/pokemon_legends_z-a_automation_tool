#!/bin/bash

# エラーが発生した場合はスクリプトを終了する
set -e

# --- 色付け用の変数 ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# --- ヘッダー表示 ---
clear
echo -e "${BOLD}${CYAN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     Nintendo Switch マクロ環境セットアップ            ║"
echo "║     初心者でも簡単！自動でインストールします          ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo
echo -e "${BLUE}このスクリプトは以下のことを自動で行います:${NC}"
echo "  ✓ 必要なプログラムのインストール"
echo "  ✓ Bluetoothの設定"
echo "  ✓ Nintendo Switch接続用ライブラリのセットアップ"
echo "  ✓ マクロ実行環境の構築"
echo
echo -e "${YELLOW}所要時間: 約5〜10分${NC}"
echo
read -p "Enterキーを押して開始します..."
clear

# --- sudo権限の事前確認 ---
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${YELLOW}  管理者パスワードの入力${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${CYAN}システムにプログラムをインストールするため、${NC}"
echo -e "${CYAN}管理者パスワード（普段ログインするときのパスワード）が必要です。${NC}"
echo
echo -e "${YELLOW}💡 パスワードを入力しても画面には何も表示されませんが、${NC}"
echo -e "${YELLOW}   ちゃんと入力されています。入力後にEnterを押してください。${NC}"
echo
sudo -v

# sudoのタイムスタンプを更新し続ける
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

clear

# --- 動作環境チェック ---
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  ステップ 1/6: パソコンの環境をチェック中${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Pythonチェック
echo -n "Python3がインストールされているか確認中... "
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}✗${NC}"
    echo -e "${RED}エラー: Python3がインストールされていません${NC}"
    echo "Ubuntu 20.04以降であれば、通常は最初から入っています。"
    exit 1
fi
PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
echo -e "${GREEN}✓${NC} (バージョン: ${PYTHON_VERSION})"

# Bluetoothチェック
echo -n "Bluetoothが使えるか確認中... "
if ! command -v bluetoothctl &> /dev/null; then
    echo -e "${YELLOW}△${NC} (後でインストールします)"
else
    echo -e "${GREEN}✓${NC}"
fi

echo
echo -e "${GREEN}✓ 環境チェック完了！${NC}"
sleep 2
clear

# --- ステップ2: 依存関係のインストール ---
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  ステップ 2/6: 必要なプログラムをインストール${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${CYAN}Nintendo Switchと通信するために必要なプログラムを${NC}"
echo -e "${CYAN}インターネットからダウンロードしてインストールします。${NC}"
echo
echo -e "${YELLOW}💡 少し時間がかかります。コーヒーでも飲んでお待ちください☕${NC}"
echo

# パッケージリストの更新
echo "プログラムリストを最新に更新中..."
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

echo
echo -e "${CYAN}以下のプログラムをインストールします:${NC}"
echo "  • Python開発ツール"
echo "  • Bluetooth通信ライブラリ"
echo "  • その他の必要なツール"
echo

sudo apt install -y "${PACKAGES[@]}" 2>&1 | grep -v "^Selecting" | grep -v "^Preparing" || true

echo
echo -e "${GREEN}✓ プログラムのインストール完了！${NC}"
sleep 2
clear

# --- ステップ3: Bluetoothサービスの設定 ---
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  ステップ 3/6: Bluetoothの設定${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${CYAN}Switchとワイヤレスで通信するためにBluetoothを設定します。${NC}"
echo

# Bluetoothサービスの有効化
echo -n "Bluetoothサービスを起動中... "
sudo systemctl enable bluetooth > /dev/null 2>&1
sudo systemctl start bluetooth
echo -e "${GREEN}✓${NC}"

# rfkillでブロックされていないか確認・解除
if command -v rfkill &> /dev/null; then
    echo -n "Bluetoothのブロックを解除中... "
    sudo rfkill unblock bluetooth
    echo -e "${GREEN}✓${NC}"
fi

# Bluetoothサービスの状態確認
echo -n "Bluetooth動作確認中... "
if systemctl is-active --quiet bluetooth; then
    echo -e "${GREEN}✓ 正常に動作しています${NC}"
else
    echo -e "${RED}✗ エラーが発生しました${NC}"
    exit 1
fi

# ユーザーをbluetoothグループに追加
echo -n "Bluetoothの使用権限を設定中... "
if ! groups $USER | grep -q '\bbluetooth\b'; then
    sudo usermod -a -G bluetooth $USER
    echo -e "${GREEN}✓${NC}"
    NEED_RELOGIN=true
else
    echo -e "${GREEN}✓ (設定済み)${NC}"
fi

# Bluetooth設定ディレクトリの権限設定
echo -n "Bluetooth設定フォルダを準備中... "
sudo mkdir -p /var/run/bluetooth
sudo chmod 755 /var/run/bluetooth

# nxbtが使用するsystemd設定ディレクトリも作成
sudo mkdir -p /run/systemd/system/bluetooth.service.d
sudo chmod 755 /run/systemd/system/bluetooth.service.d

# systemd設定ディレクトリにも権限を設定
sudo mkdir -p /etc/systemd/system/bluetooth.service.d
sudo chmod 755 /etc/systemd/system/bluetooth.service.d

echo -e "${GREEN}✓${NC}"

# D-Bus設定ファイルの作成（nxbt用）
echo -n "通信設定ファイルを作成中... "
sudo tee /etc/dbus-1/system.d/nxbt.conf > /dev/null << 'DBUS_EOF'
<!DOCTYPE busconfig PUBLIC
 "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>
  <policy group="bluetooth">
    <allow send_destination="org.bluez"/>
    <allow send_interface="org.bluez.Agent1"/>
    <allow send_interface="org.bluez.MediaEndpoint1"/>
    <allow send_interface="org.bluez.MediaPlayer1"/>
    <allow send_interface="org.bluez.ThermometerWatcher1"/>
    <allow send_interface="org.bluez.AlertAgent1"/>
    <allow send_interface="org.bluez.Profile1"/>
    <allow send_interface="org.bluez.HeartRateWatcher1"/>
    <allow send_interface="org.bluez.CyclingSpeedWatcher1"/>
    <allow send_interface="org.bluez.GattCharacteristic1"/>
    <allow send_interface="org.bluez.GattDescriptor1"/>
    <allow send_interface="org.freedesktop.DBus.ObjectManager"/>
    <allow send_interface="org.freedesktop.DBus.Properties"/>
  </policy>
</busconfig>
DBUS_EOF
echo -e "${GREEN}✓${NC}"

# D-Busサービスを再読み込み
echo -n "設定を反映中... "
sudo systemctl reload dbus
echo -e "${GREEN}✓${NC}"

echo
echo -e "${GREEN}✓ Bluetoothの設定完了！${NC}"
sleep 2
clear

# --- ステップ4: プロジェクトディレクトリの準備 ---
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  ステップ 4/6: 作業フォルダの準備${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${CYAN}マクロを保存するフォルダを作成します。${NC}"
echo

# このスクリプトがあるディレクトリをプロジェクトディレクトリとする
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$PROJECT_DIR"

echo -e "作業フォルダの場所: ${YELLOW}$PROJECT_DIR${NC}"
echo

# 必要なディレクトリを作成
echo -n "必要なフォルダを作成中... "
mkdir -p "$PROJECT_DIR/src"
mkdir -p "$PROJECT_DIR/macros"
mkdir -p "$PROJECT_DIR/logs"
echo -e "${GREEN}✓${NC}"

echo "  📁 macros/ ← ここにマクロを保存します"
echo "  📁 src/    ← 自作のプログラムを保存します"
echo "  📁 logs/   ← 実行記録を保存します"

echo
echo -e "${GREEN}✓ フォルダの準備完了！${NC}"
sleep 2
clear

# --- ステップ5: Python仮想環境のセットアップ ---
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  ステップ 5/6: Python実行環境の準備${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${CYAN}このプロジェクト専用のPython環境を作成します。${NC}"
echo -e "${CYAN}（他のPythonプログラムに影響を与えないようにするためです）${NC}"
echo

# 仮想環境の作成
if [ -d ".venv" ]; then
    echo -e "${YELLOW}既存の環境が見つかりました。${NC}"
    read -p "削除して作り直しますか？ (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -n "既存環境を削除中... "
        rm -rf .venv
        echo -e "${GREEN}✓${NC}"
    else
        echo "既存環境を使用します。"
    fi
fi

if [ ! -d ".venv" ]; then
    echo -n "Python専用環境を作成中... "
    python3 -m venv .venv

    # 作成確認
    if [ -d ".venv" ]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ 作成に失敗しました${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ 既存環境を使用します${NC}"
fi

echo -n "Python環境を起動中... "
if [ ! -f ".venv/bin/activate" ]; then
    echo -e "${RED}✗ エラー: 環境が正しく作成されませんでした${NC}"
    exit 1
fi

source .venv/bin/activate

if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "${RED}✗ 起動に失敗しました${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC}"

# pipのアップグレード
echo -n "パッケージ管理ツールを更新中... "
pip install --upgrade pip -q
echo -e "${GREEN}✓${NC}"

echo
echo -e "${GREEN}✓ Python環境の準備完了！${NC}"
sleep 2
clear

# --- ステップ6: Pythonライブラリのインストール ---
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${BLUE}  ステップ 6/6: Nintendo Switch用ライブラリのインストール${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${CYAN}Switchと通信するための専用ライブラリをインストールします。${NC}"
echo

# システムパッケージへのシンボリックリンクを作成する関数
create_system_links() {
    PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
    VENV_SITE_PACKAGES="$PROJECT_DIR/.venv/lib/python${PYTHON_VERSION}/site-packages"

    echo "必要なライブラリをリンク中..."

    # PyGObject (gi)
    if [ -d "/usr/lib/python3/dist-packages/gi" ]; then
        ln -sf /usr/lib/python3/dist-packages/gi "$VENV_SITE_PACKAGES/" 2>/dev/null || true
        echo "  ✓ PyGObject (画面表示用)"
    fi

    # Cairo
    if [ -d "/usr/lib/python3/dist-packages/cairo" ]; then
        ln -sf /usr/lib/python3/dist-packages/cairo "$VENV_SITE_PACKAGES/" 2>/dev/null || true
        echo "  ✓ Cairo (描画用)"
    fi

    # dbus-python
    if [ -d "/usr/lib/python3/dist-packages/dbus" ]; then
        ln -sf /usr/lib/python3/dist-packages/dbus "$VENV_SITE_PACKAGES/" 2>/dev/null || true
        echo "  ✓ D-Bus (通信用)"
    fi

    # _dbus_bindings と _dbus_glib_bindings (.so ファイル)
    for file in /usr/lib/python3/dist-packages/_dbus*.so; do
        if [ -f "$file" ]; then
            ln -sf "$file" "$VENV_SITE_PACKAGES/" 2>/dev/null || true
        fi
    done

    # .egg-info も必要な場合がある
    for dir in /usr/lib/python3/dist-packages/dbus*.egg-info; do
        if [ -d "$dir" ]; then
            ln -sf "$dir" "$VENV_SITE_PACKAGES/" 2>/dev/null || true
        fi
    done
}

create_system_links

echo
echo -n "Nintendo Switch通信ライブラリ (nxbt) をインストール中... "

# まず依存関係を確認
pip install blessed pynput -q

# nxbtを依存関係チェックなしでインストール（システムのdbus-pythonを使用）
pip install --no-deps nxbt -q

echo -e "${GREEN}✓${NC}"

echo
echo -e "${GREEN}✓ すべてのライブラリのインストール完了！${NC}"

deactivate

sleep 2
clear

# --- 起動スクリプトの作成 ---
echo -n "便利な起動スクリプトを作成中... "

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
    echo -e "${RED}❌ Python環境が見つかりません${NC}"
    echo "先に setup.sh を実行してください"
    exit 1
fi

# 仮想環境を有効化
source .venv/bin/activate

echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Nintendo Switch マクロ実行                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
echo

# 引数チェック
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}使い方: $0 <マクロファイル.py>${NC}"
    echo
    echo "📂 利用可能なマクロ:"
    if [ -d "macros" ] && [ "$(ls -A macros/*.py 2>/dev/null)" ]; then
        ls -1 macros/*.py | sed 's/^/  /'
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

echo -e "🎮 実行するマクロ: ${GREEN}$(basename "$MACRO_SCRIPT")${NC}"
echo

# マクロを実行
python3 "$MACRO_SCRIPT"

deactivate
EOF

chmod +x "$PROJECT_DIR/run_macro.sh"

# コントロールパネルの作成
cat > "$PROJECT_DIR/control_panel.sh" << 'EOF'
#!/bin/bash

# 色付け用の変数
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# 設定
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
MACRO_DIR="$PROJECT_DIR/macros"

# 状態表示
display_status() {
    echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║                                                ║${NC}"
    echo -e "${BOLD}${BLUE}║    Nintendo Switch マクロ コントロール         ║${NC}"
    echo -e "${BOLD}${BLUE}║                                                ║${NC}"
    echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════════╝${NC}"
    echo

    # 実行中のマクロを確認
    RUNNING_MACROS=$(pgrep -fa "python.*macros/.*\.py" | wc -l)
    if [ "$RUNNING_MACROS" -gt 0 ]; then
        echo -e "🎮 マクロの状態: ${GREEN}実行中${NC} (${RUNNING_MACROS}個)"
        echo
        echo "実行中のマクロ:"
        pgrep -fa "python.*macros/.*\.py" | sed 's/^/  /'
    else
        echo -e "🎮 マクロの状態: ${YELLOW}停止中${NC}"
    fi

    echo

    # Bluetooth状態確認
    if systemctl is-active --quiet bluetooth; then
        echo -e "📡 Bluetooth: ${GREEN}有効${NC}"
    else
        echo -e "📡 Bluetooth: ${RED}無効${NC}"
    fi

    # 仮想環境の確認
    if [ -d "$PROJECT_DIR/.venv" ]; then
        echo -e "🐍 Python環境: ${GREEN}準備OK${NC}"
    else
        echo -e "🐍 Python環境: ${RED}未作成${NC}"
    fi

    echo
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
    echo "  ${BOLD}[1]${NC} マクロを選んで実行する"
    echo "  ${BOLD}[2]${NC} 実行中のマクロを停止する"
    echo "  ${BOLD}[3]${NC} Bluetoothを再起動する"
    echo "  ${BOLD}[4]${NC} 環境をチェックする"
    echo "  ${BOLD}[5]${NC} 画面を更新する"
    echo "  ${BOLD}[0]${NC} 終了する"
    echo
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# マクロ選択と実行
start_macro() {
    clear
    echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║  マクロを選択                                  ║${NC}"
    echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════════╝${NC}"
    echo

    if [ ! -d "$MACRO_DIR" ]; then
        echo -e "${RED}❌ macrosフォルダが見つかりません${NC}"
        read -p "Enterで戻る..."
        return
    fi

    # .pyファイルを配列に格納
    mapfile -t MACROS < <(find "$MACRO_DIR" -maxdepth 1 -name "*.py" -type f | sort)

    if [ ${#MACROS[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠️  実行できるマクロがありません${NC}"
        echo
        echo "macros/ フォルダに .py ファイルを入れてください"
        echo
        read -p "Enterで戻る..."
        return
    fi

    echo "📂 利用可能なマクロ:"
    echo
    for i in "${!MACROS[@]}"; do
        MACRO_NAME=$(basename "${MACROS[$i]}")
        echo "    ${BOLD}[$((i+1))]${NC} $MACRO_NAME"
    done
    echo "    ${BOLD}[0]${NC} キャンセル"
    echo
    read -p "番号を選択 (0-${#MACROS[@]}): " choice

    if [ "$choice" = "0" ]; then
        return
    fi

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#MACROS[@]} ]; then
        echo -e "${RED}❌ 無効な番号です${NC}"
        sleep 2
        return
    fi

    SELECTED_MACRO="${MACROS[$((choice-1))]}"
    clear
    echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${GREEN}║  マクロを起動します                            ║${NC}"
    echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "選択したマクロ: ${GREEN}$(basename "$SELECTED_MACRO")${NC}"
    echo
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📱 Nintendo Switchで以下の操作をしてください:${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
    echo "  1. HOMEボタンを押す"
    echo "  2. 「コントローラー」を選ぶ"
    echo "  3. 「持ちかた/順番を変える」を選ぶ"
    echo "  4. この画面を開いたままにする"
    echo
    read -p "準備ができたらEnterを押してください..."

    if [ ! -f "$PROJECT_DIR/.venv/bin/activate" ]; then
        echo -e "${RED}❌ Python環境が見つかりません${NC}"
        echo "setup.sh を実行してください"
        read -p "Enterで戻る..."
        return
    fi

    echo
    echo "🚀 マクロを起動しています..."
    sleep 1

    # 新しいターミナルで実行
    if command -v gnome-terminal &> /dev/null; then
        gnome-terminal -- bash -c "cd '$PROJECT_DIR' && source .venv/bin/activate && python3 '$SELECTED_MACRO'; echo; echo '✅ マクロが終了しました'; echo 'このウィンドウを閉じてください'; read"
    elif command -v xterm &> /dev/null; then
        xterm -hold -e "cd '$PROJECT_DIR' && source .venv/bin/activate && python3 '$SELECTED_MACRO'" &
    else
        cd "$PROJECT_DIR"
        source .venv/bin/activate
        python3 "$SELECTED_MACRO"
        read -p "Enterで戻る..."
        return
    fi

    sleep 2
    echo
    echo -e "${GREEN}✅ マクロを起動しました！${NC}"
    echo "新しいウィンドウで実行されています"
    echo
    read -p "Enterで戻る..."
}

# マクロ停止
stop_macro() {
    clear
    echo -e "${BOLD}${YELLOW}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${YELLOW}║  マクロを停止                                  ║${NC}"
    echo -e "${BOLD}${YELLOW}╚════════════════════════════════════════════════╝${NC}"
    echo

    # 実行中のマクロを検索
    MACRO_PIDS=$(pgrep -f "python.*macros/.*\.py")

    if [ -z "$MACRO_PIDS" ]; then
        echo -e "${YELLOW}ℹ️  実行中のマクロはありません${NC}"
    else
        echo "実行中のマクロ:"
        pgrep -fa "python.*macros/.*\.py"
        echo
        read -p "これらを停止しますか？ (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            pkill -f "python.*macros/.*\.py"
            echo -e "${GREEN}✅ マクロを停止しました${NC}"
        else
            echo "キャンセルしました"
        fi
    fi
    echo
    read -p "Enterで戻る..."
}

# Bluetooth再起動
reconnect_bt() {
    clear
    echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║  Bluetoothを再起動                             ║${NC}"
    echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════════╝${NC}"
    echo
    echo "🔄 Bluetoothサービスを再起動中..."
    sudo systemctl restart bluetooth

    if [ $? -eq 0 ]; then
        echo "⏳ 起動を待っています... (3秒)"
        sleep 3

        if systemctl is-active --quiet bluetooth; then
            echo -e "${GREEN}✅ Bluetoothが起動しました${NC}"
        else
            echo -e "${RED}❌ 起動に失敗しました${NC}"
        fi
    else
        echo -e "${RED}❌ 再起動コマンドが失敗しました${NC}"
    fi
    echo
    read -p "Enterで戻る..."
}

# 環境チェック
run_test() {
    clear
    echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${GREEN}║  環境チェック                                  ║${NC}"
    echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════╝${NC}"
    echo

    # 1. プロジェクトディレクトリ
    echo -n "[1/6] 📁 プロジェクトフォルダ... "
    if [ -d "$PROJECT_DIR" ]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi

    # 2. Python仮想環境
    echo -n "[2/6] 🐍 Python環境... "
    if [ -f "$PROJECT_DIR/.venv/bin/activate" ]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ 未作成${NC}"
    fi

    # 3. NXBT
    echo -n "[3/6] 📦 NXBTライブラリ... "
    if [ -f "$PROJECT_DIR/.venv/bin/python3" ]; then
        if "$PROJECT_DIR/.venv/bin/python3" -c "import nxbt" 2>/dev/null; then
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${RED}✗ インポートエラー${NC}"
        fi
    else
        echo -e "${RED}✗ Python未作成${NC}"
    fi

    # 4. マクロディレクトリ
    echo -n "[4/6] 📂 マクロフォルダ... "
    if [ -d "$MACRO_DIR" ]; then
        MACRO_COUNT=$(find "$MACRO_DIR" -maxdepth 1 -name "*.py" -type f | wc -l)
        echo -e "${GREEN}✓${NC} ($MACRO_COUNT 個)"
    else
        echo -e "${RED}✗ 未作成${NC}"
    fi

    # 5. Bluetoothサービス
    echo -n "[5/6] 📡 Bluetoothサービス... "
    if systemctl is-active --quiet bluetooth; then
        echo -e "${GREEN}✓ 実行中${NC}"
    else
        echo -e "${RED}✗ 停止中${NC}"
    fi

    # 6. Bluetoothグループ
    echo -n "[6/6] 👤 Bluetooth権限... "
    if groups $USER | grep -q '\bbluetooth\b'; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ 権限なし${NC}"
        echo
        echo -e "${YELLOW}⚠️  ログアウト→ログインが必要かもしれません${NC}"
    fi

    echo
    echo -e "${GREEN}✅ チェック完了${NC}"
    read -p "Enterで戻る..."
}

# メインループ
while true; do
    clear
    display_status
    echo
    read -p "👉 番号を選択してください (0-5): " choice

    case $choice in
        1) start_macro ;;
        2) stop_macro ;;
        3) reconnect_bt ;;
        4) run_test ;;
        5) continue ;;
        0) break ;;
        *)
            echo -e "${RED}❌ 無効な番号です${NC}"
            sleep 2
            ;;
    esac
done

clear
echo "👋 終了します"
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
import os
import sys

def main():
    print("=" * 50)
    print(" Nintendo Switch マクロを開始します")
    print("=" * 50)
    print()

    # 権限チェック
    if os.geteuid() != 0:
        print("⚠️  このマクロは管理者権限が必要です")
        print()
        print("再実行しています...")
        print()
        # sudoで自分自身を再実行
        os.execvp('sudo', ['sudo', 'python3'] + sys.argv)

    # NXBTインスタンスの作成
    print("🔧 初期化中...")
    try:
        nx = nxbt.Nxbt()
    except Exception as e:
        print(f"❌ 初期化エラー: {e}")
        print()
        print("対処方法:")
        print("  1. Bluetoothサービスを再起動してみてください")
        print("     sudo systemctl restart bluetooth")
        print("  2. もう一度マクロを実行してください")
        return

    print()
    print("📡 利用可能なBluetoothアダプタ:")
    adapters = nx.get_available_adapters()
    for i, adapter in enumerate(adapters):
        print(f"  [{i}] {adapter}")
    print()

    if not adapters:
        print("❌ Bluetoothアダプタが見つかりません")
        print()
        print("対処方法:")
        print("  1. Bluetoothが有効になっているか確認")
        print("  2. コントロールパネルから「Bluetoothを再起動」を試す")
        return

    # Pro Controllerとして接続
    print("=" * 50)
    print(" Switchに接続します")
    print("=" * 50)
    print()
    print("📱 Switch本体で以下の操作をしてください:")
    print("  1. HOMEボタンを押す")
    print("  2. 「コントローラー」を選ぶ")
    print("  3. 「持ちかた/順番を変える」を選ぶ")
    print()
    print("🔗 接続を待っています...")
    print()

    try:
        controller_index = nx.create_controller(
            nxbt.PRO_CONTROLLER,
            adapter_path=adapters[0]
        )

        nx.wait_for_connection(controller_index)
        print()
        print("✅ 接続に成功しました！")
        print()

        # 少し待機
        time.sleep(1)

        # LとRボタンを同時に押す
        print("=" * 50)
        print(" マクロを実行します")
        print("=" * 50)
        print()
        print("🎮 LボタンとRボタンを同時に押します...")

        nx.press_buttons(controller_index, [nxbt.Buttons.L, nxbt.Buttons.R])
        time.sleep(0.5)
        nx.release_buttons(controller_index, [nxbt.Buttons.L, nxbt.Buttons.R])

        print("✅ ボタンを押しました")

        # 少し待機してから切断
        time.sleep(1)

        print()
        print("=" * 50)
        print(" マクロが完了しました")
        print("=" * 50)

        # 接続を解除
        nx.remove_controller(controller_index)
        print()
        print("👋 Switchとの接続を解除しました")

    except Exception as e:
        print()
        print(f"❌ エラーが発生しました: {e}")
        print()
        print("対処方法:")
        print("  1. Switchの「持ちかた/順番を変える」画面を開いているか確認")
        print("  2. Bluetoothが有効になっているか確認")
        print("  3. 他のコントローラーを切断してみる")
        print("  4. Bluetoothサービスを再起動:")
        print("     sudo systemctl restart bluetooth")
        return

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print()
        print("⚠️  ユーザーによって中断されました")
    except Exception as e:
        print()
        print(f"❌ 予期しないエラー: {e}")
EOF

chmod +x "$PROJECT_DIR/macros/press_lr.py"

# READMEの作成
cat > "$PROJECT_DIR/README.md" << 'EOF'
# 🎮 Nintendo Switch マクロ環境

初心者でも簡単！Nintendo Switchに自動でコントローラー操作を送信できます。

## 📖 このプロジェクトでできること

- パソコンからSwitchにBluetoothで接続
- コントローラー操作を自動化（マクロ）
- 自分でカスタムマクロを作成

## 🚀 使い方（3ステップ）

### ステップ1: セットアップ（最初に1回だけ）

```bash
chmod +x setup.sh
./setup.sh
```

**重要:** セットアップ後、ログアウト→ログインしてください

### ステップ2: ログアウト→ログイン

1. 画面右上の電源ボタンをクリック
2. 「ログアウト」を選択
3. 再度ログインする

または、ターミナルで：
```bash
gnome-session-quit --logout --no-prompt
```

### ステップ3: マクロを実行

```bash
./control_panel.sh
```

コントロールパネルで「1」を選んでマクロを実行します。

## 📁 フォルダ構成

```
.
├── setup.sh           ← 最初に実行（1回だけ）
├── control_panel.sh   ← マクロを実行するときに使う
├── run_macro.sh       ← 直接マクロを実行したいとき用
├── macros/            ← マクロを保存するフォルダ
│   └── press_lr.py    ← サンプルマクロ（LとRボタン）
├── src/               ← 自作プログラム用
├── logs/              ← 実行記録用
└── .venv/             ← Python環境（自動作成）
```

## 🎯 マクロの実行手順

1. **コントロールパネルを起動**
   ```bash
   ./control_panel.sh
   ```

2. **Switch本体で準備**
   - HOMEボタンを押す
   - 「コントローラー」を選ぶ
   - 「持ちかた/順番を変える」を開く

3. **マクロを選択**
   - コントロールパネルで「1」を入力
   - 実行したいマクロを番号で選ぶ
   - Enterキーを押す

4. **自動で実行されます！**

## 📝 自分でマクロを作る

`macros/` フォルダに `.py` ファイルを作成してください。

### 簡単な例：Aボタンを押す

```python
import nxbt
import time

nx = nxbt.Nxbt()
adapters = nx.get_available_adapters()

# 接続
controller = nx.create_controller(nxbt.PRO_CONTROLLER, adapter_path=adapters[0])
nx.wait_for_connection(controller)

# Aボタンを押す
nx.press_buttons(controller, [nxbt.Buttons.A])
time.sleep(0.1)
nx.release_buttons(controller, [nxbt.Buttons.A])

# 切断
nx.remove_controller(controller)
```

### 使えるボタン一覧

- **メインボタン**: `A`, `B`, `X`, `Y`
- **トリガー**: `L`, `R`, `ZL`, `ZR`
- **システム**: `PLUS`, `MINUS`, `HOME`, `CAPTURE`
- **十字キー**: `DPAD_UP`, `DPAD_DOWN`, `DPAD_LEFT`, `DPAD_RIGHT`
- **スティック**: `L_STICK`, `R_STICK`（押し込み）

## ❓ トラブルシューティング

### 「Permission denied」エラーが出る

→ ログアウト→ログインしましたか？

確認方法：
```bash
groups
```
`bluetooth` が表示されればOK

### 「Bluetoothアダプタが見つかりません」

→ Bluetoothを再起動してください
1. コントロールパネルで「3」を選択
2. または: `sudo systemctl restart bluetooth`

### 接続できない

1. Switchの「持ちかた/順番を変える」画面を開いていますか？
2. 他のコントローラーを切断してみてください
3. Switch本体を再起動してみてください

### マクロが動かない

1. コントロールパネルで「4」を選んで環境チェック
2. すべて「✓」になっているか確認

## ⚠️ 注意事項

- このツールは教育・研究目的で使用してください
- ゲームの利用規約を守ってください
- オンライン対戦では使わないでください

## 🔗 参考リンク

- [nxbt GitHub](https://github.com/Brikwerk/nxbt)
- [nxbt ドキュメント](https://github.com/Brikwerk/nxbt/wiki)

---

何か問題がありましたか？
setup.sh を再実行するか、README.mdをよく読んでください。
EOF

echo -e "${GREEN}✓${NC}"

sleep 1
clear

# --- 完了メッセージ ---
echo
echo -e "${BOLD}${GREEN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║           🎉 セットアップ完了！ 🎉                    ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo
echo -e "${BLUE}📂 作成されたファイル:${NC}"
echo "  ✓ .venv/             (Python実行環境)"
echo "  ✓ macros/            (マクロ保存フォルダ)"
echo "  ✓ control_panel.sh   (コントロールパネル)"
echo "  ✓ run_macro.sh       (マクロ実行スクリプト)"
echo "  ✓ README.md          (使い方ガイド)"
echo
echo -e "${BLUE}📍 プロジェクトの場所:${NC}"
echo -e "  ${YELLOW}$PROJECT_DIR${NC}"
echo

# 再ログインが必要かチェック
if [ "$NEED_RELOGIN" = true ]; then
    echo
    echo -e "${BOLD}${RED}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${RED}║                                                        ║${NC}"
    echo -e "${BOLD}${RED}║  ⚠️  重要: ログアウト→ログインが必要です ⚠️          ║${NC}"
    echo -e "${BOLD}${RED}║                                                        ║${NC}"
    echo -e "${BOLD}${RED}╚════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${YELLOW}Bluetoothの使用権限を有効にするため、${NC}"
    echo -e "${YELLOW}一度ログアウトして再ログインする必要があります。${NC}"
    echo
    echo -e "${CYAN}ログアウトの方法:${NC}"
    echo "  1. 画面右上の電源ボタンをクリック"
    echo "  2. 「ログアウト」を選択"
    echo "  3. 再度ログインする"
    echo
    echo -e "${CYAN}または、このコマンドを実行:${NC}"
    echo -e "  ${GREEN}gnome-session-quit --logout --no-prompt${NC}"
    echo
    echo -e "${CYAN}ログイン後、以下のコマンドで確認:${NC}"
    echo -e "  ${GREEN}groups${NC}"
    echo "  → 'bluetooth' が表示されればOK！"
    echo
    echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
fi

echo -e "${BOLD}${CYAN}📋 次にやること:${NC}"
echo

if [ "$NEED_RELOGIN" = true ]; then
    echo -e "${YELLOW}1. ログアウト→ログイン（忘れずに！）${NC}"
    echo
    echo "2. ログイン後、以下のコマンドを実行:"
else
    echo "1. 以下のコマンドを実行:"
fi

echo -e "   ${BOLD}${GREEN}./control_panel.sh${NC}"
echo
echo "3. Switch本体で準備:"
echo "   - HOMEボタンを押す"
echo "   - 「コントローラー」を選ぶ"
echo "   - 「持ちかた/順番を変える」を開く"
echo
echo "4. コントロールパネルで「1」を選んでマクロを実行！"
echo
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${GREEN}詳しい使い方は README.md を読んでください${NC}"
echo
echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║  準備完了！楽しいマクロライフを！ 🎮               ║${NC}"
echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
echo