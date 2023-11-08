import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:kuepay_qr/config/config.dart';

class OfflineWallet {

  static SharedPreferences? prefInstance;

  static Future<SharedPreferences> get _pref async {
    prefInstance ??= await SharedPreferences.getInstance();
    return prefInstance!;
  }

  static Future<Map<String, String>> get details async {
    final String mId = await id;
    final String mAddress = await address;
    final String mCurrency = await currency;
    final String mBalance = await balance;

    return {
      "id": mId,
      "currency": mCurrency,
      "walletAddress": mAddress,
      "walletBalance": mBalance,
    };
  }

  static Future<String> get id async {
    final pref = await _pref;
    final String mId = pref.getString('walletId') ?? "1";
    final decrypted = await Utils.decryptVariable(mId);
    return jsonDecode(decrypted);  }

  static Future<String> get address async {
    final pref = await _pref;
    final String mAddress = pref.getString('address') ?? await Utils.encryptVariable("ADDRESS");
    final decrypted = await Utils.decryptVariable(mAddress);
    return jsonDecode(decrypted);  }

  static Future<String> get currency async {
    final pref = await _pref;
    final String mCurrency = pref.getString('currency') ?? await Utils.encryptVariable(Constants.nairaSign);
    final decrypted = await Utils.decryptVariable(mCurrency);
    return jsonDecode(decrypted);
  }

  static Future<String> get balance async {
    final pref = await _pref;
    final String mBalance = pref.getString('balance') ?? await Utils.encryptVariable("00.00");
    final decrypted = await Utils.decryptVariable(mBalance);
    return jsonDecode(decrypted);
  }

  static Future<void> setId(String value) async {
    if(value.trim().isNotEmpty){
      final pref = await _pref;
      await pref.setString('walletId', await Utils.encryptVariable(value));
    }
  }

  static Future<void> setAddress(String value) async {
    if(value.trim().isNotEmpty){
      final pref = await _pref;
      await pref.setString('address', await Utils.encryptVariable(value));
    }
  }

  static Future<void> setCurrency(String value) async {
    if(value.trim().isNotEmpty) {
      final pref = await _pref;
      await pref.setString('currency', await Utils.encryptVariable(value));
    }
  }

  static Future<void> setBalance(String value) async {
    if(value.trim().isNotEmpty){
      final pref = await _pref;
      await pref.setString('balance', await Utils.encryptVariable(value));
    }
  }

  static Future<void> credit(double value) async {
    final currentBalance = await balance;
    await setBalance((num.parse(currentBalance).toDouble() + value).toString());
  }

  static Future<void> debit(double value) async {
    final currentBalance = await balance;
    await setBalance((num.parse(currentBalance).toDouble() - value).toString());
  }
}