@echo off
chcp 65001 >nul

echo ✅ Please wait for some time so that we can verify your connection...

cd /d %~dp0

rem Compile Arduino code
cli\arduino-cli.exe compile --fqbn esp8266:esp8266:nodemcuv2 arduino
if %errorlevel% neq 0 (
    echo ❌ Compilation Failed!
    pause
    exit /b
)

rem Upload Arduino code
cli\arduino-cli.exe upload -p COM6 --fqbn esp8266:esp8266:nodemcuv2 arduino
if %errorlevel% neq 0 (
    echo ❌ Upload Failed! Check your COM port or connection.
    pause
    exit /b
)

echo ✅ Your connection is done...

rem Wait for Arduino reboot
timeout /t 3 >nul

echo ✅ Just wait for few seconds , we are reading your data...
start cmd /k "node server.js"

timeout /t 2 >nul

echo ✅ You are almost done! here's your visualization data...
start chrome http://localhost:3000/home.html

echo ✅ All Systems GO!
exit
