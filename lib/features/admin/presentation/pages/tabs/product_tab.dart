import 'package:flutter/material.dart';

class ProductTab extends StatelessWidget {
  const ProductTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 64,
              color: Colors.green[700],
            ),
            const SizedBox(height: 16),
            const Text(
              'Product Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage products and inventory',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement product management
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product management coming soon...'),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

