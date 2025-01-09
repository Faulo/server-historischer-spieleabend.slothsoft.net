setlocal
cd %~dp0
call load-env
findstr /C:"127.0.0.1 %STACK_NAME%" C:\Windows\System32\drivers\etc\hosts >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo 127.0.0.1 %STACK_NAME% >> C:\Windows\System32\drivers\etc\hosts
)
call docker build -t tmp/%STACK_NAME%:latest --build-arg PHP_VERSION=%PHP_VERSION% .
start "Production Server" docker compose --file=.jenkins/docker-compose-%DOCKER_OS_TYPE%.yml up
endlocal