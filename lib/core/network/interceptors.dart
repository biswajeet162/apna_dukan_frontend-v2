// HTTP Interceptors
import 'dart:async';
import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../constants/api_endpoints.dart';
import '../../features/auth/data/models/refresh_token_request.dart';
import '../../features/auth/data/models/refresh_token_response.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage = SecureStorage();
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip adding token for auth endpoints
    if (options.path.contains('/auth/login') || 
        options.path.contains('/auth/register') ||
        options.path.contains('/auth/token/refresh')) {
      handler.next(options);
      return;
    }

    // Add authentication token if available
    try {
      final isLoggedIn = await _secureStorage.isLoggedIn();
      if (isLoggedIn) {
        final token = await _secureStorage.getAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
    } catch (e) {
      // If there's an error reading tokens, log it but don't block the request
      print('Error reading auth token: $e');
    }
    // If not logged in, don't add header (allows anonymous access to public APIs)
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - Try to refresh token
    if (err.response?.statusCode == 401) {
      final isLoggedIn = await _secureStorage.isLoggedIn();
      
      if (isLoggedIn && !err.requestOptions.path.contains('/auth/')) {
        // Check if we're already refreshing
        if (_isRefreshing) {
          // Queue this request
          final completer = Completer<Response>();
          _pendingRequests.add(_PendingRequest(
            requestOptions: err.requestOptions,
            completer: completer,
          ));
          
          try {
            final response = await completer.future;
            return handler.resolve(response);
          } catch (e) {
            return handler.next(err);
          }
        }

        _isRefreshing = true;

        try {
          // Get refresh token
          final refreshToken = await _secureStorage.getRefreshToken();
          
          if (refreshToken == null) {
            throw Exception('No refresh token available');
          }

          // Create a new Dio instance without interceptors to avoid recursion
          final dio = Dio(BaseOptions(
            baseUrl: err.requestOptions.baseUrl,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));

          // Call refresh token endpoint
          final refreshResponse = await dio.post(
            ApiEndpoints.refreshToken,
            data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
          );

          if (refreshResponse.statusCode == 200) {
            final refreshTokenResponse = RefreshTokenResponse.fromJson(
              refreshResponse.data as Map<String, dynamic>,
            );

            // Update tokens in storage
            await _secureStorage.updateTokens(
              accessToken: refreshTokenResponse.accessToken,
              refreshToken: refreshTokenResponse.refreshToken,
            );

            // Retry original request with new token
            final newToken = refreshTokenResponse.accessToken;
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

            final opts = Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            );

            final response = await dio.request(
              err.requestOptions.path,
              options: opts,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
            );

            // Resolve all pending requests
            for (var pending in _pendingRequests) {
              pending.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final pendingOpts = Options(
                method: pending.requestOptions.method,
                headers: pending.requestOptions.headers,
              );
              try {
                final pendingResponse = await dio.request(
                  pending.requestOptions.path,
                  options: pendingOpts,
                  data: pending.requestOptions.data,
                  queryParameters: pending.requestOptions.queryParameters,
                );
                pending.completer.complete(pendingResponse);
              } catch (e) {
                pending.completer.completeError(e);
              }
            }
            _pendingRequests.clear();

            _isRefreshing = false;
            return handler.resolve(response);
          }
        } catch (e) {
          // Refresh failed - clear tokens and logout
          await _secureStorage.clearAll();
          _isRefreshing = false;
          _pendingRequests.clear();
        }
      }
    }

    super.onError(err, handler);
  }
}

class _PendingRequest {
  final RequestOptions requestOptions;
  final Completer<Response> completer;

  _PendingRequest({
    required this.requestOptions,
    required this.completer,
  });
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    print('Data: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('Error: ${err.message}');
    super.onError(err, handler);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle common errors
    if (err.response?.statusCode == 401) {
      // TODO: Handle unauthorized - redirect to login
    } else if (err.response?.statusCode == 500) {
      // TODO: Handle server error
    }
    super.onError(err, handler);
  }
}
