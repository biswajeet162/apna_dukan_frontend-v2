import 'package:flutter/material.dart';
import '../../../../di/service_locator.dart';
import '../../features/cart/presentation/cart_controller.dart';

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
    final cartController = ServiceLocator().cartController;
    
    return ValueListenableBuilder<int>(
      valueListenable: cartController,
      builder: (context, totalItems, child) {
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

        // Add Cart button if cart has items
        if (totalItems > 0) {
          items.insert(
            2,
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart),
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        totalItems > 99 ? '99+' : totalItems.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              label: 'Cart',
            ),
          );
        }

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
      },
    );
  }
}
