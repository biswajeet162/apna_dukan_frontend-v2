import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../di/service_locator.dart';
import '../../../../../../app/routes.dart';
import '../../../../catalog_layout/domain/models/catalog_section.dart';
import '../../../../catalog_layout/data/models/bulk_update_item.dart';
import '../../../../catalog_layout/data/models/bulk_update_request.dart';
import '../widgets/add_layout_modal.dart';

class LayoutTab extends StatefulWidget {
  const LayoutTab({super.key});

  @override
  State<LayoutTab> createState() => _LayoutTabState();
}

class _LayoutTabState extends State<LayoutTab> with AutomaticKeepAliveClientMixin {
  List<CatalogSection> _layouts = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _hasLoaded = false; // Track if data has been loaded
  bool _isLoadingInProgress = false; // Prevent concurrent API calls
  bool _isReordering = false; // Track if reordering is in progress

  @override
  bool get wantKeepAlive => true; // Keep the tab alive when switching

  @override
  void initState() {
    super.initState();
    // Only load if we haven't loaded before
    if (!_hasLoaded && !_isLoadingInProgress) {
      _loadLayouts();
    } else if (_hasLoaded && _layouts.isNotEmpty) {
      // If already loaded, set loading to false immediately
      _isLoading = false;
    }
  }

  Future<void> _loadLayouts({bool forceRefresh = false}) async {
    // Prevent duplicate calls - if already loaded and not forcing refresh, return
    if (!forceRefresh && _hasLoaded && _layouts.isNotEmpty) {
      return;
    }

    // Prevent concurrent calls
    if (_isLoadingInProgress) {
      return;
    }

    try {
      _isLoadingInProgress = true;
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final layouts = await ServiceLocator().getAllCatalogLayoutsUseCase.call();

      if (mounted) {
        setState(() {
          _layouts = layouts;
          _isLoading = false;
          _hasLoaded = true;
          _isLoadingInProgress = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
          _hasLoaded = false; // Allow retry on error
          _isLoadingInProgress = false;
        });
      }
    }
  }

  void _onLayoutTap(CatalogSection layout) async {
    final result = await context.push<bool>(AppRoutes.adminLayoutEditWithId(layout.sectionId));
    // If layout was updated or deleted, refresh the list
    if (result == true) {
      _loadLayouts(forceRefresh: true);
    }
  }

  void _showAddLayoutModal() {
    showDialog(
      context: context,
      builder: (context) => AddLayoutModal(
        existingLayouts: _layouts,
        onSuccess: () {
          _loadLayouts(forceRefresh: true);
        },
      ),
    );
  }

  Future<void> _handleReorder(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;

    setState(() {
      // Update local list order
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _layouts.removeAt(oldIndex);
      _layouts.insert(newIndex, item);

      // Recalculate displayOrder for all items
      for (int i = 0; i < _layouts.length; i++) {
        _layouts[i] = CatalogSection(
          sectionId: _layouts[i].sectionId,
          sectionCode: _layouts[i].sectionCode,
          title: _layouts[i].title,
          description: _layouts[i].description,
          layoutType: _layouts[i].layoutType,
          scrollType: _layouts[i].scrollType,
          displayOrder: i + 1, // Update display order (1-based)
          enabled: _layouts[i].enabled,
          personalized: _layouts[i].personalized,
          createdAt: _layouts[i].createdAt,
          updatedAt: _layouts[i].updatedAt,
        );
      }
    });

    // Call bulk update API
    await _bulkUpdateDisplayOrders();
  }

  Future<void> _bulkUpdateDisplayOrders() async {
    if (_isReordering) return;

    try {
      setState(() {
        _isReordering = true;
      });

      // Create bulk update items with new displayOrder
      final bulkUpdateItems = _layouts.map((layout) {
        return BulkUpdateItem(
          sectionId: layout.sectionId,
          displayOrder: layout.displayOrder,
        );
      }).toList();

      final bulkUpdateRequest = BulkUpdateRequest(sections: bulkUpdateItems);

      await ServiceLocator().bulkUpdateCatalogSectionsUseCase.call(
            bulkUpdateRequest.toJson(),
          );

      // Reload to get updated data from server
      await _loadLayouts(forceRefresh: true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Layout order updated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Reload original order on error
      await _loadLayouts(forceRefresh: true);
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
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
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
                        'Error loading layouts',
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
                        onPressed: _loadLayouts,
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
              : _layouts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.view_module_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No layouts found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => _showAddLayoutModal(),
                            icon: const Icon(Icons.add),
                            label: const Text('Add New Layout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Header with Add button
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Layouts (${_layouts.length})',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _showAddLayoutModal(),
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text('Add New'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[700],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Hold and drag to reorder layouts',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Layout list with drag-and-drop
                        Expanded(
                          child: Stack(
                            children: [
                              RefreshIndicator(
                                onRefresh: () => _loadLayouts(forceRefresh: true),
                                child: ReorderableListView.builder(
                                  itemCount: _layouts.length,
                                  onReorder: _handleReorder,
                                  itemBuilder: (context, index) {
                                    final layout = _layouts[index];
                                    return _buildLayoutItem(layout, index);
                                  },
                                ),
                              ),
                              if (_isReordering)
                                Container(
                                  color: Colors.black.withOpacity(0.3),
                                  child: const Center(
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text('Updating order...'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildLayoutItem(CatalogSection layout, int index) {
    return Container(
      key: ValueKey(layout.sectionId), // Required for ReorderableListView
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onLayoutTap(layout),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                // Drag handle icon
                Icon(
                  Icons.drag_handle,
                  color: Colors.grey[400],
                  size: 24,
                ),
                const SizedBox(width: 12),
                // Order number
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(
                    '${layout.displayOrder}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Title
                Expanded(
                  child: Text(
                    layout.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
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
}


