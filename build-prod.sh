#!/bin/bash
# Build script for production
echo "Building Flutter web app for PRODUCTION environment..."
flutter build web --release --dart-define=ENV=prod
echo "Build complete! Backend URL: https://apna-dukan-backend-v2.onrender.com"

