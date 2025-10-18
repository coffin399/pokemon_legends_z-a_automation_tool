@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

:check_ubuntu
echo.
echo [�X�e�b�v 2/5] Ubuntu 22.04�̊m�F�ƃC���X�g�[��
echo -----------------------------------------
echo [�m�F��] �C���X�g�[���ς݂�Linux���m�F...
wsl -l -v

set "UBUNTU_FOUND=0"
set "WSL_DISTRO="
for /f "tokens=1" %%i in ('wsl -l -v 2^>nul ^| findstr /i "Ubuntu"') do (
    set "TEMP_DISTRO=%%i"
    set "TEMP_DISTRO=!TEMP_DISTRO:*=!"
    set "WSL_DISTRO=!TEMP_DISTRO!"
    set "UBUNTU_FOUND=1"
)

if %UBUNTU_FOUND% equ 1 (
    echo [����] Ubuntu�����o����܂���: %WSL_DISTRO%
    echo %WSL_DISTRO% > "%~dp0distro.tmp"
    exit /b 0
)

echo [���o����] Ubuntu��������܂���ł����B�����C���X�g�[�����J�n���܂��B
echo.
echo    �����������y�d�v�z����������
echo    ���ꂩ��\�������V�����E�B���h�E�̎w���ɏ]����
echo    �y���[�U�[���z�Ɓy�p�X���[�h�z��ݒ肵�Ă��������B
echo    �ݒ肪��������ƁA�E�B���h�E�͎����ŕ��܂��B
echo    ����������������������������
echo.
pause

start "Ubuntu 22.04 LTS �̃C���X�g�[��" /wait wsl --install Ubuntu-22.04

if %errorlevel% neq 0 (
    echo [�G���[] Ubuntu�̃C���X�g�[���Ɏ��s���܂����B
    exit /b 1
)

echo [����] Ubuntu�̃C���X�g�[�����������܂����B�ēx�m�F���܂�...
timeout /t 2 >nul
goto :check_ubuntu