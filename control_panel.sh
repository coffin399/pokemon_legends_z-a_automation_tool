#!/bin/bash

# --- 色付け用の変数 ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- 設定 ---
PROJECT_DIR="$HOME/switch-macro"
MACRO_SCRIPT="src/switch_macro.py"

# --- 関数定義 ---

# 状態表示
display_status() {
    echo "========================================"
    echo "  Nintendo Switch マクロ コントロールパネル"
    echo "========================================"
    echo

    # マクロ状態確認
    if pgrep -f "$MACRO_SCRIPT" > /dev/null; then
        echo -e "状態      : ${GREEN}[実行中]${NC} マクロ実行中"
    else
        echo -e "状態      : ${YELLOW}[停止中]${NC} マクロ停止中"
    fi

    # Bluetooth状態確認
    if hciconfig 2>/dev/null | grep -q "UP RUNNING"; then
        echo -e "Bluetooth : ${GREEN}[接続済]${NC} アダプタ有効"
    else
        echo -e "Bluetooth : ${RED}[未接続]${NC} アダプタ無効またはエラー"
    fi

    echo
    echo "========================================"
    echo
    echo "[1] マクロ開始"
    echo "[2] マクロ停止"
    echo "[3] Bluetooth再起動"
    echo "[4] 環境チェック"
    echo "[5] 状態を更新"
    echo "[0] 終了"
    echo
    echo "========================================"
}

# マクロ開始
start_macro() {
    clear
    echo "========================================"
    echo "  マクロ開始"
    echo "========================================"
    echo
    if pgrep -f "$MACRO_SCRIPT" > /dev/null; then
        echo -e "${YELLOW}[警告] マクロは既に実行中です。${NC}"
        read -p "Enterキーを押してメニューに戻ります..."
        return
    fi

    echo "Switchで「持ちかた/順番を変える」を開いてください"
    read -p "準備ができたらEnterキーを押してください..."

    echo "マクロを新しいウィンドウで起動中..."

    # gnome-terminalを使って別ウィンドウで実行
    gnome-terminal -- bash -c "cd '$PROJECT_DIR' && source .venv/bin/activate && sudo python3 '$MACRO_SCRIPT'; exec bash"

    sleep 2
    echo
    echo -e "${GREEN}[完了] マクロを起動しました。${NC}"
    echo "   新しいターミナルウィンドウで実行中です。"
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
    if pgrep -f "$MACRO_SCRIPT" > /dev/null; then
        sudo pkill -f "$MACRO_SCRIPT"
        echo -e "${GREEN}[完了] マクロを停止しました。${NC}"
    else
        echo -e "${YELLOW}[情報] マクロは実行されていませんでした。${NC}"
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
        echo "サービス再起動コマンドを送信しました。"
        echo "アダプタの初期化を待っています... (5秒)"
        sleep 5

        echo
        echo "--- hciconfig の実行結果 ---"
        hciconfig
        echo "---------------------------"
        echo

        if hciconfig 2>/dev/null | grep -q "UP RUNNING"; then
            echo -e "${GREEN}[成功] Bluetoothアダプタが有効になりました！${NC}"
        else
            echo -e "${RED}[失敗] Bluetoothアダプタを有効にできませんでした。${NC}"
            echo "手動で 'sudo hciconfig hci0 up' などを試してください。"
        fi
    else
        echo -e "${RED}[エラー] Bluetoothサービスの再起動に失敗しました。${NC}"
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

    # 1. Python仮想環境
    echo -n "[1/4] Python仮想環境... "
    if [ -f "$PROJECT_DIR/.venv/bin/activate" ]; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[NG] .venvが見つかりません${NC}"
    fi

    # 2. NXBT
    echo -n "[2/4] NXBTライブラリ... "
    if [ -f "$PROJECT_DIR/.venv/bin/pip" ] && "$PROJECT_DIR/.venv/bin/pip" list 2>/dev/null | grep -q "nxbt"; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[NG] nxbtがインストールされていません${NC}"
    fi

    # 3. マクロファイル
    echo -n "[3/4] マクロファイル... "
    if [ -f "$PROJECT_DIR/$MACRO_SCRIPT" ]; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[NG] $MACRO_SCRIPT が見つかりません${NC}"
    fi

    # 4. Bluetoothサービス
    echo -n "[4/4] Bluetoothサービス... "
    if systemctl is-active --quiet bluetooth; then
        echo -e "${GREEN}[OK] 実行中${NC}"
    else
        echo -e "${RED}[NG] 停止中${NC}"
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
            echo -e "${RED}無効な選択です。再入力してください。${NC}"
            sleep 2
            ;;
    esac
done

clear
echo "終了します。"