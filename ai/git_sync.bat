@echo off
title Git SSH 自动同步增强版

echo ========================================
echo   开始执行 Git 同步 (SSH 模式)
echo   时间: %date% %time%
echo ========================================

:: 1. 自动同步远程更改 (解决 fetch first 错误)
echo [1/5] 正在拉取远程更新 (git pull)...
git pull origin main --rebase

:: 2. 添加所有更改
echo [2/5] 正在添加本地文件 (git add)...
git add .

:: 3. 提交更改
echo [3/5] 正在提交更改 (git commit)...
set msg=daily_update_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%
git commit -m "%msg%"

:: 4. 推送到服务器
echo [4/5] 正在上传至 GitHub (git push)...
git push origin main

:: 检查最终结果
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo [成功] 同步完成！
    echo ========================================
) else (
    echo.
    echo ========================================
    echo [失败] 发生错误，请检查网络或冲突。
    echo ========================================
)

pause