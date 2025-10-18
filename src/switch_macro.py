#!/usr/bin/env python3
"""
Nintendo Switch 自動マクロツール
ZLを押しながらAボタンを自動連打するスクリプト
ENTERキーまたはCTRL+Yでマクロの開始/停止を切り替え
"""

import time
import sys
import threading
import select
from nxbt import Nxbt, PRO_CONTROLLER


class SwitchMacro:
    def __init__(self):
        """マクロ実行クラスの初期化"""
        print("🎮 Nintendo Switch マクロツール起動中...")
        self.nxbt = None
        self.controller_index = None
        self.is_running = False
        self.should_stop = False

    def connect(self):
        """Switchに接続"""
        try:
            print("\n📡 Bluetoothアダプタを検索中...")
            self.nxbt = Nxbt()

            print("🔌 Switchに接続中...")
            print("   ※ Switchで「持ちかた/順番を変える」画面を開いてください")

            self.controller_index = self.nxbt.create_controller(
                PRO_CONTROLLER,
                reconnect_address=self.nxbt.get_switch_addresses()
            )

            if self.controller_index is None:
                raise Exception("コントローラーの作成に失敗しました")

            # 接続の安定化のため少し待機
            time.sleep(2)

            print("✅ 接続成功！ コントローラーとして認識されました")
            return True

        except Exception as e:
            print(f"\n❌ エラー: {e}")
            print("\n以下を確認してください:")
            print("  1. Switchの「持ちかた/順番を変える」画面が開いているか")
            print("  2. Bluetoothアダプタが正しく接続されているか")
            print("  3. 他のコントローラーが接続されていないか")
            return False

    def press_button(self, button, duration=0.1):
        """
        ボタンを押す

        Args:
            button: ボタン名（例: "A", "B", "ZL"）
            duration: 押す時間（秒）
        """
        if self.controller_index is None:
            print("❌ エラー: コントローラーが接続されていません")
            return

        try:
            # ボタンを押す
            self.nxbt.press_buttons(self.controller_index, [button])
            time.sleep(duration)
            # ボタンを離す
            self.nxbt.release_buttons(self.controller_index, [button])
        except Exception as e:
            print(f"❌ ボタン操作エラー: {e}")

    def press_buttons(self, buttons, duration=0.1):
        """
        複数のボタンを同時に押す

        Args:
            buttons: ボタン名のリスト（例: ["ZL", "A"]）
            duration: 押す時間（秒）
        """
        if self.controller_index is None:
            print("❌ エラー: コントローラーが接続されていません")
            return

        try:
            # 複数ボタンを同時に押す
            self.nxbt.press_buttons(self.controller_index, buttons)
            time.sleep(duration)
            # すべてのボタンを離す
            self.nxbt.release_buttons(self.controller_index, buttons)
        except Exception as e:
            print(f"❌ ボタン操作エラー: {e}")

    def wait(self, duration):
        """指定時間待機"""
        time.sleep(duration)

    def disconnect(self):
        """Switchから切断"""
        if self.controller_index is not None:
            try:
                print("\n🔌 切断中...")
                self.nxbt.remove_controller(self.controller_index)
                print("✅ 切断完了")
            except Exception as e:
                print(f"⚠️ 切断時の警告: {e}")


def check_input(macro_obj):
    """
    キー入力を監視するスレッド
    ENTERまたはCTRL+Yでマクロの開始/停止を切り替え
    """
    print("\n💡 操作方法:")
    print("  ▶ ENTERキー: マクロ開始/停止")
    print("  ▶ CTRL+Y: マクロ停止")
    print("  ▶ CTRL+C: プログラム終了\n")

    while not macro_obj.should_stop:
        try:
            # stdinが読み取り可能かチェック（タイムアウト0.1秒）
            if select.select([sys.stdin], [], [], 0.1)[0]:
                char = sys.stdin.read(1)

                # ENTERキー（改行）をチェック
                if char == '\n':
                    if macro_obj.is_running:
                        print("\n⏸️  マクロを停止しました")
                        print("   再開するにはENTERキーを押してください\n")
                        macro_obj.is_running = False
                    else:
                        print("\n▶️  マクロを開始します！\n")
                        macro_obj.is_running = True

                # CTRL+Y（ASCII 25）をチェック
                elif ord(char) == 25:
                    print("\n⏹️  CTRL+Y が押されました")
                    print("   マクロを停止します...\n")
                    macro_obj.is_running = False

        except Exception:
            pass


def zl_a_loop():
    """
    メインマクロ: ZLを押しながら0.5秒後にAを押す動作をループ
    ENTERキーまたはCTRL+Yで開始/停止を切り替え
    """
    macro = SwitchMacro()

    # Switchに接続
    if not macro.connect():
        print("\n❌ 接続に失敗しました。終了します。")
        sys.exit(1)

    print("\n" + "=" * 50)
    print("🎮 マクロツール起動完了！")
    print("=" * 50)
    print("\n動作: ZLを押しながら0.5秒後にAを押す（ループ）")

    # キー入力監視スレッドを開始
    input_thread = threading.Thread(target=check_input, args=(macro,), daemon=True)
    input_thread.start()

    print("\n待機中... ENTERキーを押してマクロを開始してください")

    loop_count = 0

    try:
        while not macro.should_stop:
            if macro.is_running:
                loop_count += 1
                print(f"🔄 ループ {loop_count}回目...")

                # 1. ZLを押す
                print("   ▶ ZLボタン押下")
                macro.press_button("ZL", 0.5)  # ZLを0.5秒押す

                # 2. ZLとAを同時に押す
                print("   ▶ ZL+A同時押し")
                macro.press_buttons(["ZL", "A"], 0.1)  # ZL+Aを0.1秒押す

                # 3. 少し待機
                macro.wait(0.5)

                print(f"   ✓ 完了 (合計: {loop_count}回)\n")
            else:
                # マクロが停止中の場合は短く待機
                time.sleep(0.1)

    except KeyboardInterrupt:
        print("\n\n⏹️  Ctrl+C が押されました")
        print("プログラムを終了します...")
        macro.should_stop = True

    except Exception as e:
        print(f"\n❌ エラーが発生しました: {e}")
        macro.should_stop = True

    finally:
        # 必ず切断処理を実行
        macro.disconnect()
        print("\n👋 終了しました。お疲れ様でした！")


if __name__ == "__main__":
    print("""
╔══════════════════════════════════════════════════════╗
║                                                      ║
║     🎮 Nintendo Switch 自動マクロツール 🎮              ║
║                                                       ║
║  ZL+A 自動連打プログラム                                 ║
║  制御: ENTER（開始/停止）/ CTRL+Y（停止）                 ║
║  終了: CTRL+C                                         ║
║                                                      ║
╚══════════════════════════════════════════════════════╝
    """)

    print("\n⚠️  注意事項:")
    print("  - このツールは教育目的で作成されています")
    print("  - オンラインゲームでの使用は推奨しません")
    print("  - ゲームの利用規約を確認してください")
    print("  - 使用は自己責任でお願いします\n")

    input("準備ができたら Enter キーを押してください...")

    # メインマクロ実行
    zl_a_loop()