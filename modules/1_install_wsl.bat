@echo off
chcp 932 >nul
setlocal

echo.
echo [�X�e�b�v 1/5] WSL2�̃C���X�g�[���m�F
echo -----------------------------------------

wsl --status >nul 2>&1
if %errorLevel% equ 0 (
    echo [����] WSL2�͊��ɃC���X�g�[������Ă��܂��B
    wsl --set-default-version 2 >nul 2>&1
    echo [INFO] WSL2���f�t�H���g�o�[�W�����ɐݒ肵�܂����B
    exit /b 0
)

echo WSL2��������܂���B������C���X�g�[�����܂�...
echo [�_�E�����[�h] WSL2���C���X�g�[����...�i����������܂��j
wsl --install --no-distribution

if %errorlevel% neq 0 (
    echo [����] �����C���X�g�[���Ɏ��s���܂����B�蓮��WSL�@�\��L�������܂�...
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
)

echo.
echo [����] WSL2�̃C���X�g�[�����������܂����B
echo.
echo ========================================================
echo [�d�v] PC�̍ċN�����K�v�ł��I
echo ========================================================
echo.
echo �ċN����A������x setup_all.bat ���y�_�u���N���b�N�z���Ă��������B
echo.
echo ========================================================
echo.

choice /c YN /m "�������ċN�����܂����H" /t 30 /d N
if %errorlevel% equ 1 (
    echo 10�b��ɍċN�����܂�...
    shutdown /r /t 10 /c "WSL2�C���X�g�[�������B�ċN����..."
) else (
    echo ��Ŏ蓮�ōċN�����Ă��������B
)

REM �ċN�����K�v�Ȃ��߁A�G���[�R�[�h��Ԃ��ă��C���o�b�`����U��~������
exit /b 1