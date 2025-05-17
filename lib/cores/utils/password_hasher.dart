import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class PasswordHasher {
  static String generateSalt([int length = 32]) {
    final random = Random.secure();
    final saltBytes = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(saltBytes);
  }

  static String hashPassword(String password, String salt) {
    final codec = Utf8Codec();
    final key = codec.encode(password);
    final saltBytes = codec.encode(salt);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(saltBytes);
    return digest.toString();
  }

  static bool verifyPassword(
    String enteredPassword, 
    String storedHash, 
    String salt,
  ) {
    final hash = hashPassword(enteredPassword, salt);
    return hash == storedHash;
  }
}