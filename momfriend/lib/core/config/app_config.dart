enum Environment { development, staging, production }

class AppConfig {
  static Environment _currentEnvironment = Environment.development;
  
  static Environment get currentEnvironment => _currentEnvironment;
  
  static void setEnvironment(Environment environment) {
    _currentEnvironment = environment;
  }
  
  // API Configuration based on environment
  static String get apiBaseUrl {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'http://localhost:3000';
      case Environment.staging:
        return 'https://staging-api.momfriend.app';
      case Environment.production:
        return 'https://api.momfriend.app';
    }
  }
  
  static String get wsUrl {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'ws://localhost:3000';
      case Environment.staging:
        return 'wss://staging-api.momfriend.app';
      case Environment.production:
        return 'wss://api.momfriend.app';
    }
  }
  
  // App Information
  static const String appName = 'MomFriend';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // Feature flags
  static bool get enableAnalytics {
    return _currentEnvironment == Environment.production;
  }
  
  static bool get enableCrashReporting {
    return _currentEnvironment != Environment.development;
  }
  
  static bool get enableDebugMode {
    return _currentEnvironment == Environment.development;
  }
  
  static bool get enableVerboseLogging {
    return _currentEnvironment == Environment.development;
  }
  
  // API Configuration
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 10);
  static const int maxRetries = 3;
  
  // App Settings
  static const int maxProfileImages = 6;
  static const int maxBioLength = 500;
  static const double maxDistanceKm = 50.0;
  static const int minAge = 18;
  static const int maxAge = 60;
  
  // Cache Settings
  static const Duration cacheExpiration = Duration(hours: 24);
  static const Duration profileCacheExpiration = Duration(hours: 1);
  
  // Push Notifications
  static bool get enablePushNotifications {
    return _currentEnvironment != Environment.development;
  }
  
  // External Services
  static String get googleMapsApiKey {
    // In a real app, these would come from secure storage or environment variables
    switch (_currentEnvironment) {
      case Environment.development:
        return 'dev_google_maps_key';
      case Environment.staging:
        return 'staging_google_maps_key';
      case Environment.production:
        return 'prod_google_maps_key';
    }
  }
  
  // Security
  static const String encryptionKey = 'mom_friend_encryption_key_2025';
  
  // Helper methods
  static bool get isDebug => _currentEnvironment == Environment.development;
  static bool get isProduction => _currentEnvironment == Environment.production;
  
  static String get environmentName {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }
  
  static Map<String, dynamic> toJson() {
    return {
      'environment': environmentName,
      'apiBaseUrl': apiBaseUrl,
      'wsUrl': wsUrl,
      'appName': appName,
      'appVersion': appVersion,
      'appBuildNumber': appBuildNumber,
      'enableDebugMode': enableDebugMode,
      'enableAnalytics': enableAnalytics,
      'enableCrashReporting': enableCrashReporting,
    };
  }
} 