import "package:better_auth_flutter/better_auth_flutter.dart";
import "package:better_auth_flutter/src/core/local_storage/kv_store.dart";
import "package:better_auth_flutter/src/modules/better_auth_client.dart";

class BetterAuth {
  BetterAuth._() {
    init();
  }

  static final BetterAuth _instance = BetterAuth._();
  factory BetterAuth() => _instance;

  static BetterAuth get instance => _instance;

  final BetterAuthClient _client = BetterAuthClient();
  BetterAuthClient get client => _client;

  static void init() async {
    await KVStore.init();
    await Api.init();
  }
}
