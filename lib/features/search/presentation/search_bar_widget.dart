import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String? hintText;

  const SearchBarWidget({
    super.key,
    this.onTap,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.pushNamed(context, AppRoutes.search);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hintText ?? "Search for atta, dal, coke and more",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(Icons.mic, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}

