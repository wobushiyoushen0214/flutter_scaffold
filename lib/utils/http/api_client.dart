import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../services/user_service.dart';
import '../logger_util.dart';
import 'api_constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late Dio _dio;

  ApiClient._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(
        milliseconds: ApiConstants.connectionTimeout,
      ),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          LoggerUtil.i('REQUEST[${options.method}] => PATH: ${options.path}');

          UserService? userService;
          if (Get.isRegistered<UserService>()) {
            userService = Get.find<UserService>();
          }
          final token = userService?.token.value;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          LoggerUtil.i(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );

          final data = response.data;
          if (data is Map<String, dynamic>) {
            final code = data['code'];
            if (code != null && code != 0 && code != 200) {
              final dynamic rawMessage = data['message'] ?? data['msg'];
              final String message = rawMessage?.toString() ?? '请求失败';

              LoggerUtil.e(
                'BUSINESS_ERROR[$code] => PATH: ${response.requestOptions.path} Message: $message',
              );

              return handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  response: response,
                  type: DioExceptionType.badResponse,
                  error: message,
                ),
                true,
              );
            }
          }

          return handler.next(response);
        },
        onError: (DioException e, handler) {
          LoggerUtil.e(
            'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path} \n Message: ${e.message}',
          );

          final statusCode = e.response?.statusCode;
          if (statusCode == 401) {
            if (Get.isRegistered<UserService>()) {
              final userService = Get.find<UserService>();
              userService.clearUser();
            }
            if (Get.currentRoute != '/login') {
              Get.offAllNamed('/login');
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    String errorDescription = "";
    switch (error.type) {
      case DioExceptionType.cancel:
        errorDescription = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription = "Connection timeout with API server";
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          errorDescription = "未授权或登录已过期";
          break;
        }

        final dynamic data = error.response?.data;
        if (data is Map<String, dynamic>) {
          final dynamic code = data['code'];
          final dynamic rawMessage = data['message'] ?? data['msg'];

          if (code == 401) {
            if (rawMessage != null && rawMessage.toString().isNotEmpty) {
              errorDescription = rawMessage.toString();
            } else {
              errorDescription = "未授权或登录已过期";
            }
          } else if (rawMessage != null && rawMessage.toString().isNotEmpty) {
            errorDescription = rawMessage.toString();
          } else {
            errorDescription = "Received invalid status code: $statusCode";
          }
        } else {
          errorDescription = "Received invalid status code: $statusCode";
        }
        break;
      case DioExceptionType.sendTimeout:
        errorDescription = "Send timeout in connection with API server";
        break;
      case DioExceptionType.connectionError:
        errorDescription = "Connection error";
        break;
      default:
        errorDescription = "Unexpected error occurred";
    }
    return errorDescription;
  }
}
