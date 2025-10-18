#!/usr/bin/env python3
"""
Nintendo Switch 接続テストスクリプト

Switchに接続できるか簡単にテストします。
接続後、Aボタンを1回押して切断します。
"""

import sys
import os
import time

# 親ディレクトリのsrcをインポートパスに追加
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))
from switch_macro import SwitchMacro


def test_connection():
    """接続テスト"""
    print("""
╔══════════════════════════════════════════════════════╗
║                                                      ║
║     🧪 Nintendo Switch 接続テスト                   ║
║                                                      ║
╚══════════════════════════════════════════════════════╝
    """)

    print("\n📋 事前確認:")
    print("  1. Switchの「持ちかた/順番を変える」画面が開いていますか？")
    print("  2. Bluetoothアダプタは接続されていますか？")
    print()

    input("準備ができたら Enter キーを押してください...")
    print()

    # マクロインスタンスを作成
    macro = SwitchMacro()

    # 接続テスト
    print("\n【ステップ 1】 Switchに接続中...")
    if not macro.connect():
        print("\n❌ 接続に失敗しました")
        print("\nトラブルシューティング:")
        print("  1. scripts/troubleshoot.sh を実行して環境を確認")
        print("  2. Switchの画面を確認")
        print("  3. Bluetoothアダプタの接続を確認")
        return False

    print("✅ 接続成功！")

    # ボタンテスト
    print("\n【ステップ 2】 ボタン動作テスト")
    print("  これからAボタンを1回押します...")
    time.sleep(2)

    print("  Aボタンを押しています...")
    macro.press_button("A", 0.5)

    print("✅ ボタンが正常に動作しました")

    # 切断
    print("\n【ステップ 3】 切断中...")
    macro.disconnect()

    print("\n" + "=" * 50)
    print("✅ すべてのテストが成功しました！")
    print("=" * 50)
    print("\nマクロツールは正常に動作します。")
    print("run_macro.bat を使用してマクロを実行できます。")
    print()

    return True


if __name__ == "__main__":
    try:
        success = test_connection()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\n⏹️  テストが中断されました")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ エラーが発生しました: {e}")
        print("\nトラブルシューティングを実行してください:")
        print("  wsl -d Ubuntu-22.04 bash ~/switch-macro/scripts/troubleshoot.sh")
        sys.exit(1)