import "dart:convert";
import "package:better_auth_flutter/src/core/api/data/enums/error_type.dart";

class Failure {
  final BetterAuthError code;
  final String message;

  Failure({
    required this.code,
    this.message = "An unexpected error occurred. Please try again later.",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{"errorType": code.message, "message": message};
  }

  factory Failure.fromMap(Map<String, dynamic> map) {
    return Failure(
      code: BetterAuthError.values.firstWhere(
        (element) => element.message == map["errorType"],
      ),
      message: map["message"] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Failure.fromJson(String source) =>
      Failure.fromMap(json.decode(source) as Map<String, dynamic>);
}
