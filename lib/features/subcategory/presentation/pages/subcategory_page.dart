// SubCategory Page
import 'package:flutter/material.dart';
import '../controllers/subcategory_controller.dart';
import '../widgets/subcategory_tile.dart';

class SubCategoryPage extends StatefulWidget {
  final String categoryId;

  const SubCategoryPage({
    super.key,
    required this.categoryId,
  });

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  late final SubCategoryController _controller;

  @override
  void initState() {
    super.initState();
    // TODO: Get repository from DI
    // _controller = SubCategoryController(repository);
    // _controller.loadSubCategoriesForCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_controller.subCategoryResponse?.categoryName ?? 'Subcategories'),
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.errorMessage != null
              ? Center(child: Text('Error: ${_controller.errorMessage}'))
              : _controller.subCategoryResponse == null
                  ? const Center(child: Text('No subcategories found'))
                  : ListView.builder(
                      itemCount: _controller.subCategoryResponse!.subCategories.length,
                      itemBuilder: (context, index) {
                        final subcategory = _controller.subCategoryResponse!.subCategories[index];
                        return SubCategoryTile(subcategory: subcategory);
                      },
                    ),
    );
  }
}


