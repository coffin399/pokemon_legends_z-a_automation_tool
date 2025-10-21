# 🎮 Herramienta de Automatización Pokemon Legends Z-A (Linux/Ubuntu)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Ubuntu-orange)
![Language](https://img.shields.io/badge/Language-Python-blue.svg)
![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)

---

## 📖 Idioma / Language

- [🇯🇵 日本語](README.md)
- [🇺🇸 English](README_en.md)
- [🇫🇷 Français](README_fr.md)
- [🇩🇪 Deutsch](README_de.md)
- [🇨🇳 简体中文](README_zh-CN.md)
- [🇹🇼 繁體中文](README_zh-TW.md)
- [🇪🇸 Español](README_es.md) (Actual)

---

![Vista previa de funcionamiento](preview.gif)
**¡Súper fácil!** Una herramienta que puede controlar automáticamente tu Nintendo Switch con un solo script.

Presiona automáticamente el botón A de forma continua mientras mantienes presionado ZL.

¡Puedes iniciar/detener la macro libremente con la **tecla ENTER** o **CTRL+Y**!

---

## 📋 ¿Qué puede hacer esta herramienta?

- **Pulsación automática de ZL+A** en bucle continuo
- **Iniciar/detener fácilmente con la tecla ENTER** - Puedes interrumpir y reanudar en cualquier momento
- **También se puede detener con CTRL+Y** - Detención rápida
- Automatiza tareas simples y repetitivas en el juego
- Se puede usar sin conocimientos de programación

---

## 🛠️ Requisitos

### Hardware
- ✅ PC con **Ubuntu 24.04 LTS** instalado (u otro Linux basado en Debian)
- ✅ Funcionalidad Bluetooth (integrado o adaptador USB)
- ✅ Consola Nintendo Switch

### Otros
- Conexión a Internet (solo necesaria para la configuración inicial)
- Aproximadamente 10 minutos de tiempo (solo para la configuración inicial)

---

## 📁 Estructura de archivos

Contenido de la carpeta descargada:

```
switch-macro/
│
├── 📄 README.md               ← Este archivo (guía completa)
├── 📄 LICENSE                 ← Licencia MIT
│
├── 🚀 set_up.sh          ← ★【HACER PRIMERO】Script de configuración de entorno con un clic
├── 🎮 control_panel.sh        ← ★【USAR ESTO】Panel de control
│
└── 📁 src/                    ← Código fuente principal
    ├── macro1.py              ← Script de ejecución de macro
    ├── others_macro.py        ← Script de ejecución de macro
    ...
```

### 🎯 ¿Qué archivo usar?

| Archivo               | Propósito |
|--------------------|------|
| `set_up.sh`        | **Solo la primera vez** - Instala automáticamente todo lo necesario. |
| `control_panel.sh` | **Usar cada vez** - Desde aquí realizas todas las operaciones: iniciar/detener macro, verificar conexión, etc. |

**¡Después de configurar el entorno con `set_up.sh`, solo usa `control_panel.sh`!**

---

## 🚀 Configuración inicial (versión con un clic)

Operación necesaria solo la primera vez que lo uses. **¡Solo ejecuta 3 comandos!**

### ⏱️ Tiempo requerido: Aproximadamente 10 minutos

---

### 📝 Paso 1: Abrir la terminal

Presiona `Ctrl + Alt + T` en tu teclado para abrir la terminal (pantalla negra).

### 📝 Paso 2: Ejecutar el script

Copia y pega los siguientes comandos **uno por uno** y presiona **Enter**.

```bash
# 1. Navigate to the downloaded folder
# Example: cd ~/Downloads/switch-macro
cd /path/to/your/switch-macro

# 2. Grant execution permission to the script (first time only)
chmod +x set_up.sh

# 3. Run the setup script
./set_up.sh
```

Si se te solicita una contraseña durante la ejecución, ingresa la contraseña de inicio de sesión de tu PC.
(La contraseña no se mostrará en la pantalla mientras la escribes, pero se está ingresando)

---

### 🎉 ¡Configuración completa!

Cuando aparezca "セットアップがすべて完了しました！" (¡La configuración está completa!), estás listo.
¡Buen trabajo! A partir de la próxima vez, ve a "Modo de uso".

---

## 🎯 Modo de uso (cada vez)

Una vez completada la configuración, solo necesitas usar el **panel de control** en adelante.

Ejecuta los siguientes comandos en la terminal.

```bash
# 1. Navigate to the folder
cd /path/to/your/switch-macro

# 2. Launch the control panel
./control_panel.sh
```

Se mostrará la pantalla del menú:

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

#### 📝 Procedimiento de operación

1. **Preparar Nintendo Switch**
   - Inicio → "Controles" → "Cambiar orden/estilo"

2. **Iniciar macro**
   - Presiona "**1**" y luego Enter
   - La macro se iniciará en una nueva ventana de terminal

3. **Detener macro**
   - Vuelve a la ventana del panel de control, presiona "**2**" y luego Enter

4. **Después de reiniciar el PC**
   - Si el Bluetooth no funciona bien, puedes presionar "**3**" para reiniciar el servicio.

---

## 🎮 Método de operación

| Tecla | Acción |
|---------|------|
| **ENTER** | Iniciar macro / Pausar / Reanudar |
| **CTRL+Y** | Detener macro |
| **CTRL+C** | Salir del programa · Desconectar |

### Funcionamiento de la macro (para restaurante)

```
1. Presionar botón ZL (0.5 segundos)
   ↓
2. Presionar ZL+A simultáneamente (0.1 segundos)
   ↓
3. Esperar 0.5 segundos
   ↓
4. Repetir hasta presionar tecla ENTER o CTRL+Y
```

---

## 🔄 Uso después de reiniciar el PC

Básicamente, solo ejecuta los pasos de la sección "Modo de uso" cada vez.

Si el Bluetooth no funciona correctamente, inicia `control_panel.sh` y presiona "**3**" para intentar reiniciar el servicio Bluetooth.

---

## ⚠️ Solución de problemas

### 💡 Primero intenta esto

**`./control_panel.sh` → "4" Verificación de entorno**

Puede ayudar a identificar el problema.

---

### Problema 1: "No se encuentra el adaptador Bluetooth" "No se puede conectar"

**Solución**:

1. **Desde el panel de control**
   - `./control_panel.sh` → "3" Reiniciar Bluetooth

2. **O manualmente**
   ```bash
   # Run in terminal
   sudo systemctl restart bluetooth
   sleep 3
   hciconfig
   ```
   Si muestra `UP RUNNING`, está bien.

3. **Verificar la preparación del Switch**
   - Confirma que la pantalla "Cambiar orden/estilo" del Switch está abierta
   - Desconecta todos los demás controles

---

### Problema 2: La tecla ENTER o CTRL+Y no funciona

**Causa**: La ventana de terminal no está seleccionada

**Solución**:
1. Haz clic en la ventana de terminal donde se está ejecutando la macro para seleccionarla
2. Presiona la tecla ENTER o CTRL+Y

---

### Problema 3: La macro no se detiene

**Solución**:

1. **Desde el panel de control**
   - `./control_panel.sh` → "2" Detener macro

2. **O manualmente**
   ```bash
   # Run in terminal
   sudo pkill -f switch_macro.py
   ```

---

### Problema 4: Error "Permission denied"

**Causa**: Intentando ejecutar sin `sudo` (permisos de administrador)

**Solución**:
Asegúrate de iniciar usando `./control_panel.sh`. Este script usa correctamente `sudo` internamente.

---

### Problema 5: Errores como "nxbt: command not found"

**Causa**: El entorno virtual de Python no está activado

**Solución**:
Asegúrate de iniciar usando `./control_panel.sh`. Este script activa automáticamente el entorno virtual.

---

## 🔧 Personalización (para usuarios avanzados)

### Editar la macro

Abre `src/switch_macro.py` con un editor de texto y edita la siguiente parte:

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

### Botones disponibles

| Botón | Código |
|--------|--------|
| A, B, X, Y | `"A"`, `"B"`, `"X"`, `"Y"` |
| L, R | `"L"`, `"R"` |
| ZL, ZR | `"ZL"`, `"ZR"` |
| Cruceta | `"DPAD_UP"`, `"DPAD_DOWN"`, `"DPAD_LEFT"`, `"DPAD_RIGHT"` |
| Sistema | `"PLUS"`, `"MINUS"`, `"HOME"`, `"CAPTURE"` |

---

## 🗑️ Desinstalación

1. Elimina la carpeta del proyecto.
    ```bash
    rm -rf /path/to/your/switch-macro
    ```

2. (Opcional) Si deseas eliminar los paquetes del sistema instalados durante la configuración:
    ```bash
    sudo apt remove --purge -y python3-pip python3-venv bluez libbluetooth-dev libhidapi-dev
    sudo apt autoremove -y
    ```

---

## ⚖️ Riesgos y descargo de responsabilidad (Importante)

### 🚨 Riesgo de BAN

Esta herramienta es una herramienta de automatización **similar a los controles de disparo rápido/controles de macro**.

#### Posible violación de los términos de uso de Nintendo

El uso de medios de automatización está expresamente prohibido.

#### Posible BAN de consola y cuenta

- ✗ No se puede acceder a la eShop
- ✗ No se puede jugar multijugador en línea
- ✗ No se pueden actualizar juegos
- ✗ Todas las funciones en línea no disponibles

### 💡 Condiciones de uso seguro

1. **Switch dedicado completamente sin conexión**
2. **Uso en consola secundaria**
3. **Solo juegos de un jugador**
4. **Propósitos educativos y de investigación**

### ⚖️ Responsabilidad legal

El creador no asume ninguna responsabilidad por cualquier daño o BAN causado por el uso.

**El uso es completamente bajo tu propio riesgo.**

---

## 📚 Preguntas frecuentes (FAQ)

### P1: ¿Qué archivo debo usar?

**R**: ¡La primera vez ejecuta `set_up.sh`, luego solo usa **`control_panel.sh`**!

---

### P2: ¿En qué juegos se puede usar?

**R**: Funciona en todos los juegos de Switch, pero no lo uses en juegos en línea.

---

### P3: ¿Qué pasa si el PC entra en modo de suspensión?

**R**: La conexión se perderá. Intenta `control_panel.sh` → "3" para reiniciar Bluetooth.

---

### P4: ¿Puedo pausar la macro y reanudarla más tarde?

**R**: ¡Sí! Presiona la tecla ENTER en la ventana de ejecución de la macro para pausar, presiona nuevamente para reanudar.

---

## 🎉 ¡Disfruta de una vida de juego divertida!

**Happy Gaming! 🎮✨**

---

## 📝 Historial de actualizaciones
- v2.0.0 (2025/10/20)
  - Cambiado a formato de envío de macro
- v1.2.0 (2025/10/19)
  - Eliminado `run_macro.sh`, operación unificada en `control_panel.sh`
- v1.1.0 (2025/10/19)
  - Soporte oficial para Linux/Ubuntu
  - Agregado script de configuración con un clic `set_up.sh`
  - Agregado panel de control `control_panel.sh`

- v1.0.0 (2025/10/19)
  - Lanzamiento inicial

---

**Creador**: coffin299 y amigos divertidos  
**Licencia**: MIT  
**Soporte**: GitHub Issues