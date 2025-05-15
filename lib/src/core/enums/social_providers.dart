enum SocialProvider { google, apple, x }

extension SocialProviderId on SocialProvider {
  String get id {
    switch (this) {
      case SocialProvider.google:
        return "google";
      case SocialProvider.apple:
        return "apple";
      case SocialProvider.x:
        return "twitter";
    }
  }
}
