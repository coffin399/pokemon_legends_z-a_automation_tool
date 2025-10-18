@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

REM ============================================
REM Nintendo Switch �����}�N���c�[��
REM �����N���b�N�Z�b�g�A�b�v�X�N���v�g
REM ============================================

REM �Ǘ��Ҍ����`�F�b�N - �Ȃ���Ύ����ŏ��i
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo �Ǘ��Ҍ������K�v�ł��B�����ŏ��i���܂�...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo ����������������������������������������������������������������������������������������������������������������
echo ��                                                      ��
echo ��     Nintendo Switch �}�N���c�[��                       ��
echo ��          �����N���b�N�Z�b�g�A�b�v                         ��
echo ��                                                      ��
echo ����������������������������������������������������������������������������������������������������������������
echo.
echo [OK] �Ǘ��Ҍ����Ŏ��s��
echo.
echo ���̃Z�b�g�A�b�v�ł͈ȉ��������ōs���܂�:
echo   1. WSL2�̃C���X�g�[��
echo   2. Ubuntu 22.04�̃C���X�g�[��
echo   3. Python���̍\�z
echo   4. �K�v�ȃp�b�P�[�W�̃C���X�g�[��
echo   5. Bluetooth�ݒ�̈ē�
echo.
echo [�ڈ�] ���v����: ��30���i����̂݁j
echo.

choice /c YN /m "�Z�b�g�A�b�v���J�n���܂����H"
if %errorLevel% equ 2 (
    echo.
    echo �Z�b�g�A�b�v���L�����Z�����܂����B
    pause
    exit /b 0
)

echo.
echo ========================================================
echo >> �Z�b�g�A�b�v�J�n
echo ========================================================
echo.

REM ============================================
REM �X�e�b�v1: WSL2�̃C���X�g�[���m�F
REM ============================================

echo [�X�e�b�v 1/6] WSL2�̃C���X�g�[���m�F
echo -----------------------------------------

wsl --status >nul 2>&1
if %errorLevel% neq 0 (
    echo WSL2��������܂���B������C���X�g�[�����܂�...
    echo.
    echo [�_�E�����[�h] WSL2���C���X�g�[����...�i����������܂��j

    REM WSL2�̃����R�}���h�C���X�g�[���iWindows 10 build 19041�ȍ~�j
    wsl --install --no-distribution

    if %errorLevel% neq 0 (
        echo.
        echo [����] �����C���X�g�[���Ɏ��s���܂����B
        echo �蓮��WSL�@�\��L�������܂�...

        REM �蓮�ŋ@�\��L����
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    )

    echo.
    echo [����] WSL2�̃C���X�g�[�����������܂���
    echo.
    echo [�d�v] PC�̍ċN�����K�v�ł��I
    echo.
    echo �ċN����A���̃t�@�C���isetup.bat�j��������x
    echo �y�_�u���N���b�N�z���Ă��������B
    echo �� 2��ڂ͎����ő�������n�܂�܂�
    echo.

    choice /c YN /m "�������ċN�����܂����H"
    if !errorLevel! equ 1 (
        echo.
        echo 10�b��ɍċN�����܂�...
        shutdown /r /t 10 /c "WSL2�C���X�g�[�������B�ċN����..."
        pause
        exit /b 0
    ) else (
        echo.
        echo ��Ŏ蓮�ōċN�����Ă��������B
        echo �ċN����Asetup.bat ��������x���s���Ă��������B
        pause
        exit /b 0
    )
) else (
    echo [����] WSL2�����ɃC���X�g�[������Ă��܂�
)

echo.

REM WSL2���f�t�H���g�ɐݒ�
wsl --set-default-version 2 >nul 2>&1

REM ============================================
REM �X�e�b�v2: Ubuntu 22.04�̎����C���X�g�[��
REM ============================================

echo [�X�e�b�v 2/6] Ubuntu 22.04�̃C���X�g�[��
echo -----------------------------------------

wsl -l -v | findstr "Ubuntu-22.04" >nul 2>&1
if %errorLevel% neq 0 (
    echo Ubuntu 22.04���C���X�g�[����...
    echo.
    echo [�_�E�����[�h] �_�E�����[�h�ƃC���X�g�[�������s��...
    echo    �i����������܂��B���҂����������j
    echo.

    REM Ubuntu 22.04���C���X�g�[��
    wsl --install -d Ubuntu-22.04

    echo.
    echo [����] Ubuntu 22.04�̃C���X�g�[�����������܂���
    echo.
    echo [���[�U�[] ���[�U�[���ƃp�X���[�h�̐ݒ�
    echo -----------------------------------------
    echo.
    echo �V�����E�B���h�E��Ubuntu���N�����܂����B
    echo �ȉ�����͂��Ă�������:
    echo.
    echo   1. ���[�U�[��: �D���Ȗ��O�i��: switch�j
    echo   2. �p�X���[�h: �D���ȃp�X���[�h
    echo      �� �p�X���[�h�͉�ʂɕ\������܂��񂪓��͂���Ă��܂�
    echo   3. �p�X���[�h�ē��́i�m�F�j
    echo.
    echo [�d�v] �ݒ芮����AUbuntu�̃E�B���h�E�ňȉ������:
    echo.
    echo   exit
    echo.
    echo �Ɠ��͂���Enter�������Ă��������B
    echo ���̌�A���̃E�B���h�E�ŉ����L�[�������Ă��������B
    echo.

    pause

    REM Ubuntu���m���ɏI������܂ő҂�
    echo.
    echo Ubuntu�̏I����҂��Ă��܂�...
    timeout /t 3 /nobreak >nul

    REM Ubuntu�̃v���Z�X���I���������m�F
    :wait_ubuntu_close
    wsl -d Ubuntu-22.04 -e echo "test" >nul 2>&1
    if %errorLevel% equ 0 (
        echo [OK] Ubuntu�̏����ݒ肪�������܂���
        goto ubuntu_ready
    )
    timeout /t 2 /nobreak >nul
    goto wait_ubuntu_close

    :ubuntu_ready

) else (
    echo [����] Ubuntu 22.04�����ɃC���X�g�[������Ă��܂�
)

echo.

REM ============================================
REM �X�e�b�v3: �t�@�C���̓]��
REM ============================================

echo [�X�e�b�v 3/6] �t�@�C���̓]��
echo -----------------------------------------

set "CURRENT_DIR=%CD%"
echo [�t�H���_] ���݂̃f�B���N�g��: %CURRENT_DIR%
echo.

echo WSL���Ƀt�H���_���쐬��...
wsl -d Ubuntu-22.04 bash -c "mkdir -p ~/switch-macro"

echo �t�@�C�����R�s�[��...
wsl -d Ubuntu-22.04 bash -c "cp -r '%CURRENT_DIR:\=/%'/src ~/switch-macro/ 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "cp -r '%CURRENT_DIR:\=/%'/scripts ~/switch-macro/ 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "cp -r '%CURRENT_DIR:\=/%'/macros ~/switch-macro/ 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "cp '%CURRENT_DIR:\=/%'/requirements.txt ~/switch-macro/ 2>/dev/null || true"

REM ���s������t�^
wsl -d Ubuntu-22.04 bash -c "chmod +x ~/switch-macro/scripts/*.sh 2>/dev/null || true"

echo [����] �t�@�C���̓]�����������܂���
echo.

REM ============================================
REM �X�e�b�v4: �ˑ��֌W�̎����C���X�g�[��
REM ============================================

echo [�X�e�b�v 4/6] Python���̃Z�b�g�A�b�v
echo -----------------------------------------
echo.
echo [�p�b�P�[�W] �K�v�ȃp�b�P�[�W���C���X�g�[����...
echo    �� ���̏����ɂ�5~15��������ꍇ������܂�
echo    �� Ubuntu�̃p�X���[�h���͂����߂��܂�
echo    �� �p�X���[�h�͉�ʂɕ\������܂��񂪓��͂���Ă��܂�
echo.

REM �Θb�I�ɃX�N���v�g�����s�i�p�X���[�h���͉\�j
wsl -d Ubuntu-22.04 bash -ic "cd ~/switch-macro && bash scripts/install_dependencies.sh"

if %errorLevel% neq 0 (
    echo.
    echo [�G���[] �C���X�g�[���Ɏ��s���܂���
    echo.
    echo �g���u���V���[�e�B���O:
    echo   1. �C���^�[�l�b�g�ڑ����m�F
    echo   2. ������x setup.bat �����s
    echo   3. ����ł��_���Ȃ�蓮�C���X�g�[��:
    echo      wsl -d Ubuntu-22.04
    echo      cd ~/switch-macro
    echo      bash scripts/install_dependencies.sh
    echo.
    pause
    exit /b 1
)

echo.

REM ============================================
REM �X�e�b�v5: usbipd-win�̎����C���X�g�[��
REM ============================================

echo [�X�e�b�v 5/6] usbipd-win �̃C���X�g�[��
echo -----------------------------------------
echo.

REM usbipd-win���C���X�g�[���ς݂��m�F
where usbipd >nul 2>&1
if %errorLevel% equ 0 (
    echo [����] usbipd-win�͊��ɃC���X�g�[������Ă��܂�
    echo.
) else (
    echo usbipd-win��������܂���B
    echo.
    echo [�_�E�����[�h] usbipd-win���_�E�����[�h��...
    echo.

    REM PowerShell��winget���g���ăC���X�g�[��
    powershell -Command "if (Get-Command winget -ErrorAction SilentlyContinue) { winget install --id dorssel.usbipd-win --silent --accept-source-agreements --accept-package-agreements } else { Write-Host '[����] winget��������܂���B�蓮�C���X�g�[�����K�v�ł�' }"

    if !errorLevel! equ 0 (
        echo [����] usbipd-win�̃C���X�g�[�����������܂���
    ) else (
        echo [����] �����C���X�g�[���Ɏ��s���܂���
        echo.
        echo �y�蓮�C���X�g�[�����@�z
        echo 1. �ȉ���URL���J��:
        echo    https://github.com/dorssel/usbipd-win/releases
        echo.
        echo 2. �ŐV�� .msi �t�@�C�����_�E�����[�h
        echo    �i��: usbipd-win_4.0.0.msi�j
        echo.
        echo 3. �_�E�����[�h�����t�@�C�����_�u���N���b�N���ăC���X�g�[��
        echo.

        choice /c YN /m "�������u���E�U�ŊJ���܂����H"
        if !errorLevel! equ 1 (
            start https://github.com/dorssel/usbipd-win/releases
        )
    )
)

echo.

REM ============================================
REM �X�e�b�v6: Bluetooth�ݒ�̈ē�
REM ============================================

echo [�X�e�b�v 6/6] Bluetooth�ݒ�
echo -----------------------------------------
echo.
echo [�d�v] �Ō�̎蓮�ݒ�
echo.
echo Bluetooth�A�_�v�^�̐ڑ��ݒ肪�K�v�ł��B
echo �ȉ��̎菇�����s���Ă�������:
echo.
echo ========================================================
echo [�菇] Bluetooth�ݒ�菇
echo ========================================================
echo.
echo 1. �yPowerShell���J���z
echo    - Windows�L�[ ������
echo    - �uPowerShell�v�Ɠ���
echo    - �E�N���b�N �� �u�Ǘ��҂Ƃ��Ď��s�v
echo.
echo 2. �yBluetooth�A�_�v�^���m�F�z
echo    PowerShell�ňȉ������:
echo.
echo    usbipd list
echo.
echo 3. �yBUSID�������z
echo    Bluetooth�A�_�v�^�̍s��T���i��j:
echo    2-3    8087:0025  Intel(R) Wireless Bluetooth(R)
echo    �����́u2-3�v������
echo.
echo 4. �y�ڑ�����z�iBUSID�͎����̂��̂ɕύX�j
echo    PowerShell�ňȉ������:
echo.
echo    usbipd bind --busid 2-3
echo    usbipd attach --wsl --busid 2-3
echo.
echo 5. �y�m�F�z
echo    PowerShell�ňȉ������:
echo.
echo    wsl -d Ubuntu-22.04
echo    hciconfig
echo.
echo    �uhci0�v���\��������OK�I
echo.
echo ========================================================
echo.

choice /c YN /m "������ǂ݂܂������H"

echo.

REM ============================================
REM �Z�b�g�A�b�v����
REM ============================================

cls
echo.
echo ����������������������������������������������������������������������������������������������������������������
echo ��                                                      ��
echo ��     [����] �Z�b�g�A�b�v���������܂����I                    ��
echo ��                                                      ��
echo ����������������������������������������������������������������������������������������������������������������
echo.
echo �� ���߂łƂ��������܂��I
echo    �Z�b�g�A�b�v������Ɋ������܂����B
echo.
echo ========================================================
echo [�菇] ���̃X�e�b�v
echo ========================================================
echo.
echo 1. �yBluetooth�ݒ�������z�i�܂��̏ꍇ�j
echo    ��L�̎菇�ɏ]����Bluetooth�A�_�v�^��ڑ�
echo.
echo 2. �y�ڑ��e�X�g�z�i�����j
echo    test_connection.bat ���_�u���N���b�N
echo    ������ɓ��삷�邩�m�F�ł��܂�
echo.
echo 3. �y�}�N�����s�z
echo    run_macro.bat ���_�u���N���b�N
echo    ��ZL+A�����A�ł��n�܂�܂�
echo.
echo ========================================================
echo [�h�L�������g]
echo ========================================================
echo.
echo   README.md       - �ڍׂȎg����
echo   QUICKSTART.md   - 5���Ŏn�߂�ȒP�K�C�h
echo.
echo ========================================================
echo.
echo   Happy Gaming!!
echo.
pause