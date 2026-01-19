// Environment configuration
enum Environment {
  local,
  prod,
}

class AppConfig {
  static Environment _currentEnvironment = Environment.local;

  static Environment get currentEnvironment => _currentEnvironment;

  static void setEnvironment(Environment env) {
    _currentEnvironment = env;
  }

  static String get baseUrl {
    switch (_currentEnvironment) {
      case Environment.local:
        return 'http://localhost:8080';
      case Environment.prod:
        return 'https://api.apnadukan.com'; // TODO: Configure prod URL later
    }
  }

  static String get apiBaseUrl => '$baseUrl/api';
}

