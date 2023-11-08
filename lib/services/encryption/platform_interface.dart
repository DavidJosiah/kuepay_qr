import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'key_store.dart';

abstract class KuepayQrPlatform extends PlatformInterface {
  KuepayQrPlatform() : super(token: _token);

  static final Object _token = Object();

  static KuepayQrPlatform _instance = KeyStore();

  static KuepayQrPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KuepayQrPlatform] when
  /// they register themselves.
  static set instance(KuepayQrPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> encryptString(String data) {
    throw UnimplementedError('encryptString() has not been implemented.');
  }

  Future<String> decryptString(String data) {
    throw UnimplementedError('decryptString() has not been implemented.');
  }
}