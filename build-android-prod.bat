@echo off
REM Build script for Android APK - Production
REM This script always builds with production backend endpoints
echo Building Android APK for PRODUCTION environment...
echo Backend URL: https://apna-dukan-backend-v2-v6w4.onrender.com
flutter build apk --release --dart-define=ENV=prod
echo Build complete! APK location: build\app\outputs\flutter-apk\app-release.apk

