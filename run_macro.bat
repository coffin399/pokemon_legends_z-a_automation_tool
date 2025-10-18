@echo off
chcp 65001 >nul

cls
echo.
echo ========================================
echo   ? Nintendo Switch マクロ実行
echo ========================================
echo.
echo 準備:
echo  1. Nintendo Switchのホーム画面を開く
echo  2. 「コントローラー」を選択
echo  3. 「持ちかた/順番を変える」を選択
echo.
echo 準備ができたら何かキーを押してください...
pause >nul

echo.
echo マクロプログラムを起動中...
echo.
echo 操作方法:
echo  - ENTERキー: マクロ開始/停止
echo  - CTRL+Y: マクロ停止
echo  - CTRL+C: プログラム終了
echo.

:: WSL経由でPythonプログラムを実行
wsl -d Ubuntu-22.04 -e bash -c "cd ~/switch-macro && sudo python3 src/switch_macro.py"

echo.
echo マクロ実行が終了しました
pause