@echo off
chcp 932 >nul
setlocal

if not exist "%~dp0distro.tmp" (
    set "WSL_DISTRO=Ubuntu-22.04"
) else (
    set /p WSL_DISTRO=<"%~dp0distro.tmp"
)

cls
echo.
echo ����������������������������������������������������������������������������������������������������������������
echo ��                                                      ��
echo ��      ������ �Z�b�g�A�b�v�����ׂĊ������܂����I ������        ��
echo ��                                                      ��
echo ����������������������������������������������������������������������������������������������������������������
echo.
echo ���߂łƂ��������܂��I
echo ����ŁA�����}�N�������s���鏀���������܂����B
echo.
echo ========================================================
echo [���̃X�e�b�v] �Ō��PC��Switch��ڑ����܂�
echo ========================================================
echo.
echo �� Bluetooth�ݒ�i����̂݁A3���Ŋ����j
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
echo    �����́u2-3�v������ (BUSID�Ƃ����܂�)
echo.
echo 4. �ȉ��̃R�}���h�����s�i2-3�͎�����BUSID�ɕύX�j:
echo.
echo    usbipd bind --busid 2-3
echo    usbipd attach --wsl --busid 2-3
echo.
echo 5. �ڑ��m�F:
echo    wsl -d "%WSL_DISTRO%" hciconfig
echo    ���uhci0�v���\�������ΐ����ł��I
echo.
echo ========================================================
echo [�g����]
echo ========================================================
echo.
echo �� �ڑ��e�X�g�i�����j �� test_connection.bat ���_�u���N���b�N
echo �� ����}�N�����s     �� run_macro.bat ���_�u���N���b�N
echo.
echo ========================================================
echo.
echo   Happy Z-A Life!!
echo.
echo ========================================================
echo.

REM �ꎞ�t�@�C�����폜
del "%~dp0distro.tmp" 2>nul

exit /b 0