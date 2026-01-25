// Service locator / Dependency injection
import '../core/network/dio_client.dart';
import '../core/network/api_client.dart';
import '../features/catalog_layout/data/datasources/catalog_layout_remote_datasource.dart';
import '../features/catalog_layout/data/repositories/catalog_layout_repository.dart';
import '../features/catalog_layout/domain/usecases/get_catalog_layout_usecase.dart';
import '../features/catalog_layout/domain/usecases/get_all_catalog_layouts_usecase.dart';
import '../features/catalog_layout/domain/usecases/get_catalog_section_by_id_usecase.dart';
import '../features/catalog_layout/domain/usecases/update_catalog_section_usecase.dart';
import '../features/catalog_layout/domain/usecases/create_catalog_section_usecase.dart';
import '../features/catalog_layout/domain/usecases/delete_catalog_section_usecase.dart';
import '../features/catalog_layout/domain/usecases/bulk_update_catalog_sections_usecase.dart';
import '../features/category/data/datasources/category_remote_datasource.dart';
import '../features/category/data/repositories/category_repository.dart';
import '../features/category/domain/usecases/get_categories_usecase.dart';
import '../features/category/domain/usecases/get_categories_for_admin_usecase.dart';
import '../features/category/domain/usecases/get_category_by_id_usecase.dart';
import '../features/category/domain/usecases/create_category_usecase.dart';
import '../features/category/domain/usecases/update_category_usecase.dart';
import '../features/category/domain/usecases/delete_category_usecase.dart';
import '../features/category/domain/usecases/bulk_update_categories_usecase.dart';
import '../features/subcategory/data/datasources/subcategory_remote_datasource.dart';
import '../features/subcategory/data/repositories/subcategory_repository.dart';
import '../features/subcategory/domain/usecases/get_subcategories_usecase.dart';
import '../features/subcategory/domain/usecases/get_subcategories_for_admin_usecase.dart';
import '../features/subcategory/domain/usecases/get_subcategory_by_id_usecase.dart';
import '../features/subcategory/domain/usecases/create_subcategory_usecase.dart';
import '../features/subcategory/domain/usecases/update_subcategory_usecase.dart';
import '../features/subcategory/domain/usecases/delete_subcategory_usecase.dart';
import '../features/subcategory/domain/usecases/bulk_update_subcategories_usecase.dart';
import '../features/product_group/data/datasources/product_group_remote_datasource.dart';
import '../features/product_group/data/repositories/product_group_repository.dart';
import '../features/product_group/domain/usecases/get_product_groups_usecase.dart';
import '../features/product_group/domain/usecases/create_product_group_usecase.dart';
import '../features/product_group/domain/usecases/get_product_group_by_id_usecase.dart';
import '../features/product_group/domain/usecases/update_product_group_usecase.dart';
import '../features/product_group/domain/usecases/delete_product_group_usecase.dart';
import '../features/product_group/domain/usecases/bulk_update_product_groups_usecase.dart';
import '../features/product/data/datasources/product_listing_remote_datasource.dart';
import '../features/product/data/repositories/product_repository.dart';
import '../features/product/domain/usecases/get_product_listing_usecase.dart';
import '../features/product/domain/usecases/get_product_details_usecase.dart';
import '../features/home/data/repositories/home_repository.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/signup_usecase.dart';
import '../features/profile/data/datasources/profile_remote_datasource.dart';
import '../features/profile/data/repositories/profile_repository.dart';
import '../features/profile/domain/usecases/get_user_profile_usecase.dart';
import '../features/profile/domain/usecases/get_user_addresses_usecase.dart';
import '../features/cart/data/datasources/cart_remote_datasource.dart';
import '../features/cart/data/repositories/cart_repository.dart';
import '../features/cart/domain/usecases/get_cart_usecase.dart';
import '../features/cart/domain/usecases/add_cart_item_usecase.dart';
import '../features/cart/domain/usecases/update_cart_item_usecase.dart';
import '../features/cart/domain/usecases/remove_cart_item_usecase.dart';
import '../features/cart/presentation/cart_controller.dart';
import '../core/storage/secure_storage.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Core
  late final DioClient _dioClient;
  late final ApiClient _apiClient;
  late final SecureStorage _secureStorage;

  // Data Sources
  late final CatalogLayoutRemoteDataSource _catalogLayoutRemoteDataSource;
  late final CategoryRemoteDataSource _categoryRemoteDataSource;
  late final SubCategoryRemoteDataSource _subCategoryRemoteDataSource;
  late final ProductGroupRemoteDataSource _productGroupRemoteDataSource;
  late final ProductListingRemoteDataSource _productListingRemoteDataSource;
  late final AuthRemoteDataSource _authRemoteDataSource;
  late final ProfileRemoteDataSource _profileRemoteDataSource;
  late final CartRemoteDataSource _cartRemoteDataSource;

  // Repositories
  late final CatalogLayoutRepository _catalogLayoutRepository;
  late final CategoryRepository _categoryRepository;
  late final SubCategoryRepository _subCategoryRepository;
  late final ProductGroupRepository _productGroupRepository;
  late final ProductRepository _productRepository;
  late final HomeRepository _homeRepository;
  late final AuthRepository _authRepository;
  late final ProfileRepository _profileRepository;
  late final CartRepository _cartRepository;

  // Use Cases
  late final GetCatalogLayoutUseCase _getCatalogLayoutUseCase;
  late final GetAllCatalogLayoutsUseCase _getAllCatalogLayoutsUseCase;
  late final GetCatalogSectionByIdUseCase _getCatalogSectionByIdUseCase;
  late final UpdateCatalogSectionUseCase _updateCatalogSectionUseCase;
  late final CreateCatalogSectionUseCase _createCatalogSectionUseCase;
  late final DeleteCatalogSectionUseCase _deleteCatalogSectionUseCase;
  late final BulkUpdateCatalogSectionsUseCase _bulkUpdateCatalogSectionsUseCase;
  late final GetCategoriesUseCase _getCategoriesUseCase;
  late final GetCategoriesForAdminUseCase _getCategoriesForAdminUseCase;
  late final GetCategoryByIdUseCase _getCategoryByIdUseCase;
  late final CreateCategoryUseCase _createCategoryUseCase;
  late final UpdateCategoryUseCase _updateCategoryUseCase;
  late final DeleteCategoryUseCase _deleteCategoryUseCase;
  late final BulkUpdateCategoriesUseCase _bulkUpdateCategoriesUseCase;
  late final GetSubCategoriesUseCase _getSubCategoriesUseCase;
  late final GetSubCategoriesForAdminUseCase _getSubCategoriesForAdminUseCase;
  late final GetSubCategoryByIdUseCase _getSubCategoryByIdUseCase;
  late final CreateSubCategoryUseCase _createSubCategoryUseCase;
  late final UpdateSubCategoryUseCase _updateSubCategoryUseCase;
  late final DeleteSubCategoryUseCase _deleteSubCategoryUseCase;
  late final BulkUpdateSubCategoriesUseCase _bulkUpdateSubCategoriesUseCase;
  late final GetProductGroupsUseCase _getProductGroupsUseCase;
  late final CreateProductGroupUseCase _createProductGroupUseCase;
  late final GetProductGroupByIdUseCase _getProductGroupByIdUseCase;
  late final UpdateProductGroupUseCase _updateProductGroupUseCase;
  late final DeleteProductGroupUseCase _deleteProductGroupUseCase;
  late final BulkUpdateProductGroupsUseCase _bulkUpdateProductGroupsUseCase;
  late final GetProductListingUseCase _getProductListingUseCase;
  late final GetProductDetailsUseCase _getProductDetailsUseCase;
  late final LoginUseCase _loginUseCase;
  late final SignupUseCase _signupUseCase;
  late final GetCartUseCase _getCartUseCase;
  late final AddCartItemUseCase _addCartItemUseCase;
  late final UpdateCartItemUseCase _updateCartItemUseCase;
  late final RemoveCartItemUseCase _removeCartItemUseCase;
  late final CartController _cartController;

  void init() {
    // Initialize core services
    _dioClient = DioClient();
    _apiClient = ApiClient(_dioClient);
    _secureStorage = SecureStorage();

    // Initialize data sources
    _catalogLayoutRemoteDataSource = CatalogLayoutRemoteDataSource(_dioClient);
    _categoryRemoteDataSource = CategoryRemoteDataSource(_dioClient);
    _subCategoryRemoteDataSource = SubCategoryRemoteDataSource(_dioClient);
    _productGroupRemoteDataSource = ProductGroupRemoteDataSource(_dioClient);
    _productListingRemoteDataSource = ProductListingRemoteDataSource(_dioClient);
    _authRemoteDataSource = AuthRemoteDataSource(_dioClient);
    _profileRemoteDataSource = ProfileRemoteDataSource(_dioClient);
    _cartRemoteDataSource = CartRemoteDataSource(_dioClient);

    // Initialize repositories
    _catalogLayoutRepository = CatalogLayoutRepository(_catalogLayoutRemoteDataSource);
    _categoryRepository = CategoryRepository(_categoryRemoteDataSource);
    _subCategoryRepository = SubCategoryRepository(_subCategoryRemoteDataSource);
    _productGroupRepository = ProductGroupRepository(_productGroupRemoteDataSource);
    _productRepository = ProductRepository(_productListingRemoteDataSource);
    _homeRepository = HomeRepository(_catalogLayoutRepository);
    _authRepository = AuthRepository(_authRemoteDataSource);
    _profileRepository = ProfileRepository(_profileRemoteDataSource);
    _cartRepository = CartRepository(_cartRemoteDataSource);

    // Initialize use cases
    _getCatalogLayoutUseCase = GetCatalogLayoutUseCase(_catalogLayoutRepository);
    _getAllCatalogLayoutsUseCase = GetAllCatalogLayoutsUseCase(_catalogLayoutRepository);
    _getCatalogSectionByIdUseCase = GetCatalogSectionByIdUseCase(_catalogLayoutRepository);
    _updateCatalogSectionUseCase = UpdateCatalogSectionUseCase(_catalogLayoutRepository);
    _createCatalogSectionUseCase = CreateCatalogSectionUseCase(_catalogLayoutRepository);
    _deleteCatalogSectionUseCase = DeleteCatalogSectionUseCase(_catalogLayoutRepository);
    _bulkUpdateCatalogSectionsUseCase = BulkUpdateCatalogSectionsUseCase(_catalogLayoutRepository);
    _getCategoriesUseCase = GetCategoriesUseCase(_categoryRepository);
    _getCategoriesForAdminUseCase = GetCategoriesForAdminUseCase(_categoryRepository);
    _getCategoryByIdUseCase = GetCategoryByIdUseCase(_categoryRepository);
    _createCategoryUseCase = CreateCategoryUseCase(_categoryRepository);
    _updateCategoryUseCase = UpdateCategoryUseCase(_categoryRepository);
    _deleteCategoryUseCase = DeleteCategoryUseCase(_categoryRepository);
    _bulkUpdateCategoriesUseCase = BulkUpdateCategoriesUseCase(_categoryRepository);
    _getSubCategoriesUseCase = GetSubCategoriesUseCase(_subCategoryRepository);
    _getSubCategoriesForAdminUseCase = GetSubCategoriesForAdminUseCase(_subCategoryRepository);
    _getSubCategoryByIdUseCase = GetSubCategoryByIdUseCase(_subCategoryRepository);
    _createSubCategoryUseCase = CreateSubCategoryUseCase(_subCategoryRepository);
    _updateSubCategoryUseCase = UpdateSubCategoryUseCase(_subCategoryRepository);
    _deleteSubCategoryUseCase = DeleteSubCategoryUseCase(_subCategoryRepository);
    _bulkUpdateSubCategoriesUseCase = BulkUpdateSubCategoriesUseCase(_subCategoryRepository);
    _getProductGroupsUseCase = GetProductGroupsUseCase(_productGroupRepository);
    _createProductGroupUseCase = CreateProductGroupUseCase(_productGroupRepository);
    _getProductGroupByIdUseCase = GetProductGroupByIdUseCase(_productGroupRepository);
    _updateProductGroupUseCase = UpdateProductGroupUseCase(_productGroupRepository);
    _deleteProductGroupUseCase = DeleteProductGroupUseCase(_productGroupRepository);
    _bulkUpdateProductGroupsUseCase = BulkUpdateProductGroupsUseCase(_productGroupRepository);
    _getProductListingUseCase = GetProductListingUseCase(_productRepository);
    _getProductDetailsUseCase = GetProductDetailsUseCase(_productRepository);
    _loginUseCase = LoginUseCase(_authRepository);
    _signupUseCase = SignupUseCase(_authRepository);
    _getCartUseCase = GetCartUseCase(_cartRepository);
    _addCartItemUseCase = AddCartItemUseCase(_cartRepository);
    _updateCartItemUseCase = UpdateCartItemUseCase(_cartRepository);
    _removeCartItemUseCase = RemoveCartItemUseCase(_cartRepository);
    _cartController = CartController(
      _getCartUseCase,
      _addCartItemUseCase,
      _updateCartItemUseCase,
      _removeCartItemUseCase,
    );
  }

  // Getters
  DioClient get dioClient => _dioClient;
  ApiClient get apiClient => _apiClient;
  GetCatalogLayoutUseCase get getCatalogLayoutUseCase => _getCatalogLayoutUseCase;
  GetAllCatalogLayoutsUseCase get getAllCatalogLayoutsUseCase => _getAllCatalogLayoutsUseCase;
  GetCatalogSectionByIdUseCase get getCatalogSectionByIdUseCase => _getCatalogSectionByIdUseCase;
  UpdateCatalogSectionUseCase get updateCatalogSectionUseCase => _updateCatalogSectionUseCase;
  CreateCatalogSectionUseCase get createCatalogSectionUseCase => _createCatalogSectionUseCase;
  DeleteCatalogSectionUseCase get deleteCatalogSectionUseCase => _deleteCatalogSectionUseCase;
  BulkUpdateCatalogSectionsUseCase get bulkUpdateCatalogSectionsUseCase => _bulkUpdateCatalogSectionsUseCase;
  GetCategoriesUseCase get getCategoriesUseCase => _getCategoriesUseCase;
  GetCategoriesForAdminUseCase get getCategoriesForAdminUseCase => _getCategoriesForAdminUseCase;
  GetCategoryByIdUseCase get getCategoryByIdUseCase => _getCategoryByIdUseCase;
  CreateCategoryUseCase get createCategoryUseCase => _createCategoryUseCase;
  UpdateCategoryUseCase get updateCategoryUseCase => _updateCategoryUseCase;
  DeleteCategoryUseCase get deleteCategoryUseCase => _deleteCategoryUseCase;
  BulkUpdateCategoriesUseCase get bulkUpdateCategoriesUseCase => _bulkUpdateCategoriesUseCase;
  GetSubCategoriesUseCase get getSubCategoriesUseCase => _getSubCategoriesUseCase;
  GetSubCategoriesForAdminUseCase get getSubCategoriesForAdminUseCase => _getSubCategoriesForAdminUseCase;
  GetSubCategoryByIdUseCase get getSubCategoryByIdUseCase => _getSubCategoryByIdUseCase;
  CreateSubCategoryUseCase get createSubCategoryUseCase => _createSubCategoryUseCase;
  UpdateSubCategoryUseCase get updateSubCategoryUseCase => _updateSubCategoryUseCase;
  DeleteSubCategoryUseCase get deleteSubCategoryUseCase => _deleteSubCategoryUseCase;
  BulkUpdateSubCategoriesUseCase get bulkUpdateSubCategoriesUseCase => _bulkUpdateSubCategoriesUseCase;
  GetProductGroupsUseCase get getProductGroupsUseCase => _getProductGroupsUseCase;
  CreateProductGroupUseCase get createProductGroupUseCase => _createProductGroupUseCase;
  GetProductGroupByIdUseCase get getProductGroupByIdUseCase => _getProductGroupByIdUseCase;
  UpdateProductGroupUseCase get updateProductGroupUseCase => _updateProductGroupUseCase;
  DeleteProductGroupUseCase get deleteProductGroupUseCase => _deleteProductGroupUseCase;
  BulkUpdateProductGroupsUseCase get bulkUpdateProductGroupsUseCase => _bulkUpdateProductGroupsUseCase;
  GetProductListingUseCase get getProductListingUseCase => _getProductListingUseCase;
  GetProductDetailsUseCase get getProductDetailsUseCase => _getProductDetailsUseCase;
  HomeRepository get homeRepository => _homeRepository;
  CategoryRepository get categoryRepository => _categoryRepository;
  SubCategoryRepository get subCategoryRepository => _subCategoryRepository;
  ProductGroupRepository get productGroupRepository => _productGroupRepository;
  ProductRepository get productRepository => _productRepository;
  AuthRepository get authRepository => _authRepository;
  SecureStorage get secureStorage => _secureStorage;
  LoginUseCase get loginUseCase => _loginUseCase;
  SignupUseCase get signupUseCase => _signupUseCase;
  ProfileRepository get profileRepository => _profileRepository;
  GetCartUseCase get getCartUseCase => _getCartUseCase;
  AddCartItemUseCase get addCartItemUseCase => _addCartItemUseCase;
  UpdateCartItemUseCase get updateCartItemUseCase => _updateCartItemUseCase;
  RemoveCartItemUseCase get removeCartItemUseCase => _removeCartItemUseCase;
  CartController get cartController => _cartController;
}
