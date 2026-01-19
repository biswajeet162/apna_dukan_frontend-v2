import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../search/presentation/search_bar_widget.dart';
import '../../../core/widgets/app_navbar.dart';
import '../../../core/routes/app_routes.dart';
import '../../../di/service_locator.dart';
import '../../catalog_layout/domain/models/catalog_section.dart';
import '../../category/domain/models/category_section_response.dart';
import '../../category/domain/models/category.dart';
import '../../subcategory/domain/models/subcategory_response.dart';
import '../../subcategory/domain/models/subcategory.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const CategoriesPage(),
    const OrdersPage(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: AppNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<CatalogSection> _catalogSections = [];
  CategorySectionResponse? _categorySectionResponse;
  Map<String, SubCategoryResponse> _subCategoriesMap = {}; // categoryId -> SubCategoryResponse
  Map<String, bool> _loadingSubCategories = {}; // categoryId -> isLoading
  bool _isLoading = true;
  bool _isLoadingCategories = false;
  String? _errorMessage;
  String? _categoryErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadCatalogLayout();
  }

  Future<void> _loadCatalogLayout() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final sections = await ServiceLocator().getCatalogLayoutUseCase();
      
      setState(() {
        _catalogSections = sections;
        _isLoading = false;
      });

      // Find first PRODUCT_CATEGORY section and load its categories
      try {
        final productCategorySection = sections.firstWhere(
          (section) => section.sectionCode == 'PRODUCT_CATEGORY',
        );
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

      final categoryResponse = await ServiceLocator().getCategoriesUseCase(sectionId);
      
      setState(() {
        _categorySectionResponse = categoryResponse;
        _isLoadingCategories = false;
      });

      // Load subcategories for each category one by one
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

      final subCategoryResponse = await ServiceLocator().getSubCategoriesUseCase(categoryId);
      
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Section
            _buildTopHeader(),
            
            // Search Bar
            const SearchBarWidget(),
            
            // Catalog Sections from API
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null)
              Padding(
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
              )
            else if (_catalogSections.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('No catalog sections available'),
                ),
              )
            else
              ..._catalogSections.map((section) => _buildCatalogSection(section)).toList(),
            
            const SizedBox(height: 20),
          ],
        ),
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
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '64, Ring Road',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
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
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet,
                            size: 18, color: Colors.green[700]),
                        const SizedBox(width: 4),
                        Text(
                          '₹0',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.person, size: 28, color: Colors.grey[600]),
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
    final sortedCategories = List<Category>.from(_categorySectionResponse!.categories)
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sortedCategories.map((category) {
          return _buildCategoryWithSubcategories(category, productCategorySection);
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryWithSubcategories(Category category, CatalogSection? catalogSection) {
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
          // Category Title
          Text(
            category.name,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
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
            _buildSubCategoriesGrid(subCategoryResponse.subCategories, layoutType, scrollType)
          else if (subCategoryResponse != null && subCategoryResponse.subCategories.isEmpty)
            Padding(
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

  Widget _buildSubCategoriesGrid(
    List<SubCategory> subCategories,
    LayoutType layoutType,
    ScrollType scrollType,
  ) {
    // Sort by displayOrder
    final sortedSubCategories = List<SubCategory>.from(subCategories)
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    // Always show in 4-column grid, items flow left to right
    // After 4 items in first row, move to next row
    // No horizontal scrolling, all items visible
    const itemsPerRow = 4; // Always 4 columns
    const spacing = 12.0;

    // Show all items in a fixed 4-column grid that wraps naturally
    // Items flow: 1, 2, 3, 4 (row 1), then 5, 6, 7, 8 (row 2), etc.
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsPerRow,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 0.85,
      ),
      itemCount: sortedSubCategories.length,
      itemBuilder: (context, index) {
        return _buildSubCategoryCard(sortedSubCategories[index]);
      },
    );
  }

  Widget _buildSingleLineHorizontal(List<SubCategory> subCategories) {
    const spacing = 12.0;
    final screenWidth = MediaQuery.of(context).size.width;
    const padding = 32.0; // 16 on each side
    final itemWidth = ((screenWidth - padding - (3 * spacing)) / 4);
    final itemHeight = itemWidth / 0.85;
    final totalWidth = (subCategories.length * itemWidth) + 
                       ((subCategories.length - 1) * spacing) + 
                       padding;

    return SizedBox(
      height: itemHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: totalWidth,
          child: Row(
            children: subCategories.asMap().entries.map((entry) {
              final index = entry.key;
              final subCategory = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  right: index < subCategories.length - 1 ? spacing : 0,
                ),
                child: SizedBox(
                  width: itemWidth,
                  height: itemHeight,
                  child: _buildSubCategoryCard(subCategory),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategoryCard(SubCategory subCategory) {
    final imageUrl = subCategory.imageUrl.isNotEmpty
        ? subCategory.imageUrl.first
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image or Icon
          Container(
            width: 50,
            height: 50,
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
                        size: 28,
                      ),
                    ),
                  )
                : Icon(
                    Icons.category,
                    color: Colors.green[700],
                    size: 28,
                  ),
          ),
          const SizedBox(height: 8),
          // Subcategory Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              subCategory.name,
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


  Widget _buildCategoryListItem(Category category) {
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
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category.icon,
              color: Colors.green[700],
              size: 28,
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

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Categories Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Orders Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
