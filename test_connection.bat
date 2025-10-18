@echo off
chcp 932 >nul
setlocal enabledelayedexpansion

REM ============================================
REM Nintendo Switch �}�N���c�[��
REM �ڑ��e�X�g�X�N���v�g
REM ============================================

echo.
echo ����������������������������������������������������������������������������������������������������������������
echo ��                                                      ��
echo ��     Nintendo Switch �ڑ��e�X�g                         ��
echo ��                                                      ��
echo ����������������������������������������������������������������������������������������������������������������
echo.

REM WSL�̊m�F
wsl -l -v | findstr "Ubuntu-22.04" >nul 2>&1
if %errorLevel% neq 0 (
    echo [�G���[] Ubuntu-22.04��������܂���
    echo.
    echo �܂� setup.bat �����s���ăZ�b�g�A�b�v���������Ă��������B
    echo.
    pause
    exit /b 1
)

echo [OK] WSL����������܂���
echo.
echo ���̃e�X�g�ł͈ȉ����m�F���܂�:
echo   1. Switch�ւ̐ڑ�
echo   2. �{�^������iA�{�^����1�񉟂��j
echo   3. ����Ȑؒf
echo.
echo �e�X�g����: ��30�b
echo.

pause


echo.
echo >> �e�X�g�J�n...
echo ========================================================
echo.

REM WSL���Ńe�X�g�X�N���v�g�����s
wsl -d Ubuntu-22.04 bash -c "cd ~/switch-macro && source .venv/bin/activate && sudo python3 scripts/test_connection.py"

if %errorLevel% equ 0 (
    echo.
    echo ========================================================
    echo [����] �e�X�g�����I
    echo ========================================================
    echo.
    echo �}�N���c�[���͐���ɓ��삵�܂��B
    echo run_macro.bat ���_�u���N���b�N���ă}�N�������s�ł��܂��B
) else (
    echo.
    echo ========================================================
    echo [���s] �e�X�g���s
    echo ========================================================
    echo.
    echo �g���u���V���[�e�B���O�����s���邱�Ƃ𐄏����܂��B
    echo.
    choice /c YN /m "�g���u���V���[�e�B���O�����s���܂����H"
    if !errorLevel! equ 1 (
        wsl -d Ubuntu-22.04 bash ~/switch-macro/scripts/troubleshoot.sh
    )
)

echo.
pause