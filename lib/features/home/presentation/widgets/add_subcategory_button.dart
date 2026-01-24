import 'package:flutter/material.dart';

/// Reusable widget for adding a new subcategory
/// Displays a plus icon button that matches the subcategory card style
class AddSubcategoryButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddSubcategoryButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image Container with green background - matches subcategory card style
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green[300]!,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.green[700],
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Label - matches subcategory name style
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              'Add New',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

