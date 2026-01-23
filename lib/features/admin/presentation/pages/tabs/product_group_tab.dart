import 'package:flutter/material.dart';

class ProductGroupTab extends StatelessWidget {
  const ProductGroupTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2,
              size: 64,
              color: Colors.green[700],
            ),
            const SizedBox(height: 16),
            const Text(
              'Product Group Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage product groups',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement product group management
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product group management coming soon...'),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Product Group'),
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

