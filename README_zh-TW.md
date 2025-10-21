# 🎮 Pokemon Legends Z-A 自動化工具（Linux/Ubuntu）

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Ubuntu-orange)
![Language](https://img.shields.io/badge/Language-Python-blue.svg)
![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)

---

## 📖 語言 / Language

- [🇯🇵 日本語](README.md)
- [🇺🇸 English](README_en.md)
- [🇫🇷 Français](README_fr.md)
- [🇩🇪 Deutsch](README_de.md)
- [🇨🇳 简体中文](README_zh-CN.md)
- [🇹🇼 繁體中文](README_zh-TW.md)（目前）
- [🇪🇸 Español](README_es.md)

---

![操作預覽](preview.gif)
**超簡單！** 只需一個腳本就能自動操作Nintendo Switch的工具。

按住ZL鍵的同時自動連續按A鍵。

可以使用**ENTER鍵**或**CTRL+Y**隨時開始/停止巨集！

---

## 📋 這個工具能做什麼？

- **ZL+A鍵自動連按**循環執行
- **用ENTER鍵輕鬆開始/停止** - 隨時可以中斷和恢復
- **也可用CTRL+Y停止** - 快速停止
- 可以自動化遊戲中的簡單重複操作
- 無需程式設計知識即可使用

---

## 🛠️ 所需條件

### 硬體
- ✅ 安裝了**Ubuntu 24.04 LTS**的PC（或其他基於Debian的Linux）
- ✅ 藍牙功能（內建或USB轉接器）
- ✅ Nintendo Switch主機

### 其他
- 網際網路連線（僅首次設定時需要）
- 約10分鐘時間（僅首次設定時需要）

---

## 📁 檔案結構

下載資料夾中的內容：

```
switch-macro/
│
├── 📄 README.md               ← 本檔案（完整指南）
├── 📄 LICENSE                 ← MIT授權
│
├── 🚀 set_up.sh          ← ★【首次執行】一鍵環境配置腳本
├── 🎮 control_panel.sh        ← ★【用這個操作】控制面板
│
└── 📁 src/                    ← 主要原始碼
    ├── macro1.py              ← 巨集執行腳本
    ├── others_macro.py        ← 巨集執行腳本
    ...
```

### 🎯 使用哪個檔案？

| 檔案               | 用途 |
|--------------------|------|
| `set_up.sh`        | **僅首次** - 自動安裝所有必需的內容。 |
| `control_panel.sh` | **每次使用** - 從這裡進行巨集的開始/停止、連線確認等所有操作。 |

**使用`set_up.sh`配置環境後，只需使用`control_panel.sh`！**

---

## 🚀 首次設定（一鍵版）

僅在首次使用時需要的操作。**只需執行3個命令！**

### ⏱️ 所需時間：約10分鐘

---

### 📝 步驟1：開啟終端機

按鍵盤上的`Ctrl + Alt + T`，開啟終端機（黑色畫面）。

### 📝 步驟2：執行腳本

請**逐個**複製貼上以下命令，然後按**Enter**。

```bash
# 1. Navigate to the downloaded folder
# Example: cd ~/Downloads/switch-macro
cd /path/to/your/switch-macro

# 2. Grant execution permission to the script (first time only)
chmod +x set_up.sh

# 3. Run the setup script
./set_up.sh
```

執行過程中如果要求輸入密碼，請輸入您的PC登入密碼。
（輸入密碼時螢幕不顯示，但已經輸入了）

---

### 🎉 設定完成！

顯示「セットアップがすべて完了しました！」（設定全部完成！）後準備就緒。
辛苦了！從下次開始請轉到「使用方法」。

---

## 🎯 使用方法（每次）

設定完成後，之後只需使用**控制面板**。

在終端機中執行以下命令。

```bash
# 1. Navigate to the folder
cd /path/to/your/switch-macro

# 2. Launch the control panel
./control_panel.sh
```

將顯示選單畫面：

```
========================================
  Nintendo Switch Macro Control Panel
========================================

Status    : [Stopped] Macro stopped
Bluetooth : [Connected] Adapter active

========================================

[1] Start Macro
[2] Stop Macro
[3] Restart Bluetooth
[4] Environment Check
[5] Refresh Status
[0] Exit

========================================
```

#### 📝 操作步驟

1. **準備Nintendo Switch**
   - 主畫面 → 「控制器」→ 「更改握法/順序」

2. **開始巨集**
   - 按「**1**」然後Enter
   - 巨集將在新的終端機視窗中啟動

3. **停止巨集**
   - 返回控制面板視窗，按「**2**」然後Enter

4. **PC重新啟動後**
   - 如果藍牙狀態不佳，可以按「**3**」重新啟動服務。

---

## 🎮 操作方法

| 按鍵操作 | 動作 |
|---------|------|
| **ENTER** | 巨集開始 / 暫停 / 恢復 |
| **CTRL+Y** | 巨集停止 |
| **CTRL+C** | 程式結束·中斷連線 |

### 巨集的動作（餐廳用）

```
1. 按ZL鍵（0.5秒）
   ↓
2. 同時按ZL+A（0.1秒）
   ↓
3. 等待0.5秒
   ↓
4. 重複直到按ENTER鍵或CTRL+Y
```

---

## 🔄 PC重新啟動後的使用方法

基本上，每次只需執行「使用方法」部分的步驟。

如果藍牙無法正常運作，請啟動`control_panel.sh`，按「**3**」嘗試重新啟動藍牙服務。

---

## ⚠️ 故障排除

### 💡 首先嘗試

**`./control_panel.sh` → 「4」環境檢查**

可以協助識別問題。

---

### 問題1：「找不到藍牙轉接器」「無法連線」

**解決方法**：

1. **從控制面板**
   - `./control_panel.sh` → 「3」重新啟動藍牙

2. **或手動**
   ```bash
   # Run in terminal
   sudo systemctl restart bluetooth
   sleep 3
   hciconfig
   ```
   如果顯示`UP RUNNING`則正常。

3. **確認Switch的準備**
   - 確認Switch的「更改握法/順序」畫面是否開啟
   - 中斷所有其他控制器

---

### 問題2：ENTER鍵或CTRL+Y不起作用

**原因**：未選擇終端機視窗

**解決方法**：
1. 點擊巨集正在執行的終端機視窗使其成為選取狀態
2. 按ENTER鍵或CTRL+Y

---

### 問題3：巨集無法停止

**解決方法**：

1. **從控制面板**
   - `./control_panel.sh` → 「2」停止巨集

2. **或手動**
   ```bash
   # Run in terminal
   sudo pkill -f switch_macro.py
   ```

---

### 問題4：「Permission denied」錯誤

**原因**：嘗試在沒有`sudo`（管理員權限）的情況下執行

**解決方法**：
請務必使用`./control_panel.sh`啟動。此腳本內部正確使用`sudo`。

---

### 問題5：「nxbt: command not found」等錯誤

**原因**：Python虛擬環境未啟用

**解決方法**：
請務必使用`./control_panel.sh`啟動。此腳本會自動啟用虛擬環境。

---

## 🔧 自訂（進階使用者）

### 編輯巨集

用文字編輯器開啟`src/switch_macro.py`，編輯以下部分：

```python
    def execute_macro(self):
        """
        Execute macro
        Press ZL → Add A after 0.2s → Release all after 0.5s
        """
        try:
            # Macro definition: simultaneous press separated by spaces
            # Format: "button1 button2 time" or "time" (wait only)
            macro_sequence = (
                "ZL 0.2s\n"  # Press ZL for 0.2s
                "ZL A 0.5s\n"  # Press ZL and A simultaneously for 0.5s
                "0.1s"  # Release all buttons and wait 0.1s
            )

            # Send macro (block=True waits until completion)
            self.nxbt.macro(
                self.controller_index,
                macro_sequence,
                block=True
            )

            return True

        except Exception as e:
            print(f"❌ Macro execution error: {e}")
            self.is_connected = False
            return False
```

### 可用按鍵

| 按鍵 | 代碼 |
|--------|--------|
| A, B, X, Y | `"A"`, `"B"`, `"X"`, `"Y"` |
| L, R | `"L"`, `"R"` |
| ZL, ZR | `"ZL"`, `"ZR"` |
| 方向鍵 | `"DPAD_UP"`, `"DPAD_DOWN"`, `"DPAD_LEFT"`, `"DPAD_RIGHT"` |
| 系統 | `"PLUS"`, `"MINUS"`, `"HOME"`, `"CAPTURE"` |

---

## 🗑️ 解除安裝

1. 刪除專案資料夾。
    ```bash
    rm -rf /path/to/your/switch-macro
    ```

2. （可選）如果要刪除設定時安裝的系統套件：
    ```bash
    sudo apt remove --purge -y python3-pip python3-venv bluez libbluetooth-dev libhidapi-dev
    sudo apt autoremove -y
    ```

---

## ⚖️ 風險和免責聲明（重要）

### 🚨 封鎖風險

此工具是**與連發控制器/巨集控制器相同**的自動化工具。

#### 可能違反Nintendo使用條款

明確禁止使用自動化手段。

#### 可能封鎖主機·帳號

- ✗ 無法存取eShop
- ✗ 無法線上多人遊戲
- ✗ 無法更新遊戲
- ✗ 所有線上功能不可用

### 💡 安全使用條件

1. **完全離線專用的Switch**
2. **在備用機上使用**
3. **僅限單人遊戲**
4. **教育·研究目的**

### ⚖️ 法律責任

製作者對使用造成的任何損害或封鎖不承擔責任。

**使用完全自負風險。**

---

## 📚 常見問題（FAQ）

### Q1：應該使用哪個檔案？

**A**：首次執行`set_up.sh`，之後只需使用**`control_panel.sh`**！

---

### Q2：可以在哪些遊戲中使用？

**A**：可在所有Switch遊戲中運行，但請勿在線上遊戲中使用。

---

### Q3：PC進入睡眠狀態會怎樣？

**A**：連線會中斷。嘗試`control_panel.sh` → 「3」重新啟動藍牙。

---

### Q4：可以暫停巨集並稍後恢復嗎？

**A**：可以！在巨集執行視窗中按ENTER鍵暫停，再按一次恢復。

---

## 🎉 享受愉快的遊戲生活！

**Happy Gaming! 🎮✨**

---

## 📝 更新歷史
- v2.0.0 (2025/10/20)
  - 改為傳送macro的形式
- v1.2.0 (2025/10/19)
  - 廢除`run_macro.sh`，將操作統一到`control_panel.sh`
- v1.1.0 (2025/10/19)
  - 正式支援Linux/Ubuntu
  - 新增一鍵設定腳本`set_up.sh`
  - 新增控制面板`control_panel.sh`

- v1.0.0 (2025/10/19)
  - 首次發布

---

**製作者**：coffin299和愉快的夥伴們  
**授權**：MIT  
**支援**：GitHub Issues