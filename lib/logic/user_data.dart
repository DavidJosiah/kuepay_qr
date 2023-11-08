import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:kuepay_qr/config/config.dart';

class UserData {

  static SharedPreferences? prefInstance;

  static Future<SharedPreferences> get _pref async {
    prefInstance ??= await SharedPreferences.getInstance();
    return prefInstance!;
  }

  static Future<Map<String, dynamic>> get details async {
    final String mUserId = await userId;
    final String mName = await name;
    final double mAvailableLimit = await availableLimit;
    final String mEncryptedPin = await pin;

    return {
      "userId": mUserId,
      "name": mName,
      "availableLimit": mAvailableLimit,
      "pin": mEncryptedPin,
    };
  }

  static Future<String> get userId async {
    final pref = await _pref;
    final String mUserId = pref.getString('userId') ?? await Utils.encryptVariable("USER ID");
    final decrypted = await Utils.decryptVariable(mUserId);
    return jsonDecode(decrypted);
  }

  static Future<String> get name async {
    final pref = await _pref;
    final String mName = pref.getString('name') ?? await Utils.encryptVariable("NAME");
    final decrypted = await Utils.decryptVariable(mName);
    return jsonDecode(decrypted);
  }

  static Future<double> get availableLimit async {
    final pref = await _pref;
    final String mAvailableLimit = pref.getString('availableLimit') ?? await Utils.encryptVariable(50000);
    final decrypted = await Utils.decryptVariable(mAvailableLimit);
    return (jsonDecode(decrypted) as num).toDouble();
  }

  static Future<String> get pin async {
    final pref = await _pref;
    final defaultPin = await Utils.encryptVariable(await Utils.encryptVariableHMAC('pin'));

    final String mEncryptedPin = pref.getString('encryptedPin') ?? defaultPin;
    final decrypted = await Utils.decryptVariable(mEncryptedPin);
    return jsonDecode(decrypted);
  }

  static Future<void> setUserId(String value) async {
    if(value.trim().isNotEmpty){
      final pref = await _pref;
      await pref.setString('userId', await Utils.encryptVariable(value));
    }
  }

  static Future<void> setName(String value) async {
    if(value.trim().isNotEmpty){
      final pref = await _pref;
      await pref.setString('name', await Utils.encryptVariable(value));
    }
  }

  static Future<void> setAvailableLimit(double value) async {
    if(value.toString().trim().isNotEmpty) {
      final pref = await _pref;
      await pref.setString('availableLimit', await Utils.encryptVariable(value));
    }
  }

  static Future<void> setPin(String value) async {
    if(value.trim().isNotEmpty){
      final pref = await _pref;
      await pref.setString('encryptedPin', await Utils.encryptVariable(value));
    }
  }

  static Future<void> resetLimit() async {
    final pref = await _pref;

    //TODO make dynamic based on kyc
    await pref.setString('availableLimit', await Utils.encryptVariable(50000));
  }
}