// Product Groups Page - Shows product groups for a subcategory
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../di/service_locator.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/models/product_group_response.dart';
import '../../data/models/product_group_model.dart';
import '../../data/models/bulk_update_product_group_item.dart';
import '../../data/models/bulk_update_product_group_request.dart';
import '../../../product/data/models/product_listing_response.dart';
import '../../../product/data/models/product_listing_item.dart';
import '../../../product/presentation/widgets/product_listing_card.dart';
import '../../../../app/routes.dart';

class ProductGroupsPage extends StatefulWidget {
  final String subCategoryId;
  final String subCategoryName;
  final String? categoryId;
  final String? sectionId;
  final Widget? bottomNavigationBar;

  const ProductGroupsPage({
    super.key,
    required this.subCategoryId,
    required this.subCategoryName,
    this.categoryId,
    this.sectionId,
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
  late AuthService _authService;
  bool _isAdmin = false;
  bool _isEditMode = false;
  String? _sectionId;
  String? _categoryId;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(ServiceLocator().secureStorage);
    _sectionId = widget.sectionId;
    _categoryId = widget.categoryId;
    _checkAdminStatus();
    // When route is /home/categories?subCategoryId=xxx, ALWAYS make these 2 API calls:
    // 1. Product Groups API (using subCategoryId)
    // 2. Products API (using first product group ID - default selected)
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await _authService.isAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
      _loadProductGroups();
    }
  }

  Future<void> _loadProductGroups() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // API CALL #1: Load Product Groups using subCategoryId
      final response = await ServiceLocator()
          .getProductGroupsUseCase(widget.subCategoryId, isAdmin: _isAdmin);

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

  Future<void> _openAddProductGroupPage() async {
    final result = await context.push<bool>(
      '${AppRoutes.addProductGroupCategories}?subCategoryId=${widget.subCategoryId}&subCategoryName=${Uri.encodeComponent(widget.subCategoryName)}',
    );

    if (result == true) {
      _loadProductGroups();
    }
  }

  Future<void> _ensureParentIds() async {
    if (!_isAdmin || (_sectionId != null && _categoryId != null)) {
      return;
    }

    try {
      final subCategory = await ServiceLocator()
          .getSubCategoryByIdUseCase
          .call(widget.subCategoryId);
      final category = await ServiceLocator()
          .getCategoryByIdUseCase
          .call(subCategory.categoryId);

      if (mounted) {
        setState(() {
          _categoryId = subCategory.categoryId;
          _sectionId = category.sectionId;
        });
      }
    } catch (_) {
      // Ignore - edit mode navigation will handle missing IDs
    }
  }

  Future<void> _openEditProductGroup(ProductGroupModel productGroup) async {
    await _ensureParentIds();

    if (_sectionId == null || _categoryId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open edit page. Missing category info.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final uri = AppRoutes.homeEditProductGroupWithIds(
      _sectionId!,
      _categoryId!,
      widget.subCategoryId,
      productGroup.productGroupId,
      productGroupName: productGroup.name,
    );

    final result = await context.push<bool>(uri);
    if (result == true) {
      _loadProductGroups();
    }
  }

  void _handleToggleEditMode(bool value) {
    setState(() {
      _isEditMode = value;
    });
    if (value) {
      _ensureParentIds();
    }
  }

  Future<void> _handleReorder(int oldIndex, int newIndex) async {
    if (!_isEditMode || _productGroupResponse == null) {
      return;
    }

    final productGroups = List<ProductGroupModel>.from(_productGroupResponse!.productGroups);
    if (productGroups.isEmpty) return;

    if (oldIndex >= productGroups.length) {
      return;
    }

    if (newIndex > productGroups.length) {
      newIndex = productGroups.length;
    }

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    if (oldIndex == newIndex) return;

    final item = productGroups.removeAt(oldIndex);
    productGroups.insert(newIndex, item);

    final bulkUpdateItems = <BulkUpdateProductGroupItem>[];
    final updatedProductGroups = <ProductGroupModel>[];
    for (int i = 0; i < productGroups.length; i++) {
      final group = productGroups[i];
      bulkUpdateItems.add(BulkUpdateProductGroupItem(
        productGroupId: group.productGroupId,
        displayOrder: i + 1,
      ));
      updatedProductGroups.add(ProductGroupModel(
        productGroupId: group.productGroupId,
        subCategoryId: group.subCategoryId,
        name: group.name,
        description: group.description,
        code: group.code,
        displayOrder: i + 1,
        enabled: group.enabled,
        imageUrl: group.imageUrl,
      ));
    }

    setState(() {
      _productGroupResponse = ProductGroupResponse(
        subCategoryId: _productGroupResponse!.subCategoryId,
        subCategoryName: _productGroupResponse!.subCategoryName,
        productGroups: updatedProductGroups,
      );
      if (_selectedProductGroupId != null) {
        final newSelectedIndex = updatedProductGroups.indexWhere(
          (group) => group.productGroupId == _selectedProductGroupId,
        );
        if (newSelectedIndex >= 0) {
          _selectedIndex = newSelectedIndex;
        }
      }
    });

    try {
      final request = BulkUpdateProductGroupRequest(productGroups: bulkUpdateItems);
      await ServiceLocator().bulkUpdateProductGroupsUseCase.call(request.toJson());
    } catch (e) {
      _loadProductGroups();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating order: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
          if (_isAdmin) ...[
            const SizedBox(width: 8),
            Text(
              'Edit',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: _isEditMode,
                onChanged: _isLoading ? null : _handleToggleEditMode,
                activeColor: Colors.white,
                activeTrackColor: Colors.white.withOpacity(0.4),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.white.withOpacity(0.2),
              ),
            ),
          ],
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
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        onReorder: _handleReorder,
        itemCount: _productGroupResponse!.productGroups.length + 1,
        itemBuilder: (context, index) {
          final isAddItem = index == _productGroupResponse!.productGroups.length;
          if (isAddItem) {
            return KeyedSubtree(
              key: const ValueKey('add_product_group'),
              child: InkWell(
                onTap: _isLoading ? null : _openAddProductGroupPage,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green[700],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Add',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final productGroup = _productGroupResponse!.productGroups[index];
          final isSelected = _selectedIndex == index;
          final imageUrl = productGroup.imageUrl.isNotEmpty
              ? productGroup.imageUrl.first
              : null;
          final isDisabled = !productGroup.enabled;

          final itemContent = InkWell(
            onTap: () {
              if (_isEditMode) {
                _openEditProductGroup(productGroup);
                return;
              }
              setState(() {
                _selectedIndex = index;
                _selectedProductGroupId = productGroup.productGroupId;
              });
              _loadProducts(productGroup.productGroupId);
            },
            child: Opacity(
              opacity: isDisabled ? 0.6 : 1,
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
                    Stack(
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
                            child: ImageFiltered(
                              imageFilter: isDisabled
                                  ? ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5)
                                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
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
                        ),
                        if (_isEditMode)
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: GestureDetector(
                              onTap: () => _openEditProductGroup(productGroup),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green[700]!),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 12,
                                  color: Colors.green[700],
                                ),
                              ),
                            ),
                          ),
                        if (isDisabled)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red[700],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'OFF',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
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
            ),
          );

          if (_isEditMode) {
            return ReorderableDelayedDragStartListener(
              key: ValueKey(productGroup.productGroupId),
              index: index,
              child: itemContent,
            );
          }

          return KeyedSubtree(
            key: ValueKey(productGroup.productGroupId),
            child: itemContent,
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
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 8,
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

