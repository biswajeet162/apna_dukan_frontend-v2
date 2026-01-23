import 'package:flutter/material.dart';
import '../../../../catalog_layout/domain/models/catalog_section.dart';
import '../../../../catalog_layout/data/models/create_section_request.dart';
import '../../../../../di/service_locator.dart';

class AddLayoutModal extends StatefulWidget {
  final List<CatalogSection> existingLayouts;
  final Function() onSuccess;

  const AddLayoutModal({
    super.key,
    required this.existingLayouts,
    required this.onSuccess,
  });

  @override
  State<AddLayoutModal> createState() => _AddLayoutModalState();
}

class _AddLayoutModalState extends State<AddLayoutModal> {
  final _formKey = GlobalKey<FormState>();
  final _sectionCodeController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  LayoutType _selectedLayoutType = LayoutType.twoRow;
  ScrollType _selectedScrollType = ScrollType.horizontal;
  bool _enabled = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _sectionCodeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int _getNextDisplayOrder() {
    if (widget.existingLayouts.isEmpty) {
      return 1;
    }
    final maxOrder = widget.existingLayouts
        .map((layout) => layout.displayOrder)
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

      final createRequest = CreateSectionRequest(
        sectionCode: _sectionCodeController.text.trim().toUpperCase(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        layoutType: _selectedLayoutType,
        scrollType: _selectedScrollType,
        displayOrder: _getNextDisplayOrder(),
        enabled: _enabled,
        personalized: false,
      );

      await ServiceLocator().createCatalogSectionUseCase.call(createRequest.toJson());

      if (mounted) {
        widget.onSuccess();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Layout created successfully'),
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
            content: Text('Error creating layout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Padding(
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
                      const Text(
                        'Add New Layout',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Section Code
                  TextFormField(
                    controller: _sectionCodeController,
                    decoration: InputDecoration(
                      labelText: 'Section Code *',
                      hintText: 'e.g., PRODUCT_CATEGORY',
                      prefixIcon: const Icon(Icons.code),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      helperText: 'Will be converted to uppercase',
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Section code is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title *',
                      hintText: 'e.g., Category',
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
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

                  // Layout Type
                  DropdownButtonFormField<LayoutType>(
                    value: _selectedLayoutType,
                    decoration: InputDecoration(
                      labelText: 'Layout Type *',
                      prefixIcon: const Icon(Icons.view_module),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: LayoutType.values.map((type) {
                      return DropdownMenuItem<LayoutType>(
                        value: type,
                        child: Text(type.value.replaceAll('_', ' ')),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedLayoutType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Scroll Type
                  DropdownButtonFormField<ScrollType>(
                    value: _selectedScrollType,
                    decoration: InputDecoration(
                      labelText: 'Scroll Type *',
                      prefixIcon: const Icon(Icons.swap_horiz),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ScrollType.values.map((type) {
                      return DropdownMenuItem<ScrollType>(
                        value: type,
                        child: Text(type.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedScrollType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Display Order (Read-only, showing next value)
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
                                '${_getNextDisplayOrder()} (auto-calculated)',
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
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : _handleSave,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.add),
                        label: Text(_isSaving ? 'Creating...' : 'Create'),
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
    );
  }
}

