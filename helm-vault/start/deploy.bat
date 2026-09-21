@echo off
if exist .env (
    for /f "usebackq tokens=*" %%i in (.env) do (
        set "%%i"
    )
)

for /f %%a in ('type .env ^| find /c /v ""') do set LINES=%%a
echo file has %LINES% lines

echo databse: ref+vault://secrets/db#/db | vals eval -f -

pause
