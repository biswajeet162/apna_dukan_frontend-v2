// Product Listing Card Widget - Shows product with pricing and availability
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/product_listing_item.dart';
import '../../../../app/routes.dart';

class ProductListingCard extends StatelessWidget {
  final ProductListingItem product;

  const ProductListingCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          context.push(AppRoutes.productDetailsWithId(product.productId));
        },
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Section
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: product.image.primary != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: product.image.primary!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 50,
                          ),
                  ),
                ),
                // Vegetarian indicator (top left) - green square with white circle
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                // Heart icon (top right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Add to favorites
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Weight/Variant with green circle
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          product.defaultVariant.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      height: 1.15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  // Rating Section
                  if (product.metrics?.rating != null)
                    _buildRatingWidget(product.metrics!.rating!),
                  const SizedBox(height: 4),
                  // Availability (Only X left)
                  if (product.availability.availableQuantity > 0 &&
                      product.availability.availableQuantity <= 5)
                    Text(
                      'Only ${product.availability.availableQuantity} left',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (product.availability.availableQuantity > 0 &&
                      product.availability.availableQuantity <= 5)
                    const SizedBox(height: 2),
                  // Discount badge (green, not blue)
                  if (product.pricing.discountPercent > 0)
                    Text(
                      '${product.pricing.discountPercent}% OFF',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (product.pricing.discountPercent > 0)
                    const SizedBox(height: 2),
                  // Pricing Section
                  Wrap(
                    spacing: 4,
                    runSpacing: 2,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '₹${product.pricing.sellingPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'MRP ₹${product.pricing.mrp.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 10,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingWidget(ProductRating rating) {
    // Format count: 8490 -> "(8,490)", 127000 -> "(1.27 lac)", 892 -> "(892)"
    String formatCount(int count) {
      if (count >= 100000) {
        // Format as "lac" (lakh) - Indian numbering system
        final lac = count / 100000;
        return '(${lac.toStringAsFixed(2)} lac)';
      } else {
        // Format with comma separator for readability
        final countStr = count.toString();
        final buffer = StringBuffer('(');
        for (int i = 0; i < countStr.length; i++) {
          if (i > 0 && (countStr.length - i) % 3 == 0) {
            buffer.write(',');
          }
          buffer.write(countStr[i]);
        }
        buffer.write(')');
        return buffer.toString();
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Star rating - show filled/half stars based on average rating
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            if (starValue <= rating.average.floor()) {
              // Fully filled star
              return const Icon(
                Icons.star,
                size: 12,
                color: Colors.amber,
              );
            } else if (starValue - rating.average < 1 && starValue - rating.average > 0) {
              // Partially filled star (half star)
              return const Icon(
                Icons.star_half,
                size: 12,
                color: Colors.amber,
              );
            } else {
              // Empty star
              return const Icon(
                Icons.star_border,
                size: 12,
                color: Colors.amber,
              );
            }
          }),
        ),
        const SizedBox(width: 3),
        // Rating value and count in brackets (e.g., "4.5 (8,490)")
        Flexible(
          child: Text(
            '${rating.average.toStringAsFixed(1)} ${formatCount(rating.count)}',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

