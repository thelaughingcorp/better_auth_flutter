import 'package:better_auth_flutter/better_auth_flutter.dart';
import 'package:better_auth_flutter_example/home.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BetterAuth.init();
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
