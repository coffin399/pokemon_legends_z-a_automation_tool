@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

:: --- �ݒ� ---
set WSL_DISTRO_NAME=Ubuntu-22.04
set "config_file=%~dp0.busid_config"

:menu
cls
echo.
echo ========================================
echo   Nintendo Switch �}�N�� �R���g���[���p�l��
echo ========================================
echo.

:: �}�N����Ԋm�F
wsl -d %WSL_DISTRO_NAME% -e bash -c "pgrep -f switch_macro.py > /dev/null" >nul 2>&1
if %errorlevel% equ 0 (
    echo ���: [���s��] �}�N�����s��
) else (
    echo ���: [��~��] �}�N����~��
)

:: Bluetooth��Ԋm�F
wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'" >nul 2>&1
if %errorlevel% equ 0 (
    echo Bluetooth: [�ڑ���] �ڑ��ς�
) else (
    echo Bluetooth: [���ڑ�] ���ڑ�
)

echo.
echo ========================================
echo.
echo [1] �}�N���J�n (�ʏ탂�[�h)
echo [2] �}�N����~
echo [3] Bluetooth�Đڑ�
echo [4] �ڑ��e�X�g
echo [5] ��Ԋm�F
echo [0] �I��
echo.
echo ========================================
echo.

set /p choice="�I�� (0-5): "

if "%choice%"=="1" goto start_macro
if "%choice%"=="2" goto stop_macro
if "%choice%"=="3" goto reconnect_bt
if "%choice%"=="4" goto test_connection
if "%choice%"=="5" goto menu
if "%choice%"=="0" goto end

echo �����ȑI���ł�
timeout /t 2 >nul
goto menu

:start_macro
cls
echo.
echo ========================================
echo   �}�N���J�n
echo ========================================
echo.
echo Switch�Łu��������/���Ԃ�ς���v���J���Ă�������
echo.
pause

echo �}�N�����N����...
start "Switch Macro" wsl -d %WSL_DISTRO_NAME% -e bash -c "cd ~/switch-macro && sudo python3 src/switch_macro.py"
timeout /t 2 >nul
echo.
echo [����] �}�N�����N�����܂���
echo    �V�����E�B���h�E�Ŏ��s���ł�
echo.
pause
goto menu

:stop_macro
cls
echo.
echo ========================================
echo   �}�N����~
echo ========================================
echo.
wsl -d %WSL_DISTRO_NAME% -e bash -c "sudo pkill -f switch_macro.py"
echo [����] �}�N�����~���܂���
echo.
pause
goto menu

:reconnect_bt
cls
echo.
echo ========================================
echo   Bluetooth�Đڑ�
echo ========================================
echo.

:: BUSID�ݒ�̓ǂݍ���
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
        goto do_bind
    )
)

echo.
echo ���p�\��USB�f�o�C�X���m�F���܂�...
echo.
usbipd list
echo.
echo ��L���X�g����ABluetooth�A�_�v�^�́uBUSID�v���m�F���Ă��������B
echo ��: 2-3, 1-4 �Ȃ�
echo.
set /p busid="BUSID����͂��Ă�������: "

:: BUSID��ۑ�
echo !busid!>"%config_file%"
echo.
echo [����] BUSID��ۑ����܂���
echo.

:do_bind
echo ----------------------------------------
echo [%busid%] Bluetooth�A�_�v�^���o�C���h��...
echo.

:: ����Shared��Ԃ��`�F�b�N
usbipd bind --busid %busid% 2>&1 | findstr /C:"already shared" >nul
if %errorlevel% equ 0 (
    echo [���] �f�o�C�X�͊���Shared��Ԃł��B
    goto do_attach
)

:: �o�C���h���s
usbipd bind --busid %busid% >nul 2>&1
if %errorlevel% neq 0 (
    echo [�x��] �o�C���h�Ɏ��s���܂����B�����o�C���h�������܂�...
    usbipd bind --busid %busid% --force >nul 2>&1
    if !errorlevel! neq 0 (
        echo [���s] �����o�C���h�����s���܂����B
        echo.
        echo �g���u���V���[�e�B���O:
        echo 1. BUSID�����������m�F���Ă�������
        echo 2. �Ǘ��Ҍ����Ŏ��s���Ă��܂����H
        echo.
        pause
        goto menu
    )
)

echo �o�C���h�����B

:do_attach
timeout /t 2 >nul
echo WSL�ɐڑ���...
echo.

:: �A�^�b�`���s
usbipd attach --wsl --busid %busid%

if %errorlevel% equ 0 (
    echo.
    echo [����] �ڑ��R�}���h�����s���܂���
    echo.

    :: �������ҋ@
    echo Bluetooth�A�_�v�^�̏�������... (5�b)
    timeout /t 5 >nul

    :: ��Ԋm�F�iUTF-8��Shift-JIS�ɕϊ��j
    echo Bluetooth��Ԃ��m�F��...
    echo.
    echo --- hciconfig �̎��s���� ---
    wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | iconv -f UTF-8 -t SHIFT_JIS//TRANSLIT"
    echo ---------------------------
    echo.

    wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'"
    if !errorlevel! equ 0 (
        echo [����] Bluetooth�ڑ����L���ɂȂ�܂����I
    ) else (
        echo [�x��] Bluetooth�ڑ����m�F�ł��܂���ł���
        echo.
        echo �蓮�ňȉ��������Ă�������:
        echo   wsl -d %WSL_DISTRO_NAME%
        echo   sudo service dbus start
        echo   sudo service bluetooth start
        echo   hciconfig hci0 up
    )
) else (
    echo.
    echo [���s] WSL�ւ̐ڑ��Ɏ��s���܂���
    echo.
    echo �g���u���V���[�e�B���O:
    echo 1. WSL2���N�����Ă��܂����H
    echo 2. usbipd-win���C���X�g�[������Ă��܂����H
)

echo.
pause
goto menu

:test_connection
cls
echo.
echo ========================================
echo   �ڑ��e�X�g
echo ========================================
echo.

echo [1/4] WSL�ڑ��m�F...
wsl -d %WSL_DISTRO_NAME% -e bash -c "echo 'OK'" >nul 2>&1
if %errorlevel% equ 0 (
    echo   [OK] WSL�ڑ� OK
) else (
    echo   [NG] WSL�ڑ� NG - WSL���N�����Ă��܂���
)

echo [2/4] Bluetooth�m�F...
wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'" >nul 2>&1
if %errorlevel% equ 0 (
    echo   [OK] Bluetooth OK

    :: Bluetooth�̏ڍ׏��iShift-JIS�ϊ��j
    wsl -d %WSL_DISTRO_NAME% -e bash -c "hciconfig 2>/dev/null | head -n 2 | iconv -f UTF-8 -t SHIFT_JIS//TRANSLIT" 2>nul
) else (
    echo   [NG] Bluetooth NG - �Đڑ����K�v�ł�
)

echo [3/4] NXBT�m�F...
wsl -d %WSL_DISTRO_NAME% -e bash -c "which nxbt" >nul 2>&1
if %errorlevel% equ 0 (
    echo   [OK] NXBT OK
) else (
    echo   [NG] NXBT NG - �ăC���X�g�[�����K�v�ł�
)

echo [4/4] �}�N���t�@�C���m�F...
wsl -d %WSL_DISTRO_NAME% -e bash -c "test -f ~/switch-macro/src/switch_macro.py" >nul 2>&1
if %errorlevel% equ 0 (
    echo   [OK] �}�N���t�@�C�� OK
) else (
    echo   [NG] �}�N���t�@�C�� NG - �t�@�C����������܂���
)

echo.
echo ========================================
echo   �ڍ׏��
echo ========================================
echo.

:: Bluetooth�T�[�r�X��Ԋm�F
echo Bluetooth�T�[�r�X���:
wsl -d %WSL_DISTRO_NAME% -e bash -c "service bluetooth status 2>/dev/null | grep -q 'running' && echo '[���s��] bluetooth service is running' || echo '[��~��] bluetooth service is not running'" 2>nul

echo.
echo �e�X�g����
pause
goto menu

:end
echo.
echo �I�����܂�
exit /b 0