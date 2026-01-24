import 'package:flutter/material.dart';
import '../../../../category/data/models/category_admin_model.dart';
import '../../../../subcategory/data/models/subcategory_admin_model.dart';
import '../../../../subcategory/data/models/create_subcategory_request.dart';
import '../../../../subcategory/data/models/update_subcategory_request.dart';
import '../../../../../di/service_locator.dart';

class SubcategoryEditModal extends StatefulWidget {
  final CategoryAdminModel category;
  final List<SubCategoryAdminModel> existingSubcategories;
  final SubCategoryAdminModel? subcategory; // null for create, non-null for edit

  const SubcategoryEditModal({
    super.key,
    required this.category,
    required this.existingSubcategories,
    this.subcategory,
  });

  @override
  State<SubcategoryEditModal> createState() => _SubcategoryEditModalState();
}

class _SubcategoryEditModalState extends State<SubcategoryEditModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _codeController = TextEditingController();
  final List<TextEditingController> _imageUrlControllers = [];
  
  bool _enabled = true;
  bool _isSaving = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    if (widget.subcategory != null) {
      // Edit mode - populate fields
      _nameController.text = widget.subcategory!.name;
      _descriptionController.text = widget.subcategory!.description ?? '';
      _codeController.text = widget.subcategory!.code;
      _enabled = widget.subcategory!.enabled;
      _imageUrlControllers.addAll(
        widget.subcategory!.imageUrl.map((url) => TextEditingController(text: url)),
      );
    } else {
      // Create mode - generate code from name
      _nameController.addListener(_updateCodeFromName);
    }
    if (_imageUrlControllers.isEmpty) {
      _imageUrlControllers.add(TextEditingController());
    }
  }

  void _updateCodeFromName() {
    if (widget.subcategory == null) {
      // Only auto-generate code in create mode
      final name = _nameController.text.trim();
      if (name.isNotEmpty) {
        final code = name.toUpperCase().replaceAll(' ', '_').replaceAll(RegExp(r'[^A-Z0-9_]'), '');
        _codeController.text = code;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    for (var controller in _imageUrlControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  int _getNextDisplayOrder() {
    if (widget.existingSubcategories.isEmpty) {
      return 1;
    }
    final maxOrder = widget.existingSubcategories
        .map((sub) => sub.displayOrder)
        .reduce((a, b) => a > b ? a : b);
    return maxOrder + 1;
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

      if (widget.subcategory != null) {
        // Update mode
        final updateRequest = UpdateSubCategoryRequest(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          code: _codeController.text.trim().toUpperCase(),
          enabled: _enabled,
          imageUrl: imageUrls,
        );

        await ServiceLocator().updateSubCategoryUseCase.call(
          widget.subcategory!.subCategoryId,
          updateRequest.toJson(),
        );
      } else {
        // Create mode
        final createRequest = CreateSubCategoryRequest(
          categoryId: widget.category.categoryId,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          code: _codeController.text.trim().toUpperCase(),
          displayOrder: _getNextDisplayOrder(),
          enabled: _enabled,
          imageUrl: imageUrls,
        );

        await ServiceLocator().createSubCategoryUseCase.call(createRequest.toJson());
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.subcategory != null
                ? 'Subcategory updated successfully'
                : 'Subcategory created successfully'),
            backgroundColor: Colors.green,
          ),
        );
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
    if (widget.subcategory == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subcategory'),
        content: Text('Are you sure you want to delete "${widget.subcategory!.name}"?'),
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

      await ServiceLocator().deleteSubCategoryUseCase.call(widget.subcategory!.subCategoryId);

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate deletion
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subcategory deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting subcategory: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
  Widget build(BuildContext context) {
    final isEditMode = widget.subcategory != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditMode ? 'Edit Subcategory' : 'Add New Subcategory',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Category: ${widget.category.name}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: (_isSaving || _isDeleting) ? null : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Form
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SubCategory ID (read-only, edit mode only)
                        if (isEditMode)
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
                                        'SubCategory ID',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.subcategory!.subCategoryId,
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
                        if (isEditMode) const SizedBox(height: 16),

                        // Category ID (read-only, edit mode only)
                        if (isEditMode)
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
                                        'Category ID',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.subcategory!.categoryId,
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
                        if (isEditMode) const SizedBox(height: 16),

                        // Name
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name *',
                            hintText: 'e.g., Fruits & Vegetables',
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

                        // Code
                        TextFormField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            labelText: 'Code *',
                            hintText: 'e.g., FRUITS_VEGETABLES',
                            prefixIcon: const Icon(Icons.code),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            helperText: isEditMode ? null : 'Auto-generated from name',
                          ),
                          textCapitalization: TextCapitalization.characters,
                          enabled: !isEditMode, // Disable in edit mode
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Code is required';
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
                                      isEditMode
                                          ? '${widget.subcategory!.displayOrder}'
                                          : '${_getNextDisplayOrder()} (auto-calculated)',
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
                            if (isEditMode)
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
                            if (isEditMode) const SizedBox(width: 12),
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
                                  : Icon(isEditMode ? Icons.save : Icons.add),
                              label: Text(_isSaving
                                  ? (isEditMode ? 'Saving...' : 'Creating...')
                                  : (isEditMode ? 'Save' : 'Create')),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

