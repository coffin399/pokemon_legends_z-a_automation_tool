@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

cls
echo.
echo ========================================
echo   Bluetooth�Đڑ��w���p�[
echo ========================================
echo.

:: �ۑ����ꂽBUSID��ǂݍ���
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
echo �܂��ABluetooth�A�_�v�^���m�F���܂�...
echo.
usbipd list
echo.
echo ��L�̃��X�g����ABluetooth�A�_�v�^�́uBUSID�v���m�F���Ă�������
echo ��: 2-3, 1-4 �Ȃ�
echo.
set /p busid="BUSID����͂��Ă�������: "

:: BUSID��ۑ�
echo !busid!>"%config_file%"
echo.
echo [����] BUSID��ۑ����܂����i���񂩂玩�����͂���܂��j
echo.

:attach
echo Bluetooth�A�_�v�^���o�C���h��...
echo.

:: �o�C���h
usbipd bind --busid %busid% >nul 2>&1

echo �o�C���h�����B�ڑ���...
timeout /t 2 >nul

:: �A�^�b�`
usbipd attach --wsl --busid %busid%

if %errorlevel% equ 0 (
    echo.
    echo [����] �ڑ��R�}���h���s����
    echo.

    :: �ڑ��ҋ@�i�x���ǉ��j
    echo Bluetooth�A�_�v�^�̏�������҂��Ă��܂�...
    timeout /t 5 >nul

    :: WSL���Ŋm�F
    echo Bluetooth��Ԃ��m�F��...
    echo.
    wsl -d Ubuntu-22.04 -e bash -c "hciconfig 2>/dev/null"
    echo.

    wsl -d Ubuntu-22.04 -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'" >nul 2>&1
    if !errorlevel! equ 0 (
        echo [����] Bluetooth�ڑ�OK
    ) else (
        echo [�x��] Bluetooth�ڑ����m�F�ł��܂���ł���
        echo.
        echo �蓮�Ŋm�F���Ă�������:
        echo   wsl -d Ubuntu-22.04
        echo   sudo service bluetooth restart
        echo   hciconfig
    )


) else (
    echo.
    echo [���s] �ڑ��Ɏ��s���܂���
    echo.
    echo �g���u���V���[�e�B���O:
    echo 1. BUSID�����������m�F���Ă�������
    echo 2. PowerShell���Ǘ��҂Ƃ��Ď��s���Ă��܂����H
    echo 3. usbipd-win���C���X�g�[������Ă��܂����H
    echo.
    echo �蓮�Ŏ����ꍇ:
    echo   usbipd list
    echo   usbipd bind --busid %busid%
    echo   usbipd attach --wsl --busid %busid%
)

echo.
pause