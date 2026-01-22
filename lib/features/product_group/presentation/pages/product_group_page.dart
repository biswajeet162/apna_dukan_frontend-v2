// Product Group Page
import 'package:flutter/material.dart';
import '../controllers/product_group_controller.dart';
import '../widgets/product_group_card.dart';

class ProductGroupPage extends StatefulWidget {
  final String subCategoryId;

  const ProductGroupPage({
    super.key,
    required this.subCategoryId,
  });

  @override
  State<ProductGroupPage> createState() => _ProductGroupPageState();
}

class _ProductGroupPageState extends State<ProductGroupPage> {
  late final ProductGroupController _controller;

  @override
  void initState() {
    super.initState();
    // TODO: Get repository from DI
    // _controller = ProductGroupController(repository);
    // _controller.loadProductGroupsForSubCategory(widget.subCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Groups'),
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.errorMessage != null
              ? Center(child: Text('Error: ${_controller.errorMessage}'))
              : _controller.productGroups.isEmpty
                  ? const Center(child: Text('No product groups found'))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _controller.productGroups.length,
                      itemBuilder: (context, index) {
                        final productGroup = _controller.productGroups[index];
                        return ProductGroupCard(productGroup: productGroup);
                      },
                    ),
    );
  }
}




