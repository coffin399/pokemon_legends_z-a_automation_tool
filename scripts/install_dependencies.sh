#!/bin/bash

# ============================================
# Nintendo Switch マクロツール
# 依存関係インストールスクリプト（WSL内で実行）
# ============================================

set -e  # エラーが発生したら停止

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║                                                      ║"
echo "║     📦 依存関係のインストール開始                   ║"
echo "║                                                      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# ============================================
# 1. システムパッケージの更新
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 ステップ 1: システムパッケージの更新"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

sudo apt-get update -qq
echo "✅ パッケージリストの更新完了"
echo ""

# ============================================
# 2. 必須パッケージのインストール
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 ステップ 2: 必須パッケージのインストール"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "以下をインストールします:"
echo "  - Python 3.10+"
echo "  - pip (Pythonパッケージマネージャー)"
echo "  - venv (仮想環境)"
echo "  - Bluetoothツール (bluez, bluetooth)"
echo "  - ビルドツール (gcc, make, libdbus-1-dev)"
echo ""

sudo apt-get install -y -qq \
    python3 \
    python3-pip \
    python3-venv \
    bluez \
    bluetooth \
    libdbus-1-dev \
    libglib2.0-dev \
    gcc \
    make \
    git

echo "✅ 必須パッケージのインストール完了"
echo ""

# ============================================
# 3. Bluetoothサービスの設定
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📡 ステップ 3: Bluetoothサービスの設定"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Bluetoothサービスを開始
sudo service bluetooth start

# Bluetoothアダプタの確認
if hciconfig | grep -q "hci0"; then
    echo "✅ Bluetoothアダプタが検出されました"
    hciconfig hci0 | grep "BD Address"
else
    echo "⚠️ 警告: Bluetoothアダプタが検出されませんでした"
    echo ""
    echo "以下を確認してください:"
    echo "  1. PowerShellで以下を実行:"
    echo "     usbipd list"
    echo "  2. BluetoothアダプタのBUSIDを確認"
    echo "  3. 以下を実行:"
    echo "     usbipd bind --busid [BUSID]"
    echo "     usbipd attach --wsl --busid [BUSID]"
    echo ""
fi

echo ""

# ============================================
# 4. Python仮想環境の作成
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐍 ステップ 4: Python仮想環境の作成"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd ~/switch-macro

# 既存の仮想環境を削除（存在する場合）
if [ -d ".venv" ]; then
    echo "既存の仮想環境を削除中..."
    rm -rf .venv
fi

# 新しい仮想環境を作成
echo "仮想環境を作成中..."
python3 -m venv .venv

# 仮想環境をアクティブ化
source .venv/bin/activate

echo "✅ 仮想環境の作成完了"
echo ""

# ============================================
# 5. Pythonパッケージのインストール
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 ステップ 5: Pythonパッケージのインストール"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# pipをアップグレード
echo "pipをアップグレード中..."
pip install --upgrade pip -q

# requirements.txtからインストール
echo "必要なパッケージをインストール中..."
echo "  - NXBT (Nintendo Switch Bluetooth Library)"
echo "  - 依存パッケージ (dbus-python, blessed, etc.)"
echo ""
echo "※ これには数分かかる場合があります..."
echo ""

pip install -r requirements.txt

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Pythonパッケージのインストール完了"
else
    echo ""
    echo "❌ エラー: パッケージのインストールに失敗しました"
    exit 1
fi

echo ""

# ============================================
# 6. インストール確認
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ステップ 6: インストール確認"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "📋 インストールされたパッケージ:"
pip list | grep -E "nxbt|dbus|blessed"

echo ""
echo "🐍 Python バージョン:"
python3 --version

echo ""
echo "📡 Bluetooth バージョン:"
bluetoothctl --version

echo ""

# ============================================
# インストール完了
# ============================================

echo "╔══════════════════════════════════════════════════════╗"
echo "║                                                      ║"
echo "║     ✅ すべてのインストールが完了しました！         ║"
echo "║                                                      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

echo "📋 次のステップ:"
echo ""
echo "1. Bluetoothアダプタの接続（まだの場合）:"
echo "   PowerShellで:"
echo "   usbipd list"
echo "   usbipd bind --busid [BUSID]"
echo "   usbipd attach --wsl --busid [BUSID]"
echo ""
echo "2. マクロの実行:"
echo "   run_macro.bat をダブルクリック"
echo ""
echo "詳しくは README.md を参照してください！"
echo ""