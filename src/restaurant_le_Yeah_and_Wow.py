#!/usr/bin/env python3
"""
Nintendo Switch Automation Macro Tool
Presses ZL, then adds A after 0.2s, and releases all after 0.5s.
Minimizes lag by using NXBT's macro feature.
"""

import time
import sys
import threading
import select
from nxbt import Nxbt, PRO_CONTROLLER


class SwitchMacro:
    def __init__(self):
        """Initializes the macro execution class."""
        print("🎮 Initializing Nintendo Switch Macro Tool...")
        self.nxbt = None
        self.controller_index = None
        self.is_running = False
        self.should_stop = False
        self.is_connected = False

    def connect(self):
        """Connects to the Switch."""
        try:
            print("\n📡 Searching for Bluetooth adapter...")
            if self.nxbt is None:
                self.nxbt = Nxbt()

            print("🔌 Connecting to the Switch...")
            print("   ※ Please open the 'Change Grip/Order' screen on your Switch.")

            self.controller_index = self.nxbt.create_controller(
                PRO_CONTROLLER,
                reconnect_address=self.nxbt.get_switch_addresses()
            )

            if self.controller_index is None:
                raise Exception("Failed to create the controller")

            # Waiting a moment for the connection to stabilize.
            time.sleep(6)

            print(
                "✅ Connection successful! Recognized as a PRO Controller. Please connect the controller you will use to control your character afterwards.")
            self.is_connected = True
            return True

        except Exception as e:
            print(f"\n❌ Error: {e}")
            print("\nPlease check the following:")
            print("  1. If the 'Change Grip/Order' screen is open on your Switch.")
            print("  2. If the Bluetooth adapter is properly connected.")
            print("  3. If no other controllers are connected.")
            self.is_connected = False
            return False

    def reconnect(self):
        """Reconnects to the Switch."""
        print("\n🔄 Attempting to reconnect...")
        self.is_running = False  # Pausing the macro.

        # Disconnecting the existing connection.
        if self.controller_index is not None:
            try:
                self.nxbt.remove_controller(self.controller_index)
                self.controller_index = None
            except Exception:
                pass

        # Reconnecting.
        return self.connect()

    def execute_macro(self):
        """
        Executes the macro.
        Press ZL -> Add A after 0.2s -> Release all after 0.5s.
        """
        try:
            # Macro definition: Simultaneous presses are separated by spaces.
            # Format: "BUTTON1 BUTTON2 DURATION" or just "DURATION" (for waiting).
            macro_sequence = (
                "ZL 0.2s\n"      # Press ZL for 0.2s
                "ZL A 0.3s\n"    # Press ZL and A simultaneously for 0.3s
                "ZL Y 0.3s\n"    # Press ZL and Y simultaneously for 0.3s
                "ZL X 0.3s\n"    # Press ZL and X simultaneously for 0.3s
            )

            # Send the macro (block=True waits for completion).
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

    def disconnect(self):
        """Disconnects from the Switch."""
        if self.controller_index is not None:
            try:
                print("\n🔌 Disconnecting...")
                self.nxbt.remove_controller(self.controller_index)
                print("✅ Disconnected successfully.")
                self.is_connected = False
            except Exception as e:
                print(f"⚠️ Warning on disconnect: {e}")


def check_input(macro_obj):
    """
    Thread to monitor key inputs.
    ENTER to start/stop, 'R' to reconnect, CTRL+C to exit.
    """
    print("\n💡 Controls:")
    print("  ▶ ENTER key: Start/Stop Macro")
    print("  ▶ R key:     Reconnect")
    print("  ▶ CTRL+C:    Exit Program\n")

    while not macro_obj.should_stop:
        try:
            # Check if stdin is readable (0.1s timeout).
            if select.select([sys.stdin], [], [], 0.1)[0]:
                char = sys.stdin.read(1)

                # Check for ENTER key (newline).
                if char == '\n':
                    if not macro_obj.is_connected:
                        print("\n⚠️ Not connected. Please press 'R' to reconnect.")
                        continue

                    if macro_obj.is_running:
                        print("\n⏸️ Macro paused.")
                        print("   Press ENTER to resume.\n")
                        macro_obj.is_running = False
                    else:
                        print("\n▶️ Starting macro!\n")
                        macro_obj.is_running = True

                # 'R' key (reconnect).
                elif char.lower() == 'r':
                    macro_obj.reconnect()

        except Exception:
            pass


def zl_a_loop():
    """
    Main macro: Loops ZL+A operation using the macro feature.
    Start/Stop with ENTER, Reconnect with 'R'.
    """
    macro = SwitchMacro()

    # Connect to the Switch
    if not macro.connect():
        print("\n❌ Connection failed.")
        print("Press 'R' to try reconnecting, or CTRL+C to exit.")

    print("\n" + "=" * 50)
    print("🎮 Macro Tool is ready!")
    print("=" * 50)
    print("\nAction: Press ZL -> Add A after 0.2s -> Release all after 0.5s (Loop)")
    print("※ Using macro feature to minimize lag.")

    # Starting key input monitoring thread.
    input_thread = threading.Thread(target=check_input, args=(macro,), daemon=True)
    input_thread.start()

    if macro.is_connected:
        print("\nWaiting... Press ENTER to start the macro.")
    else:
        print("\nWaiting... Press 'R' to connect.")

    loop_count = 0

    try:
        while not macro.should_stop:
            if macro.is_running and macro.is_connected:
                loop_count += 1
                print(f"🔄 Loop #{loop_count}...")

                # Execute the macro
                success = macro.execute_macro()

                if success:
                    print(f"   ✓ Done (Total: {loop_count})\n")
                else:
                    print("\n⚠️ Connection lost. Press 'R' to reconnect.")
                    macro.is_running = False
            else:
                # If macro is paused, wait briefly.
                time.sleep(0.1)

    except KeyboardInterrupt:
        print("\n\n⏹️ Ctrl+C pressed.")
        print("Exiting the program...")
        macro.should_stop = True

    except Exception as e:
        print(f"\n❌ An error occurred: {e}")
        macro.should_stop = True

    finally:
        # Ensuring disconnection process is executed.
        macro.disconnect()
        print("\n👋 Exited. Thank you for using!")


if __name__ == "__main__":
    print("""
╔══════════════════════════════════════════════════════╗
║                                                      ║
║      🎮 Nintendo Switch Automation Macro Tool 🎮     ║
║                                                      ║
║      ZL+A Auto-Press Program (Macro Version)         ║
║      Controls: ENTER (Start/Stop) / R (Reconnect)    ║
║      Exit: CTRL+C                                    ║
║                                                      ║
╚══════════════════════════════════════════════════════╝
    """)

    print("\n⚠️ Disclaimer:")
    print("  - This tool is created for educational purposes.")
    print("  - Use in online games is not recommended.")
    print("  - Please check the terms of service for your game.")
    print("  - Use at your own risk.\n")

    input("Press Enter when you are ready to start...")

    # Running the main macro.
    zl_a_loop()