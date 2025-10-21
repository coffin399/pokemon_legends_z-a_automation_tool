# 🎮 Pokemon Legends Z-A 自动化工具（Linux/Ubuntu）

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Ubuntu-orange)
![Language](https://img.shields.io/badge/Language-Python-blue.svg)
![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)

---

## 📖 语言 / Language

- [🇯🇵 日本語](README.md)
- [🇺🇸 English](README_en.md)
- [🇫🇷 Français](README_fr.md)
- [🇩🇪 Deutsch](README_de.md)
- [🇨🇳 简体中文](README_zh-CN.md)（当前）
- [🇹🇼 繁體中文](README_zh-TW.md)
- [🇪🇸 Español](README_es.md)

---

![操作预览](preview.gif)
**超简单！** 只需一个脚本就能自动操作Nintendo Switch的工具。

按住ZL键的同时自动连续按A键。

可以使用**ENTER键**或**CTRL+Y**随时开始/停止宏！

---

## 📋 这个工具能做什么？

- **ZL+A键自动连按**循环执行
- **用ENTER键轻松开始/停止** - 随时可以中断和恢复
- **也可用CTRL+Y停止** - 快速停止
- 可以自动化游戏中的简单重复操作
- 无需编程知识即可使用

---

## 🛠️ 所需条件

### 硬件
- ✅ 安装了**Ubuntu 24.04 LTS**的PC（或其他基于Debian的Linux）
- ✅ 蓝牙功能（内置或USB适配器）
- ✅ Nintendo Switch主机

### 其他
- 互联网连接（仅首次设置时需要）
- 约10分钟时间（仅首次设置时需要）

---

## 📁 文件结构

下载文件夹中的内容：

```
switch-macro/
│
├── 📄 README.md               ← 本文件（完整指南）
├── 📄 LICENSE                 ← MIT许可证
│
├── 🚀 set_up.sh          ← ★【首次执行】一键环境配置脚本
├── 🎮 control_panel.sh        ← ★【用这个操作】控制面板
│
└── 📁 src/                    ← 主要源代码
    ├── macro1.py              ← 宏执行脚本
    ├── others_macro.py        ← 宏执行脚本
    ...
```

### 🎯 使用哪个文件？

| 文件               | 用途 |
|--------------------|------|
| `set_up.sh`        | **仅首次** - 自动安装所有必需的内容。 |
| `control_panel.sh` | **每次使用** - 从这里进行宏的开始/停止、连接确认等所有操作。 |

**使用`set_up.sh`配置环境后，只需使用`control_panel.sh`！**

---

## 🚀 首次设置（一键版）

仅在首次使用时需要的操作。**只需执行3个命令！**

### ⏱️ 所需时间：约10分钟

---

### 📝 步骤1：打开终端

按键盘上的`Ctrl + Alt + T`，打开终端（黑屏）。

### 📝 步骤2：执行脚本

请**逐个**复制粘贴以下命令，然后按**Enter**。

```bash
# 1. Navigate to the downloaded folder
# Example: cd ~/Downloads/switch-macro
cd /path/to/your/switch-macro

# 2. Grant execution permission to the script (first time only)
chmod +x set_up.sh

# 3. Run the setup script
./set_up.sh
```

执行过程中如果要求输入密码，请输入您的PC登录密码。
（输入密码时屏幕不显示，但已经输入了）

---

### 🎉 设置完成！

显示"セットアップがすべて完了しました！"（设置全部完成！）后准备就绪。
辛苦了！从下次开始请转到"使用方法"。

---

## 🎯 使用方法（每次）

设置完成后，之后只需使用**控制面板**。

在终端中执行以下命令。

```bash
# 1. Navigate to the folder
cd /path/to/your/switch-macro

# 2. Launch the control panel
./control_panel.sh
```

将显示菜单屏幕：

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

#### 📝 操作步骤

1. **准备Nintendo Switch**
   - 主页 → "手柄"→ "更改握法/顺序"

2. **开始宏**
   - 按"**1**"然后Enter
   - 宏将在新的终端窗口中启动

3. **停止宏**
   - 返回控制面板窗口，按"**2**"然后Enter

4. **PC重启后**
   - 如果蓝牙状态不佳，可以按"**3**"重启服务。

---

## 🎮 操作方法

| 按键操作 | 动作 |
|---------|------|
| **ENTER** | 宏开始 / 暂停 / 恢复 |
| **CTRL+Y** | 宏停止 |
| **CTRL+C** | 程序退出·断开连接 |

### 宏的动作（餐厅用）

```
1. 按ZL键（0.5秒）
   ↓
2. 同时按ZL+A（0.1秒）
   ↓
3. 等待0.5秒
   ↓
4. 重复直到按ENTER键或CTRL+Y
```

---

## 🔄 PC重启后的使用方法

基本上，每次只需执行"使用方法"部分的步骤。

如果蓝牙无法正常工作，请启动`control_panel.sh`，按"**3**"尝试重启蓝牙服务。

---

## ⚠️ 故障排除

### 💡 首先尝试

**`./control_panel.sh` → "4"环境检查**

可以帮助识别问题。

---

### 问题1："找不到蓝牙适配器""无法连接"

**解决方法**：

1. **从控制面板**
   - `./control_panel.sh` → "3"重启蓝牙

2. **或手动**
   ```bash
   # Run in terminal
   sudo systemctl restart bluetooth
   sleep 3
   hciconfig
   ```
   如果显示`UP RUNNING`则正常。

3. **确认Switch的准备**
   - 确认Switch的"更改握法/顺序"屏幕是否打开
   - 断开所有其他手柄

---

### 问题2：ENTER键或CTRL+Y不起作用

**原因**：未选择终端窗口

**解决方法**：
1. 点击宏正在执行的终端窗口使其成为选中状态
2. 按ENTER键或CTRL+Y

---

### 问题3：宏无法停止

**解决方法**：

1. **从控制面板**
   - `./control_panel.sh` → "2"停止宏

2. **或手动**
   ```bash
   # Run in terminal
   sudo pkill -f switch_macro.py
   ```

---

### 问题4："Permission denied"错误

**原因**：尝试在没有`sudo`（管理员权限）的情况下执行

**解决方法**：
请务必使用`./control_panel.sh`启动。此脚本内部正确使用`sudo`。

---

### 问题5："nxbt: command not found"等错误

**原因**：Python虚拟环境未激活

**解决方法**：
请务必使用`./control_panel.sh`启动。此脚本会自动激活虚拟环境。

---

## 🔧 自定义（高级用户）

### 编辑宏

用文本编辑器打开`src/switch_macro.py`，编辑以下部分：

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

### 可用按键

| 按键 | 代码 |
|--------|--------|
| A, B, X, Y | `"A"`, `"B"`, `"X"`, `"Y"` |
| L, R | `"L"`, `"R"` |
| ZL, ZR | `"ZL"`, `"ZR"` |
| 方向键 | `"DPAD_UP"`, `"DPAD_DOWN"`, `"DPAD_LEFT"`, `"DPAD_RIGHT"` |
| 系统 | `"PLUS"`, `"MINUS"`, `"HOME"`, `"CAPTURE"` |

---

## 🗑️ 卸载

1. 删除项目文件夹。
    ```bash
    rm -rf /path/to/your/switch-macro
    ```

2. （可选）如果要删除设置时安装的系统包：
    ```bash
    sudo apt remove --purge -y python3-pip python3-venv bluez libbluetooth-dev libhidapi-dev
    sudo apt autoremove -y
    ```

---

## ⚖️ 风险和免责声明（重要）

### 🚨 封禁风险

此工具是**与连发手柄/宏手柄相同**的自动化工具。

#### 可能违反Nintendo使用条款

明确禁止使用自动化手段。

#### 可能封禁主机·账号

- ✗ 无法访问eShop
- ✗ 无法在线多人游戏
- ✗ 无法更新游戏
- ✗ 所有在线功能不可用

### 💡 安全使用条件

1. **完全离线专用的Switch**
2. **在备用机上使用**
3. **仅限单人游戏**
4. **教育·研究目的**

### ⚖️ 法律责任

制作者对使用造成的任何损害或封禁不承担责任。

**使用完全自负风险。**

---

## 📚 常见问题（FAQ）

### Q1：应该使用哪个文件？

**A**：首次执行`set_up.sh`，之后只需使用**`control_panel.sh`**！

---

### Q2：可以在哪些游戏中使用？

**A**：可在所有Switch游戏中运行，但请勿在在线游戏中使用。

---

### Q3：PC进入睡眠状态会怎样？

**A**：连接会断开。尝试`control_panel.sh` → "3"重启蓝牙。

---

### Q4：可以暂停宏并稍后恢复吗？

**A**：可以！在宏执行窗口中按ENTER键暂停，再按一次恢复。

---

## 🎉 享受愉快的游戏生活！

**Happy Gaming! 🎮✨**

---

## 📝 更新历史
- v2.0.0 (2025/10/20)
  - 改为发送macro的形式
- v1.2.0 (2025/10/19)
  - 废除`run_macro.sh`，将操作统一到`control_panel.sh`
- v1.1.0 (2025/10/19)
  - 正式支持Linux/Ubuntu
  - 添加一键设置脚本`set_up.sh`
  - 添加控制面板`control_panel.sh`

- v1.0.0 (2025/10/19)
  - 首次发布

---

**制作者**：coffin299和愉快的伙伴们  
**许可证**：MIT  
**支持**：GitHub Issues