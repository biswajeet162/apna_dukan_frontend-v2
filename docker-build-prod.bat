@echo off
REM Docker build script for production environment
echo Building Docker image for PRODUCTION environment...
docker build --build-arg ENV=prod -t apna-dukan-frontend:prod .
echo Build complete!
echo To run: docker run -p 8080:80 apna-dukan-frontend:prod

