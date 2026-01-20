// Environment configuration
import 'package:flutter/foundation.dart';

enum Environment {
  local,
  prod,
}

class AppConfig {
  // Get environment from compile-time constant or default based on build mode
  // Debug mode defaults to local, Release mode defaults to prod
  static Environment get _currentEnvironment {
    const env = String.fromEnvironment('ENV', defaultValue: '');
    
    // If explicitly set via --dart-define, use that
    if (env == 'local') return Environment.local;
    if (env == 'prod') return Environment.prod;
    
    // Otherwise, default based on build mode
    // Debug mode (flutter run) → local
    // Release mode (flutter build) → prod
    if (kDebugMode) {
      return Environment.local;
    } else {
      return Environment.prod;
    }
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

