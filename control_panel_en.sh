#!/bin/bash

# --- Color Variables ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- Settings ---
PROJECT_DIR="$HOME/switch-macro"
MACRO_SCRIPT="src/switch_macro.py"

# --- Function Definitions ---

# Display Status
display_status() {
    echo "========================================"
    echo "  Nintendo Switch Macro Control Panel"
    echo "========================================"
    echo

    # Check macro status
    if pgrep -f "$MACRO_SCRIPT" > /dev/null; then
        echo -e "Status    : ${GREEN}[Running]${NC}  Macro is running"
    else
        echo -e "Status    : ${YELLOW}[Stopped]${NC}  Macro is not running"
    fi

    # Check Bluetooth status
    if hciconfig 2>/dev/null | grep -q "UP RUNNING"; then
        echo -e "Bluetooth : ${GREEN}[Active]${NC}   Adapter is enabled"
    else
        echo -e "Bluetooth : ${RED}[Inactive]${NC} Adapter is disabled or in error"
    fi

    echo
    echo "========================================"
    echo
    echo "[1] Start Macro"
    echo "[2] Stop Macro"
    echo "[3] Restart Bluetooth"
    echo "[4] Environment Check"
    echo "[5] Refresh Status"
    echo "[0] Exit"
    echo
    echo "========================================"
}

# Start Macro
start_macro() {
    clear
    echo "========================================"
    echo "  Start Macro"
    echo "========================================"
    echo
    if pgrep -f "$MACRO_SCRIPT" > /dev/null; then
        echo -e "${YELLOW}[WARNING] The macro is already running.${NC}"
        read -p "Press Enter to return to the menu..."
        return
    fi

    echo "Please open 'Change Grip/Order' on your Switch."
    read -p "Press Enter when you are ready..."

    echo "Starting the macro in a new window..."

    # Run in a new window using gnome-terminal
    gnome-terminal -- bash -c "cd '$PROJECT_DIR' && source .venv/bin/activate && sudo python3 '$MACRO_SCRIPT'; exec bash"

    sleep 2
    echo
    echo -e "${GREEN}[SUCCESS] Macro has been started.${NC}"
    echo "   It is running in a new terminal window."
    echo
    read -p "Press Enter to return to the menu..."
}

# Stop Macro
stop_macro() {
    clear
    echo "========================================"
    echo "  Stop Macro"
    echo "========================================"
    echo
    if pgrep -f "$MACRO_SCRIPT" > /dev/null; then
        sudo pkill -f "$MACRO_SCRIPT"
        echo -e "${GREEN}[SUCCESS] The macro has been stopped.${NC}"
    else
        echo -e "${YELLOW}[INFO] The macro was not running.${NC}"
    fi
    echo
    read -p "Press Enter to return to the menu..."
}

# Restart Bluetooth
reconnect_bt() {
    clear
    echo "========================================"
    echo "  Restart Bluetooth"
    echo "========================================"
    echo
    echo "Restarting the Bluetooth service..."
    sudo systemctl restart bluetooth

    if [ $? -eq 0 ]; then
        echo "Sent the service restart command."
        echo "Waiting for the adapter to initialize... (5 seconds)"
        sleep 5

        echo
        echo "--- Output of hciconfig ---"
        hciconfig
        echo "---------------------------"
        echo

        if hciconfig 2>/dev/null | grep -q "UP RUNNING"; then
            echo -e "${GREEN}[SUCCESS] The Bluetooth adapter has been enabled!${NC}"
        else
            echo -e "${RED}[FAILURE] Could not enable the Bluetooth adapter.${NC}"
            echo "Please try running 'sudo hciconfig hci0 up' manually."
        fi
    else
        echo -e "${RED}[ERROR] Failed to restart the Bluetooth service.${NC}"
    fi
    echo
    read -p "Press Enter to return to the menu..."
}

# Environment Check
run_test() {
    clear
    echo "========================================"
    echo "  Environment Check"
    echo "========================================"
    echo

    # 1. Python virtual environment
    echo -n "[1/4] Python virtual environment... "
    if [ -f "$PROJECT_DIR/.venv/bin/activate" ]; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[FAIL] .venv not found${NC}"
    fi

    # 2. NXBT library
    echo -n "[2/4] NXBT library... "
    if [ -f "$PROJECT_DIR/.venv/bin/pip" ] && "$PROJECT_DIR/.venv/bin/pip" list 2>/dev/null | grep -q "nxbt"; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[FAIL] nxbt is not installed${NC}"
    fi

    # 3. Macro file
    echo -n "[3/4] Macro file... "
    if [ -f "$PROJECT_DIR/$MACRO_SCRIPT" ]; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[FAIL] $MACRO_SCRIPT not found${NC}"
    fi

    # 4. Bluetooth service
    echo -n "[4/4] Bluetooth service... "
    if systemctl is-active --quiet bluetooth; then
        echo -e "${GREEN}[OK] Active${NC}"
    else
        echo -e "${RED}[FAIL] Inactive${NC}"
    fi

    echo
    echo "Check complete."
    read -p "Press Enter to return to the menu..."
}


# --- Main Loop ---
while true; do
    clear
    display_status
    read -p "Select an option (0-5): " choice

    case $choice in
        1) start_macro ;;
        2) stop_macro ;;
        3) reconnect_bt ;;
        4) run_test ;;
        5) continue ;;
        0) break ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            sleep 2
            ;;
    esac
done

clear
echo "Exiting."