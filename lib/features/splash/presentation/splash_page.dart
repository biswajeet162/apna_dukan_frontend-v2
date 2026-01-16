import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'Apna Dukan',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
