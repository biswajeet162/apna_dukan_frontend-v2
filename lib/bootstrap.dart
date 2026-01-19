// Dependency injection setup
import 'di/service_locator.dart';
import 'app/app_config.dart';

void bootstrap() {
  // Initialize service locator
  ServiceLocator().init();
  
  // Environment is automatically detected from compile-time constants
  // Default: Production (Android APKs always use production backend)
  // Use --dart-define=ENV=local for local development/testing
  // Use --dart-define=ENV=prod to explicitly set production (default)
  print('Running in ${AppConfig.currentEnvironment.name} environment');
  print('API Base URL: ${AppConfig.apiBaseUrl}');
}

