import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../di/service_locator.dart';
import '../../../../../../app/routes.dart';
import '../../../../catalog_layout/domain/models/catalog_section.dart';
import '../../../../category/data/models/category_admin_model.dart';
import '../../../../category/data/models/category_section_admin_response.dart';
import '../../../../subcategory/data/models/subcategory_admin_model.dart';
import '../../../../subcategory/data/models/subcategory_admin_response.dart';

class SubcategoryTab extends StatefulWidget {
  const SubcategoryTab({super.key});

  @override
  State<SubcategoryTab> createState() => _SubcategoryTabState();
}

class _SubcategoryTabState extends State<SubcategoryTab> with AutomaticKeepAliveClientMixin {
  List<CatalogSection> _sections = [];
  Map<String, List<CategoryAdminModel>> _categoriesBySection = {};
  Map<String, List<SubCategoryAdminModel>> _subcategoriesByCategory = {};
  Map<String, bool> _sectionLoadingStates = {};
  Map<String, bool> _categoryLoadingStates = {};
  Map<String, String?> _sectionErrors = {};
  Map<String, String?> _categoryErrors = {};
  Set<String> _expandedSections = {}; // Track which sections are expanded
  Map<String, Set<String>> _expandedCategories = {}; // Track which categories are expanded per section
  bool _isLoadingSections = true;
  String? _errorMessage;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadSections();
  }

  Future<void> _loadSections() async {
    try {
      setState(() {
        _isLoadingSections = true;
        _errorMessage = null;
      });

      // Get all layout sections
      final allSections = await ServiceLocator().getAllCatalogLayoutsUseCase.call();
      
      // Filter sections with PRODUCT_CATEGORY sectionCode
      final productCategorySections = allSections
          .where((section) => section.sectionCode == 'PRODUCT_CATEGORY')
          .toList();

      // Sort by displayOrder
      productCategorySections.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

      setState(() {
        _sections = productCategorySections;
        _isLoadingSections = false;
      });

      // Load first section by default
      if (productCategorySections.isNotEmpty) {
        _loadCategoriesForSection(productCategorySections.first.sectionId, expand: true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingSections = false;
      });
    }
  }

  Future<void> _loadCategoriesForSection(String sectionId, {bool expand = false}) async {
    // If already loaded, just expand it
    if (_categoriesBySection.containsKey(sectionId)) {
      if (expand) {
        setState(() {
          _expandedSections.add(sectionId);
        });
      }
      return;
    }

    // If already loading, don't call again
    if (_sectionLoadingStates[sectionId] == true) {
      return;
    }

    try {
      setState(() {
        _sectionLoadingStates[sectionId] = true;
        _sectionErrors[sectionId] = null;
        if (expand) {
          _expandedSections.add(sectionId);
        }
      });

      final response = await ServiceLocator().getCategoriesForAdminUseCase.call(sectionId);

      setState(() {
        _categoriesBySection[sectionId] = response.categories;
        _sectionLoadingStates[sectionId] = false;
        // Initialize expanded categories set for this section
        _expandedCategories[sectionId] = {};
      });
    } catch (e) {
      setState(() {
        _sectionErrors[sectionId] = e.toString();
        _sectionLoadingStates[sectionId] = false;
        _categoriesBySection[sectionId] = [];
      });
    }
  }

  Future<void> _loadSubcategoriesForCategory(String categoryId, String sectionId, {bool expand = false}) async {
    // If already loaded, just expand it
    if (_subcategoriesByCategory.containsKey(categoryId)) {
      if (expand) {
        setState(() {
          _expandedCategories[sectionId]?.add(categoryId);
        });
      }
      return;
    }

    // If already loading, don't call again
    if (_categoryLoadingStates[categoryId] == true) {
      return;
    }

    try {
      setState(() {
        _categoryLoadingStates[categoryId] = true;
        _categoryErrors[categoryId] = null;
        if (expand) {
          _expandedCategories[sectionId]?.add(categoryId);
        }
      });

      final response = await ServiceLocator().getSubCategoriesForAdminUseCase.call(categoryId);

      setState(() {
        _subcategoriesByCategory[categoryId] = response.subCategories;
        _categoryLoadingStates[categoryId] = false;
      });
    } catch (e) {
      setState(() {
        _categoryErrors[categoryId] = e.toString();
        _categoryLoadingStates[categoryId] = false;
        _subcategoriesByCategory[categoryId] = [];
      });
    }
  }

  void _onSectionExpansionChanged(String sectionId, bool isExpanded) {
    if (isExpanded) {
      _loadCategoriesForSection(sectionId, expand: true);
    } else {
      setState(() {
        _expandedSections.remove(sectionId);
        // Collapse all categories in this section
        _expandedCategories[sectionId]?.clear();
      });
    }
  }

  void _onCategoryExpansionChanged(String categoryId, String sectionId, bool isExpanded) {
    if (isExpanded) {
      _loadSubcategoriesForCategory(categoryId, sectionId, expand: true);
    } else {
      setState(() {
        _expandedCategories[sectionId]?.remove(categoryId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _isLoadingSections
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null && _sections.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[700],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading sections',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadSections,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : _sections.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.subdirectory_arrow_right_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No category sections found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create a layout section with PRODUCT_CATEGORY code first',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
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
                              Text(
                                'Subcategories by Section (${_sections.length} sections)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Dropdown sections
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _loadSections,
                            child: ListView.builder(
                              itemCount: _sections.length,
                              itemBuilder: (context, index) {
                                final section = _sections[index];
                                final isExpanded = _expandedSections.contains(section.sectionId);
                                return _buildSectionDropdown(section, isExpanded);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildSectionDropdown(CatalogSection section, bool isExpanded) {
    final categories = _categoriesBySection[section.sectionId] ?? [];
    final isLoading = _sectionLoadingStates[section.sectionId] == true;
    final error = _sectionErrors[section.sectionId];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(section.sectionId),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) => _onSectionExpansionChanged(section.sectionId, expanded),
          leading: Icon(
            Icons.view_module,
            color: Colors.green[700],
          ),
          title: Text(
            section.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          subtitle: Text(
            isLoading
                ? 'Loading...'
                : error != null
                    ? 'Error loading categories'
                    : '${categories.length} categories',
            style: TextStyle(
              fontSize: 12,
              color: isLoading ? Colors.blue[600] : error != null ? Colors.red[600] : Colors.grey[600],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isExpanded && isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey[600],
              ),
            ],
          ),
          children: [
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (error != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red[600],
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error loading categories',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      error,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _loadCategoriesForSection(section.sectionId, expand: true),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            else if (categories.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No categories in this section',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...categories.map((category) => _buildCategoryDropdown(category, section.sectionId)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(CategoryAdminModel category, String sectionId) {
    final subcategories = _subcategoriesByCategory[category.categoryId] ?? [];
    final isLoading = _categoryLoadingStates[category.categoryId] == true;
    final error = _categoryErrors[category.categoryId];
    final isExpanded = _expandedCategories[sectionId]?.contains(category.categoryId) ?? false;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(category.categoryId),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) => _onCategoryExpansionChanged(category.categoryId, sectionId, expanded),
          leading: Icon(
            Icons.category,
            color: Colors.blue[700],
            size: 20,
          ),
          title: Text(
            category.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          subtitle: Text(
            isLoading
                ? 'Loading...'
                : error != null
                    ? 'Error loading subcategories'
                    : '${subcategories.length} subcategories',
            style: TextStyle(
              fontSize: 11,
              color: isLoading ? Colors.blue[600] : error != null ? Colors.red[600] : Colors.grey[600],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isExpanded && isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey[600],
                size: 18,
              ),
            ],
          ),
          children: [
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red[600],
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error loading subcategories',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      error,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _loadSubcategoriesForCategory(category.categoryId, sectionId, expand: true),
                      icon: const Icon(Icons.refresh, size: 14),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                    ),
                  ],
                ),
              )
            else if (subcategories.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.subdirectory_arrow_right_outlined,
                        size: 32,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No subcategories',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...subcategories.map((subcategory) => _buildSubcategoryItem(subcategory)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryItem(SubCategoryAdminModel subcategory) {
    return Container(
      key: ValueKey(subcategory.subCategoryId),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Navigate to subcategory edit page when implemented
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Subcategory: ${subcategory.name}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                // Order number
                Container(
                  width: 28,
                  alignment: Alignment.center,
                  child: Text(
                    '${subcategory.displayOrder}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Subcategory name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subcategory.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                      if (subcategory.code.isNotEmpty)
                        Text(
                          subcategory.code,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                // Enabled indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: subcategory.enabled ? Colors.green[100] : Colors.red[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    subcategory.enabled ? 'Enabled' : 'Disabled',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: subcategory.enabled ? Colors.green[700] : Colors.red[700],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
