import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../di/service_locator.dart';
import '../../../../../../app/routes.dart';
import '../../../../catalog_layout/domain/models/catalog_section.dart';

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
    // If layout was updated, refresh the list
    if (result == true) {
      _loadLayouts(forceRefresh: true);
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
                            onPressed: () {
                              // TODO: Implement add new layout
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Add new layout coming soon...'),
                                ),
                              );
                            },
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
                          child: Row(
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
                                onPressed: () {
                                  // TODO: Implement add new layout
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Add new layout coming soon...'),
                                    ),
                                  );
                                },
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
                        ),
                        // Layout list
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => _loadLayouts(forceRefresh: true),
                            child: ListView.builder(
                              itemCount: _layouts.length,
                              itemBuilder: (context, index) {
                                final layout = _layouts[index];
                                return _buildLayoutItem(layout);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildLayoutItem(CatalogSection layout) {
    return InkWell(
      onTap: () => _onLayoutTap(layout),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
    );
  }
}


