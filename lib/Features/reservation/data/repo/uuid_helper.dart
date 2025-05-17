import 'package:uuid/uuid.dart';

class UuidHelper {
  static const Uuid _uuid = Uuid();

  static String generate() => _uuid.v4();

  static bool isValid(String? uuid) {
    if (uuid == null || uuid.isEmpty) return false;
    return RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    ).hasMatch(uuid);
  }
}
