@echo off
chcp 65001 >nul

cls
echo.
echo ========================================
echo   ? Nintendo Switch �}�N�����s
echo ========================================
echo.
echo ����:
echo  1. Nintendo Switch�̃z�[����ʂ��J��
echo  2. �u�R���g���[���[�v��I��
echo  3. �u��������/���Ԃ�ς���v��I��
echo.
echo �������ł����牽���L�[�������Ă�������...
pause >nul

echo.
echo �}�N���v���O�������N����...
echo.
echo ������@:
echo  - ENTER�L�[: �}�N���J�n/��~
echo  - CTRL+Y: �}�N����~
echo  - CTRL+C: �v���O�����I��
echo.

:: WSL�o�R��Python�v���O���������s
wsl -d Ubuntu-22.04 -e bash -c "cd ~/switch-macro && sudo python3 src/switch_macro.py"

echo.
echo �}�N�����s���I�����܂���
pause