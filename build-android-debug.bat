@echo off
REM Build script for Android APK - Debug Mode
REM This script cleans the build cache and builds a fresh debug APK
echo Cleaning Flutter build cache...
flutter clean
echo.
echo Building Android APK for DEBUG mode (Production backend)...
echo Backend URL: https://apna-dukan-backend-v2-v6w4.onrender.com
flutter build apk --debug --dart-define=ENV=prod
echo.
echo Build complete! APK location: build\app\outputs\flutter-apk\app-debug.apk
echo.
echo To install on connected device:
echo   flutter install


