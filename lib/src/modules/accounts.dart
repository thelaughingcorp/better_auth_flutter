import "dart:developer";

import "package:better_auth_flutter/better_auth_flutter.dart";

class Accounts {
  static Future<void> listAccounts() async {
    try {
      final (response, failure) = await Api.sendRequest(
        AppEndpoints.listAccounts,
        method: MethodType.get,
      );

      if (failure != null) {
        log("Error listing accounts: ${failure.toJson()}");
        return;
      }

      if (response == null) {
        return;
      }

      log("List accounts: $response");
    } catch (e) {
      log("Error listing accounts: $e");
      return;
    }
  }
}
