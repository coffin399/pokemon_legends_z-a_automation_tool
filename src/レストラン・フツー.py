#!/usr/bin/env python3
"""
Nintendo Switch 自動マクロツール
ZLを押しながら0.2秒後にA、0.5秒後に全部離す
NXBTのマクロ機能を使用してラグを最小化
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
        self.is_connected = False

    def connect(self):
        """Switchに接続"""
        try:
            print("\n📡 Bluetoothアダプタを検索中...")
            if self.nxbt is None:
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
            time.sleep(6)

            print(
                "✅ 接続成功！ PROコントローラーとして認識されました。その後にキャラクターを操作するコントローラーを接続してください。")
            self.is_connected = True
            return True

        except Exception as e:
            print(f"\n❌ エラー: {e}")
            print("\n以下を確認してください:")
            print("  1. Switchの「持ちかた/順番を変える」画面が開いているか")
            print("  2. Bluetoothアダプタが正しく接続されているか")
            print("  3. 他のコントローラーが接続されていないか")
            self.is_connected = False
            return False

    def reconnect(self):
        """再接続"""
        print("\n🔄 再接続を試みます...")
        self.is_running = False  # マクロを一時停止

        # 既存の接続を切断
        if self.controller_index is not None:
            try:
                self.nxbt.remove_controller(self.controller_index)
                self.controller_index = None
            except Exception:
                pass

        # 再接続
        return self.connect()

    def execute_macro(self):
        """
        マクロを実行
        ZL押す → 0.2秒後A追加 → 0.5秒後全部離す
        """
        try:
            # マクロ定義：スペース区切りで同時押し
            # 形式: "ボタン1 ボタン2 時間" または "時間" (待機のみ)
            macro_sequence = (
                "ZL 0.2s\n"  # ZLを0.2秒押す
                "ZL A 0.5s\n"  # ZLとAを同時に0.5秒押す
                "0.1s"  # 全ボタン離して0.1秒待機
            )

            # マクロを送信（block=Trueで完了まで待機）
            self.nxbt.macro(
                self.controller_index,
                macro_sequence,
                block=True
            )

            return True

        except Exception as e:
            print(f"❌ マクロ実行エラー: {e}")
            self.is_connected = False
            return False

    def disconnect(self):
        """Switchから切断"""
        if self.controller_index is not None:
            try:
                print("\n🔌 切断中...")
                self.nxbt.remove_controller(self.controller_index)
                print("✅ 切断完了")
                self.is_connected = False
            except Exception as e:
                print(f"⚠️ 切断時の警告: {e}")


def check_input(macro_obj):
    """
    キー入力を監視するスレッド
    ENTERでマクロの開始/停止、Rキーで再接続、CTRL+Cで終了
    """
    print("\n💡 操作方法:")
    print("  ▶ ENTERキー: マクロ開始/停止")
    print("  ▶ Rキー: 再接続")
    print("  ▶ CTRL+C: プログラム終了\n")

    while not macro_obj.should_stop:
        try:
            # stdinが読み取り可能かチェック（タイムアウト0.1秒）
            if select.select([sys.stdin], [], [], 0.1)[0]:
                char = sys.stdin.read(1)

                # ENTERキー（改行）をチェック
                if char == '\n':
                    if not macro_obj.is_connected:
                        print("\n⚠️  接続されていません。Rキーで再接続してください")
                        continue

                    if macro_obj.is_running:
                        print("\n⏸️  マクロを停止しました")
                        print("   再開するにはENTERキーを押してください\n")
                        macro_obj.is_running = False
                    else:
                        print("\n▶️  マクロを開始します！\n")
                        macro_obj.is_running = True

                # Rキー（再接続）
                elif char.lower() == 'r':
                    macro_obj.reconnect()

        except Exception:
            pass


def zl_a_loop():
    """
    メインマクロ: マクロ機能を使ってZL+A操作をループ
    ENTERキーで開始/停止、Rキーで再接続
    """
    macro = SwitchMacro()

    # Switchに接続
    if not macro.connect():
        print("\n❌ 接続に失敗しました。")
        print("Rキーを押して再接続を試みるか、CTRL+Cで終了してください。")

    print("\n" + "=" * 50)
    print("🎮 マクロツール起動完了！")
    print("=" * 50)
    print("\n動作: ZL押す → 0.2秒後A追加 → 0.5秒後全部離す（ループ）")
    print("※ マクロ機能使用でラグを最小化")

    # キー入力監視スレッドを開始
    input_thread = threading.Thread(target=check_input, args=(macro,), daemon=True)
    input_thread.start()

    if macro.is_connected:
        print("\n待機中... ENTERキーを押してマクロを開始してください")
    else:
        print("\n待機中... Rキーを押して接続してください")

    loop_count = 0

    try:
        while not macro.should_stop:
            if macro.is_running and macro.is_connected:
                loop_count += 1
                print(f"🔄 ループ {loop_count}回目...")

                # マクロを実行
                success = macro.execute_macro()

                if success:
                    print(f"   ✓ 完了 (合計: {loop_count}回)\n")
                else:
                    print("\n⚠️  接続が切れました。Rキーで再接続してください")
                    macro.is_running = False
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
║  ZL+A 自動連打プログラム (マクロ機能版)                    ║
║  制御: ENTER（開始/停止）/ R（再接続）                    ║
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