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
echo BUSID��ۑ����܂����i���񂩂玩�����͂���܂��j
echo.

:attach
echo Bluetooth�A�_�v�^��ڑ���...
echo.

:: �o�C���h
usbipd bind --busid %busid% >nul 2>&1

:: �A�^�b�`
usbipd attach --wsl --busid %busid%

if %errorlevel% equ 0 (
    echo.
    echo �ڑ������I
    echo.

    :: WSL���Ŋm�F
    echo Bluetooth��Ԃ��m�F��...
    wsl -d Ubuntu-22.04 -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING' && echo 'Bluetooth�ڑ�OK' || echo 'Bluetooth�ڑ����m�F�ł��܂���ł���'"

) else (
    echo.
    echo �ڑ��Ɏ��s���܂���
    echo.
    echo �g���u���V���[�e�B���O:
    echo 1. BUSID�����������m�F���Ă�������
    echo 2. PowerShell���Ǘ��҂Ƃ��Ď��s���Ă��܂����H
    echo 3. usbipd-win���C���X�g�[������Ă��܂����H
)

echo.
pause