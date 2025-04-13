enum SocialProvider { google, github }

extension SocialProviderId on SocialProvider {
  String get id {
    switch (this) {
      case SocialProvider.google:
        return "google";
      case SocialProvider.github:
        return "github";
    }
  }
}
