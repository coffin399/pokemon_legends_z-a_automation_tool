@echo off
chcp 932 >nul
setlocal

echo.
echo [�X�e�b�v 4/5] usbipd-win �̃C���X�g�[��
echo -----------------------------------------

where usbipd >nul 2>&1
if %errorlevel% equ 0 (
    echo [����] usbipd-win�͊��ɃC���X�g�[������Ă��܂��B
    exit /b 0
)

echo usbipd-win�������C���X�g�[����...
powershell -Command "if (Get-Command winget -ErrorAction SilentlyContinue) { winget install --id dorssel.usbipd-win --silent --accept-source-agreements --accept-package-agreements } else { Write-Host '[�G���[] winget��������܂���'; exit 1 }"

if %errorlevel% neq 0 (
    echo [����] �����C���X�g�[���Ɏ��s���܂����B�蓮�ŃC���X�g�[�����Ă��������B
    echo 1. https://github.com/dorssel/usbipd-win/releases ���J��
    echo 2. �ŐV�� .msi �t�@�C�����_�E�����[�h���ăC���X�g�[��
    start https://github.com/dorssel/usbipd-win/releases
    echo.
    echo �C���X�g�[����A������x setup_all.bat �����s���Ă��������B
    exit /b 1
)

echo [����] usbipd-win�̃C���X�g�[�����������܂����B
exit /b 0