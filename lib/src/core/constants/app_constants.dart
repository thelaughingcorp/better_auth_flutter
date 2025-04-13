import "package:flutter/foundation.dart";

class AppConstants {
  static const String scheme = "http";
  static const String defaultHost =
      kIsWeb || kIsWasm ? "127.0.0.1" : "10.0.2.2";
  static const int port = 8000;
  static const Duration autoRefreshSessionInterval = Duration(seconds: 5);
  static const int autoRefreshSessionTickThreshhold = 3;
}
