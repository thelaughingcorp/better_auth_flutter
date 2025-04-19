import 'package:better_auth_flutter_example/repo.dart';
import 'package:flutter/material.dart';

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
          ],
        ),
      ),
    );
  }
}
