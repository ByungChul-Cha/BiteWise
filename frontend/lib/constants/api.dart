import 'package:flutter/foundation.dart';

// Returns the base URL for API calls depending on platform.
String get apiBaseUrl {
  if (kIsWeb) return 'http://localhost:8000';
  if (defaultTargetPlatform == TargetPlatform.android) {
    // Android emulator cannot reach host's 127.0.0.1 directly.
    return 'http://10.0.2.2:8000';
  }
  // iOS simulator/desktop use localhost.
  return 'http://localhost:8000';
}

Uri get loginUri => Uri.parse('$apiBaseUrl/api/users/login/');
