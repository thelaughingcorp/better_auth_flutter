enum SocialProvider { google, github, apple }

extension SocialProviderId on SocialProvider {
  String get id {
    switch (this) {
      case SocialProvider.google:
        return "google";
      case SocialProvider.github:
        return "github";
      case SocialProvider.apple:
        return "apple";
    }
  }
}
