// Product Groups Page - Shows product groups for a subcategory
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../di/service_locator.dart';
import '../../data/models/product_group_response.dart';
import '../../data/models/product_group_model.dart';
import '../../../product/data/models/product_listing_response.dart';
import '../../../product/data/models/product_listing_item.dart';
import '../../../product/presentation/widgets/product_listing_card.dart';
import '../../../../app/routes.dart';

class ProductGroupsPage extends StatefulWidget {
  final String subCategoryId;
  final String subCategoryName;
  final Widget? bottomNavigationBar;

  const ProductGroupsPage({
    super.key,
    required this.subCategoryId,
    required this.subCategoryName,
    this.bottomNavigationBar,
  });

  @override
  State<ProductGroupsPage> createState() => _ProductGroupsPageState();
}

class _ProductGroupsPageState extends State<ProductGroupsPage> {
  ProductGroupResponse? _productGroupResponse;
  ProductListingResponse? _productListingResponse;
  bool _isLoading = true;
  bool _isLoadingProducts = false;
  String? _errorMessage;
  String? _productErrorMessage;
  int _selectedIndex = 0;
  String? _selectedProductGroupId;

  @override
  void initState() {
    super.initState();
    // When route is /home/categories?subCategoryId=xxx, ALWAYS make these 2 API calls:
    // 1. Product Groups API (using subCategoryId)
    // 2. Products API (using first product group ID - default selected)
    _loadProductGroups();
  }

  Future<void> _loadProductGroups() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // API CALL #1: Load Product Groups using subCategoryId
      final response = await ServiceLocator().getProductGroupsUseCase(widget.subCategoryId);

      setState(() {
        _productGroupResponse = response;
        _isLoading = false;
      });

      // API CALL #2: Load Products for the first product group (default selected)
      if (response.productGroups.isNotEmpty) {
        _selectedIndex = 0;
        _selectedProductGroupId = response.productGroups[0].productGroupId;
        _loadProducts(response.productGroups[0].productGroupId);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProducts(String productGroupId) async {
    try {
      setState(() {
        _isLoadingProducts = true;
        _productErrorMessage = null;
      });

      final response = await ServiceLocator()
          .getProductListingUseCase(productGroupId, size: 100);

      setState(() {
        _productListingResponse = response;
        _isLoadingProducts = false;
      });
    } catch (e) {
      setState(() {
        _productErrorMessage = e.toString();
        _isLoadingProducts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: widget.bottomNavigationBar,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            _buildTopBar(),
            // Filter/Sort Bar
            _buildFilterBar(),
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error: $_errorMessage',
                                style: TextStyle(color: Colors.red[700]),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadProductGroups,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _productGroupResponse == null ||
                              _productGroupResponse!.productGroups.isEmpty
                          ? const Center(
                              child: Text('No product groups found'),
                            )
                          : Row(
                              children: [
                                // Left Sidebar - Product Groups List
                                _buildSidebar(),
                                // Main Content - Product Groups Grid
                                Expanded(
                                  child: _buildProductGroupsGrid(),
                                ),
                              ],
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[700],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              // Navigate to home page which will reload layout, categories, and subcategories
              context.go(AppRoutes.home);
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.subCategoryName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              context.push(AppRoutes.search);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          _buildFilterChip('Filters', Icons.tune),
          const SizedBox(width: 8),
          _buildFilterChip('Sort', Icons.swap_vert),
          const SizedBox(width: 8),
          _buildFilterChip('Price', Icons.arrow_drop_down),
          const SizedBox(width: 8),
          _buildFilterChip('Brand', Icons.arrow_drop_down),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return InkWell(
      onTap: () {
        // TODO: Implement filter/sort functionality
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            Icon(icon, size: 18, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    if (_productGroupResponse == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          right: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: ListView.builder(
        itemCount: _productGroupResponse!.productGroups.length,
        itemBuilder: (context, index) {
          final productGroup = _productGroupResponse!.productGroups[index];
          final isSelected = _selectedIndex == index;
          final imageUrl = productGroup.imageUrl.isNotEmpty
              ? productGroup.imageUrl.first
              : null;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedIndex = index;
                _selectedProductGroupId = productGroup.productGroupId;
              });
              _loadProducts(productGroup.productGroupId);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                border: isSelected
                    ? Border(
                        left: BorderSide(color: Colors.green[700]!, width: 3),
                      )
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.green[700]! : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[400],
                                size: 22,
                              ),
                            )
                          : Icon(
                              Icons.category,
                              color: Colors.grey[400],
                              size: 26,
                            ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    productGroup.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.green[700] : Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGroupsGrid() {
    if (_isLoadingProducts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_productErrorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error loading products: $_productErrorMessage',
              style: TextStyle(color: Colors.red[700]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedProductGroupId != null) {
                  _loadProducts(_selectedProductGroupId!);
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_productListingResponse == null ||
        _productListingResponse!.products.isEmpty) {
      return const Center(
        child: Text('No products found'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 12,
        childAspectRatio: 0.50, // Increased for larger cards
      ),
      itemCount: _productListingResponse!.products.length,
      itemBuilder: (context, index) {
        return ProductListingCard(
          product: _productListingResponse!.products[index],
        );
      },
    );
  }
}

