@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

REM ========================================================
REM �|�P����LEGENDS Z-A ��������}�N��
REM ���S���������N���b�N�Z�b�g�A�b�v (���C���R���g���[���[)
REM ========================================================

REM �Ǘ��Ҍ����`�F�b�N
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo �Ǘ��Ҍ������K�v�ł��B�����ŏ��i���܂�...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    timeout /t 2 >nul
    exit /b
)

cls
echo.
echo ����������������������������������������������������������������������������������������������������������������
echo ��                                                      ��
echo ��     �|�P����LEGENDS Z-A ��������}�N��                 ��
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
echo ���̃Z�b�g�A�b�v�ł̓}�N���ɕK�v�Ȋ��������ō\�z���܂�:
echo ========================================================
echo   1. WSL2 (Windows���Linux�𓮂����d�g��) �̃C���X�g�[��
echo   2. Ubuntu (Linux�̈��) �̃C���X�g�[��
echo   3. Python (�}�N���𓮂����v���O��������) ���̍\�z
echo   4. �K�v�ȃp�b�P�[�W�̃C���X�g�[��
echo   5. usbipd-win (PC��Switch���q���c�[��) �̃C���X�g�[��
echo.
echo ========================================================
echo.

choice /c YN /m "�Z�b�g�A�b�v���J�n���܂����H" /t 60 /d N
if %errorLevel% equ 2 (
    echo.
    echo �Z�b�g�A�b�v���L�����Z�����܂����B
    goto :normal_exit
)

REM --- �e�X�e�b�v�̃o�b�`�t�@�C�������ԂɌĂяo�� ---

echo.
echo.
echo ========================================================
echo [���C��] �X�e�b�v1: WSL2�̃C���X�g�[�����J�n���܂�...
echo ========================================================
call "%~dp0modules\1_install_wsl.bat"
if %errorlevel% neq 0 goto :error_exit

echo.
echo ========================================================
echo [���C��] �X�e�b�v2: Ubuntu�̃C���X�g�[�����J�n���܂�...
echo ========================================================
call "%~dp0modules\2_install_ubuntu.bat"
if %errorlevel% neq 0 goto :error_exit

echo.
echo ========================================================
echo [���C��] �X�e�b�v3: Ubuntu���̃Z�b�g�A�b�v���J�n���܂�...
echo ========================================================
call "%~dp0modules\3_setup_ubuntu.bat"
if %errorlevel% neq 0 goto :error_exit

echo.
echo ========================================================
echo [���C��] �X�e�b�v4: usbipd-win�̃C���X�g�[�����J�n���܂�...
echo ========================================================
call "%~dp0modules\4_install_usbipd.bat"
if %errorlevel% neq 0 goto :error_exit

echo.
echo ========================================================
echo [���C��] �X�e�b�v5: �ŏI�ē���\�����܂�...
echo ========================================================
call "%~dp0modules\5_show_next_steps.bat"

goto :normal_exit

:error_exit
echo.
echo ����������������������������������������������������������������������������������������������������������������
echo ��                                                      ��
echo ��         �G���[�������������߁A�����𒆒f���܂��� ?           ��
echo ��                                                      ��
echo ����������������������������������������������������������������������������������������������������������������
echo.
echo ��L�̃��O���m�F���A�G���[�̌�������菜���Ă���
echo ������x���� setup_all.bat �����s���Ă��������B
echo.
goto :end

:normal_exit
echo.
echo [���C��] �S�ẴZ�b�g�A�b�v�v���Z�X���������܂����B
echo.

:end
echo �����L�[�������ƏI�����܂�...
pause >nul
exit /b 0