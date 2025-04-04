import 'dart:developer';

import 'package:better_auth_flutter/better_auth_flutter.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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

    log("Signed out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: signUp, child: Text("Sign Up")),
            ElevatedButton(onPressed: signIn, child: Text("Sign In")),
            ElevatedButton(onPressed: signOut, child: Text("Sign Out")),
          ],
        ),
      ),
    );
  }
}
