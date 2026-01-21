// Category Tile Widget
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/category_model.dart';
import '../../../../app/routes.dart';

class CategoryTile extends StatelessWidget {
  final CategoryModel category;

  const CategoryTile({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category.name),
      subtitle: category.description != null ? Text(category.description!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.push(AppRoutes.categoryWithId(category.categoryId));
      },
    );
  }
}



