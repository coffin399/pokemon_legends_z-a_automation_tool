@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

REM ============================================
REM Nintendo Switch �����}�N���c�[��
REM ���S���������N���b�N�Z�b�g�A�b�v
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

choice /c YN /m "�Z�b�g�A�b�v���J�n���܂����H"
if %errorLevel% equ 2 (
    echo.
    echo �Z�b�g�A�b�v���L�����Z�����܂����B
    pause
    exit /b 0
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
echo ========================================================
pause
echo.

REM WSL2���f�t�H���g�ɐݒ�
wsl --set-default-version 2 >nul 2>&1

REM ============================================
REM �X�e�b�v2: Ubuntu 22.04�̊��S�����C���X�g�[��
REM ============================================

echo [�X�e�b�v 2/5] Ubuntu 22.04�̎����C���X�g�[��
echo -----------------------------------------

wsl -l -v | findstr /C:"Ubuntu-22.04" /C:"Ubuntu 22.04" >nul 2>&1
if %errorLevel% neq 0 (
    echo Ubuntu 22.04��������܂���B
    echo.

    REM ����Ubuntu�f�B�X�g���r���[�V���������邩�m�F
    wsl -l -v | findstr "Ubuntu" >nul 2>&1
    if %errorLevel% equ 0 (
        echo.
        echo [����] �ʂ�Ubuntu�f�B�X�g���r���[�V������������܂���:
        echo.
        wsl -l -v | findstr "Ubuntu"
        echo.
        echo ========================================================
        echo [�I��] �ǂ�����g�p���܂����H
        echo ========================================================
        echo.
        echo 1. ������Ubuntu���g�p����i�����E�������j
        echo    �� ���ɂ���Ubuntu�����̂܂܎g���܂�
        echo.
        echo 2. Ubuntu 22.04��V�K�C���X�g�[������i5-10���j
        echo    �� �V����Ubuntu 22.04���C���X�g�[�����܂�
        echo.

        choice /c 12 /m "�I�����Ă�������"

        if !errorLevel! equ 1 (
            echo.
            echo [�I��] ������Ubuntu���g�p���܂�
            echo.

            REM ������Ubuntu�f�B�X�g���r���[�V���������擾
            for /f "tokens=1" %%i in ('wsl -l -v ^| findstr "Ubuntu" ^| findstr /v "docker"') do (
                set "DISTRO_NAME=%%i"
                goto found_distro
            )

            :found_distro
            echo [���o] �f�B�X�g���r���[�V����: !DISTRO_NAME!
            echo.

            REM sudo������������
            echo [�ݒ�] sudo��������������...
            wsl -d !DISTRO_NAME! bash -c "echo '$(whoami) ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/$(whoami) > /dev/null 2>&1 && sudo chmod 0440 /etc/sudoers.d/$(whoami) 2>/dev/null"

            echo [����] ������Ubuntu�̐ݒ肪�������܂���

            REM �ȍ~�̏����Ŏg�p����f�B�X�g���r���[�V��������ύX
            set "WSL_DISTRO=!DISTRO_NAME!"

            goto skip_ubuntu_install
        )
    )

    echo [���S�����C���X�g�[��] Ubuntu 22.04���C���X�g�[�����܂�
    echo.
    echo �� ���S�Ɏ����Ői�݂܂��i���͕s�v�j
    echo �� 5-10�����҂���������...
    echo.

    REM WSL���N���[���A�b�v
    echo [����] WSL���V���b�g�_�E����...
    wsl --shutdown >nul 2>&1
    timeout /t 3 /nobreak >nul

    REM �ꎞ�t�H���_���쐬
    set "TEMP_DIR=%TEMP%\ubuntu_install"
    if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

    echo [�_�E�����[�h] Ubuntu 22.04 ���_�E�����[�h��...�i����������܂��j
    echo              �� �_�E�����[�h�T�C�Y: ��450MB
    echo.

    REM PowerShell��Appx�p�b�P�[�W���_�E�����[�h
    powershell -Command "$ProgressPreference = 'SilentlyContinue'; try { Invoke-WebRequest -Uri 'https://aka.ms/wslubuntu2204' -OutFile '%TEMP_DIR%\Ubuntu2204.appx' -UseBasicParsing -TimeoutSec 600; exit 0 } catch { exit 1 }"

    if %errorLevel% neq 0 (
        echo [�G���[] �_�E�����[�h�Ɏ��s���܂���
        echo.
        echo �ʂ̕��@�������܂�...

        REM ���URL
        powershell -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://wslstorestorage.blob.core.windows.net/wslblob/Ubuntu2204-221101.AppxBundle' -OutFile '%TEMP_DIR%\Ubuntu2204.appx' -UseBasicParsing" >nul 2>&1

        if !errorLevel! neq 0 (
            echo [�G���[] �S�Ẵ_�E�����[�h���@�����s���܂���
            echo �C���^�[�l�b�g�ڑ����m�F���Ă�������
            echo.
            echo ========================================================
            echo [�G���[����] �C���^�[�l�b�g�ڑ����m�F���Ă�������
            echo ========================================================
            pause
            exit /b 1
        )
    )

    echo [����] �_�E�����[�h����
    echo.
    echo [�C���X�g�[��] Ubuntu 22.04���C���X�g�[����...

    REM Appx�p�b�P�[�W���C���X�g�[��
    powershell -Command "Add-AppxPackage '%TEMP_DIR%\Ubuntu2204.appx'" >nul 2>&1

    if %errorLevel% neq 0 (
        echo [����] �ʏ�C���X�g�[���Ɏ��s���܂���
        echo        �Ǘ��Ҍ����ōĎ��s��...
        powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList '-Command Add-AppxPackage ''%TEMP_DIR%\Ubuntu2204.appx'''" -Wait
    )

    echo [�ҋ@��] �C���X�g�[���������m�F��...
    timeout /t 5 /nobreak >nul

    REM �C���X�g�[���m�F�i�ő�30�b�ҋ@�j
    set WAIT_COUNT=0
    :wait_ubuntu_install
    wsl -l -v | findstr /C:"Ubuntu-22.04" /C:"Ubuntu 22.04" >nul 2>&1
    if %errorLevel% neq 0 (
        set /a WAIT_COUNT+=1
        if !WAIT_COUNT! gtr 10 (
            echo [�G���[] Ubuntu 22.04�̃C���X�g�[�����m�F�ł��܂���ł���
            echo.
            echo �C���X�g�[����Ԃ��m�F:
            wsl -l -v
            echo.
            echo ========================================================
            echo [�G���[����] �C���X�g�[�����������܂���ł���
            echo ========================================================
            pause
            exit /b 1
        )
        timeout /t 3 /nobreak >nul
        goto wait_ubuntu_install
    )

    echo [����] Ubuntu 22.04�̃C���X�g�[�����m�F����܂���
    echo.

    REM �f�B�X�g���r���[�V�����������o�i�o�[�W�����\�L���قȂ�\�������邽�߁j
    for /f "tokens=1" %%i in ('wsl -l -v ^| findstr /C:"Ubuntu-22.04" /C:"Ubuntu 22.04"') do (
        set "DETECTED_DISTRO=%%i"
        goto found_installed_distro
    )
    :found_installed_distro

    echo [���o] �f�B�X�g���r���[�V������: !DETECTED_DISTRO!
    echo.
    echo [�����ݒ�] ���S�����Ń��[�U�[���쐬���܂�...
    echo.

    REM �܂�root�ŃA�N�Z�X���ă��[�U�[���쐬
    echo [�쐬] ���[�U�[ switchuser ���쐬��...
    wsl -d !DETECTED_DISTRO! -u root -- bash -c "useradd -m -s /bin/bash switchuser 2>/dev/null || echo '���[�U�[�͊��ɑ��݂��܂�'"

    echo [�ݒ�] sudo������t�^��...
    wsl -d !DETECTED_DISTRO! -u root -- bash -c "usermod -aG sudo switchuser 2>/dev/null"
    wsl -d !DETECTED_DISTRO! -u root -- bash -c "mkdir -p /etc/sudoers.d && echo 'switchuser ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/switchuser && chmod 0440 /etc/sudoers.d/switchuser"

    echo [�ݒ�] �f�t�H���g���[�U�[��ݒ蒆...
    wsl -d !DETECTED_DISTRO! -u root -- bash -c "echo -e '[user]\ndefault=switchuser' > /etc/wsl.conf"

    REM ubuntu2204.exe �����݂���ꍇ�͂�����g��
    where ubuntu2204.exe >nul 2>&1
    if %errorLevel% equ 0 (
        ubuntu2204.exe config --default-user switchuser >nul 2>&1
    )

    REM WSL���ċN�����Đݒ�𔽉f
    echo [�ċN��] WSL���ċN�����Đݒ�𔽉f��...
    wsl --shutdown
    timeout /t 3 /nobreak >nul

    echo [����] Ubuntu 22.04�̊��S�����C���X�g�[�����������܂���
    echo         ���[�U�[��: switchuser�i�p�X���[�h�s�v�j
    echo.

    REM �ꎞ�t�@�C�����폜
    if exist "%TEMP_DIR%\Ubuntu2204.appx" del /q "%TEMP_DIR%\Ubuntu2204.appx" >nul 2>&1

    set "WSL_DISTRO=!DETECTED_DISTRO!"

:skip_ubuntu_install

) else (
    echo [����] Ubuntu 22.04�����ɃC���X�g�[������Ă��܂�

    REM �f�B�X�g���r���[�V�����������o
    for /f "tokens=1" %%i in ('wsl -l -v ^| findstr /C:"Ubuntu-22.04" /C:"Ubuntu 22.04"') do (
        set "WSL_DISTRO=%%i"
        goto found_existing_distro
    )
    :found_existing_distro

    echo [���o] �f�B�X�g���r���[�V������: !WSL_DISTRO!

    REM �����̃C���X�g�[���ł��p�X���[�h�Ȃ�sudo��ݒ�
    wsl -d !WSL_DISTRO! bash -c "echo '$(whoami) ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/$(whoami) > /dev/null 2>&1 && sudo chmod 0440 /etc/sudoers.d/$(whoami) 2>/dev/null" >nul 2>&1
    echo [�ݒ�] sudo���������������܂���
)

REM WSL����x�V���b�g�_�E�����Đݒ�𔽉f
echo [�ݒ蔽�f] WSL���ċN����...
wsl --shutdown
timeout /t 3 /nobreak >nul

echo.
echo ========================================================
echo [�X�e�b�v 2 ����] Ubuntu 22.04�̃Z�b�g�A�b�v���������܂���
echo ========================================================
pause
echo.

REM ============================================
REM �X�e�b�v3: �t�@�C���̓]��
REM ============================================

echo [�X�e�b�v 3/5] �t�@�C���̓]��
echo -----------------------------------------

set "CURRENT_DIR=%CD%"
echo [�t�H���_] ���݂̃f�B���N�g��: %CURRENT_DIR%
echo.

echo WSL���Ƀt�H���_���쐬��...
wsl -d %WSL_DISTRO% bash -c "mkdir -p ~/switch-macro"

if %errorLevel% neq 0 (
    echo [�G���[] �t�H���_�쐬�Ɏ��s���܂���
    echo.
    echo ========================================================
    echo [�G���[����] WSL�̏�Ԃ��m�F���Ă�������
    echo ========================================================
    pause
    exit /b 1
)

echo �t�@�C�����R�s�[��...
wsl -d %WSL_DISTRO% bash -c "cp -r '%CURRENT_DIR:\=/%'/src ~/switch-macro/ 2>/dev/null || true"
wsl -d %WSL_DISTRO% bash -c "cp -r '%CURRENT_DIR:\=/%'/scripts ~/switch-macro/ 2>/dev/null || true"
wsl -d %WSL_DISTRO% bash -c "cp -r '%CURRENT_DIR:\=/%'/macros ~/switch-macro/ 2>/dev/null || true"
wsl -d %WSL_DISTRO% bash -c "cp '%CURRENT_DIR:\=/%'/requirements.txt ~/switch-macro/ 2>/dev/null || true"

REM ���s������t�^
wsl -d %WSL_DISTRO% bash -c "chmod +x ~/switch-macro/scripts/*.sh 2>/dev/null || true"

echo [����] �t�@�C���̓]�����������܂���
echo.
echo ========================================================
echo [�X�e�b�v 3 ����] �t�@�C���̓]�����������܂���
echo ========================================================
pause
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

wsl -d %WSL_DISTRO% bash -c "cd ~/switch-macro && bash scripts/install_dependencies.sh"

if %errorLevel% neq 0 (
    echo.
    echo [�G���[] �C���X�g�[���Ɏ��s���܂���
    echo.
    echo �g���u���V���[�e�B���O:
    echo   1. �C���^�[�l�b�g�ڑ����m�F
    echo   2. ������x setup.bat �����s
    echo   3. ����ł��_���Ȃ�蓮�C���X�g�[��:
    echo      wsl -d %WSL_DISTRO%
    echo      cd ~/switch-macro
    echo      bash scripts/install_dependencies.sh
    echo.
    echo ========================================================
    echo [�G���[����] �G���[���O���m�F���Ă�������
    echo ========================================================
    pause
    exit /b 1
)

echo.
echo [����] Python���̃Z�b�g�A�b�v���������܂���
echo.
echo ========================================================
echo [�X�e�b�v 4 ����] Python���̃Z�b�g�A�b�v���������܂���
echo ========================================================
pause
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

        choice /c YN /m "�������u���E�U�ŊJ���܂����H"
        if !errorLevel! equ 1 (
            start https://github.com/dorssel/usbipd-win/releases
            echo.
            echo �C���X�g�[����A�����L�[�������Ă�������
            pause
        )
    )
)

echo.
echo ========================================================
echo [�X�e�b�v 5 ����] usbipd-win�̃Z�b�g�A�b�v���������܂���
echo ========================================================
pause
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
echo    wsl -d %WSL_DISTRO%
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

pause