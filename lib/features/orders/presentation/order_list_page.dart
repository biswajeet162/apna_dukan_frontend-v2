import 'package:flutter/material.dart';
import '../../../../core/widgets/app_navbar.dart';
import '../../../../app/routes.dart';
import 'package:go_router/go_router.dart';

class OrderListPage extends StatelessWidget {
  final String? userId;

  const OrderListPage({
    super.key,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Orders Page',
              style: TextStyle(fontSize: 24),
            ),
            if (userId != null) ...[
              const SizedBox(height: 16),
              Text(
                'User ID: $userId',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: AppNavbar(
        currentIndex: 2, // Orders tab
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.categories);
              break;
            case 2:
              // Already on orders page
              break;
          }
        },
      ),
    );
  }
}
