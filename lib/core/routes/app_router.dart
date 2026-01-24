import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/add_subcategory_page.dart';
import '../../features/home/presentation/pages/edit_subcategory_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/search/presentation/search_page.dart';
import '../../features/auth/presentation/login/login_page.dart';
import '../../features/auth/presentation/signup/signup_page.dart';
import '../../features/auth/presentation/forgot_password/forgot_password_page.dart';
import '../../features/auth/presentation/otp/otp_page.dart';
import '../../features/category/presentation/pages/category_page.dart';
import '../../features/category/presentation/pages/categories_standalone_page.dart';
import '../../features/subcategory/presentation/pages/subcategory_page.dart';
import '../../features/product/presentation/pages/product_list_page.dart';
import '../../features/product/presentation/pages/product_details_page.dart';
import '../../features/product_group/presentation/pages/product_groups_page.dart';
import '../../features/product_group/presentation/pages/product_group_page.dart';
import '../../features/cart/presentation/cart_page.dart';
import '../../features/checkout/presentation/checkout_page.dart';
import '../../features/orders/presentation/order_list_page.dart';
import '../../features/orders/presentation/order_detail_page.dart';
import '../../features/payment/presentation/payment_method_page.dart';
import '../../features/payment/presentation/payment_status_page.dart';
import '../../features/address/presentation/address_list_page.dart';
import '../../features/address/presentation/address_form_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/wishlist/presentation/wishlist_page.dart';
import '../../features/reviews/presentation/review_list_page.dart';
import '../../features/reviews/presentation/review_form_page.dart';
import '../../features/notifications/presentation/notification_list_page.dart';
import '../../features/notifications/presentation/notification_detail_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/cms/presentation/about_us_page.dart';
import '../../features/cms/presentation/terms_conditions_page.dart';
import '../../features/cms/presentation/privacy_policy_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/layout_edit_page.dart';
import '../../features/admin/presentation/pages/layout_add_page.dart';
import '../../features/admin/presentation/pages/category_edit_page.dart';
import '../../features/admin/presentation/pages/category_add_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true, // Enable debug logging
  redirect: (BuildContext context, GoRouterState state) {
    // Redirect root path to /home
    if (state.uri.path == '/' || state.uri.path.isEmpty) {
      return AppRoutes.home;
    }
    return null;
  },
  routes: [
    // Splash route
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),

    // Home route - /home
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        // When route is /home, create HomePage which shows HomeContent
        // HomeContent.initState() will make 3 API calls: Layout, Categories, Subcategories
        // Check for editCategoryId query parameter to restore edit mode
        final editCategoryId = state.uri.queryParameters['editCategoryId'];
        return HomePage(initialEditCategoryId: editCategoryId);
      },
    ),

    // Add Subcategory route - /home/section/:sectionId/category/:categoryId/add-subcategory
    GoRoute(
      path: AppRoutes.homeAddSubcategory,
      builder: (context, state) {
        final sectionId = state.pathParameters['sectionId'];
        final categoryId = state.pathParameters['categoryId'];
        // Get category name from query parameters or use default
        final categoryName = state.uri.queryParameters['categoryName'] ?? 'Category';
        
        if (sectionId == null || categoryId == null) {
          // Invalid route, redirect to home
          return const HomePage();
        }
        
        return AddSubcategoryPage(
          sectionId: sectionId,
          categoryId: categoryId,
          categoryName: categoryName,
        );
      },
    ),

    // Edit Subcategory route - /home/edit/section/:sectionId/category/:categoryId/Subcategory/:subCategoryId
    GoRoute(
      path: AppRoutes.homeEditSubcategory,
      builder: (context, state) {
        final sectionId = state.pathParameters['sectionId'];
        final categoryId = state.pathParameters['categoryId'];
        final subCategoryId = state.pathParameters['subCategoryId'];
        // Get subcategory name from query parameters
        final subCategoryName = state.uri.queryParameters['subCategoryName'];
        
        if (sectionId == null || categoryId == null || subCategoryId == null) {
          // Invalid route, redirect to home
          return const HomePage();
        }
        
        return EditSubcategoryPage(
          sectionId: sectionId,
          categoryId: categoryId,
          subCategoryId: subCategoryId,
          subCategoryName: subCategoryName,
        );
      },
    ),

    // Categories route - /categories?subCategoryId=xxx&subCategoryName=xxx&productId=xxx
    GoRoute(
      path: AppRoutes.categories,
      builder: (context, state) {
        final subCategoryId = state.uri.queryParameters['subCategoryId'];
        final subCategoryNameEncoded = state.uri.queryParameters['subCategoryName'];
        final productId = state.uri.queryParameters['productId'];
        // Decode the subCategoryName (handles +, &, etc.)
        final subCategoryName = subCategoryNameEncoded != null 
            ? Uri.decodeComponent(subCategoryNameEncoded) 
            : null;
        // When loading /categories?subCategoryId=xxx, create CategoriesPage
        // CategoriesPage will create ProductGroupsPage, making ONLY 2 API calls:
        // 1. Product Groups API (/v1/subCategory/{subCategoryId}/productGroups)
        // 2. Products API (/v1/productGroup/{productGroupId}/products)
        // When productId is present, show ProductDetailsPage
        return CategoriesStandalonePage(
          subCategoryId: subCategoryId,
          subCategoryName: subCategoryName,
          productId: productId,
        );
      },
    ),

    // Orders route - /orders?userId=xxx
    GoRoute(
      path: AppRoutes.orders,
      builder: (context, state) {
        final userId = state.uri.queryParameters['userId'];
        // When loading /orders?userId=xxx, create OrderListPage
        return OrderListPage(userId: userId);
      },
    ),

    // Auth routes
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      builder: (context, state) => const OtpPage(),
    ),

    // Category routes (legacy - for browsing categories by section)
    GoRoute(
      path: '/category-section',
      builder: (context, state) => const CategoryPage(sectionId: ''),
    ),
    GoRoute(
      path: '/category/:categoryId',
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        return CategoryPage(sectionId: categoryId);
      },
    ),

    // Subcategory routes
    GoRoute(
      path: '/subcategory/:subcategoryId',
      builder: (context, state) {
        final subcategoryId = state.pathParameters['subcategoryId']!;
        return SubCategoryPage(categoryId: subcategoryId);
      },
    ),

    // Product routes
    GoRoute(
      path: AppRoutes.products,
      builder: (context, state) => const ProductListPage(),
    ),
    GoRoute(
      path: '/product/:productId',
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;
        return ProductDetailsPage(productId: productId);
      },
    ),

    // Product group routes
    GoRoute(
      path: AppRoutes.productGroups,
      builder: (context, state) => const ProductGroupsPage(
        subCategoryId: '',
        subCategoryName: '',
      ),
    ),
    GoRoute(
      path: '/product-group/:groupId',
      builder: (context, state) {
        final groupId = state.pathParameters['groupId']!;
        return ProductGroupPage(subCategoryId: groupId);
      },
    ),

    // Search route
    GoRoute(
      path: AppRoutes.search,
      builder: (context, state) => const SearchPage(),
    ),

    // Cart route
    GoRoute(
      path: AppRoutes.cart,
      builder: (context, state) => const CartPage(),
    ),

    // Checkout route
    GoRoute(
      path: AppRoutes.checkout,
      builder: (context, state) => const CheckoutPage(),
    ),

    // Order detail route (individual order)
    GoRoute(
      path: '/order/:orderId',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return OrderDetailPage(orderId: orderId);
      },
    ),

    // Payment routes
    GoRoute(
      path: AppRoutes.paymentMethod,
      builder: (context, state) => const PaymentMethodPage(),
    ),
    GoRoute(
      path: AppRoutes.paymentStatus,
      builder: (context, state) => const PaymentStatusPage(),
    ),

    // Address routes
    GoRoute(
      path: AppRoutes.addresses,
      builder: (context, state) => const AddressListPage(),
    ),
    GoRoute(
      path: AppRoutes.addressForm,
      builder: (context, state) => const AddressFormPage(),
    ),
    GoRoute(
      path: '/address/edit/:addressId',
      builder: (context, state) {
        final addressId = state.pathParameters['addressId']!;
        return AddressFormPage(addressId: addressId);
      },
    ),

    // Profile route
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfilePage(),
    ),

    // Wishlist route
    GoRoute(
      path: AppRoutes.wishlist,
      builder: (context, state) => const WishlistPage(),
    ),

    // Review routes
    GoRoute(
      path: AppRoutes.reviews,
      builder: (context, state) => const ReviewListPage(),
    ),
    GoRoute(
      path: AppRoutes.reviewForm,
      builder: (context, state) => const ReviewFormPage(),
    ),
    GoRoute(
      path: '/review/edit/:reviewId',
      builder: (context, state) {
        final reviewId = state.pathParameters['reviewId']!;
        return ReviewFormPage(reviewId: reviewId);
      },
    ),

    // Notification routes
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationListPage(),
    ),
    GoRoute(
      path: '/notification/:notificationId',
      builder: (context, state) {
        final notificationId = state.pathParameters['notificationId']!;
        return NotificationDetailPage(notificationId: notificationId);
      },
    ),

    // Settings route
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),

    // CMS routes
    GoRoute(
      path: AppRoutes.aboutUs,
      builder: (context, state) => const AboutUsPage(),
    ),
    GoRoute(
      path: AppRoutes.termsConditions,
      builder: (context, state) => const TermsConditionsPage(),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      builder: (context, state) => const PrivacyPolicyPage(),
    ),

    // Admin routes
    GoRoute(
      path: AppRoutes.adminDashboard,
      builder: (context, state) => const AdminDashboardPage(),
    ),
    // More specific routes first (with parameters or specific paths)
    GoRoute(
      path: AppRoutes.adminLayoutEdit,
      builder: (context, state) {
        final sectionId = state.pathParameters['sectionId']!;
        return LayoutEditPage(sectionId: sectionId);
      },
    ),
    GoRoute(
      path: AppRoutes.adminLayoutAdd,
      builder: (context, state) => const LayoutAddPage(),
    ),
    GoRoute(
      path: AppRoutes.adminCategoryEdit,
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        return CategoryEditPage(categoryId: categoryId);
      },
    ),
    GoRoute(
      path: AppRoutes.adminCategoryAdd,
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        return CategoryAddPage(categoryId: categoryId);
      },
    ),
    // Less specific routes after (tab routes)
    GoRoute(
      path: AppRoutes.adminDashboardLayout,
      builder: (context, state) => const AdminDashboardPage(tab: 'layout'),
    ),
    GoRoute(
      path: AppRoutes.adminDashboardCategoryWithCategory,
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId'];
        return AdminDashboardPage(tab: 'category', categoryId: categoryId);
      },
    ),
    GoRoute(
      path: AppRoutes.adminDashboardCategory,
      builder: (context, state) => const AdminDashboardPage(tab: 'category'),
    ),
    GoRoute(
      path: AppRoutes.adminDashboardSubcategory,
      builder: (context, state) => const AdminDashboardPage(tab: 'subcategory'),
    ),
    GoRoute(
      path: AppRoutes.adminDashboardProduct,
      builder: (context, state) => const AdminDashboardPage(tab: 'product'),
    ),
    GoRoute(
      path: AppRoutes.adminDashboardProductGroup,
      builder: (context, state) => const AdminDashboardPage(tab: 'product-group'),
    ),
  ],
  errorBuilder: (context, state) => const HomePage(),
);

