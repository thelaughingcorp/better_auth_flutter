import "dart:convert";
import "package:better_auth_flutter/src/core/api/data/enums/error_type.dart";
import "package:better_auth_flutter/src/core/api/data/enums/method_type.dart";
import "package:better_auth_flutter/src/core/api/data/models/api_failure.dart";
import "package:better_auth_flutter/src/core/config/config.dart";
import "package:cookie_jar/cookie_jar.dart";
import "package:http/http.dart" as http;
import "package:path_provider/path_provider.dart";
import 'dart:developer';

class Api {
  static final hc = http.Client();

  static late PersistCookieJar _cookieJar;
  
  static String _basePath = "/api/auth";

  static Future<void> init({String basePath = "/api/auth"}) async {
    try {
      final cacheDir = await getApplicationCacheDirectory();
      _cookieJar = PersistCookieJar(
        storage: FileStorage("${cacheDir.path}/.cookies/"),
      );
      _basePath = basePath;
    } catch (e) {
      log("Failed to initialize cookie jar: ${e.toString()}", error: e);
    }
  }
  
  static String get basePath => _basePath;

  static Future<(dynamic, BetterAuthFailure?)> sendRequest(
    String path, {
    required MethodType method,
    String? host,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    int retry = 0,
  }) async {
    headers ??= {};
    host ??= Config.host;

    headers.addAll({
      "Accept": "application/json",
      "Content-Type": "application/json",
    });

    final Uri uri = Uri(
      scheme: Config.scheme,
      host: host,
      path: "$_basePath$path",
      queryParameters: queryParameters,
      port: Config.port,
    );

    final cookies = await _cookieJar.loadForRequest(
      Uri(scheme: uri.scheme, host: uri.host),
    );
    if (cookies.isNotEmpty) {
      headers["Cookie"] = cookies.map((c) => "${c.name}=${c.value}").join("; ");
    }

    final http.Response response;

    try {
      switch (method) {
        case MethodType.get:
          response = await hc.get(uri, headers: headers);
          break;
        case MethodType.post:
          response = await hc.post(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
      }
    } catch (e) {
      return (null, BetterAuthFailure(code: BetterAuthError.unKnownError));
    }

    final setCookieHeader = response.headers["set-cookie"];
    if (setCookieHeader != null) {
      final cookiesList =
          setCookieHeader.split(",").map((cookieString) {
            return Cookie.fromSetCookieValue(cookieString.trim());
          }).toList();

      bool isAuthRoute = uri.path.contains(_basePath);
      if (isAuthRoute) {
        final tempUri = Uri(scheme: uri.scheme, host: uri.host);
        await _cookieJar.saveFromResponse(tempUri, cookiesList);
      } else {
        await _cookieJar.saveFromResponse(uri, cookiesList);
      }
    }

    switch (response.statusCode) {
      case 200:
        try {
          final data = jsonDecode(response.body);
          return (data, null);
        } catch (e) {
          return (
            null,
            BetterAuthFailure(
              code: BetterAuthError.unKnownError,
              message: "Failed to parse response body",
            ),
          );
        }

      default:
        try {
          final body = jsonDecode(response.body);

          if (body is! Map<String, dynamic> ||
              !body.containsKey("code") ||
              !body.containsKey("message")) {
            return (
              null,
              BetterAuthFailure(
                code: BetterAuthError.unKnownError,
                message: "Invalid response format",
              ),
            );
          }

          return (
            null,
            BetterAuthFailure(
              code: BetterAuthError.values.firstWhere(
                (element) => element.code == body["code"],
              ),
              message: body["message"],
            ),
          );
        } catch (e) {
          return (
            null,
            BetterAuthFailure(
              code: BetterAuthError.unKnownError,
              message: "Failed to parse response body",
            ),
          );
        }
    }
  }
}
