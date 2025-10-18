@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

REM �G���[�����������瑦���ɒ�~���ĕ\��
set "ERROR_OCCURRED=0"

REM ============================================
REM Nintendo Switch �����}�N���c�[��
REM ���S���������N���b�N�Z�b�g�A�b�v
REM ============================================

REM �Ǘ��Ҍ����`�F�b�N - �Ȃ���Ύ����ŏ��i
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo �Ǘ��Ҍ������K�v�ł��B�����ŏ��i���܂�...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    timeout /t 2 >nul
    exit /b
)

echo.
echo ����������������������������������������������������������������������������������������������������������������
echo ��                                                      ��
echo ��     Nintendo Switch �}�N���c�[��                       ��
echo ��       ���S���������N���b�N�Z�b�g�A�b�v                      ��
echo ��                                                      ��
echo ����������������������������������������������������������������������������������������������������������������
echo.
echo [OK] �Ǘ��Ҍ����Ŏ��s��
echo.
echo �� ���̃Z�b�g�A�b�v�͊��S�����ł��I
echo    ���Ȃ������邱�Ƃ́uY�v�����������I
echo.
echo ========================================================
echo ���̃Z�b�g�A�b�v�ł͈ȉ��������ōs���܂�:
echo ========================================================
echo   1. WSL2�̃C���X�g�[��
echo   2. Ubuntu 22.04�̃C���X�g�[���i���S�����j
echo   3. Python���̍\�z
echo   4. �K�v�ȃp�b�P�[�W�̃C���X�g�[��
echo   5. usbipd-win�̃C���X�g�[��
echo.
echo [���v����] ��20-30���i����̂݁j
echo [����] �C���^�[�l�b�g�ڑ����K�v�ł�
echo.
echo ========================================================
echo.

choice /c YN /m "�Z�b�g�A�b�v���J�n���܂����H" /t 60 /d N
if %errorLevel% equ 2 (
    echo.
    echo �Z�b�g�A�b�v���L�����Z�����܂����B
    echo.
    goto normal_exit
)

echo.
echo ========================================================
echo >> �����Z�b�g�A�b�v�J�n
echo ========================================================
echo.
echo �� ���ꂩ��S�Ď����Ői�݂܂�
echo �� �R�[�q�[�ł�����ł��҂����������I
echo.

REM ============================================
REM �X�e�b�v1: WSL2�̃C���X�g�[���m�F
REM ============================================

echo [�X�e�b�v 1/5] WSL2�̃C���X�g�[���m�F
echo -----------------------------------------

wsl --status >nul 2>&1
if %errorLevel% neq 0 (
    echo WSL2��������܂���B������C���X�g�[�����܂�...
    echo.
    echo [�_�E�����[�h] WSL2���C���X�g�[����...�i����������܂��j

    REM WSL2�̃����R�}���h�C���X�g�[��
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
    echo ========================================================
    echo [�d�v] PC�̍ċN�����K�v�ł��I
    echo ========================================================
    echo.
    echo �ċN����A���̃t�@�C���isetup.bat�j��������x
    echo �y�_�u���N���b�N�z���Ă��������B
    echo.
    echo �� 2��ڂ͎����ő�������n�܂�܂��i�������͕s�v�j
    echo.
    echo ========================================================
    echo.

    choice /c YN /m "�������ċN�����܂����H" /t 30 /d N
    if !errorLevel! equ 1 (
        echo.
        echo 10�b��ɍċN�����܂�...
        shutdown /r /t 10 /c "WSL2�C���X�g�[�������B�ċN����..."
        timeout /t 10 >nul
        exit /b 0
    ) else (
        echo.
        echo ��Ŏ蓮�ōċN�����Ă��������B
        echo �ċN����Asetup.bat ��������x���s���Ă��������B
        echo.
        goto normal_exit
    )
) else (
    echo [����] WSL2�����ɃC���X�g�[������Ă��܂�
)

echo.
echo [�f�o�b�O] WSL�̃o�[�W�����m�F
wsl --set-default-version 2
echo [�f�o�b�O] WSL2���f�t�H���g�ɐݒ肵�܂���
echo.

echo ========================================================
echo [�X�e�b�v 1 ����] WSL2�̊m�F���������܂���
echo ========================================================
echo.
timeout /t 2 >nul

REM WSL2���f�t�H���g�ɐݒ�
echo [�f�o�b�O] WSL2���f�t�H���g�o�[�W�����ɐݒ蒆...
wsl --set-default-version 2 >nul 2>&1
echo [�f�o�b�O] �ݒ芮��

REM ������WSL_DISTRO�ϐ����N���A
set "WSL_DISTRO="
echo [�f�o�b�O] WSL_DISTRO�ϐ����N���A���܂���

REM ============================================
REM �X�e�b�v2: Ubuntu 22.04�̊��S�����C���X�g�[��
REM ============================================

echo.
echo ����������������������������������������������������������������������������������������������������������������
echo �� [�X�e�b�v 2/5] Ubuntu 22.04�̎����C���X�g�[��           ��
echo ����������������������������������������������������������������������������������������������������������������
echo.
echo [�m�F��] �C���X�g�[���ς݂̃f�B�X�g���r���[�V�������m�F...
echo.
echo === �C���X�g�[���ς�WSL�f�B�X�g���r���[�V���� ===
wsl -l -v
echo ================================================
echo.
timeout /t 2 /nobreak >nul

REM Ubuntu 22.04�����ɃC���X�g�[������Ă��邩�m�F
set "UBUNTU_FOUND=0"
for /f "tokens=1" %%i in ('wsl -l -v 2^>nul ^| findstr /i "Ubuntu"') do (
    set "TEMP_DISTRO=%%i"
    REM BOM�������폜
    set "TEMP_DISTRO=!TEMP_DISTRO:*=!"
    echo [���o] �f�B�X�g���r���[�V����: !TEMP_DISTRO!
    set "WSL_DISTRO=!TEMP_DISTRO!"
    set "UBUNTU_FOUND=1"
    goto ubuntu_found
)

:ubuntu_found
if %UBUNTU_FOUND% equ 1 (
    echo [����] Ubuntu �����ɃC���X�g�[������Ă��܂�
    echo [�g�p] �f�B�X�g���r���[�V������: "%WSL_DISTRO%"

    REM sudo������������
    echo [�ݒ蒆] sudo���������������Ă��܂�...
    wsl -d "%WSL_DISTRO%" bash -c "echo '$(whoami) ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/$(whoami) > /dev/null 2>&1 && sudo chmod 0440 /etc/sudoers.d/$(whoami) 2>/dev/null" 2>nul

    goto skip_ubuntu_install
)

REM Ubuntu ��������Ȃ��ꍇ�̏���
echo [���o����] Ubuntu ��������܂���ł���
echo.
echo ========================================================
echo [�G���[] WSL�p��Linux�f�B�X�g���r���[�V������������܂���
echo ========================================================
echo.
echo �ȉ��̎菇��Ubuntu���C���X�g�[�����Ă�������:
echo.
echo 1. Microsoft Store ���J��
echo 2. "Ubuntu 22.04" �Ō���
echo 3. �C���X�g�[���{�^�����N���b�N
echo 4. �C���X�g�[��������A������x����setup.bat�����s
echo.
echo �܂��́A�R�}���h�v�����v�g�ňȉ������s:
echo    wsl --install Ubuntu-22.04
echo.

choice /c YN /m "Microsoft Store���J���܂����H" /t 30 /d Y
if !errorLevel! equ 1 (
    start ms-windows-store://pdp/?ProductId=9PN20MSR04DW
)

echo.
echo Ubuntu�̃C���X�g�[����A����setup.bat��������x���s���Ă��������B
goto normal_exit

:skip_ubuntu_install

REM �f�B�X�g���r���[�V���������ݒ肳��Ă��邩�m�F
if not defined WSL_DISTRO (
    echo.
    echo ����������������������������������������������������������������������������������������������������������������
    echo �� [�G���[] �f�B�X�g���r���[�V���������ݒ肳��Ă��܂���   ��
    echo ����������������������������������������������������������������������������������������������������������������
    echo.
    echo ���p�\�ȃf�B�X�g���r���[�V����:
    wsl -l -v
    echo.
    goto error_exit
)

echo.
echo [�m�F] �g�p����f�B�X�g���r���[�V����: "%WSL_DISTRO%"
echo.

REM WSL����x�V���b�g�_�E�����Đݒ�𔽉f
echo [�ݒ蔽�f] WSL���ċN����...
wsl --shutdown
timeout /t 3 /nobreak >nul
echo [����] WSL�ċN������

echo.
echo ========================================================
echo [�X�e�b�v 2 ����] Ubuntu �̃Z�b�g�A�b�v���������܂���
echo �g�p�f�B�X�g���r���[�V����: "%WSL_DISTRO%"
echo ========================================================
echo.
timeout /t 2 >nul

REM ============================================
REM �X�e�b�v3: �t�@�C���̓]��
REM ============================================

echo ����������������������������������������������������������������������������������������������������������������
echo �� [�X�e�b�v 3/5] �t�@�C���̓]��                           ��
echo ����������������������������������������������������������������������������������������������������������������
echo.

set "CURRENT_DIR=%CD%"
echo [���] ���݂̃f�B���N�g��: %CURRENT_DIR%
echo [���] �g�p�f�B�X�g���r���[�V����: "%WSL_DISTRO%"
echo.

echo [���s��] WSL���Ƀt�H���_���쐬...
wsl -d "%WSL_DISTRO%" bash -c "mkdir -p ~/switch-macro" 2>&1

if %errorLevel% neq 0 (
    echo [�G���[] �t�H���_�쐬�Ɏ��s���܂���
    echo.
    echo WSL�̏��:
    wsl -l -v
    echo.
    goto error_exit
)

echo [���s��] �t�@�C�����R�s�[��...
wsl -d "%WSL_DISTRO%" bash -c "cp -r '%CURRENT_DIR:\=/%'/src ~/switch-macro/ 2>/dev/null || true"
wsl -d "%WSL_DISTRO%" bash -c "cp -r '%CURRENT_DIR:\=/%'/scripts ~/switch-macro/ 2>/dev/null || true"
wsl -d "%WSL_DISTRO%" bash -c "cp -r '%CURRENT_DIR:\=/%'/macros ~/switch-macro/ 2>/dev/null || true"
wsl -d "%WSL_DISTRO%" bash -c "cp '%CURRENT_DIR:\=/%'/requirements.txt ~/switch-macro/ 2>/dev/null || true"

REM ���s������t�^
wsl -d "%WSL_DISTRO%" bash -c "chmod +x ~/switch-macro/scripts/*.sh 2>/dev/null || true"

echo [����] �t�@�C���̓]�����������܂���
echo.
echo ========================================================
echo [�X�e�b�v 3 ����] �t�@�C���̓]�����������܂���
echo ========================================================
timeout /t 2 >nul
echo.

REM ============================================
REM �X�e�b�v4: �ˑ��֌W�̎����C���X�g�[��
REM ============================================

echo [�X�e�b�v 4/5] Python���̃Z�b�g�A�b�v
echo -----------------------------------------
echo.
echo [�p�b�P�[�W] �K�v�ȃp�b�P�[�W���C���X�g�[����...
echo    �� ���̏����ɂ�10~20��������܂�
echo    �� ���S�����Ȃ̂ŉ������͕s�v�ł�
echo    �� �������肨�҂���������...
echo.

wsl -d "%WSL_DISTRO%" bash -c "cd ~/switch-macro && bash scripts/install_dependencies.sh" 2>&1

if %errorLevel% neq 0 (
    echo.
    echo [�G���[] �C���X�g�[���Ɏ��s���܂���
    echo.
    echo �g���u���V���[�e�B���O:
    echo   1. �C���^�[�l�b�g�ڑ����m�F
    echo   2. ������x setup.bat �����s
    echo   3. ����ł��_���Ȃ�蓮�C���X�g�[��:
    echo      wsl -d "%WSL_DISTRO%"
    echo      cd ~/switch-macro
    echo      bash scripts/install_dependencies.sh
    echo.
    goto error_exit
)

echo.
echo [����] Python���̃Z�b�g�A�b�v���������܂���
echo.
echo ========================================================
echo [�X�e�b�v 4 ����] Python���̃Z�b�g�A�b�v���������܂���
echo ========================================================
timeout /t 2 >nul
echo.

REM ============================================
REM �X�e�b�v5: usbipd-win�̎����C���X�g�[��
REM ============================================

echo [�X�e�b�v 5/5] usbipd-win �̃C���X�g�[��
echo -----------------------------------------
echo.

REM usbipd-win���C���X�g�[���ς݂��m�F
where usbipd >nul 2>&1
if %errorLevel% equ 0 (
    echo [����] usbipd-win�͊��ɃC���X�g�[������Ă��܂�
    echo.
) else (
    echo usbipd-win�������C���X�g�[����...
    echo.

    REM PowerShell��winget���g���ăC���X�g�[��
    powershell -Command "if (Get-Command winget -ErrorAction SilentlyContinue) { winget install --id dorssel.usbipd-win --silent --accept-source-agreements --accept-package-agreements } else { Write-Host '[�G���[] winget��������܂���' }"

    if !errorLevel! equ 0 (
        echo [����] usbipd-win�̃C���X�g�[�����������܂���
    ) else (
        echo [����] �����C���X�g�[���Ɏ��s���܂���
        echo.
        echo �蓮�C���X�g�[�����K�v�ł�:
        echo 1. https://github.com/dorssel/usbipd-win/releases
        echo 2. �ŐV�� .msi �t�@�C�����_�E�����[�h���ăC���X�g�[��
        echo.

        choice /c YN /m "�������u���E�U�ŊJ���܂����H" /t 30 /d N
        if !errorLevel! equ 1 (
            start https://github.com/dorssel/usbipd-win/releases
            echo.
            echo �C���X�g�[����A�����L�[�������Ă�������
            pause >nul
        )
    )
)

echo.
echo ========================================================
echo [�X�e�b�v 5 ����] usbipd-win�̃Z�b�g�A�b�v���������܂���
echo ========================================================
timeout /t 2 >nul
echo.

REM ============================================
REM �Z�b�g�A�b�v����
REM ============================================

cls
echo.
echo ����������������������������������������������������������������������������������������������������������������
echo ��                                                      ��
echo ��   �� �Z�b�g�A�b�v���������܂����I ��                        ��
echo ��                                                      ��
echo ����������������������������������������������������������������������������������������������������������������
echo.
echo ���߂łƂ��������܂��I
echo �����Z�b�g�A�b�v������Ɋ������܂����B
echo.
echo ========================================================
echo [���̃X�e�b�v] ����1�����蓮�ݒ肪����܂�
echo ========================================================
echo.
echo �� Bluetooth�ݒ�i1�񂾂��A3���Ŋ����j
echo.
echo 1. PowerShell���Ǘ��҂Ƃ��ĊJ��
echo    �iWindows�L�[ �� "PowerShell" �� �E�N���b�N �� �Ǘ��҂Ƃ��Ď��s�j
echo.
echo 2. �ȉ��̃R�}���h�����s:
echo.
echo    usbipd list
echo.
echo 3. Bluetooth�A�_�v�^�̍s��T���i��j:
echo    2-3    8087:0025  Intel(R) Wireless Bluetooth(R)
echo    �����́u2-3�v������
echo.
echo 4. �ȉ��̃R�}���h�����s�i2-3�͎�����BUSID�ɕύX�j:
echo.
echo    usbipd bind --busid 2-3
echo    usbipd attach --wsl --busid 2-3
echo.
echo 5. �m�F:
echo    wsl -d "%WSL_DISTRO%"
echo    hciconfig
echo    ���uhci0�v���\��������OK�I
echo.
echo ========================================================
echo [�g����]
echo ========================================================
echo.
echo �� �ڑ��e�X�g�i�����j
echo   �� test_connection.bat ���_�u���N���b�N
echo.
echo �� �}�N�����s
echo   �� run_macro.bat ���_�u���N���b�N
echo.
echo ========================================================
echo.
echo   Happy Gaming!!
echo.
echo ========================================================
echo.

goto normal_exit

REM ============================================
REM �G���[�������̏I������
REM ============================================
:error_exit
echo.
echo ����������������������������������������������������������������������������������������������������������������
echo ��                                                      ��
echo ��   ? �G���[���������܂���                               ��
echo ��                                                      ��
echo ����������������������������������������������������������������������������������������������������������������
echo.
echo �Z�b�g�A�b�v���ɃG���[���������܂����B
echo ��L�̃G���[���b�Z�[�W���m�F���Ă��������B
echo.
echo ========================================================
echo [�Ώ����@]
echo ========================================================
echo.
echo 1. �G���[���b�Z�[�W���悭�ǂ�
echo 2. �C���^�[�l�b�g�ڑ����m�F
echo 3. WSL�̏�Ԃ��m�F: wsl -l -v
echo 4. ������x setup.bat �����s
echo.
echo ����ł��������Ȃ��ꍇ�́A�G���[���b�Z�[�W��
echo �X�N���[���V���b�g���āA�T�|�[�g�ɖ₢���킹�Ă��������B
echo.
echo ========================================================
echo.
echo �����L�[�������ƏI�����܂�...
pause >nul
exit /b 1

REM ============================================
REM ����I������
REM ============================================
:normal_exit
echo.
echo �����L�[�������ƏI�����܂�...
pause >nul
exit /b 0