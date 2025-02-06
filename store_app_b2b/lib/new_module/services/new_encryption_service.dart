import 'package:b2c/utils/string_extensions.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class EncryptionService {
  EncryptionService._privateConstructor();

  static final EncryptionService instance =
      EncryptionService._privateConstructor();
  final encrypt.IV _iv = encrypt.IV.fromLength(16);
  final String keyString = "0123456789ABCDEF";

  String encryptString(String plaintext) {
    final key = encrypt.Key.fromUtf8(keyString);
    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(plaintext, iv: _iv);
    String ivString = base64.encode(_iv.bytes);
    logs("printing iv string -> $ivString:${encrypted.base64}");
    return "$ivString:${encrypted.base64}";
  }

  String decryptString(String encryptedText) {
    List<String> parts = encryptedText.split(':');
    final key = encrypt.Key.fromUtf8(keyString);
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypt.Encrypted.fromBase64(parts[1]);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
