import 'package:encrypt/encrypt.dart';

import 'encryption_contract.dart';

class EncryptionService extends IEncryption {

  final Encrypter encryptor;
  final _iv = IV.fromLength(16);

  EncryptionService(this.encryptor);

  @override
  String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return encryptor.decrypt(encrypted, iv: _iv);
  }

  @override
  String encrypt(String text) {
    return encryptor.encrypt(text, iv: _iv).base64;
  }
}