@echo off
rem �����R�[�h��Shift_JIS(���{��Windows�W��)�ɐݒ�
chcp 932 >nul
setlocal enabledelayedexpansion

cls
echo.
echo ========================================
echo   Bluetooth�Đڑ��w���p�[ for WSL
echo ========================================
echo.

:: --- �ݒ� ---
set WSL_DISTRO_NAME=Ubuntu-22.04

:: --- BUSID�ݒ�̓ǂݍ���/�ۑ� ---
set "config_file=%~dp0.busid_config"
set "saved_busid="

if exist "%config_file%" (
    set /p saved_busid=<"%config_file%"
)

if defined saved_busid (
    echo �O���BUSID: %saved_busid%
    echo.
    set /p use_saved="����BUSID���g�p���܂����H (Y/N): "

    if /i "!use_saved!"=="Y" (
        set "busid=!saved_busid!"
        goto attach
    )
)

echo.
echo �܂��A���p�\��USB�f�o�C�X���m�F���܂�...
echo.
usbipd list
echo.
echo ��L���X�g����ABluetooth�A�_�v�^�́uBUSID�v���m�F���Ă��������B
echo ��: 2-3, 1-4 �Ȃ�
echo.
set /p busid="BUSID����͂��Ă�������: "

:: ���͂��ꂽBUSID���t�@�C���ɕۑ�
echo !busid!>"%config_file%"
echo.
echo [����] BUSID��ۑ����܂��� (���񂩂玩�����͂���܂�)
echo.

:attach
echo ----------------------------------------
echo [%busid%] Bluetooth�A�_�v�^���o�C���h��...
echo.

:: �o�C���h����
usbipd bind --busid %busid% >nul 2>&1
rem �����P�_1: bind�R�}���h�̐��ۂ��`�F�b�N
if %errorlevel% neq 0 (
    echo [���s] �f�o�C�X�̃o�C���h�Ɏ��s���܂����B
    echo �EBUSID���Ԉ���Ă��܂��񂩁H
    echo �E���̃X�N���v�g���u�Ǘ��҂Ƃ��Ď��s�v���Ă��܂����H
    goto end
)

echo �o�C���h�����BWSL�ɐڑ����܂�...
rem �^�C�~���O��������邽�߂̒Z���ҋ@
timeout /t 2 >nul

:: �A�^�b�`����
usbipd attach --wsl --busid %busid%

if %errorlevel% equ 0 (
    echo.
    echo [����] �ڑ��R�}���h�̎��s���������܂����B
    echo.

    rem �����P�_3: �Ȃ��҂̂��R�����g��ǉ�
    rem WSL���f�o�C�X��F�����ABluetooth�T�[�r�X������������̂�҂�
    echo Bluetooth�A�_�v�^�̏�������҂��Ă��܂�... (5�b)
    timeout /t 5 >nul

    :: WSL����Bluetooth�̏�Ԃ��m�F
    echo Bluetooth�̏�Ԃ�WSL���Ŋm�F��...
    echo.
    echo --- hciconfig �̎��s���� ---
    wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig"
    echo ---------------------------
    echo.

    rem �����P�_2: hciconfig�̂ǂ������邩������ǉ�
    echo ��L���ʂɁuUP RUNNING�v�ƕ\������Ă���ΐ���ł��B
    echo.

    wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'"
    if !errorlevel! equ 0 (
        echo [����] Bluetooth�ڑ����L���ɂȂ�܂����I
        echo �����WSL���� 'bluetoothctl' �Ȃǂ��g�p�ł��܂��B
    ) else (
        echo [�x��] Bluetooth�ڑ��������Ŋm�F�ł��܂���ł����B
        echo.
        echo �ȉ��̃R�}���h��WSL���Ŏ蓮�Ŏ��s���āA��Ԃ��m�F���Ă�������:
        echo   wsl -d %WSL_DISTRO_NAME%
        echo   sudo service bluetooth restart
        echo   hciconfig
    )

) else (
    echo.
    echo [���s] WSL�ւ̐ڑ��Ɏ��s���܂����B
    echo.
    echo �g���u���V���[�e�B���O:
    echo 1. BUSID�����������m�F���Ă��������B
    echo 2. PowerShell (�܂��̓R�}���h�v�����v�g) ���u�Ǘ��҂Ƃ��Ď��s�v���Ă��܂����H
    echo 3. 'usbipd-win' ���������C���X�g�[������Ă��܂����H
)

:end
echo.
pause