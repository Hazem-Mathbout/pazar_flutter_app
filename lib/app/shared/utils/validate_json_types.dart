import 'dart:developer';

/// ✅ Goal
///
/// Detect when an API field is of a different type than your model expects, and log which field caused the mismatch.
void validateJsonTypes(
    Map<String, Type> expectedTypes, Map<String, dynamic> json) {
  for (var key in expectedTypes.keys) {
    final expectedType = expectedTypes[key];
    final actualValue = json[key];

    if (actualValue == null) {
      log("⚠️ Key '$key' is null.");
      continue;
    }

    if (actualValue.runtimeType != expectedType) {
      log("❌ Type mismatch for '$key': expected ${expectedType.toString()}, got ${actualValue.runtimeType}");
    }
  }
}
