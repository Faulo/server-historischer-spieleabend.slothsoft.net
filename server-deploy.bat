setlocal
FOR /F "tokens=*" %%i in ('type .env') do SET %%i
findstr /C:"127.0.0.1 %STACK_NAME%" C:\Windows\System32\drivers\etc\hosts >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo 127.0.0.1 %STACK_NAME% >> C:\Windows\System32\drivers\etc\hosts
)
call composer update
if exist "sandbox" (
    cd sandbox
)
SET WORKDIR=C:/www
call docker compose up --detach --build
endlocal