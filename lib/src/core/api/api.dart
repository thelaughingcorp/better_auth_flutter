import "dart:convert";
import "package:better_auth_flutter/src/core/api/data/enums/error_type.dart";
import "package:better_auth_flutter/src/core/api/data/enums/method_type.dart";
import "package:better_auth_flutter/src/core/api/data/models/api_failure.dart";
import "package:better_auth_flutter/src/core/constants/app_constants.dart";
import "package:better_auth_flutter/src/core/local_storage/kv_store.dart"
    show KVStore;
import "package:better_auth_flutter/src/core/local_storage/kv_store_keys.dart";
import "package:http/http.dart" as http;

class Api {
  static final hc = http.Client();

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
