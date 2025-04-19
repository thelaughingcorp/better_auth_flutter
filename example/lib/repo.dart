import 'dart:developer';

import 'package:better_auth_flutter/better_auth_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Repo {
  static final betterAuth = BetterAuth.instance.client;

  static final GoogleSignIn googleSignIn = GoogleSignIn(
    serverClientId:
        "455710607825-8gl4r9sdgubo5lrqg46194fjqmfq98tp.apps.googleusercontent.com",
  );

  static void signUp() async {
    final (result, error) = await BetterAuth.instance.client
        .signUpWithEmailAndPassword(
          email: "test@test.com",
          password: "password",
          name: "test",
        );

    if (error != null) {
      log(error.message.toString());
      return;
    }

    log(result.toString());
  }

  static void signIn() async {
    final (result, error) = await BetterAuth.instance.client
        .signInWithEmailAndPassword(
          email: "test@test.com",
          password: "password",
        );

    if (error != null) {
      log(error.message.toString());
      return;
    }

    log(result.toString());
  }

  static void signOut() async {
    final error = await BetterAuth.instance.client.signOut();

    if (error != null) {
      log(error.message.toString());
      return;
    }

    await googleSignIn.signOut();

    log("Signed out");
  }

  static void signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount == null) {
      log("Google sign in cancelled");
      return;
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final accessToken = googleSignInAuthentication.accessToken;
    final idToken = googleSignInAuthentication.idToken;

    if (accessToken == null) {
      log("Google access token is null");
      return;
    }

    if (idToken == null) {
      log("Google id token is null");
      return;
    }

    final (res, err) = await BetterAuth.instance.client.signInWithIdToken(
      provider: SocialProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    if (err != null) {
      log(err.message.toString());
      return;
    }

    log(res.toString());
  }

  static void getSession() async {
    final (session, error) = await BetterAuth.instance.client.getSession();
    if (error != null) {
      log(error.message.toString());
      return;
    }

    log(session.toString());
  }
}
