import 'package:flutter/material.dart';
import 'app.dart';
import 'di/service_locator.dart';
import 'core/config/env_config.dart';

void main() {
  // Initialize service locator
  ServiceLocator().init();
  
  // Set environment (default to local, can be changed later)
  EnvConfig.setEnvironment(Environment.local);
  
  runApp(const App());
}
