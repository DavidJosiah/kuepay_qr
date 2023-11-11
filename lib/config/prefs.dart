import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'utils.dart';

class Prefs {
  static SharedPreferences? prefInstance;

  static Future<SharedPreferences> get _pref async {
    prefInstance ??= await SharedPreferences.getInstance();
    return prefInstance!;
  }

  Future<String> get uID async {
    final pref = await _pref;
    final String mUserId = pref.getString('userId') ?? await Utils.encryptVariable("USER ID");
    final decrypted = await Utils.decryptVariable(mUserId);
    return jsonDecode(decrypted);
  }

  Future<String?> getString(String key) async {
    final userID = await uID;

    return (await _pref).getString('${userID}_$key');
  }

  Future<double?> getDouble(String key) async {
    final userID = await uID;

    return (await _pref).getDouble('${userID}_$key');
  }

  Future<bool?> getBool(String key) async {
    final userID = await uID;

    return (await _pref).getBool('${userID}_$key');
  }

  Future<List<String>?> getStringList(String key) async {
    final userID = await uID;

    return (await _pref).getStringList('${userID}_$key');
  }

  Future<void> setUID (String uID) async {
    final pref = await _pref;
    await pref.setString('userId', await Utils.encryptVariable(uID));
  }

  Future<void> setString (String key, String value) async {
    final userID = await uID;
    (await _pref).setString('${userID}_$key', value);
  }

  Future<void> setDouble (String key, double value) async {
    final userID = await uID;
    (await _pref).setDouble('${userID}_$key', value);
  }

  Future<void> setBool (String key, bool value) async {
    final userID = await uID;
    (await _pref).setBool('${userID}_$key', value);
  }

  Future<void> setStringList (String key, List<String> value) async {
    final userID = await uID;
    (await _pref).setStringList('${userID}_$key', value);
  }
}

