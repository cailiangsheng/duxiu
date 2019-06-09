@echo off

::=======================================
set ARG1=%1
set ARG2=%2
set ARG3=%3
set ARG4=%4

::---------------------------------------
set ADT=%ARG1:"=%
set APP=%ARG2:"=%
set P12=%ARG3:"=%
set PWD=%ARG4:"=%

::=======================================
@echo on

%ADT% -sign -storetype pkcs12 -keystore %P12%.p12 -storepass %PWD% -tsa none %APP%.airi %APP%.air