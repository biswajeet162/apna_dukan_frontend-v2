import 'package:flutter/material.dart';
import '../../../../core/widgets/app_navbar.dart';
import '../../../../core/widgets/login_prompt_widget.dart';
import '../../../../app/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/service_locator.dart';
import '../../../../core/services/auth_service.dart';

class OrderListPage extends StatefulWidget {
  final String? userId;

  const OrderListPage({
    super.key,
    this.userId,
  });

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  late AuthService _authService;
  bool _isAdmin = false;
  bool _isLoadingAdmin = true;
  bool _isCheckingAuth = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(ServiceLocator().secureStorage);
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final isAuthenticated = await _authService.isAuthenticated();
    setState(() {
      _isAuthenticated = isAuthenticated;
      _isCheckingAuth = false;
    });

    // Always check admin status to show correct tabs (even if not authenticated)
    await _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await _authService.isAdmin();
    setState(() {
      _isAdmin = isAdmin;
      _isLoadingAdmin = false;
    });
  }

  void _onNavTap(int index) {
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
      case 3:
        // Dashboard button (only visible for admin)
        context.go(AppRoutes.adminDashboard);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(AppRoutes.home);
          },
        ),
      ),
      body: _isCheckingAuth
          ? const Center(child: CircularProgressIndicator())
          : !_isAuthenticated
              ? const LoginPromptWidget(
                  title: 'Login Required',
                  message: 'Please login to view your orders',
                  icon: Icons.shopping_bag_outlined,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Orders Page',
                        style: TextStyle(fontSize: 24),
                      ),
                      if (widget.userId != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'User ID: ${widget.userId}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ],
                  ),
                ),
      bottomNavigationBar: _isLoadingAdmin
          ? null
          : AppNavbar(
              currentIndex: 2, // Orders tab
              onTap: _onNavTap,
              isAdmin: _isAdmin,
            ),
    );
  }
}
