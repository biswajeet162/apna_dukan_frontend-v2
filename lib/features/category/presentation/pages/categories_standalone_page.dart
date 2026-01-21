// Standalone Categories Page - /categories?subCategoryId=xxx&subCategoryName=xxx
import 'package:flutter/material.dart';
import '../../../product_group/presentation/pages/product_groups_page.dart';
import '../../../../core/widgets/app_navbar.dart';
import '../../../../app/routes.dart';
import 'package:go_router/go_router.dart';

class CategoriesStandalonePage extends StatefulWidget {
  final String? subCategoryId;
  final String? subCategoryName;

  const CategoriesStandalonePage({
    super.key,
    this.subCategoryId,
    this.subCategoryName,
  });

  @override
  State<CategoriesStandalonePage> createState() => _CategoriesStandalonePageState();
}

class _CategoriesStandalonePageState extends State<CategoriesStandalonePage> {
  @override
  Widget build(BuildContext context) {
    // If no subCategoryId, show empty state
    if (widget.subCategoryId == null || widget.subCategoryId!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            'Select a category to view products',
            style: TextStyle(fontSize: 16),
          ),
        ),
        bottomNavigationBar: AppNavbar(
          currentIndex: 1, // Categories tab
          onTap: _onNavTap,
        ),
      );
    }

    // Show ProductGroupsPage with bottom navigation
    return ProductGroupsPage(
      key: ValueKey(widget.subCategoryId), // Force rebuild when subCategoryId changes
      subCategoryId: widget.subCategoryId!,
      subCategoryName: widget.subCategoryName ?? 'Products',
      bottomNavigationBar: AppNavbar(
        currentIndex: 1, // Categories tab
        onTap: _onNavTap,
      ),
    );
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        // Already on categories page
        break;
      case 2:
        context.go(AppRoutes.orders);
        break;
    }
  }
}

