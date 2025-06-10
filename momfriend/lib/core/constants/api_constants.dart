class ApiConstants {
  // Base URLs dla różnych środowisk
  static const String baseUrl = 'http://localhost:3000';
  static const String wsUrl = 'ws://localhost:3000';
  
  // API Endpoints
  static const String apiVersion = '/api';
  static const String authEndpoint = '$apiVersion/auth';
  static const String usersEndpoint = '$apiVersion/users';
  static const String matchingEndpoint = '$apiVersion/matching';
  static const String chatEndpoint = '$apiVersion/chat';
  static const String feedEndpoint = '$apiVersion/feed';
  static const String verificationEndpoint = '$apiVersion/verification';
  
  // Specific API endpoints
  static const String loginUrl = '$authEndpoint/login';
  static const String registerUrl = '$authEndpoint/register';
  static const String refreshTokenUrl = '$authEndpoint/refresh';
  static const String logoutUrl = '$authEndpoint/logout';
  
  static const String profileUrl = '$usersEndpoint/profile';
  static const String uploadImageUrl = '$usersEndpoint/upload-image';
  
  static const String swipeUrl = '$matchingEndpoint/swipe';
  static const String profilesUrl = '$matchingEndpoint/profiles';
  static const String matchesUrl = '$matchingEndpoint/matches';
  
  static const String conversationsUrl = '$chatEndpoint/conversations';
  static const String messagesUrl = '$chatEndpoint/messages';
  
  static const String healthCheckUrl = '/health';
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeouts (w sekundach)
  static const int connectTimeout = 10;
  static const int receiveTimeout = 15;
  static const int sendTimeout = 10;
  
  // Rate limiting
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  // WebSocket events
  static const String wsEventConnect = 'connect';
  static const String wsEventDisconnect = 'disconnect';
  static const String wsEventMessage = 'message';
  static const String wsEventTyping = 'typing';
  static const String wsEventOnline = 'online';
  static const String wsEventOffline = 'offline';
  
  // Helper methods
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
  
  static Uri getUri(String endpoint, [Map<String, dynamic>? queryParameters]) {
    return Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: queryParameters,
    );
  }
  
  static String getWebSocketUrl(String path) {
    return '$wsUrl$path';
  }
} 