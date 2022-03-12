import 'package:encrypt/encrypt.dart';

class EncryptionService {
  Encrypter? _encrypter;
  final _iv = IV.fromLength(16);

  EncryptionService() {
    _encrypter = Encrypter(AES(Key.fromLength(32)));
  }

  String encrypt(String plainText) {
    return _encrypter!.encrypt(plainText, iv: _iv).base64;
  }

  String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return _encrypter!.decrypt(encrypted, iv: _iv);
  }
}
