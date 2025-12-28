@echo off
title Git SSH 自动同步工具 (待确认)

:: 设置字符集防止乱码
chcp 65001 >nul

echo ========================================
echo   Git SSH 自动同步工具
echo ========================================
echo.
echo   当前目录: %cd%
echo   当前时间: %date% %time%
echo.
echo ----------------------------------------
echo   [确认] 请按 [回车键] 开始同步到 GitHub...
echo   [取消] 如果不想同步，请直接关闭此窗口
echo ----------------------------------------
:: pause >nul 的作用是暂停并隐藏默认的“请按任意键继续”
pause >nul

echo.
echo [1/5] 正在拉取远程更新 (git pull)...
git pull origin main --rebase

echo [2/5] 正在添加本地文件 (git add)...
git add .

echo [3/5] 正在提交更改 (git commit)...
:: 生成时间戳作为注释
set msg=daily_update_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%
git commit -m "%msg%"

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
    echo [失败] 发生错误，请检查上方输出信息。
    echo ========================================
)

echo.
echo 任务结束，按任意键退出...
pause >nul