@echo off
echo === Helm Secrets Deployment ===

if exist .env (
    echo Loading environment variables from env file...
    for /f "usebackq delims=" %%i in (.env) do (
        set "%%i"
    )
) else (
    echo ERROR: env file not found!
    pause
    exit /b 1
)

echo Running helm upgrade --install...
helm secrets --evaluate-templates -b vals upgrade --install bookshelf-release ./bookshelf-chart -n bookshelf-namespace -f vault-values.yml

if %errorlevel% equ 0 (
    echo Deployment completed successfully!
) else (
    echo Deployment failed with error code %errorlevel%
)

pause
