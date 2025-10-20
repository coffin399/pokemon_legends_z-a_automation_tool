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
mkdir -p "$PROJECT_DIR/logs"
echo -e "${GREEN}✓${NC}"

echo "  📁 src/    ← ここにマクロを保存します"
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

# --- 完了メッセージ ---
echo
echo -e "${BOLD}${GREEN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║           🎉 環境構築完了！ 🎉                      ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo
echo -e "${BLUE}📂 準備されたフォルダ:${NC}"
echo "  ✓ .venv/             (Python実行環境)"
echo "  ✓ src/               (マクロ保存フォルダ)"
echo "  ✓ logs/              (ログ保存フォルダ)"
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
    echo "2. ログイン後、src/ フォルダに自作のマクロ (.py) を配置してください。"
else
    echo "1. src/ フォルダに自作のマクロ (.py) を配置してください。"
fi

echo
echo "3. ターミナルから直接マクロを実行します。"
echo "   例:"
echo -e "   ${BOLD}${GREEN}sudo .venv/bin/python3 src/あなたのマクロ.py${NC}"
echo
echo "4. Switch本体で準備:"
echo "   - HOMEボタンを押す"
echo "   - 「コントローラー」を選ぶ"
echo "   - 「持ちかた/順番を変える」を開く"
echo
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║  準備完了！楽しいマクロライフを！ 🎮               ║${NC}"
echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
echo