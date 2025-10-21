# 🎮 Pokemon Legends Z-A Automatisierungs-Tool (Linux/Ubuntu)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Ubuntu-orange)
![Language](https://img.shields.io/badge/Language-Python-blue.svg)
![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)

---

## 📖 Language / 言語

- [🇯🇵 日本語](README.md)
- [🇺🇸 English](README_en.md)
- [🇫🇷 Français](README_fr.md)
- [🇩🇪 Deutsch](README_de.md) (Aktuell)
- [🇨🇳 简体中文](README_zh-CN.md)
- [🇹🇼 繁體中文](README_zh-TW.md)
- [🇪🇸 Español](README_es.md)

---

![Vorschau](preview.gif)

**Super Einfach!** Automatisieren Sie Ihre Nintendo Switch mit nur einem Skript.

Drückt automatisch die ZL-Taste, während schnell die A-Taste gedrückt wird.

**ENTER-Taste** oder **STRG+Y** zum Starten/Stoppen des Makros jederzeit!

---

## 📋 Was Kann Dieses Tool?

- **Automatische Wiederholung der ZL+A-Tastenkombination** in einer Schleife
- **Einfaches Starten/Stoppen mit der ENTER-Taste** - jederzeit pausieren und fortsetzen
- **STRG+Y stoppt ebenfalls** - schnelles Beenden
- Automatisiert sich wiederholende Aufgaben in Spielen
- Keine Programmierkenntnisse erforderlich

---

## 🛠️ Anforderungen

### Hardware
- ✅ PC mit **Ubuntu 24.04 LTS** (oder anderes Debian-basiertes Linux)
- ✅ Bluetooth-Fähigkeit (integriert oder USB-Adapter)
- ✅ Nintendo Switch-Konsole

### Sonstiges
- Internetverbindung (nur beim ersten Setup)
- Etwa 10 Minuten (nur beim ersten Setup)

---

## 📁 Dateistruktur

Inhalt des heruntergeladenen Ordners:

```
switch-macro/
│
├── 📄 README.md               ← Diese Datei (vollständige Anleitung)
├── 📄 LICENSE                 ← MIT-Lizenz
│
├── 🚀 set_up.sh          ← ★【Erstmalig】Ein-Klick-Umgebungs-Setup-Skript
├── 🎮 control_panel.sh        ← ★【Dies verwenden】Kontrollpanel
│
└── 📁 src/                    ← Hauptquellcode
    ├── macro1.py              ← Makro-Ausführungsskript
    ├── others_macro.py        ← Makro-Ausführungsskript
    ...
```

### 🎯 Welche Dateien Verwenden?

| Datei              | Zweck |
|--------------------|-------|
| `set_up.sh`        | **Nur beim ersten Mal** - Installiert automatisch alles Notwendige. |
| `control_panel.sh` | **Jedes Mal** - Makros starten/stoppen, Verbindungen prüfen usw. |

**Nach dem Setup mit `set_up.sh` einfach `control_panel.sh` verwenden!**

---

## 🚀 Erstmaliges Setup (Ein-Klick)

Nur beim ersten Mal notwendig. **Führen Sie einfach 3 Befehle aus!**

### ⏱️ Benötigte Zeit: Etwa 10 Minuten

---

### 📝 Schritt 1: Terminal Öffnen

Drücken Sie `Strg + Alt + T` auf Ihrer Tastatur, um das Terminal (schwarzer Bildschirm) zu öffnen.

### 📝 Schritt 2: Skript Ausführen

Kopieren Sie die folgenden Befehle **einzeln** und drücken Sie **Enter**.

```bash
# 1. Navigate to the downloaded folder
# Example: cd ~/Downloads/switch-macro
cd /path/to/your/switch-macro

# 2. Grant execution permission to the script (first time only)
chmod +x set_up.sh

# 3. Run the setup script
./set_up.sh
```

Wenn Sie nach einem Passwort gefragt werden, geben Sie das Anmeldepasswort Ihres PCs ein.
(Das Passwort wird nicht auf dem Bildschirm angezeigt, wird aber eingegeben)

---

### 🎉 Setup Abgeschlossen!

Wenn Sie "Setup erfolgreich abgeschlossen!" sehen, sind Sie bereit.
Großartige Arbeit! Fahren Sie nun mit "Verwendung" fort.

---

## 🎯 Verwendung (Jedes Mal)

Nach Abschluss des Setups verwenden Sie einfach das **Kontrollpanel**.

Führen Sie die folgenden Befehle im Terminal aus:

```bash
# 1. Navigate to the folder
cd /path/to/your/switch-macro

# 2. Launch the control panel
./control_panel.sh
```

Der Menübildschirm wird erscheinen:

```
========================================
  Nintendo Switch Makro Kontrollpanel
========================================

Status    : [Gestoppt] Makro gestoppt
Bluetooth : [Verbunden] Adapter aktiv

========================================

[1] Makro Starten
[2] Makro Stoppen
[3] Bluetooth Neustarten
[4] Umgebungsprüfung
[5] Status Aktualisieren
[0] Beenden

========================================
```

#### 📝 Bedienungsschritte

1. **Nintendo Switch Vorbereiten**
   - Home → "Controller" → "Griffweise/Reihenfolge ändern"

2. **Makro Starten**
   - Drücken Sie "**1**" und Enter
   - Makro startet in einem neuen Terminalfenster

3. **Makro Stoppen**
   - Kehren Sie zum Kontrollpanel-Fenster zurück, drücken Sie "**2**" und Enter

4. **Nach PC-Neustart**
   - Wenn Bluetooth nicht gut funktioniert, drücken Sie "**3**", um den Dienst neu zu starten.

---

## 🎮 Steuerung

| Tastenbedienung | Aktion |
|-----------------|--------|
| **ENTER** | Makro starten / Pausieren / Fortsetzen |
| **STRG+Y** | Makro stoppen |
| **STRG+C** | Programm beenden und trennen |

### Makro-Verhalten (Für Restaurant)

```
1. ZL-Taste drücken (0.5s)
   ↓
2. ZL+A gleichzeitig drücken (0.1s)
   ↓
3. 0.5s warten
   ↓
4. Wiederholen, bis ENTER oder STRG+Y gedrückt wird
```

---

## 🔄 Nach PC-Neustart

Grundsätzlich folgen Sie einfach jedes Mal den Schritten im Abschnitt "Verwendung".

Wenn Bluetooth nicht richtig funktioniert, starten Sie `control_panel.sh` und drücken Sie "**3**", um den Bluetooth-Dienst neu zu starten.

---

## ⚠️ Fehlerbehebung

### 💡 Versuchen Sie Dies Zuerst

**`./control_panel.sh` → "4" Umgebungsprüfung**

Dies hilft, das Problem zu identifizieren.

---

### Problem 1: "Bluetooth-Adapter nicht gefunden" "Verbindung nicht möglich"

**Lösung**:

1. **Vom Kontrollpanel**
   - `./control_panel.sh` → "3" Bluetooth Neustarten

2. **Oder manuell**
   ```bash
   # Run in terminal
   sudo systemctl restart bluetooth
   sleep 3
   hciconfig
   ```
   Wenn `UP RUNNING` angezeigt wird, ist es OK.

3. **Switch-Vorbereitung Überprüfen**
   - Bestätigen Sie, dass der Bildschirm "Griffweise/Reihenfolge ändern" der Switch geöffnet ist
   - Trennen Sie alle anderen Controller

---

### Problem 2: ENTER-Taste oder STRG+Y funktioniert nicht

**Ursache**: Terminalfenster ist nicht ausgewählt

**Lösung**:
1. Klicken Sie auf das Terminalfenster, das das Makro ausführt, um es auszuwählen
2. Drücken Sie ENTER oder STRG+Y

---

### Problem 3: Makro stoppt nicht

**Lösung**:

1. **Vom Kontrollpanel**
   - `./control_panel.sh` → "2" Makro Stoppen

2. **Oder manuell**
   ```bash
   # Run in terminal
   sudo pkill -f switch_macro.py
   ```

---

### Problem 4: "Permission denied"-Fehler

**Ursache**: Versuch, ohne `sudo` (Administratorrechte) auszuführen

**Lösung**:
Verwenden Sie immer `./control_panel.sh` zum Starten. Dieses Skript verwendet `sudo` intern korrekt.

---

### Problem 5: "nxbt: command not found" oder ähnliche Fehler

**Ursache**: Python-Virtual-Environment ist nicht aktiviert

**Lösung**:
Verwenden Sie immer `./control_panel.sh` zum Starten. Dieses Skript aktiviert automatisch das Virtual Environment.

---

## 🔧 Anpassung (Fortgeschrittene Benutzer)

### Makros Bearbeiten

Öffnen Sie `src/switch_macro.py` in einem Texteditor und bearbeiten Sie den folgenden Abschnitt:

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

### Verfügbare Tasten

| Taste | Code |
|-------|------|
| A, B, X, Y | `"A"`, `"B"`, `"X"`, `"Y"` |
| L, R | `"L"`, `"R"` |
| ZL, ZR | `"ZL"`, `"ZR"` |
| Steuerkreuz | `"DPAD_UP"`, `"DPAD_DOWN"`, `"DPAD_LEFT"`, `"DPAD_RIGHT"` |
| System | `"PLUS"`, `"MINUS"`, `"HOME"`, `"CAPTURE"` |

---

## 🗑️ Deinstallation

1. Löschen Sie den Projektordner.
    ```bash
    rm -rf /path/to/your/switch-macro
    ```

2. (Optional) Um während des Setups installierte Systempakete zu entfernen:
    ```bash
    sudo apt remove --purge -y python3-pip python3-venv bluez libbluetooth-dev libhidapi-dev
    sudo apt autoremove -y
    ```

---

## ⚖️ Risiken und Haftungsausschluss (Wichtig)

### 🚨 Sperrrisiko

Dieses Tool ist ein Automatisierungstool **ähnlich wie Turbo-Controller/Makro-Controller**.

#### Möglicher Verstoß gegen Nintendo-Nutzungsbedingungen

Die Verwendung von Automatisierungsmethoden ist ausdrücklich verboten.

#### Mögliche Konsolen-/Kontosperrung

- ✗ Kein eShop-Zugriff
- ✗ Kein Online-Multiplayer
- ✗ Keine Spiele-Updates
- ✗ Alle Online-Funktionen deaktiviert

### 💡 Sichere Nutzungsbedingungen

1. **Nur vollständig offline Switch**
2. **Verwendung auf Zweitkonsole**
3. **Nur Einzelspielerspiele**
4. **Bildungs-/Forschungszwecke**

### ⚖️ Rechtliche Haftung

Der Ersteller übernimmt keine Verantwortung für Schäden oder Sperrungen, die sich aus der Nutzung ergeben.

**Die Nutzung erfolgt vollständig auf eigenes Risiko.**

---

## 📚 Häufig Gestellte Fragen (FAQ)

### F1: Welche Datei soll ich verwenden?

**A**: Führen Sie beim ersten Mal `set_up.sh` aus, dann verwenden Sie einfach **`control_panel.sh`**!

---

### F2: Mit welchen Spielen kann ich dies verwenden?

**A**: Es funktioniert mit allen Switch-Spielen, aber verwenden Sie es NICHT mit Online-Spielen.

---

### F3: Was passiert, wenn mein PC in den Ruhezustand wechselt?

**A**: Die Verbindung geht verloren. Versuchen Sie `control_panel.sh` → "3", um Bluetooth neu zu starten.

---

### F4: Kann ich das Makro pausieren und später fortsetzen?

**A**: Ja! Drücken Sie ENTER im Makro-Ausführungsfenster zum Pausieren, drücken Sie erneut zum Fortsetzen.

---

## 🎉 Genießen Sie Ihr Gaming-Leben!

**Viel Spaß beim Spielen! 🎮✨**

---

## 📝 Änderungsprotokoll
- v2.0.0 (2025/10/20)
  - Wechsel zum Makro-Übertragungsformat
- v1.2.0 (2025/10/19)
  - `run_macro.sh` veraltet, Operationen in `control_panel.sh` vereinheitlicht
- v1.1.0 (2025/10/19)
  - Offizielle Linux/Ubuntu-Unterstützung
  - Ein-Klick-Setup-Skript `set_up.sh` hinzugefügt
  - Kontrollpanel `control_panel.sh` hinzugefügt

- v1.0.0 (2025/10/19)
  - Erste Veröffentlichung

---

**Ersteller**: coffin299 und Freunde  
**Lizenz**: MIT  
**Support**: GitHub Issues