# 🎮 Outil d'Automatisation Pokemon Legends Z-A (Linux/Ubuntu)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Ubuntu-orange)
![Language](https://img.shields.io/badge/Language-Python-blue.svg)
![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)

---

## 📖 Language / 言語

- [🇯🇵 日本語](README.md)
- [🇺🇸 English](README_en.md)
- [🇫🇷 Français](README_fr.md) (Actuel)
- [🇩🇪 Deutsch](README_de.md)
- [🇨🇳 简体中文](README_zh-CN.md)
- [🇹🇼 繁體中文](README_zh-TW.md)
- [🇪🇸 Español](README_es.md)

---

![Aperçu](preview.gif)

**Super Facile!** Automatisez votre Nintendo Switch avec un seul script.

Appuie automatiquement sur le bouton ZL tout en appuyant rapidement sur le bouton A.

**Touche ENTRÉE** ou **CTRL+Y** pour démarrer/arrêter la macro à tout moment!

---

## 📋 Que Peut Faire Cet Outil?

- **Répétition automatique de la combinaison ZL+A** en boucle
- **Démarrage/arrêt facile avec la touche ENTRÉE** - pause et reprise à tout moment
- **CTRL+Y arrête également** - arrêt rapide
- Automatise les tâches répétitives dans les jeux
- Aucune connaissance en programmation requise

---

## 🛠️ Prérequis

### Matériel
- ✅ PC avec **Ubuntu 24.04 LTS** (ou autre Linux basé sur Debian)
- ✅ Capacité Bluetooth (intégrée ou adaptateur USB)
- ✅ Console Nintendo Switch

### Autre
- Connexion Internet (première installation uniquement)
- Environ 10 minutes (première installation uniquement)

---

## 📁 Structure des Fichiers

Contenu du dossier téléchargé:

```
switch-macro/
│
├── 📄 README.md               ← Ce fichier (guide complet)
├── 📄 LICENSE                 ← Licence MIT
│
├── 🚀 set_up.sh          ← ★【Première fois】Script de configuration en un clic
├── 🎮 control_panel.sh        ← ★【Utilisez ceci】Panneau de contrôle
│
└── 📁 src/                    ← Code source principal
    ├── macro1.py              ← Script d'exécution de macro
    ├── others_macro.py        ← Script d'exécution de macro
    ...
```

### 🎯 Quels Fichiers Utiliser?

| Fichier            | Objectif |
|--------------------|----------|
| `set_up.sh`        | **Première fois uniquement** - Installe automatiquement tout ce qui est nécessaire. |
| `control_panel.sh` | **À chaque fois** - Démarrer/arrêter les macros, vérifier les connexions, etc. |

**Après la configuration avec `set_up.sh`, utilisez simplement `control_panel.sh`!**

---

## 🚀 Configuration Initiale (Un Clic)

Nécessaire uniquement lors de la première utilisation. **Exécutez simplement 3 commandes!**

### ⏱️ Temps Requis: Environ 10 minutes

---

### 📝 Étape 1: Ouvrir le Terminal

Appuyez sur `Ctrl + Alt + T` sur votre clavier pour ouvrir le Terminal (écran noir).

### 📝 Étape 2: Exécuter le Script

Copiez et collez les commandes suivantes **une par une** et appuyez sur **Entrée**.

```bash
# 1. Navigate to the downloaded folder
# Example: cd ~/Downloads/switch-macro
cd /path/to/your/switch-macro

# 2. Grant execution permission to the script (first time only)
chmod +x set_up.sh

# 3. Run the setup script
./set_up.sh
```

Si on vous demande un mot de passe, entrez le mot de passe de connexion de votre PC.
(Le mot de passe ne s'affichera pas à l'écran, mais il est bien saisi)

---

### 🎉 Configuration Terminée!

Lorsque vous voyez "Configuration terminée avec succès!", vous êtes prêt.
Excellent travail! Passez maintenant à "Comment Utiliser".

---

## 🎯 Comment Utiliser (À Chaque Fois)

Une fois la configuration terminée, utilisez simplement le **Panneau de Contrôle**.

Exécutez les commandes suivantes dans le Terminal:

```bash
# 1. Navigate to the folder
cd /path/to/your/switch-macro

# 2. Launch the control panel
./control_panel.sh
```

L'écran de menu apparaîtra:

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

#### 📝 Étapes d'Utilisation

1. **Préparer la Nintendo Switch**
   - Accueil → "Manettes" → "Changer le style/l'ordre"

2. **Démarrer la Macro**
   - Appuyez sur "**1**" et Entrée
   - La macro démarre dans une nouvelle fenêtre de terminal

3. **Arrêter la Macro**
   - Revenez à la fenêtre du panneau de contrôle, appuyez sur "**2**" et Entrée

4. **Après le Redémarrage du PC**
   - Si le Bluetooth ne fonctionne pas bien, appuyez sur "**3**" pour redémarrer le service.

---

## 🎮 Contrôles

| Opération | Action |
|-----------|--------|
| **ENTRÉE** | Démarrer / Pause / Reprendre la macro |
| **CTRL+Y** | Arrêter la macro |
| **CTRL+C** | Quitter le programme et se déconnecter |

### Comportement de la Macro (Pour le Restaurant)

```
1. Appuyer sur le bouton ZL (0.5s)
   ↓
2. Appuyer sur ZL+A simultanément (0.1s)
   ↓
3. Attendre 0.5s
   ↓
4. Répéter jusqu'à ce qu'ENTRÉE ou CTRL+Y soit pressé
```

---

## 🔄 Après le Redémarrage du PC

En principe, suivez simplement les étapes de la section "Comment Utiliser" à chaque fois.

Si le Bluetooth ne fonctionne pas correctement, lancez `control_panel.sh` et appuyez sur "**3**" pour redémarrer le service Bluetooth.

---

## ⚠️ Dépannage

### 💡 Essayez Ceci en Premier

**`./control_panel.sh` → "4" Vérification de l'Environnement**

Cela aide à identifier le problème.

---

### Problème 1: "Adaptateur Bluetooth introuvable" "Impossible de se connecter"

**Solution**:

1. **Depuis le Panneau de Contrôle**
   - `./control_panel.sh` → "3" Redémarrer Bluetooth

2. **Ou manuellement**
   ```bash
   # Run in terminal
   sudo systemctl restart bluetooth
   sleep 3
   hciconfig
   ```
   Si `UP RUNNING` est affiché, c'est OK.

3. **Vérifier la Préparation de la Switch**
   - Confirmer que l'écran "Changer le style/l'ordre" de la Switch est ouvert
   - Déconnecter tous les autres contrôleurs

---

### Problème 2: La touche ENTRÉE ou CTRL+Y ne fonctionne pas

**Cause**: La fenêtre du terminal n'est pas sélectionnée

**Solution**:
1. Cliquez sur la fenêtre du terminal exécutant la macro pour la sélectionner
2. Appuyez sur ENTRÉE ou CTRL+Y

---

### Problème 3: La macro ne s'arrête pas

**Solution**:

1. **Depuis le Panneau de Contrôle**
   - `./control_panel.sh` → "2" Arrêter la Macro

2. **Ou manuellement**
   ```bash
   # Run in terminal
   sudo pkill -f switch_macro.py
   ```

---

### Problème 4: Erreur "Permission denied"

**Cause**: Tentative d'exécution sans `sudo` (privilèges administrateur)

**Solution**:
Utilisez toujours `./control_panel.sh` pour lancer. Ce script utilise `sudo` correctement en interne.

---

### Problème 5: "nxbt: command not found" ou erreurs similaires

**Cause**: L'environnement virtuel Python n'est pas activé

**Solution**:
Utilisez toujours `./control_panel.sh` pour lancer. Ce script active automatiquement l'environnement virtuel.

---

## 🔧 Personnalisation (Utilisateurs Avancés)

### Édition des Macros

Ouvrez `src/switch_macro.py` dans un éditeur de texte et modifiez la section suivante:

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

### Boutons Disponibles

| Bouton | Code |
|--------|------|
| A, B, X, Y | `"A"`, `"B"`, `"X"`, `"Y"` |
| L, R | `"L"`, `"R"` |
| ZL, ZR | `"ZL"`, `"ZR"` |
| Croix directionnelle | `"DPAD_UP"`, `"DPAD_DOWN"`, `"DPAD_LEFT"`, `"DPAD_RIGHT"` |
| Système | `"PLUS"`, `"MINUS"`, `"HOME"`, `"CAPTURE"` |

---

## 🗑️ Désinstallation

1. Supprimez le dossier du projet.
    ```bash
    rm -rf /path/to/your/switch-macro
    ```

2. (Optionnel) Pour supprimer les paquets système installés lors de la configuration:
    ```bash
    sudo apt remove --purge -y python3-pip python3-venv bluez libbluetooth-dev libhidapi-dev
    sudo apt autoremove -y
    ```

---

## ⚖️ Risques et Avertissement (Important)

### 🚨 Risque de Bannissement

Cet outil est un outil d'automatisation **similaire aux contrôleurs turbo/macro**.

#### Violation Potentielle des Conditions d'Utilisation de Nintendo

L'utilisation de méthodes d'automatisation est explicitement interdite.

#### Bannissement Possible de la Console/Compte

- ✗ Pas d'accès à l'eShop
- ✗ Pas de multijoueur en ligne
- ✗ Pas de mises à jour de jeux
- ✗ Toutes les fonctionnalités en ligne désactivées

### 💡 Conditions d'Utilisation Sûre

1. **Switch complètement hors ligne uniquement**
2. **Utilisation sur console secondaire**
3. **Jeux solo uniquement**
4. **À des fins éducatives/de recherche**

### ⚖️ Responsabilité Légale

Le créateur n'assume aucune responsabilité pour tout dommage ou bannissement résultant de l'utilisation.

**L'utilisation est entièrement à vos propres risques.**

---

## 📚 Questions Fréquemment Posées (FAQ)

### Q1: Quel fichier dois-je utiliser?

**R**: Exécutez `set_up.sh` la première fois, puis utilisez simplement **`control_panel.sh`**!

---

### Q2: Avec quels jeux puis-je utiliser ceci?

**R**: Il fonctionne avec tous les jeux Switch, mais NE PAS utiliser avec les jeux en ligne.

---

### Q3: Que se passe-t-il si mon PC se met en veille?

**R**: La connexion sera perdue. Essayez `control_panel.sh` → "3" pour redémarrer le Bluetooth.

---

### Q4: Puis-je mettre la macro en pause et reprendre plus tard?

**R**: Oui! Appuyez sur ENTRÉE dans la fenêtre d'exécution de la macro pour mettre en pause, appuyez à nouveau pour reprendre.

---

## 🎉 Profitez de Votre Vie de Joueur!

**Bon Jeu! 🎮✨**

---

## 📝 Journal des Modifications
- v2.0.0 (2025/10/20)
  - Changement vers le format de transmission de macro
- v1.2.0 (2025/10/19)
  - Dépréciation de `run_macro.sh`, opérations unifiées dans `control_panel.sh`
- v1.1.0 (2025/10/19)
  - Support officiel Linux/Ubuntu
  - Ajout du script de configuration en un clic `set_up.sh`
  - Ajout du panneau de contrôle `control_panel.sh`

- v1.0.0 (2025/10/19)
  - Version initiale

---

**Créateur**: coffin299 et amis  
**Licence**: MIT  
**Support**: GitHub Issues