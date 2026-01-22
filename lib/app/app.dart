import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/routes/app_router.dart';
import '../core/theme/app_theme.dart';
import '../app/routes.dart';

// Global navigation history tracker
class NavigationHistory {
  static final NavigationHistory _instance = NavigationHistory._internal();
  factory NavigationHistory() => _instance;
  NavigationHistory._internal();

  final List<String> _history = [AppRoutes.home];

  void addRoute(String route) {
    if (_history.isEmpty || _history.last != route) {
      _history.add(route);
      // Keep only last 20 routes
      if (_history.length > 20) {
        _history.removeAt(0);
      }
    }
  }

  String? getPreviousRoute() {
    if (_history.length > 1) {
      _history.removeLast(); // Remove current
      return _history.isNotEmpty ? _history.last : AppRoutes.home;
    }
    return null;
  }

  void clear() {
    _history.clear();
    _history.add(AppRoutes.home);
  }

  String getCurrentRoute() {
    return _history.isNotEmpty ? _history.last : AppRoutes.home;
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Apna Dukan',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return _BackButtonHandler(
          child: child!,
        );
      },
    );
  }
}

class _BackButtonHandler extends StatefulWidget {
  final Widget child;

  const _BackButtonHandler({required this.child});

  @override
  State<_BackButtonHandler> createState() => _BackButtonHandlerState();
}

class _BackButtonHandlerState extends State<_BackButtonHandler> {
  @override
  void initState() {
    super.initState();
    // Track initial route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trackCurrentRoute();
    });
  }

  void _trackCurrentRoute() {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      final currentPath = router.routerDelegate.currentConfiguration.uri.path;
      NavigationHistory().addRoute(currentPath);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Track route changes
    _trackCurrentRoute();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }

        final router = GoRouter.maybeOf(context);
        if (router == null) return;
        
        final currentPath = router.routerDelegate.currentConfiguration.uri.path;
        final navHistory = NavigationHistory();
        
        // Check if we can pop a route (for routes navigated with push)
        if (router.canPop()) {
          router.pop();
        } else {
          // For routes navigated with go(), use our history
          final previousRoute = navHistory.getPreviousRoute();
          if (previousRoute != null && previousRoute != currentPath) {
            router.go(previousRoute);
          } else {
            // If no history or already at home, navigate to home instead of closing
            if (currentPath != AppRoutes.home && currentPath != '/') {
              navHistory.clear();
              router.go(AppRoutes.home);
            }
            // If already at home, prevent the app from closing
            // The back button will do nothing when at home
          }
        }
      },
      child: widget.child,
    );
  }
}



