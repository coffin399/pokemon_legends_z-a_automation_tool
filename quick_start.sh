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
    echo -e "${YELLOW}既存の仮想環境が見つかりました${NC}"
    read -p "削除して再作成しますか？ (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf .venv
        echo "既存の仮想環境を削除しました"
    fi
fi

if [ ! -d ".venv" ]; then
    echo "Python仮想環境を作成しています..."
    python3 -m venv .venv
    echo -e "${GREEN}✅ 仮想環境を作成しました${NC}"
else
    echo "既存の仮想環境を使用します"
fi

# 仮想環境を有効化
echo "仮想環境を有効化しています..."
source .venv/bin/activate

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
echo -e "${YELLOW}📋 次のステップ:${NC}"
echo
echo "1. Switch本体で以下の操作を行ってください:"
echo "   「設定」→「コントローラーとセンサー」→「コントローラー」"
echo "   →「持ちかた/順番を変える」画面を開く"
echo
echo "2. サンプルマクロを実行してみましょう:"
echo -e "   ${GREEN}./run_macro.sh macros/press_lr.py${NC}"
echo
echo "3. 独自のマクロを作成する場合:"
echo "   macros/ ディレクトリにPythonスクリプトを作成してください"
echo "   press_lr.py を参考にすると良いでしょう"
echo
echo -e "${BLUE}📖 詳細はREADME.mdを参照してください${NC}"
echo
echo -e "${GREEN}============================================${NC}"
echo