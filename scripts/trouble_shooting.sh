#!/bin/bash

# ============================================
# Nintendo Switch マクロツール
# トラブルシューティングスクリプト
# ============================================

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║                                                      ║"
echo "║     🔧 トラブルシューティング診断ツール                    ║"
echo "║                                                      ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# ============================================
# 1. Python環境チェック
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐍 Python環境のチェック"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if command -v python3 &> /dev/null; then
    echo "✅ Python3: $(python3 --version)"
else
    echo "❌ Python3がインストールされていません"
fi

if [ -d "$HOME/switch-macro/.venv" ]; then
    echo "✅ 仮想環境: 存在します"

    source "$HOME/switch-macro/.venv/bin/activate"

    if pip list | grep -q "nxbt"; then
        echo "✅ NXBT: インストール済み ($(pip show nxbt | grep Version | cut -d' ' -f2))"
    else
        echo "❌ NXBT: インストールされていません"
        echo "   → pip install nxbt を実行してください"
    fi
else
    echo "❌ 仮想環境が見つかりません"
    echo "   → setup.bat を実行してください"
fi

echo ""

# ============================================
# 2. Bluetoothチェック
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📡 Bluetooth環境のチェック"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Bluetoothサービスの状態
if sudo service bluetooth status | grep -q "running"; then
    echo "✅ Bluetoothサービス: 起動中"
else
    echo "❌ Bluetoothサービス: 停止中"
    echo "   → sudo service bluetooth start を実行してください"
fi

# Bluetoothアダプタの検出
if hciconfig 2>/dev/null | grep -q "hci0"; then
    echo "✅ Bluetoothアダプタ: 検出されました"
    echo ""
    hciconfig hci0 | grep "BD Address"
    echo ""

    # アダプタの状態
    if hciconfig hci0 | grep -q "UP RUNNING"; then
        echo "✅ アダプタ状態: 動作中"
    else
        echo "⚠️ アダプタ状態: 停止中"
        echo "   → sudo hciconfig hci0 up を実行してください"
    fi
else
    echo "❌ Bluetoothアダプタ: 検出されませんでした"
    echo ""
    echo "   【解決方法】"
    echo "   PowerShell（管理者）で以下を実行:"
    echo "   1. usbipd list"
    echo "   2. BluetoothのBUSIDを確認"
    echo "   3. usbipd bind --busid [BUSID]"
    echo "   4. usbipd attach --wsl --busid [BUSID]"
fi

echo ""

# ============================================
# 3. ファイル構造チェック
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📁 ファイル構造のチェック"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd "$HOME/switch-macro" 2>/dev/null || {
    echo "❌ switch-macroディレクトリが見つかりません"
    exit 1
}

FILES=(
    "src/switch_macro.py"
    "requirements.txt"
    "scripts/install_dependencies.sh"
    ".venv/bin/activate"
)

for file in "${FILES[@]}"; do
    if [ -e "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (見つかりません)"
    fi
done

echo ""

# ============================================
# 4. 権限チェック
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔐 権限のチェック"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if sudo -n true 2>/dev/null; then
    echo "✅ sudo権限: 利用可能"
else
    echo "⚠️ sudo権限: パスワードが必要です"
    echo "   → マクロ実行時にパスワードを入力してください"
fi

echo ""

# ============================================
# 5. 推奨アクション
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💡 推奨アクション"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

ISSUES_FOUND=0

# Python環境の問題
if ! command -v python3 &> /dev/null || [ ! -d "$HOME/switch-macro/.venv" ]; then
    echo "⚠️ Python環境に問題があります"
    echo "   → setup.bat を再実行してください"
    ISSUES_FOUND=1
fi

# Bluetoothの問題
if ! hciconfig 2>/dev/null | grep -q "hci0"; then
    echo "⚠️ Bluetoothアダプタが検出されません"
    echo "   → README.mdの「Bluetooth設定」を参照してください"
    ISSUES_FOUND=1
fi

# Bluetoothサービスの問題
if ! sudo service bluetooth status | grep -q "running"; then
    echo "⚠️ Bluetoothサービスが起動していません"
    echo "   → sudo service bluetooth start を実行してください"
    ISSUES_FOUND=1
fi

if [ $ISSUES_FOUND -eq 0 ]; then
    echo "✅ すべての環境が正常です！"
    echo ""
    echo "マクロを実行できる状態です。"
    echo "run_macro.bat をダブルクリックしてください。"
fi

echo ""

# ============================================
# 6. 詳細ログ（オプション）
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 詳細ログを表示しますか？"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -p "詳細ログを表示しますか？ (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "=== システム情報 ==="
    uname -a
    echo ""

    echo "=== Python詳細 ==="
    python3 --version
    pip --version
    echo ""

    echo "=== インストール済みパッケージ ==="
    pip list
    echo ""

    echo "=== Bluetooth詳細 ==="
    hciconfig -a 2>/dev/null || echo "hciconfig: アダプタが見つかりません"
    echo ""

    echo "=== Bluetoothサービス詳細 ==="
    sudo service bluetooth status
    echo ""
fi

echo "診断完了！"
echo ""