setlocal
FOR /F "tokens=*" %%i in ('type .env') do SET %%i
start "Debug Server" podman compose --file podman-compose-debug.yml up --build
endlocal