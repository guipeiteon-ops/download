@echo off
title Git 模型同步工具 (分卷专用版)

:: --- 进入脚本所在目录 ---
cd /d "%~dp0"

echo ========================================
echo   Git 模型同步工具 (分卷专用版)
echo ========================================
echo.
echo   [保护对象] model_pack.bin.001, .002 ...
echo   [操作] 1. 锁定分卷为二进制 (Binary)
echo          2. 仅上传变更的部分
echo          3. 强制覆盖服务器
echo.
echo ----------------------------------------
echo   [确认] 请按 [回车键] 开始同步...
echo ----------------------------------------
pause >nul

:: --- 步骤 1：精确配置保护名单 ---
echo.
echo [1/3] 正在锁定分卷文件...

:: 1. 保护基础 bin 文件
echo *.bin binary > .gitattributes

:: 2. 关键：保护 .bin.xxx 这种分卷格式
echo *.bin.* binary >> .gitattributes

:: 3. 为了万无一失，直接指定你的文件名开头
echo model_pack.bin.* binary >> .gitattributes

:: 4. 确保 json 是文本 (可选)
echo *.json text >> .gitattributes

:: 关闭自动转换设置
git config --local core.autocrlf false

:: --- 步骤 2：重新扫描 ---
echo.
echo [2/3] 正在扫描文件变更...
:: 强制刷新，让 .001 文件被正确识别
git add --renormalize .

:: --- 步骤 3：提交与上传 ---
echo.
echo [3/3] 正在上传至 GitHub...
set msg=Update_Model_%date:~0,10%_%time:~0,8%
set msg=%msg:/=-%
set msg=%msg::=-%
set msg=%msg: =_%

:: 提交 (允许空提交，防止报错)
git commit -m "%msg%" || echo [提示] 文件未发生变化

:: 强制推送
git push origin main --force

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo [成功] 同步完成！分卷文件已安全上传。
    echo ========================================
) else (
    echo.
    echo ========================================
    echo [失败] 网络错误或上传中断。
    echo ========================================
)

echo.
echo 任务结束，按任意键退出...
pause >nul