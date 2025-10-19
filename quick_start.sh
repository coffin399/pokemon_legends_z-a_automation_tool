#!/bin/bash

# エラーが発生した場合はスクリプトを終了する
set -e

# --- 色付け用の変数 ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- ヘッダー表示 ---
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN} Nintendo Switch マクロ環境 (nxbt)           ${NC}"
echo -e "${GREEN} ワンクリックセットアップスクリプト for Ubuntu ${NC}"
echo -e "${GREEN}============================================${NC}"
echo

# --- sudo権限の事前確認 ---
echo -e "${YELLOW}システムパッケージのインストールには管理者権限が必要です。${NC}"
sudo -v
# sudoのタイムスタンプを更新し続ける
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- ステップ1: 依存関係のインストール ---
echo -e "${GREEN}[ステップ 1/4] 必要なパッケージをインストールします...${NC}"
sudo apt update

# apt-getをaptに変更し、コマンドを複数行に分割して安定性を向上
sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    bluez \
    libbluetooth-dev \
    libhidapi-dev \
    git \
    build-essential \
    libdbus-1-dev \
    python3-dev \
    pkg-config

echo -e "${GREEN}✅ パッケージのインストールが完了しました。${NC}"
echo

# --- ステップ2: Bluetoothサービスの有効化 ---
echo -e "${GREEN}[ステップ 2/4] Bluetoothサービスを有効化します...${NC}"
sudo systemctl enable --now bluetooth
# rfkillでブロックされていないか確認・解除
if command -v rfkill &> /dev/null; then
    sudo rfkill unblock bluetooth
fi
echo -e "${GREEN}✅ Bluetoothサービスが有効になりました。${NC}"
echo

# --- ステップ3: プロジェクトのセットアップ ---
# このスクリプトがあるディレクトリをプロジェクトディレクトリとする
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
mkdir -p "$PROJECT_DIR/src"
cd "$PROJECT_DIR"

echo -e "${GREEN}[ステップ 3/4] Python仮想環境とnxbtをセットアップします...${NC}"
echo "プロジェクトディレクトリ: $PROJECT_DIR"

# 仮想環境の作成
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
    echo "仮想環境を作成しました。"
fi

# 仮想環境を有効化してnxbtをインストール
source .venv/bin/activate
pip install --upgrade pip
pip install nxbt
deactivate # 一旦無効化しておく

echo -e "${GREEN}✅ nxbtのインストールが完了しました。${NC}"
echo

# --- ステップ4: 完了メッセージ ---
# マクロファイルは既に存在すると仮定し、完了メッセージのみ表示

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}🎉 セットアップがすべて完了しました！ 🎉${NC}"
echo -e "${GREEN}============================================${NC}"
echo
echo -e "${YELLOW}📋 次のステップ:${NC}"
echo "1. Switch本体で「コントローラー」メニューを開き、「持ちかた/順番を変える」画面にしてください。"
echo
echo "2. 以下のコマンドを実行して、コントロールパネルを起動します:"
echo
echo -e "   ${GREEN}./control_panel.sh${NC}"
echo