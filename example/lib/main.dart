import 'dart:developer';
import 'package:better_auth_flutter/better_auth_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BetterAuth.init(baseUrl: Uri(scheme: "http", host: "10.0.2.2", port: 8000));
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Better Auth Flutter",
      home: Home(),
      theme: ThemeData.dark(useMaterial3: true),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            ElevatedButton(onPressed: Repo.signUp, child: Text("Sign Up")),
            ElevatedButton(onPressed: Repo.signIn, child: Text("Sign In")),
            ElevatedButton(onPressed: Repo.signOut, child: Text("Sign Out")),
            ElevatedButton(
              onPressed: Repo.signInWithGoogle,
              child: Text("Google Sign In"),
            ),
            ElevatedButton(
              onPressed: Repo.getSession,
              child: Text("Get Session"),
            ),

            ElevatedButton(
              onPressed: Repo.listAccounts,
              child: Text("List Accounts"),
            ),
            ElevatedButton(
              onPressed: Repo.loginWithX,
              child: Text("Login With X"),
            ),
          ],
        ),
      ),
    );
  }
}

class Repo {
  static final betterAuth = BetterAuth.instance.client;

  static final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: "");

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

  static void listAccounts() async {
    await betterAuth.listAccounts();
  }

  static void loginWithX() async {
    await betterAuth.loginWithX();
  }
}
