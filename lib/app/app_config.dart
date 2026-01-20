// Environment configuration
import 'package:flutter/foundation.dart';

enum Environment {
  local,
  prod,
}

class AppConfig {
  // Get environment from compile-time constant or sensible defaults
  // Priority:
  // 1. Explicit --dart-define=ENV=local/prod
  // 2. If running on Web:
  //    - Debug (flutter run -d chrome)  → local (localhost:8080)
  //    - Release (flutter build web)    → prod
  // 3. If running on mobile/desktop (non‑web):
  //    - Always prod (even for flutter run -d <device>)
  static Environment get _currentEnvironment {
    const env = String.fromEnvironment('ENV', defaultValue: '');

    // If explicitly set via --dart-define, use that
    if (env == 'local') return Environment.local;
    if (env == 'prod') return Environment.prod;

    // Web: local in debug, prod in release
    if (kIsWeb) {
      return kDebugMode ? Environment.local : Environment.prod;
    }

    // Non‑web (mobile / desktop): always talk to PROD backend by default
    return Environment.prod;
  }

  static Environment get currentEnvironment => _currentEnvironment;

  static void setEnvironment(Environment env) {
    // Note: This is kept for backward compatibility but compile-time constant takes precedence
    // To change environment, use --dart-define=ENV=local or --dart-define=ENV=prod when building
  }

  static String get baseUrl {
    switch (_currentEnvironment) {
      case Environment.local:
        return 'http://localhost:8080';
      case Environment.prod:
        return 'https://apna-dukan-backend-v2-v6w4.onrender.com';
    }
  }

  static String get apiBaseUrl => '$baseUrl/api';
}

