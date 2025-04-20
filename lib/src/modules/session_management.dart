import "dart:convert";
import "package:better_auth_flutter/src/core/api/api.dart";
import "package:better_auth_flutter/src/core/api/data/enums/error_type.dart";
import "package:better_auth_flutter/src/core/api/data/enums/method_type.dart";
import "package:better_auth_flutter/src/core/api/data/models/api_failure.dart";
import "package:better_auth_flutter/src/core/api/data/models/session.dart";
import "package:better_auth_flutter/src/core/api/data/models/user.dart";
import "package:better_auth_flutter/src/core/constants/app_endpoints.dart";
import "../core/local_storage/kv_store.dart";
import "../core/local_storage/kv_store_keys.dart";

class SessionManagement {
  static Future<((Session?, User?)?, Failure?)> getSession() async {
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

      await KVStore.set(KVStoreKeys.user, user.toJson());
      await KVStore.set(KVStoreKeys.session, session.toJson());

      return ((session, user), null);
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
}
