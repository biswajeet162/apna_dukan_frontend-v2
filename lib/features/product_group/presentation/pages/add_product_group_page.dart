import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/routes.dart';
import '../../../../di/service_locator.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/models/create_product_group_request.dart';
import '../../data/models/product_group_model.dart';

class AddProductGroupPage extends StatefulWidget {
  final String subCategoryId;
  final String? subCategoryName;

  const AddProductGroupPage({
    super.key,
    required this.subCategoryId,
    this.subCategoryName,
  });

  @override
  State<AddProductGroupPage> createState() => _AddProductGroupPageState();
}

class _AddProductGroupPageState extends State<AddProductGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _codeController = TextEditingController();
  final List<TextEditingController> _imageUrlControllers = [];

  bool _enabled = true;
  bool _isCreating = false;
  bool _isLoadingProductGroups = true;
  List<ProductGroupModel> _existingProductGroups = [];
  String? _generatedProductGroupId;
  String? _resolvedSubCategoryName;
  int _displayOrder = 1;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _generatedProductGroupId = const Uuid().v4();
    _resolvedSubCategoryName = widget.subCategoryName;
    _authService = AuthService(ServiceLocator().secureStorage);
    _nameController.addListener(_updateCodeFromName);
    _loadExistingProductGroups();
    _imageUrlControllers.add(TextEditingController());
  }

  Future<void> _loadExistingProductGroups() async {
    try {
      setState(() {
        _isLoadingProductGroups = true;
      });

      final isAdmin = await _authService.isAdmin();
      final response = await ServiceLocator()
          .getProductGroupsUseCase(widget.subCategoryId, isAdmin: isAdmin);
      setState(() {
        _existingProductGroups = response.productGroups;
        _resolvedSubCategoryName = _resolvedSubCategoryName ?? response.subCategoryName;
        _displayOrder = _getNextDisplayOrder();
        _isLoadingProductGroups = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingProductGroups = false;
        _displayOrder = 1;
      });
    }
  }

  void _updateCodeFromName() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      final code = name.toUpperCase().replaceAll(' ', '_').replaceAll(RegExp(r'[^A-Z0-9_]'), '');
      _codeController.text = code;
    }
  }

  int _getNextDisplayOrder() {
    return _existingProductGroups.length + 1;
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isCreating = true;
      });

      final imageUrls = _imageUrlControllers
          .map((c) => c.text.trim())
          .where((url) => url.isNotEmpty)
          .toList();

      final createRequest = CreateProductGroupRequest(
        subCategoryId: widget.subCategoryId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        code: _codeController.text.trim().toUpperCase(),
        displayOrder: _displayOrder,
        enabled: _enabled,
        imageUrl: imageUrls,
      );

      await ServiceLocator().createProductGroupUseCase.call(createRequest.toJson());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product group created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _closeAfterCreate();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _closeAfterCreate() {
    if (context.canPop()) {
      context.pop(true);
    } else {
      final name = _resolvedSubCategoryName;
      final nameParam = name != null ? '&subCategoryName=${Uri.encodeComponent(name)}' : '';
      context.go('${AppRoutes.categories}?subCategoryId=${widget.subCategoryId}$nameParam');
    }
  }

  void _handleBackNavigation() {
    if (context.canPop()) {
      context.pop();
    } else {
      final name = _resolvedSubCategoryName;
      final nameParam = name != null ? '&subCategoryName=${Uri.encodeComponent(name)}' : '';
      context.go('${AppRoutes.categories}?subCategoryId=${widget.subCategoryId}$nameParam');
    }
  }

  void _addImageUrlField() {
    setState(() {
      _imageUrlControllers.add(TextEditingController());
    });
  }

  void _removeImageUrlField(int index) {
    setState(() {
      _imageUrlControllers[index].dispose();
      _imageUrlControllers.removeAt(index);
      if (_imageUrlControllers.isEmpty) {
        _imageUrlControllers.add(TextEditingController());
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    for (final controller in _imageUrlControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product Group'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isCreating ? null : _handleBackNavigation,
        ),
      ),
      body: _isLoadingProductGroups
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Group ID (read-only, generated)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Product Group ID',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _generatedProductGroupId ?? 'Generating...',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // SubCategory ID (read-only)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.category, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'SubCategory ID',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.subCategoryId,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (_resolvedSubCategoryName != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Subcategory: $_resolvedSubCategoryName',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name *',
                        hintText: 'e.g., Fresh Vegetables',
                        prefixIcon: const Icon(Icons.label),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Optional description',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Code
                    TextFormField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Code *',
                        hintText: 'e.g., FRESH_VEGETABLES',
                        prefixIcon: const Icon(Icons.code),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        helperText: 'Auto-generated from name',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Code is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Display Order (read-only)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.sort, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Display Order',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$_displayOrder (auto-calculated: ${_existingProductGroups.length} existing + 1)',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Enabled Switch
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.toggle_on, color: Colors.grey),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Enabled',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Switch(
                            value: _enabled,
                            onChanged: (value) {
                              setState(() {
                                _enabled = value;
                              });
                            },
                            activeColor: Colors.green[700],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Image URLs
                    Text(
                      'Image URLs',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(_imageUrlControllers.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _imageUrlControllers[index],
                                decoration: InputDecoration(
                                  labelText: 'Image URL ${index + 1}',
                                  hintText: 'https://example.com/image.jpg',
                                  prefixIcon: const Icon(Icons.image),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            if (_imageUrlControllers.length > 1)
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () => _removeImageUrlField(index),
                              ),
                          ],
                        ),
                      );
                    }),
                    TextButton.icon(
                      onPressed: _addImageUrlField,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Image URL'),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _isCreating ? null : () => context.pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _isCreating ? null : _handleCreate,
                          icon: _isCreating
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.add),
                          label: Text(_isCreating ? 'Creating...' : 'Create'),
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
                  ],
                ),
              ),
            ),
    );
  }
}

