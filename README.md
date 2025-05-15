# better_auth_flutter

Flutter client-side SDK for Better Auth — simplifies integration with the Better Auth backend. Supports email/password authentication, social login, session management, and secure storage.

P.S if you have any suggestions or want to contribute to this, reach out to me [https://x.com/ekaksh_janweja](here)

## Features

- Email/password sign up, sign in, and sign out
- Social login (Google & Apple) via ID token
- Automatic session retrieval and validation
- Persistent cookie-based sessions with `cookie_jar`
- Easy-to-use singleton client: `BetterAuth.instance.client`

## Getting Started

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  better_auth_flutter: ^0.0.1
```

Then run:

```bash
flutter pub get
```

### Initialization

Before using any API, initialize the SDK (e.g., in your `main.dart`):

```dart
import 'package:flutter/material.dart';
import 'package:better_auth_flutter/better_auth_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BetterAuth.init(baseUrl: Uri(scheme: "http", host: "localhost", port: 8080)); //URI of your backend
  runApp(MyApp());
}
```
