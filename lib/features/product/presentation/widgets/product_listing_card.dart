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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ad label and ADD button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ad label (if applicable - can be added later)
                      const SizedBox.shrink(),
                      // ADD button on the right
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: product.availability.inStock
                                ? () {
                                    // TODO: Add to cart
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              minimumSize: const Size(0, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'ADD',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '2 options',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Weight/Variant with green circle
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.defaultVariant.label,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Rating Section
                  if (product.metrics?.rating != null)
                    _buildRatingWidget(product.metrics!.rating!),
                  const SizedBox(height: 8),
                  // Availability (Only X left)
                  if (product.availability.availableQuantity > 0 &&
                      product.availability.availableQuantity <= 5)
                    Text(
                      'Only ${product.availability.availableQuantity} left',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (product.availability.availableQuantity > 0 &&
                      product.availability.availableQuantity <= 5)
                    const SizedBox(height: 4),
                  // Discount badge
                  if (product.pricing.discountPercent > 0)
                    Text(
                      '${product.pricing.discountPercent}% OFF',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (product.pricing.discountPercent > 0)
                    const SizedBox(height: 4),
                  // Pricing Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${product.pricing.sellingPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'MRP ₹${product.pricing.mrp.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 12,
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
                size: 14,
                color: Colors.amber,
              );
            } else if (starValue - rating.average < 1 && starValue - rating.average > 0) {
              // Partially filled star (half star)
              return const Icon(
                Icons.star_half,
                size: 14,
                color: Colors.amber,
              );
            } else {
              // Empty star
              return const Icon(
                Icons.star_border,
                size: 14,
                color: Colors.amber,
              );
            }
          }),
        ),
        const SizedBox(width: 4),
        // Rating value and count in brackets (e.g., "4.5 (8,490)")
        Text(
          '${rating.average.toStringAsFixed(1)} ${formatCount(rating.count)}',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

