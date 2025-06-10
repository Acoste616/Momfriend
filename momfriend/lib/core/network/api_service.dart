import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../config/app_config.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    required this.statusCode,
  });

  factory ApiResponse.success(T data, int statusCode) {
    return ApiResponse(
      success: true,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String error, int statusCode) {
    return ApiResponse(
      success: false,
      error: error,
      statusCode: statusCode,
    );
  }
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    _dio = Dio();
    _setupDio();
  }

  late final Dio _dio;
  String? _authToken;

  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.apiTimeout,
      sendTimeout: AppConfig.apiTimeout,
      headers: ApiConstants.defaultHeaders,
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          // Add auth token if available
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          
          if (AppConfig.enableVerboseLogging) {
            debugPrint('API Request: ${options.method} ${options.path}');
            debugPrint('Headers: ${options.headers}');
            if (options.data != null) {
              debugPrint('Data: ${options.data}');
            }
          }
          
          handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          if (AppConfig.enableVerboseLogging) {
            debugPrint('API Response: ${response.statusCode} ${response.requestOptions.path}');
            debugPrint('Data: ${response.data}');
          }
          handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          if (AppConfig.enableVerboseLogging) {
            debugPrint('API Error: ${error.message}');
            debugPrint('Response: ${error.response?.data}');
          }
          handler.next(error);
        },
      ),
    );
  }

  // Set auth token for authenticated requests
  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  // Health check to verify backend connection
  Future<ApiResponse<Map<String, dynamic>>> healthCheck() async {
    try {
      final response = await _dio.get(ApiConstants.healthCheckUrl);
      return ApiResponse.success(
        response.data as Map<String, dynamic>,
        response.statusCode ?? 200,
      );
    } catch (e) {
      return _handleError<Map<String, dynamic>>(e);
    }
  }

  // Generic GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );
      final data =
          fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResponse.success(data, response.statusCode ?? 200);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      final data =
          fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResponse.success(data, response.statusCode ?? 200);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.put(endpoint, data: body);
      final data =
          fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResponse.success(data, response.statusCode ?? 200);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // Generic DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(endpoint);
      final data =
          fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResponse.success(data, response.statusCode ?? 200);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // File upload
  Future<ApiResponse<dynamic>> uploadFile(
    String endpoint,
    String filePath,
    String fieldName,
  ) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(endpoint, data: formData);
      return ApiResponse.success(response.data, response.statusCode ?? 200);
    } catch (e) {
      return _handleError<dynamic>(e);
    }
  }

  // Handle errors
  ApiResponse<T> _handleError<T>(dynamic error) {
    String errorMessage = 'Network error occurred';
    int statusCode = 500;

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Request timeout. Please try again.';
          statusCode = 408;
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'No internet connection. Please check your network.';
          statusCode = 503;
          break;
        case DioExceptionType.badResponse:
          statusCode = error.response?.statusCode ?? 500;
          if (error.response?.data is Map<String, dynamic>) {
            final data = error.response!.data as Map<String, dynamic>;
            errorMessage = data['error'] ?? data['message'] ?? 'Server error occurred';
          } else {
            errorMessage = 'Server error: $statusCode';
          }
          break;
        case DioExceptionType.cancel:
          errorMessage = 'Request was cancelled';
          statusCode = 499;
          break;
        case DioExceptionType.unknown:
        default:
          errorMessage = error.message ?? 'Unknown error occurred';
          break;
      }
    } else if (error is SocketException) {
      errorMessage = 'No internet connection. Please check your network.';
      statusCode = 503;
    } else {
      errorMessage = error.toString();
    }

    if (AppConfig.enableVerboseLogging) {
      debugPrint('API Error: $errorMessage');
    }

    return ApiResponse.error(errorMessage, statusCode);
  }

  // Specific API methods

  // Authentication
  Future<ApiResponse<dynamic>> login(String email, String password) async {
    return post(ApiConstants.loginUrl, body: {
      'email': email,
      'password': password,
    });
  }

  Future<ApiResponse<dynamic>> register(String email, String password, String name) async {
    return post(ApiConstants.registerUrl, body: {
      'email': email,
      'password': password,
      'name': name,
    });
  }

  Future<ApiResponse<dynamic>> logout() async {
    return post(ApiConstants.logoutUrl);
  }

  Future<ApiResponse<dynamic>> refreshToken(String refreshToken) async {
    return post(ApiConstants.refreshTokenUrl, body: {
      'refreshToken': refreshToken,
    });
  }

  // Profile
  Future<ApiResponse<dynamic>> getProfile() async {
    return get(ApiConstants.profileUrl);
  }

  Future<ApiResponse<dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    return put(ApiConstants.profileUrl, body: profileData);
  }

  Future<ApiResponse<dynamic>> uploadProfileImage(String imagePath) async {
    return uploadFile(ApiConstants.uploadImageUrl, imagePath, 'profileImage');
  }

  // Matching
  Future<ApiResponse<dynamic>> getProfiles({Map<String, dynamic>? filters}) async {
    return get(ApiConstants.profilesUrl, queryParams: filters);
  }

  Future<ApiResponse<dynamic>> swipeProfile(String profileId, String action) async {
    return post(ApiConstants.swipeUrl, body: {
      'profileId': profileId,
      'action': action,
    });
  }

  Future<ApiResponse<dynamic>> getMatches() async {
    return get(ApiConstants.matchesUrl);
  }

  // Chat
  Future<ApiResponse<dynamic>> getConversations() async {
    return get(ApiConstants.conversationsUrl);
  }

  Future<ApiResponse<dynamic>> getMessages(String conversationId, {int? limit, int? offset}) async {
    return get(
      '${ApiConstants.messagesUrl}/$conversationId',
      queryParams: {
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      },
    );
  }

  Future<ApiResponse<dynamic>> sendMessage(String conversationId, String message) async {
    return post(ApiConstants.messagesUrl, body: {
      'conversationId': conversationId,
      'message': message,
    });
  }

  // Cleanup
  void dispose() {
    _dio.close();
  }
} 