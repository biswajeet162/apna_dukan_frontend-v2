import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';
import '../../../../di/service_locator.dart';
import '../../data/models/product_group_admin_model.dart';
import '../../data/models/update_product_group_request.dart';

class EditProductGroupPage extends StatefulWidget {
  final String sectionId;
  final String categoryId;
  final String subCategoryId;
  final String productGroupId;
  final String? productGroupName;

  const EditProductGroupPage({
    super.key,
    required this.sectionId,
    required this.categoryId,
    required this.subCategoryId,
    required this.productGroupId,
    this.productGroupName,
  });

  @override
  State<EditProductGroupPage> createState() => _EditProductGroupPageState();
}

class _EditProductGroupPageState extends State<EditProductGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _codeController = TextEditingController();
  final _displayOrderController = TextEditingController();
  final List<TextEditingController> _imageUrlControllers = [];

  ProductGroupAdminModel? _productGroup;
  bool _enabled = true;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isDeleting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProductGroup();
  }

  Future<void> _loadProductGroup() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final productGroup =
          await ServiceLocator().getProductGroupByIdUseCase.call(widget.productGroupId);

      setState(() {
        _productGroup = productGroup;
        _nameController.text = productGroup.name;
        _descriptionController.text = productGroup.description ?? '';
        _codeController.text = productGroup.code;
        _displayOrderController.text = productGroup.displayOrder.toString();
        _enabled = productGroup.enabled;
        _imageUrlControllers.clear();
        _imageUrlControllers.addAll(
          productGroup.imageUrl.map((url) => TextEditingController(text: url)),
        );
        if (_imageUrlControllers.isEmpty) {
          _imageUrlControllers.add(TextEditingController());
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isSaving = true;
      });

      final imageUrls = _imageUrlControllers
          .map((c) => c.text.trim())
          .where((url) => url.isNotEmpty)
          .toList();

      final updateRequest = UpdateProductGroupRequest(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        code: _codeController.text.trim().toUpperCase(),
        displayOrder: int.tryParse(_displayOrderController.text.trim()),
        enabled: _enabled,
        imageUrl: imageUrls,
      );

      await ServiceLocator().updateProductGroupUseCase.call(
            widget.productGroupId,
            updateRequest.toJson(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product group updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _closeAfterAction(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
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

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product Group'),
        content: Text('Are you sure you want to delete "${_nameController.text}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      setState(() {
        _isDeleting = true;
      });

      await ServiceLocator().deleteProductGroupUseCase.call(widget.productGroupId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product group deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _closeAfterAction(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting product group: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _closeAfterAction(bool success) {
    if (context.canPop()) {
      context.pop(success);
    } else {
      context.go('${AppRoutes.categories}?subCategoryId=${widget.subCategoryId}');
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

  void _handleBackNavigation() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('${AppRoutes.categories}?subCategoryId=${widget.subCategoryId}');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    _displayOrderController.dispose();
    for (var controller in _imageUrlControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productGroupName ?? 'Edit Product Group'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (_isSaving || _isDeleting) ? null : _handleBackNavigation,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error loading product group',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProductGroup,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section ID (read-only)
                        _buildReadOnlyField('Section ID', widget.sectionId, Icons.category),
                        const SizedBox(height: 16),

                        // Category ID (read-only)
                        _buildReadOnlyField('Category ID', widget.categoryId, Icons.category),
                        const SizedBox(height: 16),

                        // SubCategory ID (read-only)
                        _buildReadOnlyField('SubCategory ID', widget.subCategoryId, Icons.info_outline),
                        const SizedBox(height: 16),

                        // Product Group ID (read-only)
                        _buildReadOnlyField('Product Group ID', widget.productGroupId, Icons.info_outline),
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

                        // Display Order
                        TextFormField(
                          controller: _displayOrderController,
                          decoration: InputDecoration(
                            labelText: 'Display Order *',
                            hintText: 'e.g., 1',
                            prefixIcon: const Icon(Icons.sort),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Display order is required';
                            }
                            if (int.tryParse(value.trim()) == null) {
                              return 'Display order must be a number';
                            }
                            return null;
                          },
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
                            ElevatedButton.icon(
                              onPressed: (_isSaving || _isDeleting) ? null : _handleDelete,
                              icon: _isDeleting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.delete),
                              label: Text(_isDeleting ? 'Deleting...' : 'Delete'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: (_isSaving || _isDeleting) ? null : _handleSave,
                              icon: _isSaving
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.save),
                              label: Text(_isSaving ? 'Saving...' : 'Save'),
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

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
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
    );
  }
}

