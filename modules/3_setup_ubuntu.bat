@echo off
chcp 932 >nul
setlocal

echo.
echo [�X�e�b�v 3/5] Ubuntu���̃Z�b�g�A�b�v
echo -----------------------------------------

if not exist "%~dp0distro.tmp" (
    echo [�G���[] �f�B�X�g���r���[�V�������t�@�C����������܂���B
    exit /b 1
)
set /p WSL_DISTRO=<"%~dp0distro.tmp"

echo [INFO] �Ώۃf�B�X�g���r���[�V����: %WSL_DISTRO%
echo [�ݒ蒆] sudo�������p�X���[�h�Ȃ��Ŏ��s�ł���悤�ɐݒ�...
wsl -d "%WSL_DISTRO%" bash -c "echo '$(whoami) ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/90-nopasswd-$(whoami) > /dev/null && sudo chmod 0440 /etc/sudoers.d/90-nopasswd-$(whoami)"

echo [�ݒ蔽�f] WSL���ċN����...
wsl --shutdown
timeout /t 3 /nobreak >nul

echo [���s��] �}�N���֘A�t�@�C����WSL���ɓ]����...
set "PROJECT_ROOT=%~dp0..\"
set "WSL_PATH=%PROJECT_ROOT:\=/%"
wsl -d "%WSL_DISTRO%" bash -c "mkdir -p ~/switch-macro && cp -rf '%WSL_PATH%/'* ~/switch-macro/ 2>/dev/null || true"
if %errorlevel% neq 0 ( echo [�G���[] �t�@�C���]���Ɏ��s���܂����B & exit /b 1 )
echo [����] �t�@�C���]�����������܂����B

echo [���s��] Python���ƕK�v�ȃp�b�P�[�W���C���X�g�[����...(10~20��)
wsl -d "%WSL_DISTRO%" bash -c "chmod +x ~/switch-macro/scripts/*.sh && cd ~/switch-macro && bash scripts/install_dependencies.sh"
if %errorlevel% neq 0 ( echo [�G���[] Python���̍\�z�Ɏ��s���܂����B & exit /b 1 )

echo [����] Ubuntu���̃Z�b�g�A�b�v���������܂����B
exit /b 0