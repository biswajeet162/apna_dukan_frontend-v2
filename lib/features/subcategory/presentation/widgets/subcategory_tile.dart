// SubCategory Tile Widget
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/subcategory_model.dart';
import '../../../../app/routes.dart';

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
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 30,
              ),
            )
          : const Icon(Icons.category),
      title: Text(subcategory.name),
      subtitle: subcategory.description != null ? Text(subcategory.description!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        context.push(AppRoutes.subcategoryWithId(subcategory.subCategoryId));
      },
    );
  }
}



