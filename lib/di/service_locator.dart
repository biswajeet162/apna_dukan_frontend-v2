// Service locator / Dependency injection
import '../core/network/dio_client.dart';
import '../core/network/api_client.dart';
import '../features/catalog_layout/data/datasources/catalog_layout_remote_datasource.dart';
import '../features/catalog_layout/data/repositories/catalog_layout_repository.dart';
import '../features/catalog_layout/domain/usecases/get_catalog_layout_usecase.dart';
import '../features/category/data/datasources/category_remote_datasource.dart';
import '../features/category/data/repositories/category_repository.dart';
import '../features/category/domain/usecases/get_categories_usecase.dart';

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

  // Repositories
  late final CatalogLayoutRepository _catalogLayoutRepository;
  late final CategoryRepository _categoryRepository;

  // Use Cases
  late final GetCatalogLayoutUseCase _getCatalogLayoutUseCase;
  late final GetCategoriesUseCase _getCategoriesUseCase;

  void init() {
    // Initialize core services
    _dioClient = DioClient();
    _apiClient = ApiClient(_dioClient);

    // Initialize data sources
    _catalogLayoutRemoteDataSource = CatalogLayoutRemoteDataSource(_dioClient);
    _categoryRemoteDataSource = CategoryRemoteDataSource(_dioClient);

    // Initialize repositories
    _catalogLayoutRepository = CatalogLayoutRepository(_catalogLayoutRemoteDataSource);
    _categoryRepository = CategoryRepository(_categoryRemoteDataSource);

    // Initialize use cases
    _getCatalogLayoutUseCase = GetCatalogLayoutUseCase(_catalogLayoutRepository);
    _getCategoriesUseCase = GetCategoriesUseCase(_categoryRepository);
  }

  // Getters
  DioClient get dioClient => _dioClient;
  ApiClient get apiClient => _apiClient;
  GetCatalogLayoutUseCase get getCatalogLayoutUseCase => _getCatalogLayoutUseCase;
  GetCategoriesUseCase get getCategoriesUseCase => _getCategoriesUseCase;
}
