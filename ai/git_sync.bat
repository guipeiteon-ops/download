@echo off
title Git SSH 自动同步工具 (已修正顺序)

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
pause >nul

:: --- 步骤 1 & 2：先提交本地更改，解决 "unstaged changes" 报错 ---
echo.
echo [1/5] 正在添加本地文件 (git add)...
git add .

echo [2/5] 正在提交更改 (git commit)...
:: 简单的日期处理，如果不介意文件名格式，用原来的也行
:: 这里尝试更通用的命名方式，直接用整个 date 字符串，避免截取错误
set msg=AutoSync_%date:/=-%_%time::=-%
:: 如果没有东西需要提交，git commit 会报错，但不影响后续运行，所以加个 || echo 继续
git commit -m "%msg%" || echo [提示] 没有新的更改需要提交。

:: --- 步骤 3：工作区干净了，现在可以安全拉取了 ---
echo.
echo [3/5] 正在拉取远程更新 (git pull --rebase)...
git pull origin main --rebase
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [警告] 拉取时发生冲突或错误，脚本将暂停。
    echo 请手动解决冲突后再继续。
    pause
    exit
)

:: --- 步骤 4：上传 ---
echo.
echo [4/5] 正在上传至 GitHub (git push)...
git push origin main

:: --- 检查最终结果 ---
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo [成功] 同步完成！所有文件已更新。
    echo ========================================
) else (
    echo.
    echo ========================================
    echo [失败] 上传失败，可能是网络问题或权限问题。
    echo ========================================
)

echo.
echo 任务结束，按任意键退出...
pause >nul