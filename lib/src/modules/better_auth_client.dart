import "dart:async";
import "dart:developer";

import "package:better_auth_flutter/better_auth_flutter.dart";
import "package:better_auth_flutter/src/core/api/data/models/api_failure.dart";
import "package:better_auth_flutter/src/core/api/data/models/session.dart";
import "package:better_auth_flutter/src/core/api/data/models/user.dart";
import "package:better_auth_flutter/src/core/constants/app_constants.dart";
import "package:better_auth_flutter/src/core/enums/social_providers.dart";
import "package:better_auth_flutter/src/modules/email_and_password.dart";
import "package:better_auth_flutter/src/modules/id_token_auth.dart";
import "package:better_auth_flutter/src/modules/session_management.dart";

class BetterAuthClient {
  static final BetterAuthClient _instance = BetterAuthClient._internal();
  factory BetterAuthClient() => _instance;

  Timer? _autoRefreshSessionTicker;

  BetterAuthClient._internal() {
    startAutoRefreshSession();
  }

  Future<(Map<String, dynamic>?, Failure?)> Function({
    required String email,
    required String password,
    required String name,
  })
  signUpWithEmailAndPassword = EmailAndPassword.signUpWithEmailAndPassword;

  Future<(User?, Failure?)> Function({
    required String email,
    required String password,
  })
  signInWithEmailAndPassword = EmailAndPassword.signInWithEmailAndPassword;

  Future<Failure?> Function() signOut = EmailAndPassword.signOut;

  Future<(User?, Failure?)> Function({
    required SocialProvider provider,
    required String idToken,
    required String accessToken,
  })
  signInWithIdToken = IdTokenAuth.signInWithIdToken;

  Future<(Session?, Failure?)> Function() getSession =
      SessionManagement.getSession;

  Future<void> Function() refreshToken = SessionManagement.refreshToken;

  Future<void> Function() listAccounts = () async {
    try {
      final (response, failure) = await Api.sendRequest(
        AppEndpoints.listAccounts,
        method: MethodType.get,
      );

      if (failure != null) {
        log("Error listing accounts: ${failure.message}");
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
  };

  void startAutoRefreshSession() async {
    stopAutoRefreshSession();

    _autoRefreshSessionTicker = Timer.periodic(
      AppConstants.autoRefreshSessionInterval,
      (Timer t) => SessionManagement.autoRefreshTokenTick(),
    );
  }

  void stopAutoRefreshSession() {
    _autoRefreshSessionTicker?.cancel();
  }
}
