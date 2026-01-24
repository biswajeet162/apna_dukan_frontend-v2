class AppRoutes {
  // Base routes
  static const String splash = '/splash';
  static const String home = '/home';
  
  // Auth routes
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';
  
  // Category routes
  static const String categories = '/categories';
  static const String category = '/category/:categoryId';
  static String categoryWithId(String categoryId) => '/category/$categoryId';
  
  // Subcategory routes
  static const String subcategory = '/subcategory/:subcategoryId';
  static String subcategoryWithId(String subcategoryId) => '/subcategory/$subcategoryId';
  
  // Product routes
  static const String products = '/products';
  static const String productDetails = '/product/:productId';
  static String productDetailsWithId(String productId) => '/product/$productId';
  
  // Product group routes
  static const String productGroups = '/product-groups';
  static const String productGroup = '/product-group/:groupId';
  static String productGroupWithId(String groupId) => '/product-group/$groupId';
  
  // Search routes
  static const String search = '/search';
  
  // Cart routes
  static const String cart = '/cart';
  
  // Checkout routes
  static const String checkout = '/checkout';
  
  // Order routes
  static const String orders = '/orders';
  static const String orderDetail = '/order/:orderId';
  static String orderDetailWithId(String orderId) => '/order/$orderId';
  
  // Payment routes
  static const String paymentMethod = '/payment/method';
  static const String paymentStatus = '/payment/status';
  
  // Address routes
  static const String addresses = '/addresses';
  static const String addressForm = '/address/form';
  static const String addressEdit = '/address/edit/:addressId';
  static String addressEditWithId(String addressId) => '/address/edit/$addressId';
  
  // Profile routes
  static const String profile = '/profile';
  
  // Wishlist routes
  static const String wishlist = '/wishlist';
  
  // Review routes
  static const String reviews = '/reviews';
  static const String reviewForm = '/review/form';
  static const String reviewEdit = '/review/edit/:reviewId';
  static String reviewEditWithId(String reviewId) => '/review/edit/$reviewId';
  
  // Notification routes
  static const String notifications = '/notifications';
  static const String notificationDetail = '/notification/:notificationId';
  static String notificationDetailWithId(String notificationId) => '/notification/$notificationId';
  
  // Settings routes
  static const String settings = '/settings';
  
  // CMS routes
  static const String aboutUs = '/about-us';
  static const String termsConditions = '/terms-conditions';
  static const String privacyPolicy = '/privacy-policy';
  
  // Admin routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminDashboardLayout = '/admin/dashboard/layout';
  static const String adminDashboardCategory = '/admin/dashboard/category';
  static const String adminDashboardCategoryWithCategory = '/admin/dashboard/category/:categoryId';
  static String adminDashboardCategoryWithCategoryId(String categoryId) => '/admin/dashboard/category/$categoryId';
  static const String adminDashboardSubcategory = '/admin/dashboard/subcategory';
  static const String adminDashboardProduct = '/admin/dashboard/product';
  static const String adminDashboardProductGroup = '/admin/dashboard/product-group';
  static const String adminLayoutEdit = '/admin/dashboard/layout/edit/:sectionId';
  static String adminLayoutEditWithId(String sectionId) => '/admin/dashboard/layout/edit/$sectionId';
  static const String adminLayoutAdd = '/admin/dashboard/layout/add-section';
  static const String adminCategoryEdit = '/admin/dashboard/category/edit/:categoryId';
  static String adminCategoryEditWithId(String categoryId) => '/admin/dashboard/category/edit/$categoryId';
  static const String adminCategoryAdd = '/admin/dashboard/category/:categoryId/add-category';
  static String adminCategoryAddWithCategoryId(String categoryId) => '/admin/dashboard/category/$categoryId/add-category';
  
  // Home admin routes
  static const String homeAddSubcategory = '/home/section/:sectionId/category/:categoryId/add-subcategory';
  static String homeAddSubcategoryWithIds(String sectionId, String categoryId) => '/home/section/$sectionId/category/$categoryId/add-subcategory';
}



