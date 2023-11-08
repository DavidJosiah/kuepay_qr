import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'platform_interface.dart';

class KeyStore extends KuepayQrPlatform {

  @visibleForTesting
  final methodChannel = const MethodChannel('kuepay_qr');

  @override
  Future<String> encryptString (String data) async {
    if(Platform.isAndroid){
      try {
        return await methodChannel.invokeMethod(
            'encryptString',
            <String, String>{
              'data': data
            }
        ) ?? "";
      }
      on PlatformException catch (e) {
        if(kDebugMode) {
          print(e);
        }
        return "";
      }
    } else {
      //TODO implement for iOS
      return "";
    }

  }

  @override
  Future<String> decryptString (String data) async {
    if(Platform.isAndroid){
      try {
        return await methodChannel.invokeMethod(
            'decryptString',
            <String, String>{
              'data': data
            }
        ) ?? "";
      }
      on PlatformException catch (e) {
        if(kDebugMode) {
          print(e);
        }
        return "";
      }
    } else {
      //TODO implement for iOS
      return "";
    }

  }
}