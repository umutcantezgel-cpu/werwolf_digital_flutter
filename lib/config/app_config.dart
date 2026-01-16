import 'package:flutter/foundation.dart';

class AppConfig {
  static const String localServerUrl = 'http://localhost:3000';

  static const String productionServerUrl =
'https://werwolf-server-production.up.railway.app';
  static String get serverUrl {
    if (kReleaseMode) {
      return productionServerUrl;
    }
    return localServerUrl;
  }
}
