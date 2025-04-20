import "package:better_auth_flutter/better_auth_flutter.dart";
import "package:better_auth_flutter/src/core/local_storage/kv_store.dart";
import "package:better_auth_flutter/src/core/local_storage/kv_store_keys.dart";

class EmailAndPassword {
  static Future<(Map<String, dynamic>?, Failure?)> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final (result, error) = await Api.sendRequest(
        AppEndpoints.signUpWithEmailAndPassword,
        method: MethodType.post,
        body: {"email": email, "password": password, "name": name},
      );

      if (error != null) return (null, error);

      return (result as Map<String, dynamic>, null);
    } catch (e) {
      return (
        null,
        Failure(code: BetterAuthError.unKnownError, message: e.toString()),
      );
    }
  }

  static Future<(User?, Failure?)> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final (result, error) = await Api.sendRequest(
        AppEndpoints.signInWithEmailAndPassword,
        method: MethodType.post,
        body: {"email": email, "password": password},
      );

      if (error != null) return (null, error);

      if (result is! Map<String, dynamic>) {
        return (null, Failure(code: BetterAuthError.unKnownError));
      }

      final user = User.fromMap(result["user"] as Map<String, dynamic>);

      return (user, null);
    } catch (e) {
      return (
        null,
        Failure(code: BetterAuthError.unKnownError, message: e.toString()),
      );
    }
  }

  static Future<Failure?> signOut() async {
    try {
      final (result, error) = await Api.sendRequest(
        AppEndpoints.signOut,
        method: MethodType.post,
      );

      if (error != null) return error;

      if (result is! Map<String, dynamic>) {
        return Failure(code: BetterAuthError.failedToSignOut);
      }

      if (result["success"] == false) {
        return Failure(code: BetterAuthError.failedToSignOut);
      }

      await KVStore.remove(KVStoreKeys.session);

      return null;
    } catch (e) {
      return Failure(
        code: BetterAuthError.failedToSignOut,
        message: e.toString(),
      );
    }
  }
}
