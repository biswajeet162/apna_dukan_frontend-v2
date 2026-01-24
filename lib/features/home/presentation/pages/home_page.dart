import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../search/presentation/search_bar_widget.dart';
import '../../../../core/widgets/app_navbar.dart';
import '../../../../app/routes.dart';
import '../../../../di/service_locator.dart';
import '../../../../core/services/auth_service.dart';
import '../../../catalog_layout/domain/models/catalog_section.dart';
import '../../../category/data/models/category_section_response.dart';
import '../../../category/data/models/category_model.dart';
import '../../../subcategory/data/models/subcategory_response.dart';
import '../../../subcategory/data/models/subcategory_model.dart';
import '../widgets/add_subcategory_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthService _authService;
  bool _isAdmin = false;
  bool _isLoadingAdmin = true;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(ServiceLocator().secureStorage);
    _checkAdminStatus();
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
        context.go(AppRoutes.orders);
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
      body: HomeContent(
        isAdmin: _isAdmin,
        onSubCategoryTap: (subCategoryId, subCategoryName) {
          // Navigate to /categories route with subCategoryId
          final uri = Uri(
            path: AppRoutes.categories,
            queryParameters: {
              'subCategoryId': subCategoryId,
              'subCategoryName': subCategoryName,
            },
          );
          context.go(uri.toString());
        },
      ),
      bottomNavigationBar: _isLoadingAdmin
          ? null
          : AppNavbar(
              currentIndex: 0, // Home tab
              onTap: _onNavTap,
              isAdmin: _isAdmin,
            ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final bool isAdmin;
  final Function(String subCategoryId, String subCategoryName)? onSubCategoryTap;

  const HomeContent({
    super.key,
    this.isAdmin = false,
    this.onSubCategoryTap,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<CatalogSection> _catalogSections = [];
  CategorySectionResponse? _categorySectionResponse;
  Map<String, SubCategoryResponse> _subCategoriesMap = {}; // categoryId -> SubCategoryResponse
  Map<String, bool> _loadingSubCategories = {}; // categoryId -> isLoading
  String? _activeEditCategoryId; // Only one category can be in edit mode at a time
  bool _isLoading = true;
  bool _isLoadingCategories = false;
  String? _errorMessage;
  String? _categoryErrorMessage;

  @override
  void initState() {
    super.initState();
    // When route is /home, ALWAYS make these 3 API calls:
    // 1. Layout API
    // 2. Categories API  
    // 3. Subcategories API (for all categories)
    _loadCatalogLayout();
  }

  Future<void> _loadCatalogLayout() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // API CALL #1: Load Catalog Layout
      final sections = await ServiceLocator().getCatalogLayoutUseCase.call();
      
      setState(() {
        _catalogSections = sections;
        _isLoading = false;
      });

      // Find first PRODUCT_CATEGORY section and load its categories
      try {
        final productCategorySection = sections.firstWhere(
          (section) => section.sectionCode == 'PRODUCT_CATEGORY',
        );
        // API CALL #2: Load Categories (will trigger API CALL #3 for subcategories)
        _loadCategories(productCategorySection.sectionId);
      } catch (e) {
        // No PRODUCT_CATEGORY section found, skip loading categories
        print('No PRODUCT_CATEGORY section found: $e');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCategories(String sectionId) async {
    try {
      setState(() {
        _isLoadingCategories = true;
        _categoryErrorMessage = null;
      });

      // API CALL #2: Load Categories
      final categoryResponse = await ServiceLocator().getCategoriesUseCase.call(sectionId);
      
      setState(() {
        _categorySectionResponse = categoryResponse;
        _isLoadingCategories = false;
      });

      // API CALL #3: Load Subcategories for ALL categories
      for (var category in categoryResponse.categories) {
        _loadSubCategories(category.categoryId);
      }
    } catch (e) {
      setState(() {
        _categoryErrorMessage = e.toString();
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _loadSubCategories(String categoryId) async {
    try {
      setState(() {
        _loadingSubCategories[categoryId] = true;
      });

      final subCategoryResponse = await ServiceLocator().getSubCategoriesUseCase.call(categoryId);
      
      setState(() {
        _subCategoriesMap[categoryId] = subCategoryResponse;
        _loadingSubCategories[categoryId] = false;
      });
    } catch (e) {
      setState(() {
        _loadingSubCategories[categoryId] = false;
        // Don't show error for subcategories, just log it
        print('Error loading subcategories for category $categoryId: $e');
      });
    }
  }

  void _navigateToAddSubcategory(CategoryModel category) {
    final uri = Uri(
      path: AppRoutes.homeAddSubcategoryWithIds(category.sectionId, category.categoryId),
      queryParameters: {
        'categoryName': category.name,
      },
    );
    context.go(uri.toString());
  }

  Future<void> _handleReorder(
    String categoryId,
    int oldIndex,
    int newIndex,
  ) async {
    if (oldIndex == newIndex) return;

    final subCategoryResponse = _subCategoriesMap[categoryId];
    if (subCategoryResponse == null) return;

    final subCategories = List<SubCategoryModel>.from(subCategoryResponse.subCategories)
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    // Reorder the list
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = subCategories.removeAt(oldIndex);
    subCategories.insert(newIndex, item);

    // Update displayOrder for all items
    final updatedSubCategories = <SubCategoryModel>[];
    for (int i = 0; i < subCategories.length; i++) {
      final subCat = subCategories[i];
      updatedSubCategories.add(SubCategoryModel(
        subCategoryId: subCat.subCategoryId,
        categoryId: subCat.categoryId,
        name: subCat.name,
        description: subCat.description,
        code: subCat.code,
        displayOrder: i + 1,
        enabled: subCat.enabled,
        imageUrl: subCat.imageUrl,
      ));
    }

    // Update local state immediately
    setState(() {
      _subCategoriesMap[categoryId] = SubCategoryResponse(
        categoryId: categoryId,
        categoryName: subCategoryResponse.categoryName,
        subCategories: updatedSubCategories,
      );
    });

    // Update displayOrder via API
    try {
      for (final subCat in updatedSubCategories) {
        await ServiceLocator().updateSubCategoryUseCase.call(
          subCat.subCategoryId,
          {
            'displayOrder': subCat.displayOrder,
          },
        );
      }
    } catch (e) {
      // If API call fails, reload subcategories to restore original order
      _loadSubCategories(categoryId);
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
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // Header Section (Scrolls up)
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.green[700]!, // Dark green at top
                    Colors.green[600]!,
                    Colors.green[500]!,
                    Colors.green[400]!,
                    Colors.green[300]!, // Light green at bottom
                    Colors.green[50]!, // Very light at the end
                  ],
                ),
              ),
              child: _buildTopHeader(),
            ),
          ),
          
          // Sticky Search Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchBarDelegate(),
          ),
          
          // Catalog Sections Content
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else if (_errorMessage != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Error loading catalog sections',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _loadCatalogLayout,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_catalogSections.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('No catalog sections available'),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildCatalogSection(_catalogSections[index]);
                },
                childCount: _catalogSections.length,
              ),
            ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apna Dukan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        '64, Ring Road',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet,
                            size: 18, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '₹0',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Always navigate to profile page
                      // Profile page will show login prompt if not authenticated
                      context.go(AppRoutes.profile);
                    },
                    child: Icon(Icons.person, size: 28, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogSection(CatalogSection section) {
    final bool isProductCategory = section.sectionCode == 'PRODUCT_CATEGORY';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (section.description != null && section.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    section.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Show categories only for PRODUCT_CATEGORY section
        if (isProductCategory)
          _buildCategoriesForSection()
        else
          const SizedBox(height: 8),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCategoriesForSection() {
    if (_isLoadingCategories) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_categoryErrorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Text(
              'Error loading categories: $_categoryErrorMessage',
              style: TextStyle(color: Colors.red[700], fontSize: 12),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                try {
                  final productCategorySection = _catalogSections.firstWhere(
                    (section) => section.sectionCode == 'PRODUCT_CATEGORY',
                  );
                  _loadCategories(productCategorySection.sectionId);
                } catch (e) {
                  print('No PRODUCT_CATEGORY section found: $e');
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_categorySectionResponse == null || _categorySectionResponse!.categories.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get the PRODUCT_CATEGORY section to access layoutType and scrollType
    CatalogSection? productCategorySection;
    try {
      productCategorySection = _catalogSections.firstWhere(
        (section) => section.sectionCode == 'PRODUCT_CATEGORY',
      );
    } catch (e) {
      // Section not found, use defaults
    }

    // Display category titles with their subcategories, sorted by displayOrder
    final sortedCategories = List<CategoryModel>.from(_categorySectionResponse!.categories)
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sortedCategories.map((category) {
          return _buildCategoryWithSubcategories(category, productCategorySection);
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryWithSubcategories(CategoryModel category, CatalogSection? catalogSection) {
    final subCategoryResponse = _subCategoriesMap[category.categoryId];
    final isLoadingSubCategories = _loadingSubCategories[category.categoryId] ?? false;

    // Get layout type and scroll type from catalog section, default to TWO_ROW and HORIZONTAL
    final layoutType = catalogSection?.layoutType ?? LayoutType.twoRow;
    final scrollType = catalogSection?.scrollType ?? ScrollType.horizontal;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Title with Edit Toggle Button
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (widget.isAdmin)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Switch(
                        value: _activeEditCategoryId == category.categoryId,
                        onChanged: (value) {
                          setState(() {
                            if (value) {
                              // Toggle on - enter edit mode (this will disable any other active edit mode)
                              _activeEditCategoryId = category.categoryId;
                            } else {
                              // Toggle off - exit edit mode
                              _activeEditCategoryId = null;
                            }
                          });
                        },
                        activeColor: Colors.green[700],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Subcategories Grid
          if (isLoadingSubCategories)
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (subCategoryResponse != null && subCategoryResponse.subCategories.isNotEmpty)
            _buildSubCategoriesGrid(
              subCategoryResponse.subCategories,
              layoutType,
              scrollType,
              category,
              _activeEditCategoryId == category.categoryId,
            )
          else if (subCategoryResponse != null && subCategoryResponse.subCategories.isEmpty)
            widget.isAdmin
                ? _buildEmptySubcategoriesWithAddButton(category)
                : Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'No subcategories',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
        ],
      ),
    );
  }

  Widget _buildEmptySubcategoriesWithAddButton(CategoryModel category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          AddSubcategoryButton(
            onTap: () => _navigateToAddSubcategory(category),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoriesGrid(
    List<SubCategoryModel> subCategories,
    LayoutType layoutType,
    ScrollType scrollType,
    CategoryModel category,
    bool isEditMode,
  ) {
    // Sort by displayOrder
    final sortedSubCategories = List<SubCategoryModel>.from(subCategories)
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    final itemCount = sortedSubCategories.length;
    final shouldShowAddButton = widget.isAdmin;
    
    // Items that should NOT be horizontally scrollable: 3, 4, 7, or 8
    final nonScrollableCounts = [3, 4, 7, 8];
    
    // If count is 3, 4, 7, or 8, show in grid (not scrollable)
    if (nonScrollableCounts.contains(itemCount)) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 0,
          childAspectRatio: 0.58,
        ),
        itemCount: sortedSubCategories.length + (shouldShowAddButton ? 1 : 0),
        itemBuilder: (context, index) {
          if (shouldShowAddButton && index == sortedSubCategories.length) {
            return AddSubcategoryButton(
              onTap: () => _navigateToAddSubcategory(category),
            );
          }
          final subCategory = sortedSubCategories[index];
          final card = _buildSubCategoryCard(
            subCategory,
            isEditMode: isEditMode,
            category: category,
            index: index,
          );
          
          if (isEditMode) {
            return LongPressDraggable<int>(
              key: ValueKey(subCategory.subCategoryId),
              data: index,
              feedback: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: Opacity(
                  opacity: 0.8,
                  child: card,
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: card,
              ),
              onDragEnd: (details) {
                // Drag ended, but we handle reorder in DragTarget
              },
              child: DragTarget<int>(
                onAccept: (draggedIndex) {
                  if (draggedIndex != index) {
                    _handleReorder(category.categoryId, draggedIndex, index);
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  return card;
                },
              ),
            );
          }
          return card;
        },
      );
    }
    
    // If less than 5 items (and not 3 or 4), show in single line horizontal
    if (itemCount < 5) {
      return _buildSingleLineHorizontal(sortedSubCategories, category, isEditMode);
    }

    // Grid layout with 4 items per row
    // The number of rows will be automatically calculated based on itemCount
    const itemsPerRow = 4;

    // Always show fixed grid without horizontal scrolling
    // Items will be displayed in the specified number of rows
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsPerRow,
        crossAxisSpacing: 8,
        mainAxisSpacing: 0,
        childAspectRatio: 0.58,
      ),
      itemCount: sortedSubCategories.length + (shouldShowAddButton ? 1 : 0),
      itemBuilder: (context, index) {
        if (shouldShowAddButton && index == sortedSubCategories.length) {
          return AddSubcategoryButton(
            onTap: () => _navigateToAddSubcategory(category),
          );
        }
        final subCategory = sortedSubCategories[index];
        final card = _buildSubCategoryCard(
          subCategory,
          isEditMode: isEditMode,
          category: category,
          index: index,
        );
        
        if (isEditMode) {
          return LongPressDraggable<int>(
            key: ValueKey(subCategory.subCategoryId),
            data: index,
            feedback: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: Opacity(
                opacity: 0.8,
                child: card,
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: card,
            ),
            onDragEnd: (details) {
              // Drag ended, but we handle reorder in DragTarget
            },
            child: DragTarget<int>(
              onAccept: (draggedIndex) {
                if (draggedIndex != index) {
                  _handleReorder(category.categoryId, draggedIndex, index);
                }
              },
              builder: (context, candidateData, rejectedData) {
                return card;
              },
            ),
          );
        }
        return card;
      },
    );
  }

  Widget _buildSingleLineHorizontal(
    List<SubCategoryModel> subCategories,
    CategoryModel category,
    bool isEditMode,
  ) {
    const spacing = 8.0;
    final screenWidth = MediaQuery.of(context).size.width;
    const padding = 16.0; // 8 on each side
    final itemWidth = ((screenWidth - padding - (3 * spacing)) / 4);
    final itemHeight = itemWidth / 0.85;
    final shouldShowAddButton = widget.isAdmin;
    final totalItemCount = subCategories.length + (shouldShowAddButton ? 1 : 0);
    final totalWidth = (totalItemCount * itemWidth) + 
                       ((totalItemCount - 1) * spacing) + 
                       padding;

    return SizedBox(
      height: itemHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SizedBox(
          width: totalWidth,
          child: Row(
            children: [
              ...subCategories.asMap().entries.map((entry) {
                final index = entry.key;
                final subCategory = entry.value;
                final card = Padding(
                  padding: EdgeInsets.only(
                    right: spacing,
                  ),
                  child: SizedBox(
                    width: itemWidth,
                    height: itemHeight,
                    child: _buildSubCategoryCard(
                      subCategory,
                      isEditMode: isEditMode,
                      category: category,
                      index: index,
                    ),
                  ),
                );
                
                if (isEditMode) {
                  return LongPressDraggable<int>(
                    key: ValueKey(subCategory.subCategoryId),
                    data: index,
                    feedback: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(12),
                      child: Opacity(
                        opacity: 0.8,
                        child: card,
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: card,
                    ),
                    child: DragTarget<int>(
                      onAccept: (draggedIndex) {
                        if (draggedIndex != index) {
                          _handleReorder(category.categoryId, draggedIndex, index);
                        }
                      },
                      builder: (context, candidateData, rejectedData) {
                        return card;
                      },
                    ),
                  );
                }
                return card;
              }),
              if (shouldShowAddButton)
                SizedBox(
                  width: itemWidth,
                  height: itemHeight,
                  child: AddSubcategoryButton(
                    onTap: () => _navigateToAddSubcategory(category),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategoryCard(
    SubCategoryModel subCategory, {
    bool isEditMode = false,
    CategoryModel? category,
    int? index,
  }) {
    final imageUrl = subCategory.imageUrl.isNotEmpty
        ? subCategory.imageUrl.first
        : null;

    return GestureDetector(
      onTap: () {
        if (isEditMode && category != null) {
          // Navigate to edit page when in edit mode
          final uri = Uri(
            path: AppRoutes.homeEditSubcategoryWithIds(
              category.sectionId,
              category.categoryId,
              subCategory.subCategoryId,
              subCategoryName: subCategory.name,
            ),
          );
          context.go(uri.toString());
        } else if (!isEditMode) {
          widget.onSubCategoryTap?.call(subCategory.subCategoryId, subCategory.name);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image Container with green background - ONLY contains the image
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[400],
                                size: 52,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.category,
                            color: Colors.green[700],
                            size: 52,
                          ),
                  ),
                ),
              ),
              // Pencil icon in edit mode - top right corner
              if (isEditMode)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          // Subcategory Name - Completely outside the green box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              subCategory.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCategoryListItem(CategoryModel category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.category,
            color: Colors.green[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (category.description != null && category.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      category.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (category.code != null && category.code.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Code: ${category.code}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<CategoryItem> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 8, top: 12, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryItemCard(categories[index]);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCategoryItemCard(CategoryItem category) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category.icon,
              color: Colors.green[700],
              size: 36,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  List<CategoryItem> _getGroceryCategories() {
    return [
      CategoryItem('Vegetables & Fruits', Icons.apple),
      CategoryItem('Atta, Rice & Dal', Icons.rice_bowl),
      CategoryItem('Oil, Ghee & Masala', Icons.local_dining),
      CategoryItem('Dairy, Bread & Eggs', Icons.egg),
      CategoryItem('Bakery & Biscuits', Icons.cake),
      CategoryItem('Dry Fruits & Cereals', Icons.grain),
      CategoryItem('Chicken, Meat & Fish', Icons.set_meal),
      CategoryItem('Kitchenware', Icons.kitchen),
    ];
  }

  List<CategoryItem> _getBeautyCategories() {
    return [
      CategoryItem('Bath & Body', Icons.shower),
      CategoryItem('Hair', Icons.content_cut),
      CategoryItem('Skin & Face', Icons.face),
      CategoryItem('Beauty & Cosmetics', Icons.brush),
      CategoryItem('Feminine Hygiene', Icons.local_pharmacy),
      CategoryItem('Baby Care', Icons.child_care),
      CategoryItem('Health & Pharma', Icons.medical_services),
      CategoryItem('Sexual Wellness', Icons.favorite),
    ];
  }

  List<CategoryItem> _getHouseholdCategories() {
    return [
      CategoryItem('Home & Lifestyle', Icons.home),
      CategoryItem('Cleaners', Icons.cleaning_services),
      CategoryItem('Electronics', Icons.electrical_services),
      CategoryItem('Stationery & Games', Icons.games),
    ];
  }
}

class CategoryItem {
  final String name;
  final IconData icon;

  CategoryItem(this.name, this.icon);
}

// Sticky Search Bar Delegate
class _StickySearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green[50]!,
            Colors.green[100]!,
          ],
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 12.0, bottom: 0.0),
      child: const SearchBarWidget(),
    );
  }

  @override
  double get maxExtent => 70.0; // 60 (search bar) + 12 (top)

  @override
  double get minExtent => 70.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

