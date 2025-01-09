setlocal
cd %~dp0
call load-env
start "Debug Server" docker compose --file=.jenkins/docker-compose-debug.yml up
endlocal