// Product Card Widget
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/product_list_model.dart';

class ProductCard extends StatelessWidget {
  final ProductListModel product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: product.primaryImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: product.primaryImageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : const Icon(Icons.image, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.brand != null)
                    Text(
                      product.brand!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  // TODO: Add price widget
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


