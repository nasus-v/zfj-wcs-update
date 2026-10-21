@echo off
@chcp 65001 >nul
echo.
echo [信息] 使用Jar命令运行WCS服务端工程。
echo.
title WCS服务端
cd %~dp0

:: ========== PowerShell 获取安全日期 yyyyMMdd_HHmmss（不受系统区域影响） ==========
for /f "delims=" %%a in ('powershell -Command "Get-Date -Format 'yyyyMMdd_HHmmss'"') do set dt=%%a
set LOG_FILE=logs\wcs-admin_%dt%.log

:: ========== JDK21 JVM参数，GC日志固定名称，自带滚动，不再拼接日期 ==========
set JAVA_OPTS=-Xms4g -Xmx4g -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m ^
-XX:+UseG1GC ^
-XX:+HeapDumpOnOutOfMemoryError ^
-XX:HeapDumpPath=dump\wcs-oom.hprof ^
-Xlog:gc*,gc+age=trace:file=logs/gc.log:time,uptime:filecount=5,filesize=100M

:: 自动创建日志目录
for %%f in (%LOG_FILE%) do set LOG_DIR=%%~dpf
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

if not exist logs mkdir logs
if not exist dump mkdir dump

echo [信息] 日志文件: %LOG_FILE%
echo [信息] JAVA_OPTS: %JAVA_OPTS%
echo [信息] 开始启动WCS服务端...
echo.

java -Dfile.encoding=UTF-8 -Dconsole.encoding=UTF-8 %JAVA_OPTS% -Dloader.path=resources,lib -jar wcs-admin.jar 2>&1 | powershell -Command "$OutputEncoding = [System.Text.Encoding]::UTF8; [Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $input | ForEach-Object { Add-Content -Path '%LOG_FILE%' -Value $_ -Encoding UTF8; Write-Host $_ }"

pause
