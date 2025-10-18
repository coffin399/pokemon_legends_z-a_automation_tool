@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

:menu
cls
echo.
echo ========================================
echo   Switch �}�N�� �R���g���[���p�l��
echo ========================================
echo.

:: �}�N����Ԋm�F
wsl -d Ubuntu-22.04 -e bash -c "pgrep -f switch_macro.py > /dev/null" >nul 2>&1
if %errorlevel% equ 0 (
    echo ���: �}�N�����s��
) else (
    echo ���: �}�N����~��
)

:: Bluetooth��Ԋm�F
wsl -d Ubuntu-22.04 -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'" >nul 2>&1
if %errorlevel% equ 0 (
    echo Bluetooth: �ڑ��ς�
) else (
    echo Bluetooth: ���ڑ�
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
start "Switch Macro" wsl -d Ubuntu-22.04 -e bash -c "cd ~/switch-macro && sudo python3 src/switch_macro.py"
timeout /t 2 >nul
echo.
echo ? �}�N�����N�����܂���
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
wsl -d Ubuntu-22.04 -e bash -c "sudo pkill -f switch_macro.py"
echo �}�N�����~���܂���
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

:: reconnect_bluetooth.bat���Ăяo��
if exist "reconnect_bluetooth.bat" (
    call reconnect_bluetooth.bat
) else (
    echo reconnect_bluetooth.bat ��������܂���
    echo.
    echo �蓮�ōĐڑ����Ă�������:
    echo   1. PowerShell�i�Ǘ��ҁj���J��
    echo   2. usbipd attach --wsl --busid [BUSID]
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

echo [1/3] Bluetooth�m�F...
wsl -d Ubuntu-22.04 -e bash -c "hciconfig 2>/dev/null | grep -q 'UP RUNNING'" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ? Bluetooth OK
) else (
    echo   ? Bluetooth NG - �Đڑ����K�v�ł�
)

echo [2/3] NXBT�m�F...
wsl -d Ubuntu-22.04 -e bash -c "which nxbt" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ? NXBT OK
) else (
    echo   ? NXBT NG - �ăC���X�g�[�����K�v�ł�
)

echo [3/3] �}�N���t�@�C���m�F...
wsl -d Ubuntu-22.04 -e bash -c "test -f ~/switch-macro/src/switch_macro.py" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ? �}�N���t�@�C�� OK
) else (
    echo   ? �}�N���t�@�C�� NG - �t�@�C����������܂���
)

echo.
echo �e�X�g����
pause
goto menu

:end
echo.
echo �I�����܂�
exit /b 0