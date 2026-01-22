// Product Details Page
// API CALL: Product Details API (/v1/product/{productId})
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../di/service_locator.dart';
import '../../data/models/product_details_model.dart';
import '../../data/models/variant_model.dart';
import '../../../../app/routes.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;
  final String? subCategoryId;
  final String? subCategoryName;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    this.subCategoryId,
    this.subCategoryName,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  ProductDetailsModel? _product;
  VariantDetailsModel? _selectedVariant;
  bool _isLoading = true;
  String? _errorMessage;
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    // When route is /product/:productId, ALWAYS make this API call:
    // Product Details API (/v1/product/{productId})
    _loadProductDetails();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadProductDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // API CALL: Product Details API (/v1/product/{productId})
      final product = await ServiceLocator().getProductDetailsUseCase(widget.productId);

      setState(() {
        _product = product;
        // Select first variant
        if (product.variants.isNotEmpty) {
          _selectedVariant = product.variants.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _selectVariant(VariantDetailsModel variant) {
    setState(() {
      _selectedVariant = variant;
    });
  }

  void _handleBack() {
    // Remove productId from URL and navigate back to categories page
    if (widget.subCategoryId != null) {
      final uri = Uri(
        path: AppRoutes.categories,
        queryParameters: {
          'subCategoryId': widget.subCategoryId!,
          if (widget.subCategoryName != null) 'subCategoryName': widget.subCategoryName!,
        },
      );
      context.go(uri.toString());
    } else {
      context.pop();
    }
  }

  void _addToCart() {
    if (_product == null || _selectedVariant == null) return;
    
    // TODO: Implement add to cart functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${_product!.name} to cart'),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $_errorMessage',
                        style: TextStyle(color: Colors.red[700]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProductDetails,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _product == null
                  ? const Center(child: Text('Product not found'))
                  : _buildProductDetails(),
      bottomNavigationBar: _product != null && _selectedVariant != null
          ? _buildBottomBar()
          : null,
    );
  }

  Widget _buildProductDetails() {
    final product = _product!;
    // Combine primary image with gallery images (primary first)
    final List<String> allImages = [];
    if (product.images.primary != null) {
      allImages.add(product.images.primary!);
    }
    allImages.addAll(product.images.gallery);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Banner with Overlay Icons and Swipe Support
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[200],
                child: allImages.isNotEmpty
                    ? PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemCount: allImages.length,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: allImages[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.image_not_supported,
                              size: 100,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : const Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.grey,
                      ),
              ),
              // Overlay Icons
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                          onPressed: _handleBack,
                        ),
                      ),
                      // Right side icons
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border, color: Colors.white, size: 24),
                              onPressed: () {
                                // TODO: Add to wishlist
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.search, color: Colors.white, size: 24),
                              onPressed: () {
                                // TODO: Search
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.share, color: Colors.white, size: 24),
                              onPressed: () {
                                // TODO: Share
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Image indicators (dots) at the bottom
              if (allImages.length > 1)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      allImages.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Product Info Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (product.metrics?.rating != null)
                      Row(
                        children: [
                          ...List.generate(5, (index) => Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber,
                          )),
                          const SizedBox(width: 4),
                          Text(
                            '(${_formatCount(product.metrics!.rating!.count)})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Product Name with Vegetarian indicator
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vegetarian indicator (green square with white circle)
                    Container(
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Select Unit Section
                const Text(
                  'Select Unit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Variant Options - Horizontally Scrollable
                if (product.variants.isNotEmpty)
                  SizedBox(
                    height: 65,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: product.variants.length,
                      itemBuilder: (context, index) {
                        final variant = product.variants[index];
                        final isSelected = _selectedVariant?.variantId == variant.variantId;
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < product.variants.length - 1 ? 12 : 0,
                          ),
                          child: _buildVariantCard(variant, isSelected),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 16),

                // View product details link
                GestureDetector(
                  onTap: () {
                    // TODO: Expand product details
                  },
                  child: Text(
                    'View product details ▲',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Service Guarantees
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildServiceGuarantee(Icons.refresh, '72 hours\nReplacement'),
                    _buildServiceGuarantee(Icons.headset_mic, '24/7\nSupport'),
                    _buildServiceGuarantee(Icons.delivery_dining, 'Fast\nDelivery'),
                  ],
                ),
                const SizedBox(height: 24),

                // Key Information (Collapsible)
                _buildCollapsibleSection('Key Information', Icons.keyboard_arrow_down, [
                  if (product.brand != null) 'Brand: ${product.brand}',
                  if (product.description != null) product.description!,
                ]),
                const SizedBox(height: 12),

                // Nutritional Information (Collapsible)
                _buildCollapsibleSection('Nutritional Information', Icons.keyboard_arrow_down, [
                  'Nutritional information will be displayed here',
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantCard(VariantDetailsModel variant, bool isSelected) {
    final hasDiscount = variant.pricing.discountPercent > 0;
    final backgroundColor = isSelected
        ? (hasDiscount ? Colors.blue[50] : Colors.green[50])
        : Colors.white;
    
    return Container(
      width: 140,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.green[700]! : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
      ),
      child: InkWell(
        onTap: () => _selectVariant(variant),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 6, right: 12, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // First line: Label and discount (green)
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: '${variant.label} '),
                    if (hasDiscount)
                      TextSpan(
                        text: '${variant.pricing.discountPercent}% off',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // Second line: Price (bold, larger) and MRP (strikethrough)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '₹${variant.pricing.sellingPrice.toStringAsFixed(0)} ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'MRP ₹${variant.pricing.mrp.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceGuarantee(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.green[700]),
        const SizedBox(height: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsibleSection(String title, IconData icon, List<String> content) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(icon, color: Colors.grey[700]),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    if (_selectedVariant == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Left side - Price info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        _selectedVariant!.label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₹${_selectedVariant!.pricing.sellingPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Inclusive of all taxes',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right side - Buttons
            Row(
              children: [
                // Cart button
                ElevatedButton.icon(
                  onPressed: _addToCart,
                  icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                  label: const Text('Add to cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Buy button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to checkout
                    _addToCart();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Buy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 100000) {
      final lac = count / 100000;
      return '${lac.toStringAsFixed(2)} lac';
    } else if (count >= 1000) {
      final thousands = count / 1000;
      return '${thousands.toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }
}
