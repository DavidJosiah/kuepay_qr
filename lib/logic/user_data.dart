import 'dart:convert';

import 'package:kuepay_qr/config/config.dart';

import 'offline_wallet.dart';

class UserData {

  static final prefs = Prefs();

  static Future<Map<String, dynamic>> get details async {
    final String mUserId = await userId;
    final String mName = await name;
    final double mAvailableLimit = await availableLimit;
    final String mPin = await pin;

    return {
      "userId": mUserId,
      "name": mName,
      "availableLimit": mAvailableLimit,
      "pin": mPin,
    };
  }

  static Future<bool> get hasUserSetID async {
    final result = await userId;
    return result != "USER ID";
  }

  static Future<String> get userId async {
    return await prefs.uID;
  }

  static Future<String> get accessToken async {
    final String mAccessToken = await prefs.getString('accessToken') ?? await Utils.encryptVariable("ACCESS TOKEN");
    final decrypted = await Utils.decryptVariable(mAccessToken);
    return jsonDecode(decrypted);
  }

  static Future<String> get name async {
    final String mName = await prefs.getString('name') ?? await Utils.encryptVariable("NAME");
    final decrypted = await Utils.decryptVariable(mName);
    return jsonDecode(decrypted);
  }

  static Future<double> get availableLimit async {
    final String mAvailableLimit = await prefs.getString('availableLimit') ?? await Utils.encryptVariable(50000);
    final decrypted = await Utils.decryptVariable(mAvailableLimit);
    return (jsonDecode(decrypted) as num).toDouble();
  }

  static Future<bool> get hasUserSetPin async {
    final result = await pin;
    return result.length == 4;
  }

  static Future<String> get pin async {
    final String mPin = await prefs.getString('pin') ?? await Utils.encryptVariable('pin');
    final decrypted = await Utils.decryptVariable(mPin);
    return jsonDecode(decrypted);
  }

  static Future<void> setAccessToken(String value) async {
    if(value.trim().isNotEmpty) {
      await prefs.setString(
          'accessToken', await Utils.encryptVariable(value));
    }
  }

  static Future<void> setUserId(String value) async {
    if(value.trim().isNotEmpty) {
      await prefs.setUID(value);
    }
  }

  static Future<void> setName(String value) async {
    if(value.trim().isNotEmpty) {
      await prefs.setString('name', await Utils.encryptVariable(value));
    }
  }

  static Future<void> setAvailableLimit(double value) async {
    await prefs.setString('availableLimit', await Utils.encryptVariable(value));
  }

  static Future<void> setPin(String value) async {
    if(value.trim().isNotEmpty) {
      await prefs.setString('pin', await Utils.encryptVariable(value));
    }
  }

  static Future<void> resetLimit() async {
    await prefs.setString('availableLimit', await Utils.encryptVariable(50000));
  }

  static Future<bool> isDataComplete() async {

    if(!await UserData.hasUserSetID) return false;
    if(!await UserData.hasUserSetPin) return false;
    if((await UserData.name).isEmpty) return false;
    if((await OfflineWallet.address).isEmpty) return false;
    if((await OfflineWallet.details).isEmpty) return false;

    return true;
  }
}