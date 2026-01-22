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

  @override
  void initState() {
    super.initState();
    // When route is /product/:productId, ALWAYS make this API call:
    // Product Details API (/v1/product/{productId})
    _loadProductDetails();
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
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBack,
        ),
      ),
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
    );
  }

  Widget _buildProductDetails() {
    final product = _product!;
    final imageUrl = product.images.primary;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          if (imageUrl != null)
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: const Icon(
                Icons.image,
                size: 100,
                color: Colors.grey,
              ),
            ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Brand
                if (product.brand != null) ...[
                  Text(
                    product.brand!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                const SizedBox(height: 16),

                // Description
                if (product.description != null && product.description!.isNotEmpty) ...[
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Variants Section
                if (product.variants.isNotEmpty) ...[
                  Text(
                    'Variants',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.variants.map((variant) {
                      final isSelected = _selectedVariant?.variantId == variant.variantId;
                      return ChoiceChip(
                        label: Text(variant.label),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) _selectVariant(variant);
                        },
                        selectedColor: Colors.green[100],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.green[900] : Colors.grey[800],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  // Show selected variant pricing
                  if (_selectedVariant != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price: ₹${_selectedVariant!.pricing.sellingPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_selectedVariant!.pricing.mrp != _selectedVariant!.pricing.sellingPrice)
                            Text(
                              'MRP: ₹${_selectedVariant!.pricing.mrp.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[600],
                              ),
                            ),
                          if (_selectedVariant!.pricing.discountPercent > 0)
                            Text(
                              '${_selectedVariant!.pricing.discountPercent}% OFF',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (!_selectedVariant!.availability.inStock)
                            Text(
                              'Out of Stock',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],

                // Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _selectedVariant != null ? _addToCart : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
