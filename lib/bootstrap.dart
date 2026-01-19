// Dependency injection setup
import 'di/service_locator.dart';
import 'app/app_config.dart';

void bootstrap() {
  // Initialize service locator
  ServiceLocator().init();
  
  // Set environment (default to local, can be changed later)
  AppConfig.setEnvironment(Environment.local);
}

