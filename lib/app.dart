import 'package:flutter/material.dart';
import 'core/routes/route_generator.dart';
import 'core/routes/app_routes.dart';
import 'core/config/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apna Dukan',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
