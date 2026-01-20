// Product Group Card Widget
import 'package:flutter/material.dart';
import '../../data/models/product_group_model.dart';

class ProductGroupCard extends StatelessWidget {
  final ProductGroupModel productGroup;

  const ProductGroupCard({
    super.key,
    required this.productGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // TODO: Navigate to product list page
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                productGroup.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (productGroup.description != null)
                Text(
                  productGroup.description!,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}



