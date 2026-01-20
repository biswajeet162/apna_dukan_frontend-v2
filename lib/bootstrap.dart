// Dependency injection setup
import 'di/service_locator.dart';
import 'app/app_config.dart';

void bootstrap() {
  // Initialize service locator
  ServiceLocator().init();
  
  // Environment is automatically detected:
  // - Debug mode (flutter run): defaults to local (localhost:8080)
  // - Release mode (flutter build): defaults to prod
  // - Can be overridden with --dart-define=ENV=local or --dart-define=ENV=prod
  print('Running in ${AppConfig.currentEnvironment.name} environment');
  print('API Base URL: ${AppConfig.apiBaseUrl}');
}

