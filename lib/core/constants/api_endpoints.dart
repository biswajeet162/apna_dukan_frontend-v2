// API Endpoints
class ApiEndpoints {
  // User endpoints
  static const String catalogLayout = '/user/catalog/layout';
  static const String categoriesForSection = '/v1/section/{sectionId}/categories';
  static const String subCategoriesForCategory = '/v1/category/{categoryId}/subCategories';
  static const String productGroupsForSubCategory = '/v1/subCategory/{subCategoryId}/productGroups';
  static const String productsForProductGroup = '/v1/productGroup/{productGroupId}/products';
  static const String productDetails = '/v1/product/{productId}';

  // Admin endpoints
  static const String adminCatalogLayout = '/admin/catalog/layout';
  static const String adminCatalogLayoutBulk = '/admin/catalog/layout/bulk';
  static String adminCatalogLayoutById(String sectionId) => '/admin/catalog/layout/$sectionId';
  
  // Admin category endpoints
  static String adminCategoriesForSection(String sectionId) => '/v1/admin/section/$sectionId/categories';
  static String adminCategoryById(String categoryId) => '/v1/admin/category/$categoryId';
  static const String adminCategoryCreate = '/v1/admin/category';
  static const String adminCategoryBulk = '/v1/admin/category/bulk';

  // Admin subcategory endpoints
  static String adminSubCategoriesForCategory(String categoryId) => '/v1/admin/category/$categoryId/subCategories';
  static String adminSubCategoryById(String subCategoryId) => '/v1/admin/category/subCategory/$subCategoryId';
  static const String adminSubCategoryCreate = '/v1/admin/category/subCategory';
  static const String adminSubCategoryBulk = '/v1/admin/category/subCategory/bulk';

  // Admin product group endpoints
  static String adminProductGroupsForSubCategory(String subCategoryId) =>
      '/v1/admin/subCategory/$subCategoryId/productGroups';
  static String adminProductGroupById(String productGroupId) =>
      '/v1/admin/subCategory/productGroup/$productGroupId';
  static const String adminProductGroupCreate = '/v1/admin/subCategory/productGroup';
  static const String adminProductGroupBulk = '/v1/admin/subCategory/productGroup/bulk';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String signup = '/auth/register';
  static const String refreshToken = '/auth/token/refresh';
  static const String logout = '/auth/logout';

  // Helper methods
  static String categoriesForSectionUrl(String sectionId) {
    return categoriesForSection.replaceAll('{sectionId}', sectionId);
  }

  static String subCategoriesForCategoryUrl(String categoryId) {
    return subCategoriesForCategory.replaceAll('{categoryId}', categoryId);
  }

  static String productGroupsForSubCategoryUrl(String subCategoryId) {
    return productGroupsForSubCategory.replaceAll('{subCategoryId}', subCategoryId);
  }

  static String productsForProductGroupUrl(String productGroupId) {
    return productsForProductGroup.replaceAll('{productGroupId}', productGroupId);
  }

  static String productDetailsUrl(String productId) {
    return productDetails.replaceAll('{productId}', productId);
  }
}




