import "dart:convert";
import "dart:developer";
import "package:better_auth_flutter/src/core/api/api.dart";
import "package:better_auth_flutter/src/core/api/data/enums/error_type.dart";
import "package:better_auth_flutter/src/core/api/data/enums/method_type.dart";
import "package:better_auth_flutter/src/core/api/data/models/api_failure.dart";
import "package:better_auth_flutter/src/core/api/data/models/session.dart";
import "package:better_auth_flutter/src/core/api/data/models/user.dart";
import "package:better_auth_flutter/src/core/constants/app_constants.dart";
import "package:better_auth_flutter/src/core/constants/app_endpoints.dart";
import "../core/local_storage/kv_store.dart";
import "../core/local_storage/kv_store_keys.dart";

class SessionManagement {
  static Future<void> refreshToken() async {
    try {
      final (result, error) = await Api.sendRequest(
        AppEndpoints.refreshToken,
        method: MethodType.post,
        body: {
          "providerId": "google",
          "accountId": "100196553826168367924",
          "userId": "DkH10ea7UIQMAcXkv49Wdhlx46n02Ave",
        },
      );

      if (error != null) {
        log("Error in refreshToken: $error");
        return;
      }

      if (result is! Map<String, dynamic>) {
        log("Error in refreshToken: Invalid response");
        return;
      }

      log("Refresh token result: $result");
    } catch (e) {
      log("Error in refreshToken: $e");
      return;
    }
  }

  static Future<(Session?, Failure?)> getSession() async {
    try {
      final (result, error) = await Api.sendRequest(
        AppEndpoints.getSession,
        method: MethodType.get,
      );

      if (error != null) return (null, error);

      if (result is! Map<String, dynamic>) {
        return (null, Failure(code: BetterAuthError.invalidResponse));
      }

      final session = Session.fromMap(
        result["session"] as Map<String, dynamic>,
      );
      final user = User.fromMap(result["user"] as Map<String, dynamic>);

      if (session.expiresAt.isBefore(DateTime.now())) {
        return (
          null,
          Failure(
            code: BetterAuthError.sessionExpired,
            message: "Session expired",
          ),
        );
      }

      await KVStore.set(KVStoreKeys.accessToken, session.token);
      await KVStore.set(KVStoreKeys.user, user.toJson());
      await KVStore.set(KVStoreKeys.session, session.toJson());

      return (session, null);
    } catch (e) {
      return (
        null,
        Failure(code: BetterAuthError.unKnownError, message: e.toString()),
      );
    }
  }

  static Future<(Session?, Failure?)> loadSession() async {
    try {
      final sessionString = KVStore.get<String>(KVStoreKeys.session);

      if (sessionString == null) {
        return (null, Failure(code: BetterAuthError.sessionExpired));
      }

      final session = Session.fromJson(jsonDecode(sessionString));

      if (session.expiresAt.isBefore(DateTime.now())) {
        return (null, Failure(code: BetterAuthError.sessionExpired));
      }

      return (session, null);
    } catch (e) {
      return (
        null,
        Failure(code: BetterAuthError.unKnownError, message: e.toString()),
      );
    }
  }

  static Future<void> autoRefreshTokenTick() async {
    try {
      final now = DateTime.now();

      final (session, error) = await loadSession();

      if (error != null) return;

      if (session == null) {
        log("Session is null");
        return;
      }

      final expiresAt = session.expiresAt;

      final expiresInTicks =
          (expiresAt.difference(now).inMilliseconds /
                  AppConstants.autoRefreshSessionInterval.inMilliseconds)
              .floor();

      if (expiresInTicks < AppConstants.autoRefreshSessionTickThreshhold) {
        //TODO: Refresh token or get session
      }
    } catch (e) {
      log("Error in autoRefreshTokenTick: $e");
      return;
    }
  }
}
