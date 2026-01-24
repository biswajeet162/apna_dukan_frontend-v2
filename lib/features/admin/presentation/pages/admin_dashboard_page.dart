import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';
import '../../../../core/widgets/app_navbar.dart';
import '../../../../di/service_locator.dart';
import '../../../../core/services/auth_service.dart';
import 'tabs/layout_tab.dart';
import 'tabs/category_tab.dart';
import 'tabs/subcategory_tab.dart';
import 'tabs/product_tab.dart';
import 'tabs/product_group_tab.dart';

class AdminDashboardPage extends StatefulWidget {
  final String? tab;

  const AdminDashboardPage({
    super.key,
    this.tab,
  });

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AuthService _authService;
  bool _isAdmin = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(ServiceLocator().secureStorage);
    _checkAdminStatus();
    _tabController = TabController(length: 5, vsync: this);
    _setInitialTab();
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await _authService.isAdmin();
    setState(() {
      _isAdmin = isAdmin;
      _isLoading = false;
    });
  }

  void _setInitialTab() {
    // Set initial tab based on route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTabFromRoute();
    });
    _tabController.addListener(_onTabChanged);
  }

  void _updateTabFromRoute() {
    final tab = widget.tab;
    if (tab != null) {
      int targetIndex;
      switch (tab) {
        case 'layout':
          targetIndex = 0;
          break;
        case 'category':
          targetIndex = 1;
          break;
        case 'subcategory':
          targetIndex = 2;
          break;
        case 'product':
          targetIndex = 3;
          break;
        case 'product-group':
          targetIndex = 4;
          break;
        default:
          targetIndex = 0;
      }
      // Only animate if the tab is different
      if (_tabController.index != targetIndex) {
        _tabController.animateTo(targetIndex);
      }
    }
  }

  @override
  void didUpdateWidget(AdminDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update tab if the route tab parameter changed
    if (oldWidget.tab != widget.tab) {
      _updateTabFromRoute();
    }
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final index = _tabController.index;
      String route;
      switch (index) {
        case 0:
          route = AppRoutes.adminDashboardLayout;
          break;
        case 1:
          route = AppRoutes.adminDashboardCategory;
          break;
        case 2:
          route = AppRoutes.adminDashboardSubcategory;
          break;
        case 3:
          route = AppRoutes.adminDashboardProduct;
          break;
        case 4:
          route = AppRoutes.adminDashboardProductGroup;
          break;
        default:
          route = AppRoutes.adminDashboardLayout;
      }
      // Only update route if it's different from current route to prevent unnecessary rebuilds
      final currentRoute = GoRouterState.of(context).uri.path;
      if (currentRoute != route) {
        context.go(route);
      }
    }
  }

  int _getNavbarIndex() {
    // Dashboard is the 4th button (index 3) when admin is logged in
    return 3;
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
        context.go(AppRoutes.orders);
        break;
      case 3:
        // Already on dashboard
        break;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Access Denied'),
          backgroundColor: Colors.red[700],
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'You do not have permission to access this page.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // If no tab is specified, show the dashboard overview with clickable items
    if (widget.tab == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Operations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Grid of operation cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildDashboardCard(
                    context,
                    title: 'Layout',
                    icon: Icons.view_module,
                    route: AppRoutes.adminDashboardLayout,
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Category',
                    icon: Icons.category,
                    route: AppRoutes.adminDashboardCategory,
                  ),
                  _buildDashboardCard(
                    context,
                    title: 'Subcategory',
                    icon: Icons.subdirectory_arrow_right,
                    route: AppRoutes.adminDashboardSubcategory,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: AppNavbar(
          currentIndex: _getNavbarIndex(),
          onTap: _onNavTap,
          isAdmin: true,
        ),
      );
    }

    // If tab is specified, show only that specific operation with back button
    String title = _getTitleForTab(widget.tab!);
    Widget content = _getContentForTab(widget.tab!);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go(AppRoutes.adminDashboard);
          },
        ),
        title: Text(title),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: content,
      bottomNavigationBar: AppNavbar(
        currentIndex: _getNavbarIndex(),
        onTap: _onNavTap,
        isAdmin: true,
      ),
    );
  }

  String _getTitleForTab(String tab) {
    switch (tab) {
      case 'layout':
        return 'Layout';
      case 'category':
        return 'Category';
      case 'subcategory':
        return 'Subcategory';
      case 'product':
        return 'Product';
      case 'product-group':
        return 'Product Group';
      default:
        return 'Admin Dashboard';
    }
  }

  Widget _getContentForTab(String tab) {
    switch (tab) {
      case 'layout':
        return const LayoutTab(key: ValueKey('layout_tab'));
      case 'category':
        return const CategoryTab(key: ValueKey('category_tab'));
      case 'subcategory':
        return const SubcategoryTab(key: ValueKey('subcategory_tab'));
      case 'product':
        return const ProductTab(key: ValueKey('product_tab'));
      case 'product-group':
        return const ProductGroupTab(key: ValueKey('product_group_tab'));
      default:
        return const LayoutTab(key: ValueKey('layout_tab'));
    }
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.go(route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.green[700],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

