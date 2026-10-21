@echo off
@chcp 65001 >nul
echo.
echo [信息] 使用Jar命令运行WCS服务端工程。
echo.
title WCS服务端
cd %~dp0

:: ============ JVM参数，去掉GC日志、OOMDump相关 ============
set JAVA_OPTS=-Xms4g -Xmx4g -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m ^
-XX:+UseG1GC

echo [信息] JAVA_OPTS: %JAVA_OPTS%
echo [信息] 开始启动WCS服务端...
echo.

java -Dfile.encoding=UTF-8 -Dconsole.encoding=UTF-8 %JAVA_OPTS% -Dloader.path=resources,lib -jar wcs-admin.jar 2>&1