# 🎮 Pokemon Legends Z-A Automation Tool (Linux/Ubuntu)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Ubuntu-orange)
![Language](https://img.shields.io/badge/Language-Python-blue.svg)
![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)

---

## 📖 Language / 言語

- [🇯🇵 日本語](README.md)
- [🇺🇸 English](README_en.md) (Current)
- [🇫🇷 Français](README_fr.md)
- [🇩🇪 Deutsch](README_de.md)
- [🇨🇳 简体中文](README_zh-CN.md)
- [🇹🇼 繁體中文](README_zh-TW.md)
- [🇪🇸 Español](README_es.md)

---

![Preview](preview.gif)

**Super Easy!** Automate your Nintendo Switch with just one script.

Automatically presses ZL button while rapidly tapping A button.

**ENTER key** or **CTRL+Y** to start/stop the macro anytime!

---

## 📋 What Can This Tool Do?

- **Auto-repeat ZL+A button combo** in a loop
- **Easy start/stop with ENTER key** - pause and resume anytime
- **CTRL+Y also stops** - quick termination
- Automate repetitive tasks in games
- No programming knowledge required

---

## 🛠️ Requirements

### Hardware
- ✅ PC with **Ubuntu 24.04 LTS** (or other Debian-based Linux)
- ✅ Bluetooth capability (built-in or USB adapter)
- ✅ Nintendo Switch console

### Other
- Internet connection (first-time setup only)
- Approximately 10 minutes (first-time setup only)

---

## 📁 File Structure

Contents of the downloaded folder:

```
switch-macro/
│
├── 📄 README.md               ← This file (complete guide)
├── 📄 LICENSE                 ← MIT License
│
├── 🚀 set_up.sh          ← ★【First time】One-click environment setup script
├── 🎮 control_panel.sh        ← ★【Use this】Control panel
│
└── 📁 src/                    ← Main source code
    ├── macro1.py              ← Macro execution script
    ├── others_macro.py        ← Macro execution script
    ...
```

### 🎯 Which Files to Use?

| File               | Purpose |
|--------------------|---------|
| `set_up.sh`        | **First time only** - Automatically installs everything needed. |
| `control_panel.sh` | **Every time** - Start/stop macros, check connections, etc. |

**After setup with `set_up.sh`, just use `control_panel.sh`!**

---

## 🚀 First-Time Setup (One-Click)

Only needed when using for the first time. **Just run 3 commands!**

### ⏱️ Time Required: About 10 minutes

---

### 📝 Step 1: Open Terminal

Press `Ctrl + Alt + T` on your keyboard to open Terminal (black screen).

### 📝 Step 2: Run the Script

Copy and paste the following commands **one by one** and press **Enter**.

```bash
# 1. Navigate to the downloaded folder
# Example: cd ~/Downloads/switch-macro
cd /path/to/your/switch-macro

# 2. Grant execution permission to the script (first time only)
chmod +x set_up.sh

# 3. Run the setup script
./set_up.sh
```

If prompted for a password, enter your PC's login password.
(The password won't display on screen, but it's being entered)

---

### 🎉 Setup Complete!

When you see "Setup completed successfully!", you're ready to go.
Great job! From now on, proceed to "How to Use".

---

## 🎯 How to Use (Every Time)

After setup is complete, just use the **Control Panel**.

Run the following commands in Terminal:

```bash
# 1. Navigate to the folder
cd /path/to/your/switch-macro

# 2. Launch the control panel
./control_panel.sh
```

The menu screen will appear:

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

#### 📝 Operation Steps

1. **Prepare Nintendo Switch**
   - Home → "Controllers" → "Change Grip/Order"

2. **Start Macro**
   - Press "**1**" and Enter
   - Macro starts in a new terminal window

3. **Stop Macro**
   - Return to control panel window, press "**2**" and Enter

4. **After PC Restart**
   - If Bluetooth isn't working well, press "**3**" to restart the service.

---

## 🎮 Controls

| Key Operation | Action |
|---------------|--------|
| **ENTER** | Start / Pause / Resume macro |
| **CTRL+Y** | Stop macro |
| **CTRL+C** | Exit program and disconnect |

### Macro Behavior (For Restaurant)

```
1. Press ZL button (0.5s)
   ↓
2. Press ZL+A simultaneously (0.1s)
   ↓
3. Wait 0.5s
   ↓
4. Repeat until ENTER or CTRL+Y is pressed
```

---

## 🔄 After PC Restart

Basically, just follow the steps in the "How to Use" section each time.

If Bluetooth isn't working properly, launch `control_panel.sh` and press "**3**" to restart the Bluetooth service.

---

## ⚠️ Troubleshooting

### 💡 Try This First

**`./control_panel.sh` → "4" Environment Check**

This helps identify the problem.

---

### Problem 1: "Bluetooth adapter not found" "Cannot connect"

**Solution**:

1. **From Control Panel**
   - `./control_panel.sh` → "3" Restart Bluetooth

2. **Or manually**
   ```bash
   # Run in terminal
   sudo systemctl restart bluetooth
   sleep 3
   hciconfig
   ```
   If `UP RUNNING` is displayed, it's OK.

3. **Check Switch Preparation**
   - Confirm Switch's "Change Grip/Order" screen is open
   - Disconnect all other controllers

---

### Problem 2: ENTER key or CTRL+Y doesn't work

**Cause**: Terminal window is not selected

**Solution**:
1. Click the terminal window running the macro to select it
2. Press ENTER or CTRL+Y

---

### Problem 3: Macro won't stop

**Solution**:

1. **From Control Panel**
   - `./control_panel.sh` → "2" Stop Macro

2. **Or manually**
   ```bash
   # Run in terminal
   sudo pkill -f switch_macro.py
   ```

---

### Problem 4: "Permission denied" error

**Cause**: Trying to run without `sudo` (administrator privileges)

**Solution**:
Always use `./control_panel.sh` to launch. This script uses `sudo` correctly internally.

---

### Problem 5: "nxbt: command not found" or similar errors

**Cause**: Python virtual environment is not activated

**Solution**:
Always use `./control_panel.sh` to launch. This script automatically activates the virtual environment.

---

## 🔧 Customization (Advanced Users)

### Editing Macros

Open `src/switch_macro.py` in a text editor and edit the following section:

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

### Available Buttons

| Button | Code |
|--------|------|
| A, B, X, Y | `"A"`, `"B"`, `"X"`, `"Y"` |
| L, R | `"L"`, `"R"` |
| ZL, ZR | `"ZL"`, `"ZR"` |
| D-Pad | `"DPAD_UP"`, `"DPAD_DOWN"`, `"DPAD_LEFT"`, `"DPAD_RIGHT"` |
| System | `"PLUS"`, `"MINUS"`, `"HOME"`, `"CAPTURE"` |

---

## 🗑️ Uninstall

1. Delete the project folder.
    ```bash
    rm -rf /path/to/your/switch-macro
    ```

2. (Optional) To remove system packages installed during setup:
    ```bash
    sudo apt remove --purge -y python3-pip python3-venv bluez libbluetooth-dev libhidapi-dev
    sudo apt autoremove -y
    ```

---

## ⚖️ Risks and Disclaimer (Important)

### 🚨 Ban Risk

This tool is an automation tool **similar to turbo controllers/macro controllers**.

#### Potential Nintendo Terms of Service Violation

Use of automation methods is explicitly prohibited.

#### Possible Console/Account Ban

- ✗ No eShop access
- ✗ No online multiplayer
- ✗ No game updates
- ✗ All online features disabled

### 💡 Safe Usage Conditions

1. **Completely offline Switch only**
2. **Use on secondary console**
3. **Single-player games only**
4. **Educational/research purposes**

### ⚖️ Legal Liability

The creator assumes no responsibility for any damages or bans resulting from use.

**Use is entirely at your own risk.**

---

## 📚 Frequently Asked Questions (FAQ)

### Q1: Which file should I use?

**A**: Run `set_up.sh` the first time, then just use **`control_panel.sh`**!

---

### Q2: Which games can I use this with?

**A**: It works with all Switch games, but DO NOT use with online games.

---

### Q3: What happens if my PC goes to sleep?

**A**: The connection will be lost. Try `control_panel.sh` → "3" to restart Bluetooth.

---

### Q4: Can I pause the macro and resume later?

**A**: Yes! Press ENTER in the macro execution window to pause, press again to resume.

---

## 🎉 Enjoy Your Gaming Life!

**Happy Gaming! 🎮✨**

---

## 📝 Change Log
- v2.0.0 (2025/10/20)
  - Changed to macro transmission format
- v1.2.0 (2025/10/19)
  - Deprecated `run_macro.sh`, unified operations in `control_panel.sh`
- v1.1.0 (2025/10/19)
  - Official Linux/Ubuntu support
  - Added one-click setup script `set_up.sh`
  - Added control panel `control_panel.sh`

- v1.0.0 (2025/10/19)
  - Initial release

---

**Creator**: coffin299 and friends  
**License**: MIT  
**Support**: GitHub Issues