// API Endpoints
class ApiEndpoints {
  // User endpoints
  static const String catalogLayout = '/user/catalog/layout';
  static const String categoriesForSection = '/v1/section/{sectionId}/categories';
  static const String subCategoriesForCategory = '/v1/category/{categoryId}/subCategories';
  static const String productGroupsForSubCategory = '/v1/subCategory/{subCategoryId}/productGroups';
  static const String productsForProductGroup = '/v1/productGroup/{productGroupId}/products';
  static const String productDetails = '/v1/product/{productId}';

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




