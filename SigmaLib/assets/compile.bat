@echo off

::=======================================
set ARG1=%1
set ARG2=%2
set ARG3=%3

::---------------------------------------
set FLEXSDK_HOME=%ARG1:"=%
set JRE_HOME=%ARG2:"=%
set MAIN_SOURCE=%ARG3%

::---------------------------------------
set FLEXSDK_BIN=%FLEXSDK_HOME%\bin
set JRE_BIN=%JRE_HOME%\bin
set path=%path%;%FLEXSDK_BIN%;%JRE_BIN%;

::---------------------------------------
set JVM_CONFIG="%FLEXSDK_BIN%\jvm.config"

::路径字符串中要求使用/，而不是\
::路径字符串结尾不允许有空格
echo java.home=%JRE_HOME:\=/%>%JVM_CONFIG%

::以下配置可省
::echo java.args=-Xmx384m -Dsun.io.useCanonCaches=false>>%JVM_CONFIG%
::echo env=>>%JVM_CONFIG%
::echo java.class.path=>>%JVM_CONFIG%
::echo java.library.path=>>%JVM_CONFIG%

::---------------------------------------
set STAMP1=%date:~0,10%
set STAMP1=%STAMP1:/=%
set STAMP1=%STAMP1:-=%
set STAMP2=%time:~0,8%
set STAMP2=%STAMP2::=%
set STAMP2=%STAMP2:.=%
set STAMP=%STAMP1%_%STAMP2%

set MAIN_SWF=%MAIN_SOURCE:"=%
set MAIN_SWF=%MAIN_SWF:.as=.swf%
set MAIN_SWF=%MAIN_SWF:.mxml=.swf%

::=======================================
@echo on

move "%MAIN_SWF%" "%MAIN_SWF%.bak_%STAMP%"

mxmlc %MAIN_SOURCE%