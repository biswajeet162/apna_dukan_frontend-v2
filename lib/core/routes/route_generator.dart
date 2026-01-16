import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/search/presentation/search_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      
      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
