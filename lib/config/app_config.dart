import 'package:flutter/foundation.dart';

class AppConfig {
  static const String localServerUrl = 'http://localhost:3000';

  // TODO: Replace with your deployed backend URL (e.g. Railway/Render)
  static const String productionServerUrl =
      'https://werwolf-server.up.railway.app';

  static String get serverUrl {
    if (kReleaseMode) {
      return productionServerUrl;
    }
    return localServerUrl;
  }
}
