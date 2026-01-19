#!/bin/bash
# Docker build script for local environment
echo "Building Docker image for LOCAL environment..."
docker build --build-arg ENV=local -t apna-dukan-frontend:local .
echo "Build complete!"
echo "To run: docker run -p 8080:80 apna-dukan-frontend:local"

