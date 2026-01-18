// Service locator / Dependency injection
import '../core/network/dio_client.dart';
import '../core/network/api_client.dart';
import '../features/catalog_layout/data/datasources/catalog_layout_remote_datasource.dart';
import '../features/catalog_layout/data/repositories/catalog_layout_repository.dart';
import '../features/catalog_layout/domain/usecases/get_catalog_layout_usecase.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Core
  late final DioClient _dioClient;
  late final ApiClient _apiClient;

  // Data Sources
  late final CatalogLayoutRemoteDataSource _catalogLayoutRemoteDataSource;

  // Repositories
  late final CatalogLayoutRepository _catalogLayoutRepository;

  // Use Cases
  late final GetCatalogLayoutUseCase _getCatalogLayoutUseCase;

  void init() {
    // Initialize core services
    _dioClient = DioClient();
    _apiClient = ApiClient(_dioClient);

    // Initialize data sources
    _catalogLayoutRemoteDataSource = CatalogLayoutRemoteDataSource(_dioClient);

    // Initialize repositories
    _catalogLayoutRepository = CatalogLayoutRepository(_catalogLayoutRemoteDataSource);

    // Initialize use cases
    _getCatalogLayoutUseCase = GetCatalogLayoutUseCase(_catalogLayoutRepository);
  }

  // Getters
  DioClient get dioClient => _dioClient;
  ApiClient get apiClient => _apiClient;
  GetCatalogLayoutUseCase get getCatalogLayoutUseCase => _getCatalogLayoutUseCase;
}
