// Dependency injection setup
import 'di/service_locator.dart';
import 'app/app_config.dart';

void bootstrap() {
  // Initialize service locator
  ServiceLocator().init();
  
  // Environment is automatically detected from compile-time constants
  // Use --dart-define=ENV=prod for production builds
  // Use --dart-define=ENV=local (or omit) for local builds
  print('Running in ${AppConfig.currentEnvironment.name} environment');
  print('API Base URL: ${AppConfig.apiBaseUrl}');
}

