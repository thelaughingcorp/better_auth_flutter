import "dart:async";
import "package:better_auth_flutter/src/core/api/data/models/account.dart";
import "package:better_auth_flutter/src/core/api/data/models/api_failure.dart";
import "package:better_auth_flutter/src/core/api/data/models/session.dart";
import "package:better_auth_flutter/src/core/api/data/models/user.dart";
import "package:better_auth_flutter/src/core/enums/social_providers.dart";
import "package:better_auth_flutter/src/modules/accounts.dart";
import "package:better_auth_flutter/src/modules/auth.dart";
import "package:better_auth_flutter/src/modules/session_management.dart";
import "package:better_auth_flutter/src/modules/verification.dart";

class BetterAuthClient {
  static final BetterAuthClient _instance = BetterAuthClient._internal();
  factory BetterAuthClient() => _instance;

  BetterAuthClient._internal();

  Future<(Map<String, dynamic>?, Failure?)> Function({
    required String email,
    required String password,
    required String name,
  })
  signUpWithEmailAndPassword = Auth.signUpWithEmailAndPassword;

  Future<(User?, Failure?)> Function({
    required String email,
    required String password,
  })
  signInWithEmailAndPassword = Auth.signInWithEmailAndPassword;

  Future<Failure?> Function() signOut = Auth.signOut;

  Future<(User?, Failure?)> Function({
    required SocialProvider provider,
    required String idToken,
    required String accessToken,
  })
  signInWithIdToken = Auth.signInWithIdToken;

  Future<((Session?, User?)?, Failure?)> Function() getSession =
      SessionManagement.getSession;

  Future<Failure?> Function({required String email}) sendVerificationEmail =
      Verification.sendVerificationEmail;

  Future<Failure?> Function({required String verificationToken}) verifyEmail =
      Verification.verifyEmail;

  Future<(List<Account>?, Failure?)> Function() listAccounts =
      Accounts.listAccounts;
}
