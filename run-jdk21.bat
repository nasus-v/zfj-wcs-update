@echo off
@chcp 65001 >nul
echo.
echo [信息] 使用Jar命令运行WCS服务端工程。
echo.
title WCS服务端
cd %~dp0
:: ============ JVM参数调整 适配 JDK21 移除废弃GC参数 ============
:: Xms初始堆 Xmx最大堆，WCS建议4G起步，机器空闲多可以给到8g
set JAVA_OPTS=-Xms4g -Xmx4g -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m ^
-XX:+UseG1GC ^
-XX:+HeapDumpOnOutOfMemoryError ^
-XX:HeapDumpPath=dump\wcs-oom.hprof ^
-Xlog:gc*,gc+age=trace:file=logs/gc_%date:~0,4%%date:~5,2%%date:~8,2%.log:time,uptime:filecount=5,filesize=100M

set LOG_FILE=logs\wcs-admin_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%.log
set LOG_FILE=%LOG_FILE: =0%

:: 自动创建日志文件所在目录，解决Add-Content找不到路径报错
for %%f in (%LOG_FILE%) do set LOG_DIR=%%~dpf
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

if not exist logs mkdir logs
if not exist dump mkdir dump

echo [信息] 日志文件: %LOG_FILE%
echo [信息] JAVA_OPTS: %JAVA_OPTS%
echo [信息] 开始启动WCS服务端...
echo.
:: 重点：%JAVA_OPTS% 放到 -jar 前面！！！
java -Dfile.encoding=UTF-8 -Dconsole.encoding=UTF-8 %JAVA_OPTS% -Dloader.path=resources,lib -jar wcs-admin.jar 2>&1 | powershell -Command "$OutputEncoding = [System.Text.Encoding]::UTF8; [Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $input | ForEach-Object { Add-Content -Path '%LOG_FILE%' -Value $_ -Encoding UTF8; Write-Host $_ }"
pause
