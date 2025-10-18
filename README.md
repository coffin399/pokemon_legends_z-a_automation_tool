# 🎮 ポケモンLEGENDS Z-A 金策ツール

**超簡単！** ボタン一つでNintendo Switchを自動操作できるツールです。

ZLボタンを押しながらAボタンを自動で連打し続けます。

**ENTERキー**または**CTRL+Y**でマクロの開始/停止を自由に切り替えられます！

---

## 📋 このツールで何ができる？

- **ZL+Aボタンの自動連打** をループ実行
- **ENTERキーで簡単に開始/停止** - いつでも中断・再開可能
- **CTRL+Y でも停止可能** - 素早く止められる
- ゲームの単純作業を自動化できます
- プログラミング知識不要で使えます

---

## 🛠️ 必要なもの

### ハードウェア
- ✅ Windows 10 または Windows 11 のPC
- ✅ Bluetooth機能（内蔵またはUSBアダプタ）
- ✅ Nintendo Switch本体

### その他
- インターネット接続（初回セットアップ時のみ）
- 30〜60分程度の時間（初回セットアップ時のみ）

---

## 📁 ファイル構造

ダウンロードしたフォルダの中身：

```
switch-macro/
│
├── 📄 README.md               ← このファイル（完全ガイド）
├── 📄 LICENSE                 ← MITライセンス
│
├── 🎮 control_panel.bat       ← ★ 【おすすめ】コントロールパネル
├── 🚀 run_macro.bat           ← マクロ実行（直接起動）
├── 📡 reconnect_bluetooth.bat ← Bluetooth再接続ヘルパー
│
├── 📁 src/                    ← メインソースコード
│   └── switch_macro.py        ← マクロ実行スクリプト
│
└── 📁 scripts/                ← セットアップ用スクリプト
    └── setup_wsl.sh           ← WSL環境自動構築スクリプト
```

### 🎯 どのファイルを使う？

| ファイル | 用途 | 使いやすさ |
|---------|------|-----------|
| `control_panel.bat` | **全機能を統合** - マクロ開始/停止、接続確認など | ⭐⭐⭐⭐⭐ |
| `run_macro.bat` | マクロを直接起動（シンプル） | ⭐⭐⭐⭐ |
| `reconnect_bluetooth.bat` | Bluetooth再接続のみ | ⭐⭐⭐ |

**初めての方は `control_panel.bat` がおすすめです！**

---

## 🚀 初回セットアップ（完全マニュアル）

初めて使うときだけ必要な作業です。**手順通りに進めれば誰でもできます！**

### ⏱️ 所要時間: 30〜60分

---

### 📝 ステップ1: WSL2を有効化（10分）

#### 1-1. PowerShellを開く

1. **Windowsキー** を押す
2. 「**PowerShell**」と入力
3. 表示された「Windows PowerShell」を **右クリック**
4. **「管理者として実行」** を選択

#### 1-2. WSLをインストール

PowerShellに以下のコマンドをコピー＆ペーストして **Enter**:

```powershell
wsl --install
```

#### 1-3. 再起動

インストールが完了したら:

```powershell
shutdown /r /t 0
```

を実行してPCを再起動します。

```
💡 または手動で再起動してもOKです
```

---

### 📝 ステップ2: Ubuntuの初期設定（5分）

#### 2-1. Ubuntuの起動

1. PC再起動後、自動的に「Ubuntu」のウィンドウが開きます
2. 開かない場合は:
   - Windowsキー → 「**Ubuntu**」と入力 → Enter

#### 2-2. ユーザー名とパスワードを設定

```
Enter new UNIX username: switch
New password: [好きなパスワード]
Retype new password: [もう一度同じパスワード]
```

```
⚠️ 重要
- パスワードは入力しても画面に表示されません
- でもちゃんと入力されているので安心してください
- パスワードは忘れないようにメモしてください
```

#### 2-3. セットアップ完了

「Installation successful!」と表示されたら、Ubuntuウィンドウは閉じてOKです。

---

### 📝 ステップ3: NXBTのインストール（15分）

#### 3-1. PowerShellを開く（管理者として）

1. Windowsキー → 「**PowerShell**」
2. **右クリック** → 「管理者として実行」

#### 3-2. WSL2をデフォルトに設定

```powershell
wsl --set-default-version 2
```

#### 3-3. Ubuntuを起動

```powershell
wsl -d Ubuntu-22.04
```

Ubuntuの画面に切り替わります。

#### 3-4. 必要なパッケージをインストール

以下のコマンドを**1つずつ**コピー＆ペーストして実行:

```bash
# システムアップデート（2〜5分）
sudo apt update && sudo apt upgrade -y
```

パスワードを聞かれたら、ステップ2で設定したパスワードを入力。

```bash
# 必要なパッケージをインストール（5〜10分）
sudo apt install -y python3 python3-pip git bluez libbluetooth-dev libglib2.0-dev libdbus-1-dev libgirepository1.0-dev libcairo2-dev pkg-config
```

```bash
# Pythonパッケージをインストール（2〜3分）
pip3 install pydbus PyGObject
```

```bash
# NXBTをインストール（1〜2分）
pip3 install nxbt
```

```bash
# 環境変数を設定
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc
```

#### 3-5. Bluetoothサービスを起動

```bash
sudo service dbus start
sudo service bluetooth start
```

#### 3-6. インストール確認

```bash
nxbt --version
```

バージョン情報が表示されればOK！

#### 3-7. Ubuntuを終了

```bash
exit
```

PowerShellに戻ります。

---

### 📝 ステップ4: usbipd-winのインストール（5分）

#### 4-1. usbipd-winをダウンロード

1. 以下のリンクをブラウザで開く:
   https://github.com/dorssel/usbipd-win/releases

2. 最新版の **`.msi`** ファイルをクリックしてダウンロード
   例: `usbipd-win_4.3.0.msi`
　　または、コマンドプロンプトで`winget install usbipd`
#### 4-2. インストール

1. ダウンロードした `.msi` ファイルをダブルクリック
2. 「次へ」を何回かクリック
3. 「完了」をクリック

---

### 📝 ステップ5: BluetoothアダプタをWSLに接続（5分）

#### 5-1. PowerShellを開く（管理者として）

既に開いている場合はそのまま使用してOK。

#### 5-2. Bluetoothアダプタを確認

```powershell
usbipd list
```

以下のような表示が出ます:

```
BUSID  VID:PID    DEVICE
1-1    046d:c52b  USB Input Device
2-3    8087:0025  Intel(R) Wireless Bluetooth(R)  ← これ！
3-2    0bda:0129  Realtek USB 2.0 Card Reader
```

**Bluetoothの行の「BUSID」をメモしてください！**
（例: `2-3`）

```
💡 Bluetoothアダプタの見つけ方
- "Bluetooth" という文字が含まれている行
- "Intel Wireless" などのメーカー名がある行
- 分からない場合は、各行を1つずつ試してみましょう
```

#### 5-3. Bluetoothアダプタをバインド

```powershell
usbipd bind --busid 2-3
```

**`2-3` の部分は、自分のBUSIDに置き換えてください！**

#### 5-4. WSLにアタッチ

```powershell
usbipd attach --wsl --busid 2-3
```

**`2-3` の部分は、自分のBUSIDに置き換えてください！**

#### 5-5. 接続確認

```powershell
wsl -d Ubuntu-22.04
hciconfig
```

以下のように表示されればOK:

```
hci0:   Type: Primary  Bus: USB
        BD Address: XX:XX:XX:XX:XX:XX  ACL MTU: 1021:8  SCO MTU: 64:1
```

「hci0」が表示されていれば成功です！

```bash
exit
```

でPowerShellに戻ります。

---

### 📝 ステップ6: マクロファイルをWSLにコピー（3分）

#### 6-1. マクロファイルの場所を確認

ダウンロードした `pokemon_legends_z-a_money_farm_tool` フォルダの場所をメモしてください。

例: `C:\Users\YourName\Downloads\pokemon_legends_z-a_money_farm_tool-master`

#### 6-2. PowerShellでWSLのホームに移動

```powershell
wsl -d Ubuntu-22.04
cd ~
```

#### 6-3. マクロフォルダを作成

```bash
mkdir -p switch-macro/src
```

#### 6-4. Windowsからファイルをコピー

PowerShellで以下を実行（パスは自分の環境に合わせて変更）:

```powershell
# PowerShellに戻る
exit

# Windowsのファイルをコピー
wsl -d Ubuntu-22.04 -e bash -c "cp /mnt/c/Users/YourName/Downloads/switch-macro/src/switch_macro.py ~/switch-macro/src/"
```

または、手動でコピー:

1. エクスプローラーで `\\wsl$\Ubuntu-22.04\home\switch` を開く
2. `switch-macro/src/` フォルダを作成
3. `switch_macro.py` をコピー

#### 6-5. 実行権限を付与

```powershell
wsl -d Ubuntu-22.04
cd ~/switch-macro
chmod +x src/switch_macro.py
```

---

### 🎉 セットアップ完了！

お疲れ様でした！これで準備は完了です。

次回からは `run_macro.bat` をダブルクリックするだけで使えます！

---

## 🎯 使い方（毎回）

セットアップが終わったら、以降は超簡単です！

### 🎮 方法1: コントロールパネルを使う（おすすめ）

**`control_panel.bat` をダブルクリック**

メニュー画面が表示されます：

```
========================================
  🎮 Switch マクロ コントロールパネル
========================================

状態: ⚪ マクロ停止中
Bluetooth: ✅ 接続済み

========================================

[1] マクロ開始 (通常モード)
[2] マクロ停止
[3] Bluetooth再接続
[4] 接続テスト
[5] 状態確認
[0] 終了

========================================
```

#### 📝 使い方

1. **PC再起動後の初回**
   - 「3」を押してBluetooth再接続

2. **Nintendo Switchの準備**
   - ホーム → 「コントローラー」→ 「持ちかた/順番を変える」

3. **マクロ開始**
   - 「1」を押す
   - Enterキーを押す
   - 新しいウィンドウでマクロが起動

4. **マクロ停止**
   - 「2」を押す

5. **状態確認**
   - 「5」を押すと最新の状態を確認

### 🚀 方法2: 直接起動（シンプル）

**`run_macro.bat` をダブルクリック**

1. Switchで「持ちかた/順番を変える」を開く
2. Enterキーを押す
3. マクロが開始

### 📡 方法3: Bluetooth再接続のみ

**`reconnect_bluetooth.bat` をダブルクリック**

PC再起動後はこれを実行してからマクロを起動してください。

---

## 🎮 操作方法

| キー操作 | 動作 |
|---------|------|
| **ENTER** | マクロ開始 / 一時停止 / 再開 |
| **CTRL+Y** | マクロ停止 |
| **CTRL+C** | プログラム終了・切断 |

### マクロの動作

```
1. ZLボタンを押す（0.5秒）
   ↓
2. ZL+Aを同時に押す（0.1秒）
   ↓
3. 0.5秒待つ
   ↓
4. ENTERキーまたはCTRL+Yを押すまで繰り返し
```

---

## 🔄 PC再起動後の使い方

### 🎮 コントロールパネルから（おすすめ）

1. **`control_panel.bat` をダブルクリック**
2. 「**3**」を押してBluetooth再接続
3. BUSIDを入力（初回のみ、2回目以降は自動）
4. 完了したらメニューに戻る
5. 「**1**」を押してマクロ開始

### 📡 再接続のみ

**`reconnect_bluetooth.bat` をダブルクリック**

### 🛠️ 手動接続

PowerShell（管理者）で:

```powershell
usbipd attach --wsl --busid 2-3
```

---

## ⚠️ トラブルシューティング

### 💡 まず試すこと

**`control_panel.bat` → 「4」接続テスト → 「5」状態確認**

問題が自動で診断されます。

---

### 問題1: 「Bluetoothアダプタが見つかりません」

**解決方法**:

1. **コントロールパネルから**
   - `control_panel.bat` → 「3」Bluetooth再接続

2. **または手動で**
   ```powershell
   # PowerShell（管理者）
   usbipd list
   usbipd attach --wsl --busid 2-3
   ```

3. **WSL内で確認**
   ```powershell
   wsl -d Ubuntu-22.04
   sudo service bluetooth restart
   hciconfig
   ```

---

### 問題2: 「接続できません」

**原因**: Switchの準備ができていない

**解決方法**:
1. Switchの「持ちかた/順番を変える」画面が開いているか確認
2. 他のコントローラーをすべて切断
3. `control_panel.bat` → 「2」停止 → 「1」開始

---

### 問題3: ENTERキーやCTRL+Yが効かない

**原因**: ターミナルウィンドウが選択されていない

**解決方法**:
1. マクロが実行されている黒いウィンドウをクリック
2. ENTERキーまたはCTRL+Yを押す

---

### 問題4: マクロが停止しない

**解決方法**:

1. **コントロールパネルから**
   - `control_panel.bat` → 「2」マクロ停止

2. **または手動で**
   ```bash
   wsl -d Ubuntu-22.04
   sudo pkill -f switch_macro.py
   ```

---

### 問題5: 「Permission denied」エラー

**解決方法**:

```bash
wsl -d Ubuntu-22.04
cd ~/switch-macro
sudo python3 src/switch_macro.py
```

---

### 問題6: WSLが起動しない

**解決方法**:

```powershell
wsl --shutdown
wsl -d Ubuntu-22.04
```

---

### 問題7: nxbtが見つからない

**解決方法**:

```bash
wsl -d Ubuntu-22.04
pip3 install nxbt
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc
```

---

### 問題8: control_panel.batで状態が更新されない

**解決方法**:

メニューで「5」を押して手動で更新してください。

---

## 🔧 カスタマイズ（上級者向け）

### マクロの編集

`src/switch_macro.py` を開いて、以下の部分を編集:

```python
if macro.is_running:
    loop_count += 1
    print(f"🔄 ループ {loop_count}回目...")

    # ここを編集 ↓↓↓
    
    macro.press_button("ZL", 0.5)         # ZLを0.5秒押す
    macro.press_buttons(["ZL", "A"], 0.1) # ZL+A同時押し0.1秒
    macro.wait(0.5)                       # 0.5秒待つ
    
    # ここまで ↑↑↑
```

### 使えるボタン

| ボタン | コード |
|--------|--------|
| A, B, X, Y | `"A"`, `"B"`, `"X"`, `"Y"` |
| L, R | `"L"`, `"R"` |
| ZL, ZR | `"ZL"`, `"ZR"` |
| 十字キー | `"DPAD_UP"`, `"DPAD_DOWN"`, `"DPAD_LEFT"`, `"DPAD_RIGHT"` |
| システム | `"PLUS"`, `"MINUS"`, `"HOME"`, `"CAPTURE"` |

---

## 🗑️ アンインストール

PowerShell（管理者）で:

```powershell
wsl --unregister Ubuntu-22.04
```

その後、`switch-macro` フォルダを削除してください。

---

## ⚖️ リスクと免責事項（重要）

### 🚨 BANのリスク

このツールは**連射コントローラー/マクロコントローラー同様**に自動化ツールです。

#### Nintendo利用規約違反の可能性

自動化手段の使用が明示的に禁止されています。

#### 本体・アカウントBANの可能性

- ✗ eShopへのアクセス不可
- ✗ オンラインマルチプレイ不可
- ✗ ゲームアップデート不可
- ✗ オンライン機能すべて不可

### 💡 安全な使用条件

1. **完全オフライン専用のSwitch**
2. **サブ機での使用**
3. **シングルプレイゲームのみ**
4. **教育・研究目的**

### ⚖️ 法的責任

作成者は使用によって生じたいかなる損害やBANについても責任を負いません。

**使用は完全に自己責任です。**

---

## 📚 よくある質問（FAQ）

### Q1: どのファイルを使えばいいですか？

**A**: **`control_panel.bat`** が一番簡単です！メニューから選ぶだけで全部できます。

---

### Q2: どのゲームで使えますか？

**A**: すべてのSwitchゲームで動作しますが、オンラインゲームでは使用しないでください。

---

### Q3: マクロの速度を変更できますか？

**A**: `src/switch_macro.py` の待機時間を編集してください。

---

### Q4: PCがスリープしたらどうなる？

**A**: 接続が切れます。`control_panel.bat` → 「3」でBluetooth再接続してください。

---

### Q5: PC再起動後、毎回設定が必要？

**A**: `control_panel.bat` → 「3」で再接続するだけです。BUSIDは保存されます。

---

### Q6: ENTERキーを押しても反応しない

**A**: マクロ実行中の黒いウィンドウをクリックしてからENTERキーを押してください。

---

### Q7: マクロを一時停止して後で再開できますか？

**A**: はい！ENTERキーを押すと一時停止、もう一度押すと再開します。

---

### Q8: control_panel.batとrun_macro.batの違いは？

**A**: 
- **control_panel.bat**: メニューから全機能を操作（開始/停止/再接続/テスト）
- **run_macro.bat**: マクロを直接起動（シンプル）

初めての方は **control_panel.bat** がおすすめです！

---

### Q9: マクロが勝手に止まる

**A**: `control_panel.bat` → 「5」で状態確認してください。Bluetooth切断が原因の可能性があります。

---

### Q10: 複数のSwitchで使えますか？

**A**: はい。ただし、1つずつ接続してください。同時接続はできません。

---

## 🆘 それでも解決しない場合

### 🎯 自動診断を試す

**`control_panel.bat` → 「4」接続テスト**

自動で以下を確認します：
- ✅ Bluetooth接続状態
- ✅ NXBT インストール状態
- ✅ マクロファイルの存在

### 📝 手動で確認する手順

1. **PCを再起動**
2. **Switchを再起動**
3. **`control_panel.bat` → 「3」でBluetooth再接続**
4. **`control_panel.bat` → 「4」で接続テスト**
5. **それでもダメなら、GitHubのIssuesで質問してください**

### 💬 質問する際に含めてほしい情報

- Windows のバージョン（例: Windows 11）
- エラーメッセージ（スクリーンショットがあると助かります）
- 接続テストの結果
- どの手順で問題が発生したか

---

## 🎉 楽しいゲームライフを！

**Happy Gaming! 🎮✨**

---

## 📝 更新履歴

- v1.1.0 (2025/10/19)
  - ENTERキーでマクロ開始/停止切り替え
  - CTRL+Y停止機能追加
  - 手順書形式に変更

- v1.0.0 (2025/10/19)
  - 初回リリース

---

**制作者**: coffin299と愉快な仲間たち  
**ライセンス**: MIT  
**サポート**: GitHub Issues