@echo off
REM Build script for Android APK - Local (for testing only)
REM Use this only for local development/testing with local backend
echo Building Android APK for LOCAL environment...
echo Backend URL: http://localhost:8080
echo WARNING: This is for local testing only!
flutter build apk --release --dart-define=ENV=local
echo Build complete! APK location: build\app\outputs\flutter-apk\app-release.apk



