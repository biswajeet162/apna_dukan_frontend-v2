// Service locator / Dependency injection
import '../core/network/dio_client.dart';
import '../core/network/api_client.dart';
import '../features/catalog_layout/data/datasources/catalog_layout_remote_datasource.dart';
import '../features/catalog_layout/data/repositories/catalog_layout_repository.dart';
import '../features/catalog_layout/domain/usecases/get_catalog_layout_usecase.dart';
import '../features/category/data/datasources/category_remote_datasource.dart';
import '../features/category/data/repositories/category_repository.dart';
import '../features/category/domain/usecases/get_categories_usecase.dart';
import '../features/subcategory/data/datasources/subcategory_remote_datasource.dart';
import '../features/subcategory/data/repositories/subcategory_repository.dart';
import '../features/subcategory/domain/usecases/get_subcategories_usecase.dart';
import '../features/home/data/repositories/home_repository.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Core
  late final DioClient _dioClient;
  late final ApiClient _apiClient;

  // Data Sources
  late final CatalogLayoutRemoteDataSource _catalogLayoutRemoteDataSource;
  late final CategoryRemoteDataSource _categoryRemoteDataSource;
  late final SubCategoryRemoteDataSource _subCategoryRemoteDataSource;

  // Repositories
  late final CatalogLayoutRepository _catalogLayoutRepository;
  late final CategoryRepository _categoryRepository;
  late final SubCategoryRepository _subCategoryRepository;
  late final HomeRepository _homeRepository;

  // Use Cases
  late final GetCatalogLayoutUseCase _getCatalogLayoutUseCase;
  late final GetCategoriesUseCase _getCategoriesUseCase;
  late final GetSubCategoriesUseCase _getSubCategoriesUseCase;

  void init() {
    // Initialize core services
    _dioClient = DioClient();
    _apiClient = ApiClient(_dioClient);

    // Initialize data sources
    _catalogLayoutRemoteDataSource = CatalogLayoutRemoteDataSource(_dioClient);
    _categoryRemoteDataSource = CategoryRemoteDataSource(_dioClient);
    _subCategoryRemoteDataSource = SubCategoryRemoteDataSource(_dioClient);

    // Initialize repositories
    _catalogLayoutRepository = CatalogLayoutRepository(_catalogLayoutRemoteDataSource);
    _categoryRepository = CategoryRepository(_categoryRemoteDataSource);
    _subCategoryRepository = SubCategoryRepository(_subCategoryRemoteDataSource);
    _homeRepository = HomeRepository(_catalogLayoutRepository);

    // Initialize use cases
    _getCatalogLayoutUseCase = GetCatalogLayoutUseCase(_catalogLayoutRepository);
    _getCategoriesUseCase = GetCategoriesUseCase(_categoryRepository);
    _getSubCategoriesUseCase = GetSubCategoriesUseCase(_subCategoryRepository);
  }

  // Getters
  DioClient get dioClient => _dioClient;
  ApiClient get apiClient => _apiClient;
  GetCatalogLayoutUseCase get getCatalogLayoutUseCase => _getCatalogLayoutUseCase;
  GetCategoriesUseCase get getCategoriesUseCase => _getCategoriesUseCase;
  GetSubCategoriesUseCase get getSubCategoriesUseCase => _getSubCategoriesUseCase;
  HomeRepository get homeRepository => _homeRepository;
  CategoryRepository get categoryRepository => _categoryRepository;
  SubCategoryRepository get subCategoryRepository => _subCategoryRepository;
}
