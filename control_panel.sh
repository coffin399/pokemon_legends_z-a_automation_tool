#!/bin/bash

# --- �F�t���p�̕ϐ� ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- �ݒ� ---
PROJECT_DIR="$HOME/switch-macro"
MACRO_SCRIPT="src/switch_macro.py"

# --- �֐���` ---

# ��ԕ\��
display_status() {
    echo "========================================"
    echo "  Nintendo Switch �}�N�� �R���g���[���p�l��"
    echo "========================================"
    echo

    # �}�N����Ԋm�F
    if pgrep -f "$MACRO_SCRIPT" > /dev/null; then
        echo -e "���      : ${GREEN}[���s��]${NC} �}�N�����s��"
    else
        echo -e "���      : ${YELLOW}[��~��]${NC} �}�N����~��"
    fi

    # Bluetooth��Ԋm�F
    if hciconfig 2>/dev/null | grep -q "UP RUNNING"; then
        echo -e "Bluetooth : ${GREEN}[�ڑ���]${NC} �A�_�v�^�L��"
    else
        echo -e "Bluetooth : ${RED}[���ڑ�]${NC} �A�_�v�^�����܂��̓G���["
    fi

    echo
    echo "========================================"
    echo
    echo "[1] �}�N���J�n"
    echo "[2] �}�N����~"
    echo "[3] Bluetooth�ċN��"
    echo "[4] ���`�F�b�N"
    echo "[5] ��Ԃ��X�V"
    echo "[0] �I��"
    echo
    echo "========================================"
}

# �}�N���J�n
start_macro() {
    clear
    echo "========================================"
    echo "  �}�N���J�n"
    echo "========================================"
    echo
    if pgrep -f "$MACRO_SCRIPT" > /dev/null; then
        echo -e "${YELLOW}[�x��] �}�N���͊��Ɏ��s���ł��B${NC}"
        read -p "Enter�L�[�������ă��j���[�ɖ߂�܂�..."
        return
    fi

    echo "Switch�Łu��������/���Ԃ�ς���v���J���Ă�������"
    read -p "�������ł�����Enter�L�[�������Ă�������..."

    echo "�}�N����V�����E�B���h�E�ŋN����..."
    
    # gnome-terminal���g���ĕʃE�B���h�E�Ŏ��s
    gnome-terminal -- bash -c "cd '$PROJECT_DIR' && source .venv/bin/activate && sudo python3 '$MACRO_SCRIPT'; exec bash"
    
    sleep 2
    echo
    echo -e "${GREEN}[����] �}�N�����N�����܂����B${NC}"
    echo "   �V�����^�[�~�i���E�B���h�E�Ŏ��s���ł��B"
    echo
    read -p "Enter�L�[�������ă��j���[�ɖ߂�܂�..."
}

# �}�N����~
stop_macro() {
    clear
    echo "========================================"
    echo "  �}�N����~"
    echo "========================================"
    echo
    if pgrep -f "$MACRO_SCRIPT" > /dev/null; then
        sudo pkill -f "$MACRO_SCRIPT"
        echo -e "${GREEN}[����] �}�N�����~���܂����B${NC}"
    else
        echo -e "${YELLOW}[���] �}�N���͎��s����Ă��܂���ł����B${NC}"
    fi
    echo
    read -p "Enter�L�[�������ă��j���[�ɖ߂�܂�..."
}

# Bluetooth�ċN��
reconnect_bt() {
    clear
    echo "========================================"
    echo "  Bluetooth�ċN��"
    echo "========================================"
    echo
    echo "Bluetooth�T�[�r�X���ċN�����܂�..."
    sudo systemctl restart bluetooth
    
    if [ $? -eq 0 ]; then
        echo "�T�[�r�X�ċN���R�}���h�𑗐M���܂����B"
        echo "�A�_�v�^�̏�������҂��Ă��܂�... (5�b)"
        sleep 5
        
        echo
        echo "--- hciconfig �̎��s���� ---"
        hciconfig
        echo "---------------------------"
        echo

        if hciconfig 2>/dev/null | grep -q "UP RUNNING"; then
            echo -e "${GREEN}[����] Bluetooth�A�_�v�^���L���ɂȂ�܂����I${NC}"
        else
            echo -e "${RED}[���s] Bluetooth�A�_�v�^��L���ɂł��܂���ł����B${NC}"
            echo "�蓮�� 'sudo hciconfig hci0 up' �Ȃǂ������Ă��������B"
        fi
    else
        echo -e "${RED}[�G���[] Bluetooth�T�[�r�X�̍ċN���Ɏ��s���܂����B${NC}"
    fi
    echo
    read -p "Enter�L�[�������ă��j���[�ɖ߂�܂�..."
}

# ���`�F�b�N
run_test() {
    clear
    echo "========================================"
    echo "  ���`�F�b�N"
    echo "========================================"
    echo

    # 1. Python���z��
    echo -n "[1/4] Python���z��... "
    if [ -f "$PROJECT_DIR/.venv/bin/activate" ]; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[NG] .venv��������܂���${NC}"
    fi

    # 2. NXBT
    echo -n "[2/4] NXBT���C�u����... "
    if [ -f "$PROJECT_DIR/.venv/bin/pip" ] && "$PROJECT_DIR/.venv/bin/pip" list 2>/dev/null | grep -q "nxbt"; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[NG] nxbt���C���X�g�[������Ă��܂���${NC}"
    fi

    # 3. �}�N���t�@�C��
    echo -n "[3/4] �}�N���t�@�C��... "
    if [ -f "$PROJECT_DIR/$MACRO_SCRIPT" ]; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[NG] $MACRO_SCRIPT ��������܂���${NC}"
    fi

    # 4. Bluetooth�T�[�r�X
    echo -n "[4/4] Bluetooth�T�[�r�X... "
    if systemctl is-active --quiet bluetooth; then
        echo -e "${GREEN}[OK] ���s��${NC}"
    else
        echo -e "${RED}[NG] ��~��${NC}"
    fi

    echo
    echo "�`�F�b�N����"
    read -p "Enter�L�[�������ă��j���[�ɖ߂�܂�..."
}


# --- ���C�����[�v ---
while true; do
    clear
    display_status
    read -p "�I�� (0-5): " choice

    case $choice in
        1) start_macro ;;
        2) stop_macro ;;
        3) reconnect_bt ;;
        4) run_test ;;
        5) continue ;;
        0) break ;;
        *)
            echo -e "${RED}�����ȑI���ł��B�ē��͂��Ă��������B${NC}"
            sleep 2
            ;;
    esac
done

clear
echo "�I�����܂��B"