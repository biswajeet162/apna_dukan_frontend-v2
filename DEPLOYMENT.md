# Deployment Guide

## Environment Configuration

The app supports two environments:
- **Local**: Uses `http://localhost:8080` for backend API calls
- **Production**: Uses `https://apna-dukan-backend-v2.onrender.com` for backend API calls

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

For Android builds, you can specify the environment:

### Local (for testing with local backend)
```bash
flutter build apk --release --dart-define=ENV=local
```

### Production (for release)
```bash
flutter build apk --release --dart-define=ENV=prod
```

## Environment Detection

The app automatically detects the environment from the `ENV` compile-time constant:
- If `ENV=prod` is set, it uses the production backend URL
- Otherwise, it defaults to local environment

The environment is set at build time and cannot be changed at runtime for security reasons.

## Backend URLs

- **Local**: `http://localhost:8080/api`
- **Production**: `https://apna-dukan-backend-v2.onrender.com/api`

