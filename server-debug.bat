setlocal
FOR /F "tokens=*" %%i in ('type .env') do SET %%i
call docker compose --file docker-compose-debug.yml up --detach --build
endlocal