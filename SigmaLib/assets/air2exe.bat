@echo off

::=======================================
set ARG1=%1
set ARG2=%2

::---------------------------------------
set ADT=%ARG1:"=%
set APP=%ARG2:"=%

::=======================================
@echo on

%ADT% -package -target native %APP%.exe %APP%.air