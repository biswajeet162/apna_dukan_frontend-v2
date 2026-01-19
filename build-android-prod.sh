#!/bin/bash
# Build script for Android APK - Production
# This script always builds with production backend endpoints
echo "Cleaning Flutter build cache..."
flutter clean
echo ""
echo "Building Android APK for PRODUCTION environment..."
echo "Backend URL: https://apna-dukan-backend-v2-v6w4.onrender.com"
flutter build apk --release --dart-define=ENV=prod
echo ""
echo "Build complete! APK location: build/app/outputs/flutter-apk/app-release.apk"

