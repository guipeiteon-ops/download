@echo off
:: 设置标题
title Git SSH 自动同步工具

echo ========================================
echo   开始执行 Git 同步 (SSH 模式)
echo   时间: %date% %time%
echo ========================================

:: 1. 检查 SSH 连接状态 (可选，确保网络通畅)
echo [1/4] 检查 GitHub 连接...
ssh -T git@github.com >nul 2>&1
if %ERRORLEVEL% NEQ 1 (
    echo [OK] SSH 连接正常
)

:: 2. 添加所有更改 (包含分卷大文件)
echo [2/4] 正在添加文件 (git add)...
git add .

:: 3. 提交更改 (带时间戳的注释)
echo [3/4] 正在提交更改 (git commit)...
set msg=daily_update_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%
git commit -m "%msg%"

:: 4. 推送到服务器
echo [4/4] 正在上传到 GitHub (git push)...
echo (这可能需要几分钟，取决于你的文件大小和网速)
git push origin main

:: 检查最终结果
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo [成功] 所有文件已上传至 GitHub！
    echo ========================================
) else (
    echo.
    echo ========================================
    echo [失败] 发生错误，请检查输出信息。
    echo ========================================
)

pause