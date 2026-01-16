import 'package:flutter/material.dart';
import '../../search/presentation/search_bar_widget.dart';
import '../../../core/widgets/app_navbar.dart';
import '../../../core/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const CategoriesPage(),
    const OrdersPage(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: AppNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Section
            _buildTopHeader(),
            
            // Search Bar
            const SearchBarWidget(),
            
            // Category Grid
            _buildCategorySection(
              'Grocery & Kitchen',
              _getGroceryCategories(),
            ),
            
            _buildCategorySection(
              'Beauty & Personal Care',
              _getBeautyCategories(),
            ),
            
            _buildCategorySection(
              'Household Essentials',
              _getHouseholdCategories(),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apna Dukan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '64, Ring Road',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet,
                            size: 18, color: Colors.green[700]),
                        const SizedBox(width: 4),
                        Text(
                          '₹0',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.person, size: 28, color: Colors.grey[600]),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<CategoryItem> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryCard(categories[index]);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCategoryCard(CategoryItem category) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              category.icon,
              color: Colors.green[700],
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  List<CategoryItem> _getGroceryCategories() {
    return [
      CategoryItem('Vegetables & Fruits', Icons.apple),
      CategoryItem('Atta, Rice & Dal', Icons.rice_bowl),
      CategoryItem('Oil, Ghee & Masala', Icons.local_dining),
      CategoryItem('Dairy, Bread & Eggs', Icons.egg),
      CategoryItem('Bakery & Biscuits', Icons.cake),
      CategoryItem('Dry Fruits & Cereals', Icons.grain),
      CategoryItem('Chicken, Meat & Fish', Icons.set_meal),
      CategoryItem('Kitchenware', Icons.kitchen),
    ];
  }

  List<CategoryItem> _getBeautyCategories() {
    return [
      CategoryItem('Bath & Body', Icons.shower),
      CategoryItem('Hair', Icons.content_cut),
      CategoryItem('Skin & Face', Icons.face),
      CategoryItem('Beauty & Cosmetics', Icons.brush),
      CategoryItem('Feminine Hygiene', Icons.local_pharmacy),
      CategoryItem('Baby Care', Icons.child_care),
      CategoryItem('Health & Pharma', Icons.medical_services),
      CategoryItem('Sexual Wellness', Icons.favorite),
    ];
  }

  List<CategoryItem> _getHouseholdCategories() {
    return [
      CategoryItem('Home & Lifestyle', Icons.home),
      CategoryItem('Cleaners', Icons.cleaning_services),
      CategoryItem('Electronics', Icons.electrical_services),
      CategoryItem('Stationery & Games', Icons.games),
    ];
  }
}

class CategoryItem {
  final String name;
  final IconData icon;

  CategoryItem(this.name, this.icon);
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Categories Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Orders Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
