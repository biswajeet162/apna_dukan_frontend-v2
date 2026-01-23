import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';
import '../../../../di/service_locator.dart';
import '../../../catalog_layout/domain/models/catalog_section.dart';
import '../../../catalog_layout/data/models/update_section_request.dart';

class LayoutEditPage extends StatefulWidget {
  final String sectionId;

  const LayoutEditPage({
    super.key,
    required this.sectionId,
  });

  @override
  State<LayoutEditPage> createState() => _LayoutEditPageState();
}

class _LayoutEditPageState extends State<LayoutEditPage> {
  CatalogSection? _layout;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _displayOrderController = TextEditingController();
  LayoutType? _selectedLayoutType;
  ScrollType? _selectedScrollType;
  bool _enabled = true;
  bool _personalized = false;

  @override
  void initState() {
    super.initState();
    _loadLayout();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _displayOrderController.dispose();
    super.dispose();
  }

  Future<void> _loadLayout() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final layout = await ServiceLocator().getCatalogSectionByIdUseCase.call(widget.sectionId);

      setState(() {
        _layout = layout;
        _titleController.text = layout.title;
        _descriptionController.text = layout.description ?? '';
        _displayOrderController.text = layout.displayOrder.toString();
        _selectedLayoutType = layout.layoutType;
        _selectedScrollType = layout.scrollType;
        _enabled = layout.enabled;
        _personalized = layout.personalized;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _saveLayout() async {
    if (_layout == null) return;

    try {
      setState(() {
        _isSaving = true;
        _errorMessage = null;
      });

      final updateRequest = UpdateSectionRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        displayOrder: int.tryParse(_displayOrderController.text.trim()),
        layoutType: _selectedLayoutType,
        scrollType: _selectedScrollType,
        enabled: _enabled,
        personalized: _personalized,
      );

      await ServiceLocator().updateCatalogSectionUseCase.call(
            widget.sectionId,
            updateRequest.toJson(),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Layout updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(true); // Return true to indicate success
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating layout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Layout'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveLayout,
              tooltip: 'Save',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null && _layout == null
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
                        'Error loading layout',
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
                        onPressed: _loadLayout,
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
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Code (Read-only)
                      if (_layout != null) ...[
                        _buildReadOnlyField(
                          'Section Code',
                          _layout!.sectionCode,
                          Icons.code,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Title
                      _buildTextField(
                        controller: _titleController,
                        label: 'Title',
                        icon: Icons.title,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      // Description
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        icon: Icons.description,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Display Order
                      _buildTextField(
                        controller: _displayOrderController,
                        label: 'Display Order',
                        icon: Icons.sort,
                        keyboardType: TextInputType.number,
                        required: true,
                      ),
                      const SizedBox(height: 16),

                      // Layout Type
                      _buildDropdown<LayoutType>(
                        label: 'Layout Type',
                        icon: Icons.view_module,
                        value: _selectedLayoutType,
                        items: LayoutType.values,
                        onChanged: (value) {
                          setState(() {
                            _selectedLayoutType = value;
                          });
                        },
                        getLabel: (type) => type.value.replaceAll('_', ' '),
                      ),
                      const SizedBox(height: 16),

                      // Scroll Type
                      _buildDropdown<ScrollType>(
                        label: 'Scroll Type',
                        icon: Icons.swap_horiz,
                        value: _selectedScrollType,
                        items: ScrollType.values,
                        onChanged: (value) {
                          setState(() {
                            _selectedScrollType = value;
                          });
                        },
                        getLabel: (type) => type.value,
                      ),
                      const SizedBox(height: 16),

                      // Enabled Switch
                      _buildSwitch(
                        label: 'Enabled',
                        icon: Icons.toggle_on,
                        value: _enabled,
                        onChanged: (value) {
                          setState(() {
                            _enabled = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Personalized Switch
                      _buildSwitch(
                        label: 'Personalized',
                        icon: Icons.person,
                        value: _personalized,
                        onChanged: (value) {
                          setState(() {
                            _personalized = value;
                          });
                        },
                      ),
                      const SizedBox(height: 32),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : _saveLayout,
                          icon: const Icon(Icons.save),
                          label: const Text('Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            disabledBackgroundColor: Colors.grey[400],
                          ),
                        ),
                      ),
                    ],
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
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool required = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    required String Function(T) getLabel,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(getLabel(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSwitch({
    required String label,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green[700],
          ),
        ],
      ),
    );
  }
}

