#!/bin/bash
# WSL環境自動構築スクリプト

set -e  # エラーで停止

echo "========================================="
echo "  Switch Macro WSL環境セットアップ"
echo "========================================="
echo ""

# 出力を抑制してスムーズに
export DEBIAN_FRONTEND=noninteractive

echo "[1/6] システムアップデート中..."
sudo apt-get update -qq > /dev/null 2>&1
sudo apt-get upgrade -y -qq > /dev/null 2>&1
echo "✓ 完了"

echo "[2/6] 必要なパッケージをインストール中..."
sudo apt-get install -y -qq \
    python3 \
    python3-pip \
    python3-dev \
    git \
    bluez \
    libbluetooth-dev \
    libglib2.0-dev \
    libdbus-1-dev \
    libgirepository1.0-dev \
    libcairo2-dev \
    pkg-config > /dev/null 2>&1
echo "✓ 完了"

echo "[3/6] Python環境セットアップ中..."
pip3 install --upgrade pip setuptools wheel -q > /dev/null 2>&1
echo "✓ 完了"

echo "[4/6] NXBT依存関係インストール中..."
pip3 install pydbus PyGObject -q > /dev/null 2>&1
echo "✓ 完了"

echo "[5/6] NXBTインストール中..."
pip3 install nxbt -q > /dev/null 2>&1
echo "✓ 完了"

echo "[6/6] Bluetoothサービス設定中..."
sudo service dbus start > /dev/null 2>&1
sudo service bluetooth start > /dev/null 2>&1
echo "✓ 完了"

# 環境変数設定
if ! grep -q "export PATH=\$PATH:~/.local/bin" ~/.bashrc; then
    echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
fi

echo ""
echo "========================================="
echo "  ✅ セットアップ完了！"
echo "========================================="
echo ""
echo "インストールされたバージョン:"
python3 --version
pip3 --version
~/.local/bin/nxbt --version 2>/dev/null || echo "NXBT: インストール済み"
echo ""