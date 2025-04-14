import 'dart:developer';

import 'package:better_auth_flutter/better_auth_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final GoogleSignIn googleSignIn = GoogleSignIn(
    serverClientId:
        "455710607825-8gl4r9sdgubo5lrqg46194fjqmfq98tp.apps.googleusercontent.com",
  );

  void signUp() async {
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

  void signIn() async {
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

  void signOut() async {
    final error = await BetterAuth.instance.client.signOut();

    if (error != null) {
      log(error.message.toString());
      return;
    }

    await googleSignIn.signOut();

    log("Signed out");
  }

  void signInWithGoogle() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            ElevatedButton(onPressed: signUp, child: Text("Sign Up")),
            ElevatedButton(onPressed: signIn, child: Text("Sign In")),
            ElevatedButton(onPressed: signOut, child: Text("Sign Out")),
            ElevatedButton(
              onPressed: signInWithGoogle,
              child: Text("Google Sign In"),
            ),
          ],
        ),
      ),
    );
  }
}
