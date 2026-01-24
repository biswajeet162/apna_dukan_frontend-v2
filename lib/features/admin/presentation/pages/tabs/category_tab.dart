import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../di/service_locator.dart';
import '../../../../../../app/routes.dart';
import '../../../../catalog_layout/domain/models/catalog_section.dart';
import '../../../../category/data/models/category_admin_model.dart';
import '../../../../category/data/models/category_section_admin_response.dart';
import '../widgets/add_category_modal.dart';

class CategoryTab extends StatefulWidget {
  final String? initialCategoryId;

  const CategoryTab({
    super.key,
    this.initialCategoryId,
  });

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> with AutomaticKeepAliveClientMixin {
  List<CatalogSection> _sections = [];
  Map<String, List<CategoryAdminModel>> _categoriesBySection = {};
  Map<String, bool> _sectionLoadingStates = {};
  Map<String, String?> _sectionErrors = {};
  Set<String> _expandedSections = {}; // Track which sections are expanded
  bool _isLoadingSections = true;
  String? _errorMessage;
  bool _isReordering = false;
  String? _reorderingSectionId;

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

      // Load category from URL if provided
      if (widget.initialCategoryId != null && productCategorySections.isNotEmpty) {
        // Load all sections to find the one with the category
        _loadCategoryFromUrl(widget.initialCategoryId!, productCategorySections);
      } else if (productCategorySections.isNotEmpty) {
        // Load first section by default
        _loadCategoriesForSection(productCategorySections.first.sectionId, expand: true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingSections = false;
      });
    }
  }

  Future<void> _loadCategoryFromUrl(String categoryId, List<CatalogSection> sections) async {
    // Try to find the category in each section
    for (final section in sections) {
      await _loadCategoriesForSection(section.sectionId, expand: false);
      final categories = _categoriesBySection[section.sectionId] ?? [];
      if (categories.any((cat) => cat.categoryId == categoryId)) {
        setState(() {
          _expandedSections.add(section.sectionId);
        });
        return; // Found the category, stop searching
      }
    }
    // If not found, expand first section
    if (sections.isNotEmpty) {
      _loadCategoriesForSection(sections.first.sectionId, expand: true);
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
      });
    } catch (e) {
      setState(() {
        _sectionErrors[sectionId] = e.toString();
        _sectionLoadingStates[sectionId] = false;
        _categoriesBySection[sectionId] = []; // Set empty list on error
      });
    }
  }

  void _onSectionExpansionChanged(String sectionId, bool isExpanded) {
    if (isExpanded) {
      _loadCategoriesForSection(sectionId, expand: true);
    } else {
      setState(() {
        _expandedSections.remove(sectionId);
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
                            Icons.category_outlined,
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
                                'Categories by Section (${_sections.length} sections)',
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
              if (isExpanded && !isLoading && error == null)
                IconButton(
                  onPressed: () => _navigateToAddCategory(section),
                  icon: const Icon(Icons.add),
                  iconSize: 24,
                  color: Colors.green[700],
                  tooltip: 'Add Category',
                ),
              if (isExpanded && !isLoading && error == null)
                const SizedBox(width: 8), // Gap between plus and arrow
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
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  onReorder: (oldIndex, newIndex) => _handleReorder(section.sectionId, oldIndex, newIndex),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategoryItem(category, index, section.sectionId);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(CategoryAdminModel category, int index, String sectionId) {
    return Container(
      key: ValueKey(category.categoryId),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onCategoryTap(category),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                // Drag handle
                Icon(
                  Icons.drag_handle,
                  color: Colors.grey[400],
                  size: 20,
                ),
                const SizedBox(width: 12),
                // Order number
                Container(
                  width: 32,
                  alignment: Alignment.center,
                  child: Text(
                    '${category.displayOrder}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Category name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                      if (category.code.isNotEmpty)
                        Text(
                          category.code,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                // Enabled indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: category.enabled ? Colors.green[100] : Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category.enabled ? 'Enabled' : 'Disabled',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: category.enabled ? Colors.green[700] : Colors.red[700],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCategoryTap(CategoryAdminModel category) {
    // Update URL with categoryId and navigate to edit page
    context.go(AppRoutes.adminCategoryEditWithId(category.categoryId));
  }

  void _navigateToAddCategory(CatalogSection section) {
    // Get the first category in this section to use for the URL, or use the current categoryId from URL
    final categories = _categoriesBySection[section.sectionId] ?? [];
    String categoryId;
    
    if (widget.initialCategoryId != null && 
        categories.any((cat) => cat.categoryId == widget.initialCategoryId)) {
      categoryId = widget.initialCategoryId!;
    } else if (categories.isNotEmpty) {
      categoryId = categories.first.categoryId;
    } else {
      // If no categories exist, we still need a categoryId for the route
      // In this case, we'll need to create a temporary one or use the section's first category
      // For now, let's use the first category from any section, or navigate without categoryId
      // Actually, let's just use the first category from the first section
      if (_sections.isNotEmpty && _categoriesBySection[_sections.first.sectionId]?.isNotEmpty == true) {
        categoryId = _categoriesBySection[_sections.first.sectionId]!.first.categoryId;
      } else {
        // Fallback: navigate to category list and show modal
        _showAddCategoryModal(section);
        return;
      }
    }
    
    // Navigate to add category page
    context.go(AppRoutes.adminCategoryAddWithCategoryId(categoryId));
  }
  
  void _showAddCategoryModal(CatalogSection section) {
    final categories = _categoriesBySection[section.sectionId] ?? [];
    showDialog(
      context: context,
      builder: (context) => AddCategoryModal(
        section: section,
        existingCategories: categories,
        onSuccess: () async {
          await _loadCategoriesForSection(section.sectionId, expand: true);
        },
      ),
    );
  }

  Future<void> _handleReorder(String sectionId, int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    final categories = _categoriesBySection[sectionId] ?? [];
    if (categories.isEmpty) return;

    setState(() {
      _isReordering = true;
      _reorderingSectionId = sectionId;

      // Update local list order
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = categories.removeAt(oldIndex);
      categories.insert(newIndex, item);

      // Recalculate displayOrder
      for (int i = 0; i < categories.length; i++) {
        final cat = categories[i];
        categories[i] = CategoryAdminModel(
          categoryId: cat.categoryId,
          sectionId: cat.sectionId,
          name: cat.name,
          description: cat.description,
          code: cat.code,
          displayOrder: i + 1,
          enabled: cat.enabled,
          createdAt: cat.createdAt,
          updatedAt: cat.updatedAt,
        );
      }
    });

    // Call bulk update API
    await _bulkUpdateDisplayOrders(sectionId, categories);
  }

  Future<void> _bulkUpdateDisplayOrders(String sectionId, List<CategoryAdminModel> categories) async {
    try {
      // Create bulk update items - only send displayOrder updates
      final bulkUpdateItems = categories.map((cat) {
        return {
          'categoryId': cat.categoryId,
          'displayOrder': cat.displayOrder,
        };
      }).toList();

      await ServiceLocator().bulkUpdateCategoriesUseCase.call({
        'categories': bulkUpdateItems,
      });

      // Reload categories for this section
      await _loadCategoriesForSection(sectionId, expand: true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category order updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Reload categories for this section on error
      await _loadCategoriesForSection(sectionId, expand: true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating order: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isReordering = false;
          _reorderingSectionId = null;
        });
      }
    }
  }
}
