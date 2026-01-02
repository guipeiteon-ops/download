@echo off
title Git 二进制文件修复与强力上传工具

:: --- 自动进入脚本所在的目录 (download) ---
cd /d "%~dp0"

echo ========================================
echo   Git 二进制文件修复与强力上传
echo ========================================
echo.
echo   [目标] 1. 彻底解决下载后文件变大/损坏的问题
echo          2. 强制以本地文件为准，覆盖服务器
echo.
echo   当前目录: %cd%
echo.
echo ----------------------------------------
echo   [确认] 请按 [回车键] 开始清洗并上传...
echo ----------------------------------------
pause >nul

:: --- 步骤 1：强制配置 Git 不转换换行符 ---
echo.
echo [1/5] 正在配置 Git 核心参数...
:: 关闭自动换行符转换（针对当前仓库）
git config --local core.autocrlf false
:: 忽略文件权限变化
git config --local core.filemode false

:: --- 步骤 2：创建“宪法” (.gitattributes) ---
echo.
echo [2/5] 正在创建二进制保护名单 (.gitattributes)...
:: 这一步至关重要，它强制规定所有 bin 文件按二进制处理
echo *.bin* binary > .gitattributes
echo ai/*.bin* binary >> .gitattributes

:: --- 步骤 3：清洗 Git 缓存 (关键!) ---
echo.
echo [3/5] 正在清洗 Git 缓存 (Clear Cache)...
echo       (这会从 Git 记录中移除所有文件，但保留你硬盘上的文件)
:: 删除索引，让 Git 忘掉之前错误的记录
git rm -r --cached . >nul 2>&1

:: --- 步骤 4：重新重新扫描 ---
echo.
echo [4/5] 正在重新扫描本地文件...
:: 重新添加所有文件。这次 Git 会看到 .gitattributes，从而正确识别 bin 文件
git add .

echo.
echo [正在提交...]
set msg=Fix_Binary_Files_%date:~0,10%_%time:~0,8%
set msg=%msg:/=-%
set msg=%msg::=-%
set msg=%msg: =_%
git commit -m "%msg%"

:: --- 步骤 5：强力推送 ---
echo.
echo [5/5] 正在强制覆盖服务器 (git push --force)...
echo       ----------------------------------------------
echo       注意：因为是彻底重传，速度取决于你的上传带宽。
echo       请耐心等待，直到出现 [成功] 提示。
echo       ----------------------------------------------
echo.

git push origin main --force

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo [成功] 修复并上传完成！
    echo ========================================
    echo.
    echo 验证方法：
    echo 请去 GitHub 下载任一 .bin 文件，
    echo 现在的下载大小应该和你本地硬盘上的一字节都不差。
) else (
    echo.
    echo ========================================
    echo [失败] 上传过程中断，请检查网络。
    echo ========================================
)

echo.
echo 任务结束，按任意键退出...
pause >nul