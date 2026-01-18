// API client
import 'dio_client.dart';

class ApiClient {
  final DioClient _dioClient;

  ApiClient(this._dioClient);

  DioClient get dioClient => _dioClient;
}
