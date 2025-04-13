import "package:better_auth_flutter/src/core/api/api.dart";
import "package:better_auth_flutter/src/core/api/data/enums/error_type.dart";
import "package:better_auth_flutter/src/core/api/data/enums/method_type.dart";
import "package:better_auth_flutter/src/core/api/data/models/api_failure.dart";
import "package:better_auth_flutter/src/core/api/data/models/user.dart";
import "package:better_auth_flutter/src/core/constants/app_endpoints.dart";
import "package:better_auth_flutter/src/core/enums/social_providers.dart";
import "package:better_auth_flutter/src/core/local_storage/kv_store.dart";
import "package:better_auth_flutter/src/core/local_storage/kv_store_keys.dart";

class IdTokenAuth {
  static Future<(User?, Failure?)> signInWithIdToken({
    required SocialProvider provider,
    required String idToken,
  }) async {
    try {
      final (result, error) = await Api.sendRequest(
        AppEndpoints.socialSignIn,
        method: MethodType.post,
        body: {"provider": provider.id, "idToken": idToken},
      );

      if (error != null) return (null, error);

      if (result is! Map<String, dynamic>) {
        return (null, Failure(code: BetterAuthError.invalidResponse));
      }

      final user = User.fromMap(result["user"] as Map<String, dynamic>);

      final accessToken = result["accessToken"] as String;

      await KVStore.set(KVStoreKeys.accessToken, accessToken);
      await KVStore.set(KVStoreKeys.user, user.toJson());

      return (user, null);
    } catch (e) {
      return (
        null,
        Failure(code: BetterAuthError.unKnownError, message: e.toString()),
      );
    }
  }
}
