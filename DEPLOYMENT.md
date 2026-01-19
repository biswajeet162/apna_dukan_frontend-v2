# Deployment Guide

## Environment Configuration

The app supports two environments:
- **Local**: Uses `http://localhost:8080` for backend API calls
- **Production**: Uses `https://apna-dukan-backend-v2-v6w4.onrender.com` for backend API calls

## Building for Different Environments

### Local Development

#### Flutter Web Build (Local)
```bash
flutter build web --release --dart-define=ENV=local
```

Or use the build script:
```bash
./build-local.sh
```

#### Docker Build (Local)
```bash
docker build --build-arg ENV=local -t apna-dukan-frontend:local .
docker run -p 8080:80 apna-dukan-frontend:local
```

Or use the build script:
```bash
./docker-build-local.sh
```

### Production Deployment

#### Flutter Web Build (Production)
```bash
flutter build web --release --dart-define=ENV=prod
```

Or use the build script:
```bash
./build-prod.sh
```

#### Docker Build (Production)
```bash
docker build --build-arg ENV=prod -t apna-dukan-frontend:prod .
docker run -p 8080:80 apna-dukan-frontend:prod
```

Or use the build script:
```bash
./docker-build-prod.sh
```

## Android App Build

**IMPORTANT**: Android APKs **always use production backend by default**. This ensures all released APKs connect to the production backend.

### Production Build (Default - Recommended)
```bash
flutter build apk --release --dart-define=ENV=prod
```

Or use the dedicated build script:
```bash
# Windows
build-android-prod.bat

# Linux/Mac
./build-android-prod.sh
```

**Note**: Even without `--dart-define=ENV=prod`, Android builds default to production environment.

### Local Build (For Testing Only)
Only use this for local development/testing with a local backend:
```bash
flutter build apk --release --dart-define=ENV=local
```

Or use the dedicated build script:
```bash
# Windows
build-android-local.bat

# Linux/Mac
./build-android-local.sh
```

## Environment Detection

The app automatically detects the environment from the `ENV` compile-time constant:
- **Default**: Production environment (for Android APKs)
- If `ENV=local` is explicitly set, it uses the local backend URL
- If `ENV=prod` is set, it uses the production backend URL

The environment is set at build time and cannot be changed at runtime for security reasons.

## Backend URLs

- **Local**: `http://localhost:8080/api`
- **Production**: `https://apna-dukan-backend-v2-v6w4.onrender.com/api`

## Render.com Deployment

### Automatic Deployment with render.yaml

The project includes a `render.yaml` file that configures the build with the production environment automatically.

1. Connect your repository to Render
2. Render will automatically detect the `render.yaml` file
3. The build will use `ENV=prod` automatically

### Manual Render Configuration

If not using `render.yaml`, configure Render manually:

1. **Service Type**: Web Service
2. **Environment**: Docker
3. **Dockerfile Path**: `./Dockerfile`
4. **Docker Context**: `.`
5. **Build Command**: (leave empty, handled by Dockerfile)
6. **Start Command**: (leave empty, handled by Dockerfile)
7. **Environment Variables**:
   - `ENV` = `prod`
8. **Build Arguments**:
   - `ENV` = `prod`

### Verifying Production Environment

After deployment, verify the environment is correct:

1. Open the deployed app in a browser
2. Open Developer Tools (F12) → Console tab
3. Look for the bootstrap logs:
   - Should show: `Running in prod environment`
   - Should show: `API Base URL: https://apna-dukan-backend-v2-v6w4.onrender.com/api`

If you see `local` environment or `http://localhost:8080`, the build didn't use the production environment flag.

## Troubleshooting

### App is using localhost backend in production

**Solution**: Ensure the Docker build uses `--build-arg ENV=prod`:
```bash
docker build --build-arg ENV=prod -t apna-dukan-frontend:prod .
```

Or in Render, ensure the environment variable `ENV=prod` is set.

### Favicon 404 errors

The nginx configuration now redirects `/favicon.ico` to `/favicon.png` automatically. This should resolve 404 errors for favicon requests.

