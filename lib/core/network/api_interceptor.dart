import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/storage_keys.dart';

class ApiInterceptor extends Interceptor {
  final GetStorage storage;

  ApiInterceptor(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    final token = storage.read<String>(StorageKeys.token);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - logout user
    if (err.response?.statusCode == 401) {
      storage.remove(StorageKeys.token);
      storage.remove(StorageKeys.user);
      // Navigate to login (will be handled by auth guard)
    }
    super.onError(err, handler);
  }
}

