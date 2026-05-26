import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../constants/api_constants.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(_storage, _dio),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ),
    ]);
  }

  static ApiClient get instance => _instance ??= ApiClient._();

  Future<Response> get(String path, {Map<String, dynamic>? params}) =>
      _dio.get(path, queryParameters: params);

  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);

  Future<Response> patch(String path, {dynamic data}) =>
      _dio.patch(path, data: data);

  Future<Response> delete(String path) =>
      _dio.delete(path);
}

class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  final Dio _dio;

  _AuthInterceptor(this._storage, this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: 'access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _storage.read(key: 'refresh_token');
        if (refreshToken != null) {
          final response = await _dio.post(
            ApiConstants.tokenRefresh,
            data: {'refresh': refreshToken},
          );
          final newAccess = response.data['access'];
          await _storage.write(key: 'access_token', value: newAccess);

          // Reintentar la solicitud original
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccess';
          final retryResponse = await _dio.fetch(opts);
          return handler.resolve(retryResponse);
        }
      } catch (_) {
        await _storage.deleteAll();
      }
    }
    handler.next(err);
  }
}