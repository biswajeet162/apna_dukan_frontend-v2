@echo off
REM Build script for local development
echo Building Flutter web app for LOCAL environment...
flutter build web --release --dart-define=ENV=local
echo Build complete! Backend URL: http://localhost:8080

