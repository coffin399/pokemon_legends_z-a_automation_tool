# 🎮 Pokemon Legends Z-A Auto-Farming Tool (for Linux/Ubuntu)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Ubuntu-orange)
![Language](https://img.shields.io/badge/Language-Python-blue.svg)
![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)

**Super Easy!** This tool lets you automate your Nintendo Switch with a single script.

It continuously and automatically presses the **A** button while holding down the **ZL** button.

You can freely start and stop the macro by pressing the **ENTER** key or **CTRL+Y**!

---

## 📋 What Can This Tool Do?

-   Loops the **automatic pressing of ZL+A**.
-   **Easy start/stop with the ENTER key** - pause and resume anytime.
-   **Also stoppable with CTRL+Y** - for a quick stop.
-   Automate repetitive tasks in your games.
-   No programming knowledge required.

---

## 🛠️ Requirements

### Hardware
-   ✅ A PC with **Ubuntu 24.04 LTS** (or other Debian-based Linux) installed.
-   ✅ Bluetooth capability (built-in or a USB adapter).
-   ✅ A Nintendo Switch console.

### Other
-   An internet connection (only for the initial setup).
-   About 10 minutes of your time (only for the initial setup).

---

## 📁 File Structure

Contents of the downloaded folder:

```
switch-macro/
│
├── 📄 README.md               ← This file (Your complete guide)
├── 📄 LICENSE                 ← MIT License
│
├── 🚀 set_up.sh               ← ★ [Run this first] One-click setup script
├── 🎮 control_panel.sh        ← ★ [Use this to operate] The control panel
│
└── 📁 src/                     ← Main source code
    └── switch_macro.py        ← Macro execution script
```

### 🎯 Which File to Use?

| File               | Purpose                                                 |
| ------------------ | ------------------------------------------------------- |
| `set_up.sh`        | **First time only** - Automatically installs everything you need. |
| `control_panel.sh` | **Use every time** - Start/stop the macro, check connections, etc. |

**After setting up with `set_up.sh`, you only need to use `control_panel.sh`!**

---

## 🚀 Initial Setup (One-Click Version)

This is only required the first time you use the tool. **Just run 3 commands!**

### ⏱️ Estimated Time: About 10 minutes

---

### 📝 Step 1: Open a Terminal

Press `Ctrl + Alt + T` on your keyboard to open the terminal (the black screen).

### 📝 Step 2: Run the Scripts

Copy and paste the following commands **one by one** and press **Enter** after each.

```bash
# 1. Navigate to the downloaded folder
# Example: cd ~/Downloads/switch-macro
cd /path/to/your/switch-macro

# 2. Give the script execution permissions (first time only)
chmod +x set_up.sh

# 3. Run the setup script
./set_up.sh
```

If you are prompted for a password, enter the login password for your PC.
(Note: The password will not be displayed on the screen as you type, but it is being entered.)

---

### 🎉 Setup Complete!

When you see the message "Setup has been successfully completed!", you're all set.
Great job! From now on, you can proceed to the "How to Use" section.

---

## 🎯 How to Use (Every Time)

After the initial setup, you only need to use the **Control Panel**.

Run the following commands in your terminal:

```bash
# 1. Navigate to the folder
cd /path/to/your/switch-macro

# 2. Launch the control panel
./control_panel.sh
```

A menu screen will appear:

```
========================================
  Nintendo Switch Macro Control Panel
========================================

Status    : [Stopped] Macro is not running
Bluetooth : [Connected] Adapter is active

========================================

[1] Start Macro
[2] Stop Macro
[3] Restart Bluetooth
[4] Check Environment
[5] Refresh Status
[0] Exit

========================================
```

#### 📝 Operating Steps

1.  **Prepare your Nintendo Switch**
    -   Go to Home Screen → `Controllers` → `Change Grip/Order`.

2.  **Start the Macro**
    -   Press "**1**" and then Enter.
    -   The macro will start in a new terminal window.

3.  **Stop the Macro**
    -   Return to the control panel window, press "**2**", and then Enter.

4.  **After a PC Reboot**
    -   If Bluetooth isn't working correctly, you can restart the service by selecting option "**3**".

---

## 🎮 Controls

| Key        | Action                         |
| ---------- | ------------------------------ |
| **ENTER**  | Start / Pause / Resume Macro   |
| **CTRL+Y** | Stop Macro                     |
| **CTRL+C** | Exit Program & Disconnect      |

### Macro Behavior

```
1. Press ZL button (for 0.5s)
   ↓
2. Press ZL+A simultaneously (for 0.1s)
   ↓
3. Wait for 0.5s
   ↓
4. Repeat until ENTER or CTRL+Y is pressed
```

---

## 🔄 Usage After a PC Reboot

Simply follow the steps in the "How to Use" section each time.

If Bluetooth seems to be having issues, launch `control_panel.sh` and press "**3**" to restart the Bluetooth service.

---

## ⚠️ Troubleshooting

### 💡 First Things to Try

**Run `./control_panel.sh` → Select "4" (Check Environment)**

This will help you diagnose the problem.

---

### Problem 1: "Bluetooth adapter not found" or "Cannot connect"

**Solution**:

1.  **From the Control Panel**
    -   Run `./control_panel.sh` → Select "3" (Restart Bluetooth).

2.  **Or Manually**
    ```bash
    # Run in terminal
    sudo systemctl restart bluetooth
    sleep 3
    hciconfig
    ```
    If you see `UP RUNNING`, you're good to go.

3.  **Check your Switch**
    -   Ensure the "Change Grip/Order" screen is open on your Switch.
    -   Disconnect all other controllers.

---

### Problem 2: The ENTER or CTRL+Y keys don't work

**Cause**: The terminal window is not in focus.

**Solution**:
1.  Click on the terminal window where the macro is running to select it.
2.  Press ENTER or CTRL+Y.

---

### Problem 3: The macro won't stop

**Solution**:

1.  **From the Control Panel**
    -   Run `./control_panel.sh` → Select "2" (Stop Macro).

2.  **Or Manually**
    ```bash
    # Run in terminal
    sudo pkill -f switch_macro.py
    ```

---

### Problem 4: "Permission denied" error

**Cause**: Trying to run a script without `sudo` (administrator privileges).

**Solution**:
Always use `./control_panel.sh` to start the macro. This script handles `sudo` correctly internally.

---

### Problem 5: Errors like "nxbt: command not found"

**Cause**: Python's virtual environment is not activated.

**Solution**:
Always use `./control_panel.sh` to start the macro. This script automatically activates the virtual environment for you.

---

## 🔧 Customization (For Advanced Users)

### Editing the Macro

Open `src/switch_macro.py` in a text editor and modify the following section:

```python
if macro.is_running:
    loop_count += 1
    print(f"🔄 Loop {loop_count}...")

    # Edit this section ↓↓↓
    
    macro.press_button("ZL", 0.5)         # Press ZL for 0.5s
    macro.press_buttons(["ZL", "A"], 0.1) # Press ZL+A for 0.1s
    macro.wait(0.5)                       # Wait for 0.5s
    
    # End of section ↑↑↑
```

### Available Buttons

| Button      | Code                                                |
| ----------- | --------------------------------------------------- |
| A, B, X, Y  | `"A"`, `"B"`, `"X"`, `"Y"`                          |
| L, R        | `"L"`, `"R"`                                        |
| ZL, ZR      | `"ZL"`, `"ZR"`                                      |
| D-Pad       | `"DPAD_UP"`, `"DPAD_DOWN"`, `"DPAD_LEFT"`, `"DPAD_RIGHT"` |
| System      | `"PLUS"`, `"MINUS"`, `"HOME"`, `"CAPTURE"`          |

---

## 🗑️ Uninstall

1.  Delete the project folder.
    ```bash
    rm -rf /path/to/your/switch-macro
    ```

2.  (Optional) If you want to remove the system packages installed by the setup script:
    ```bash
    sudo apt remove --purge -y python3-pip python3-venv bluez libbluetooth-dev libhidapi-dev
    sudo apt autoremove -y
    ```

---

## ⚖️ Risks & Disclaimer (Important)

### 🚨 Risk of Being Banned

This tool is an **automation tool, similar to a turbo controller or macro controller**.

#### Potential Violation of Nintendo's Terms of Service

The use of automation methods is explicitly prohibited.

#### Risk of Console or Account Ban

A ban could result in:
-   ✗ Inability to access the eShop
-   ✗ Inability to play online multiplayer
-   ✗ Inability to update games
-   ✗ Loss of all online functionality

### 💡 Conditions for Safer Use

1.  Use on a **Switch that is kept completely offline**.
2.  Use on a **secondary console**, not your main one.
3.  Use for **single-player games only**.
4.  Use for **educational or research purposes**.

### ⚖️ Legal Disclaimer

The creator of this tool is not responsible for any damages or bans that may result from its use.

**Use this tool entirely at your own risk.**

---

## 📚 FAQ (Frequently Asked Questions)

### Q1: Which file should I use?

**A**: Run `set_up.sh` once for the initial setup. After that, you only need to use **`control_panel.sh`**!

---

### Q2: Which games can I use this with?

**A**: It works with all Switch games, but please do not use it in online games.

---

### Q3: What happens if my PC goes to sleep?

**A**: The connection will be lost. Try restarting the Bluetooth service via `control_panel.sh` → "3".

---

### Q4: Can I pause the macro and resume it later?

**A**: Yes! In the macro's terminal window, press ENTER to pause, and press it again to resume.

---

## 🎉 Enjoy your gaming life!

**Happy Gaming! 🎮✨**

---

## 📝 Changelog
- v2.0.0 (2025/10/20)
  - Changed the macro submission method.
- v1.2.0 (2025/10/19)
  - Deprecated `run_macro.sh` and consolidated all operations into `control_panel.sh`.
- v1.1.0 (2025/10/19)
  - Added official support for Linux/Ubuntu.
  - Added one-click setup script `set_up.sh`.
  - Added control panel `control_panel.sh`.
- v1.0.0 (2025/10/19)
  - Initial Release

---

**Author**: coffin299 and friends  
**License**: MIT  
**Support**: GitHub Issues