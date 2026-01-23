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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.view_module), text: 'Layout'),
            Tab(icon: Icon(Icons.category), text: 'Categories'),
            Tab(icon: Icon(Icons.subdirectory_arrow_right), text: 'Subcategories'),
            Tab(icon: Icon(Icons.shopping_bag), text: 'Products'),
            Tab(icon: Icon(Icons.inventory_2), text: 'Product Groups'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        // Use keys to preserve state when widget tree rebuilds
        children: const [
          LayoutTab(key: ValueKey('layout_tab')),
          CategoryTab(key: ValueKey('category_tab')),
          SubcategoryTab(key: ValueKey('subcategory_tab')),
          ProductTab(key: ValueKey('product_tab')),
          ProductGroupTab(key: ValueKey('product_group_tab')),
        ],
      ),
      bottomNavigationBar: AppNavbar(
        currentIndex: _getNavbarIndex(),
        onTap: _onNavTap,
        isAdmin: true,
      ),
    );
  }
}

