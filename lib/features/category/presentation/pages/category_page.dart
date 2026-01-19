// Category Page
import 'package:flutter/material.dart';
import '../controllers/category_controller.dart';
import '../widgets/category_tile.dart';

class CategoryPage extends StatefulWidget {
  final String sectionId;

  const CategoryPage({
    super.key,
    required this.sectionId,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late final CategoryController _controller;

  @override
  void initState() {
    super.initState();
    // TODO: Get repository from DI
    // _controller = CategoryController(repository);
    // _controller.loadCategoriesForSection(widget.sectionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.errorMessage != null
              ? Center(child: Text('Error: ${_controller.errorMessage}'))
              : _controller.categorySectionResponse == null
                  ? const Center(child: Text('No categories found'))
                  : ListView.builder(
                      itemCount: _controller.categorySectionResponse!.categories.length,
                      itemBuilder: (context, index) {
                        final category = _controller.categorySectionResponse!.categories[index];
                        return CategoryTile(category: category);
                      },
                    ),
    );
  }
}


