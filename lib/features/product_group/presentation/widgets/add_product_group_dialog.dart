import 'package:flutter/material.dart';
import '../../../../di/service_locator.dart';
import '../../data/models/create_product_group_request.dart';
import '../../data/models/product_group_model.dart';

/// Simplified dialog for quickly adding a new product group
class AddProductGroupDialog extends StatefulWidget {
  final String subCategoryId;
  final String subCategoryName;
  final List<ProductGroupModel> existingProductGroups;
  final VoidCallback? onSuccess;

  const AddProductGroupDialog({
    super.key,
    required this.subCategoryId,
    required this.subCategoryName,
    required this.existingProductGroups,
    this.onSuccess,
  });

  @override
  State<AddProductGroupDialog> createState() => _AddProductGroupDialogState();
}

class _AddProductGroupDialogState extends State<AddProductGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateCodeFromName);
  }

  void _updateCodeFromName() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      final code = name.toUpperCase().replaceAll(' ', '_').replaceAll(RegExp(r'[^A-Z0-9_]'), '');
      _codeController.text = code;
    }
  }

  int _getNextDisplayOrder() {
    if (widget.existingProductGroups.isEmpty) {
      return 1;
    }
    final maxOrder = widget.existingProductGroups
        .map((group) => group.displayOrder)
        .reduce((a, b) => a > b ? a : b);
    return maxOrder + 1;
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isCreating = true;
      });

      final createRequest = CreateProductGroupRequest(
        subCategoryId: widget.subCategoryId,
        name: _nameController.text.trim(),
        description: null,
        code: _codeController.text.trim().toUpperCase(),
        displayOrder: _getNextDisplayOrder(),
        enabled: true,
        imageUrl: const [],
      );

      await ServiceLocator().createProductGroupUseCase.call(createRequest.toJson());

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product group created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSuccess?.call();
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

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add New Product Group',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Subcategory: ${widget.subCategoryName}',
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
                    onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Name field
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
              // Code field
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
              const SizedBox(height: 24),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
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

