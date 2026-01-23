import 'package:flutter/material.dart';

class AppNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isAdmin;

  const AppNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.category),
        label: 'Categories',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.shopping_bag),
        label: 'Order',
      ),
    ];

    // Add Dashboard button for admin users
    if (isAdmin) {
      items.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
      );
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey[600],
      items: items,
    );
  }
}
