// Environment configuration
enum Environment {
  local,
  prod,
}

class AppConfig {
  // Get environment from compile-time constant or default to prod
  // Android APKs should always use production backend
  static Environment get _currentEnvironment {
    const env = String.fromEnvironment('ENV', defaultValue: 'prod');
    return env == 'local' ? Environment.local : Environment.prod;
  }

  static Environment get currentEnvironment => _currentEnvironment;

  static void setEnvironment(Environment env) {
    // Note: This is kept for backward compatibility but compile-time constant takes precedence
    // To change environment, use --dart-define=ENV=prod when building
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

