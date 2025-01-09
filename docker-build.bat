setlocal
cd %~dp0
call load-env
call docker build -t tmp/%STACK_NAME%:latest --build-arg PHP_VERSION=%PHP_VERSION% .
endlocal
pause