import "dart:async";
import "package:better_auth_flutter/src/core/api/data/models/api_failure.dart";
import "package:better_auth_flutter/src/core/api/data/models/session.dart";
import "package:better_auth_flutter/src/core/api/data/models/user.dart";
import "package:better_auth_flutter/src/core/enums/social_providers.dart";
import "package:better_auth_flutter/src/modules/accounts.dart";
import "package:better_auth_flutter/src/modules/email_and_password.dart";
import "package:better_auth_flutter/src/modules/id_token_auth.dart";
import "package:better_auth_flutter/src/modules/session_management.dart";

class BetterAuthClient {
  static final BetterAuthClient _instance = BetterAuthClient._internal();
  factory BetterAuthClient() => _instance;

  BetterAuthClient._internal();

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

  Future<((Session?, User?)?, Failure?)> Function() getSession =
      SessionManagement.getSession;

  Future<void> Function() listAccounts = Accounts.listAccounts;
}
