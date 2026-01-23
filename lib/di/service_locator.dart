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
import '../features/subcategory/data/datasources/subcategory_remote_datasource.dart';
import '../features/subcategory/data/repositories/subcategory_repository.dart';
import '../features/subcategory/domain/usecases/get_subcategories_usecase.dart';
import '../features/product_group/data/datasources/product_group_remote_datasource.dart';
import '../features/product_group/data/repositories/product_group_repository.dart';
import '../features/product_group/domain/usecases/get_product_groups_usecase.dart';
import '../features/product/data/datasources/product_listing_remote_datasource.dart';
import '../features/product/data/repositories/product_repository.dart';
import '../features/product/domain/usecases/get_product_listing_usecase.dart';
import '../features/product/domain/usecases/get_product_details_usecase.dart';
import '../features/home/data/repositories/home_repository.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/signup_usecase.dart';
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

  // Repositories
  late final CatalogLayoutRepository _catalogLayoutRepository;
  late final CategoryRepository _categoryRepository;
  late final SubCategoryRepository _subCategoryRepository;
  late final ProductGroupRepository _productGroupRepository;
  late final ProductRepository _productRepository;
  late final HomeRepository _homeRepository;
  late final AuthRepository _authRepository;

  // Use Cases
  late final GetCatalogLayoutUseCase _getCatalogLayoutUseCase;
  late final GetAllCatalogLayoutsUseCase _getAllCatalogLayoutsUseCase;
  late final GetCatalogSectionByIdUseCase _getCatalogSectionByIdUseCase;
  late final UpdateCatalogSectionUseCase _updateCatalogSectionUseCase;
  late final CreateCatalogSectionUseCase _createCatalogSectionUseCase;
  late final DeleteCatalogSectionUseCase _deleteCatalogSectionUseCase;
  late final BulkUpdateCatalogSectionsUseCase _bulkUpdateCatalogSectionsUseCase;
  late final GetCategoriesUseCase _getCategoriesUseCase;
  late final GetSubCategoriesUseCase _getSubCategoriesUseCase;
  late final GetProductGroupsUseCase _getProductGroupsUseCase;
  late final GetProductListingUseCase _getProductListingUseCase;
  late final GetProductDetailsUseCase _getProductDetailsUseCase;
  late final LoginUseCase _loginUseCase;
  late final SignupUseCase _signupUseCase;

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

    // Initialize repositories
    _catalogLayoutRepository = CatalogLayoutRepository(_catalogLayoutRemoteDataSource);
    _categoryRepository = CategoryRepository(_categoryRemoteDataSource);
    _subCategoryRepository = SubCategoryRepository(_subCategoryRemoteDataSource);
    _productGroupRepository = ProductGroupRepository(_productGroupRemoteDataSource);
    _productRepository = ProductRepository(_productListingRemoteDataSource);
    _homeRepository = HomeRepository(_catalogLayoutRepository);
    _authRepository = AuthRepository(_authRemoteDataSource);

    // Initialize use cases
    _getCatalogLayoutUseCase = GetCatalogLayoutUseCase(_catalogLayoutRepository);
    _getAllCatalogLayoutsUseCase = GetAllCatalogLayoutsUseCase(_catalogLayoutRepository);
    _getCatalogSectionByIdUseCase = GetCatalogSectionByIdUseCase(_catalogLayoutRepository);
    _updateCatalogSectionUseCase = UpdateCatalogSectionUseCase(_catalogLayoutRepository);
    _createCatalogSectionUseCase = CreateCatalogSectionUseCase(_catalogLayoutRepository);
    _deleteCatalogSectionUseCase = DeleteCatalogSectionUseCase(_catalogLayoutRepository);
    _bulkUpdateCatalogSectionsUseCase = BulkUpdateCatalogSectionsUseCase(_catalogLayoutRepository);
    _getCategoriesUseCase = GetCategoriesUseCase(_categoryRepository);
    _getSubCategoriesUseCase = GetSubCategoriesUseCase(_subCategoryRepository);
    _getProductGroupsUseCase = GetProductGroupsUseCase(_productGroupRepository);
    _getProductListingUseCase = GetProductListingUseCase(_productRepository);
    _getProductDetailsUseCase = GetProductDetailsUseCase(_productRepository);
    _loginUseCase = LoginUseCase(_authRepository);
    _signupUseCase = SignupUseCase(_authRepository);
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
  GetSubCategoriesUseCase get getSubCategoriesUseCase => _getSubCategoriesUseCase;
  GetProductGroupsUseCase get getProductGroupsUseCase => _getProductGroupsUseCase;
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
}
