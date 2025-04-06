import "dart:convert";
import "package:better_auth_flutter/src/core/api/data/enums/error_type.dart";
import "package:better_auth_flutter/src/core/api/data/enums/method_type.dart";
import "package:better_auth_flutter/src/core/api/data/models/api_failure.dart";
import "package:better_auth_flutter/src/core/constants/app_constants.dart";
import "package:better_auth_flutter/src/core/local_storage/kv_store.dart";
import "package:better_auth_flutter/src/core/local_storage/kv_store_keys.dart";
import "package:cookie_jar/cookie_jar.dart";
import "package:http/http.dart" as http;
import "package:path_provider/path_provider.dart";

class Api {
  static final hc = http.Client();

  static late PersistCookieJar _cookieJar;

  static Future<void> init() async {
    final cacheDir = await getApplicationCacheDirectory();
    _cookieJar = PersistCookieJar(
      storage: FileStorage("${cacheDir.path}/.cookies/"),
    );
  }

  static Future<(dynamic, Failure?)> sendRequest(
    String path, {
    required MethodType method,
    String? host,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    int retry = 0,
  }) async {
    headers ??= {};
    host ??= AppConstants.defaultHost;

    final accessToken = KVStore.get<String>(KVStoreKeys.accessToken);

    if (!headers.containsKey("Authorization")) {
      headers["Authorization"] = "Bearer $accessToken";
    }

    headers.addAll({
      "Accept": "application/json",
      "Content-Type": "application/json",
    });

    final Uri uri = Uri(
      scheme: AppConstants.scheme,
      host: host,
      path: path,
      queryParameters: queryParameters,
      port: AppConstants.port,
    );

    final cookies = await _cookieJar.loadForRequest(uri);
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
      return (null, Failure(code: BetterAuthError.unKnownError));
    }

    final setCookieHeader = response.headers["set-cookie"];
    if (setCookieHeader != null) {
      final cookiesList =
          setCookieHeader.split(",").map((cookieString) {
            return Cookie.fromSetCookieValue(cookieString.trim());
          }).toList();
      await _cookieJar.saveFromResponse(uri, cookiesList);
    }

    switch (response.statusCode) {
      case 200:
        try {
          final data = jsonDecode(response.body);

          if (data is! Map<String, dynamic>) {
            return (
              null,
              Failure(
                code: BetterAuthError.unKnownError,
                message: "Invalid response format",
              ),
            );
          }

          // if (response.headers.containsKey("set-cookie")) {
          //   final cookie = response.headers["set-cookie"];
          //   if (cookie != null) {
          //     log("Cookie: $cookie");
          //   }
          // }

          return (data, null);
        } catch (e) {
          return (
            null,
            Failure(
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
              Failure(
                code: BetterAuthError.unKnownError,
                message: "Invalid response format",
              ),
            );
          }

          return (
            null,
            Failure(
              code: BetterAuthError.values.firstWhere(
                (element) => element.code == body["code"],
              ),
              message: body["message"],
            ),
          );
        } catch (e) {
          return (
            null,
            Failure(
              code: BetterAuthError.unKnownError,
              message: "Failed to parse response body",
            ),
          );
        }
    }
  }
}
