setlocal
FOR /F "tokens=*" %%i in ('type .env') do SET %%i
start "Debug Server" docker compose --file docker-compose-debug.yml up --build
endlocal