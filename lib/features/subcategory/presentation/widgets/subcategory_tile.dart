// SubCategory Tile Widget
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/subcategory_model.dart';

class SubCategoryTile extends StatelessWidget {
  final SubCategoryModel subcategory;

  const SubCategoryTile({
    super.key,
    required this.subcategory,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: subcategory.imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: subcategory.imageUrl.first,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
          : const Icon(Icons.category),
      title: Text(subcategory.name),
      subtitle: subcategory.description != null ? Text(subcategory.description!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Navigate to product group page
      },
    );
  }
}



