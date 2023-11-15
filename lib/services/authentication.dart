import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kuepay_qr/logic/logic.dart';
import 'package:kuepay_qr/shared/shared.dart';

import 'package:kuepay_qr/config/config.dart';

import 'services.dart';

class Auth {

  final String base = "${Api().base}/account";
  final postRequest = Api().postRequest;
  final getRequest = Api().getRequest;

  void showErrorMessage (String message) {
    Api.showErrorMessage(message);
  }


  Future<String> signUp({
    required String name,
    required String phoneNumber,
    required String password,
    required String pin,
  }) async {

    if(pin.length != 4){
      Toast.show(message: "Pin should be 4-digit", type: ToastType.error);
      return "";
    }

    String path = "/signup";
    String url = '$base$path';

    final body = json.encode({
      "name" : name,
      "phoneNumber": phoneNumber,
      "password": password,
    });

    final data = await postRequest(url, body, isSignUp: true, verifyToken: false);

    final result = data["success"] ?? false;

    if(result){
      await setPin(pin);
    }

    return data["data"]["uID"] ?? "";
  }

  Future<bool> signIn({
    required String userID,
    required String password,
  }) async {

    String path = "/login";
    String url = '$base$path';

    final body = json.encode({
      "userID": userID,
      "password": password,
    });

    final result = await postRequest(url, body, isSignIn: true, verifyToken: false);

    if (result.isNotEmpty) {
      final userID = result['data']['userId'];
      final name = result['data']['name'];

      final walletAddress = result['data']['walletAddress'];
      final walletId = result['data']['walletId'];

      await UserData.setUserId(userID);
      await UserData.setName(name);
      await UserData.resetLimit();

      await OfflineWallet.setAddress(walletAddress);
      await OfflineWallet.setCurrency(Constants.nairaSign);
      await OfflineWallet.setId(walletId);

      await OfflineWallet.setBalance(await OfflineWallet.balance);

      await UserData.setAccessToken(result['token']['accesstoken']);

      final prefs = Prefs();

      await prefs.setString('previousSignIn', DateTime.now().millisecondsSinceEpoch.toString());
      await prefs.setString('tokenExpiry', result['token']['tokenExpire'].toString().split(' ')[0]);
      await prefs.setString('lastVerification', DateTime.now().millisecondsSinceEpoch.toString());

    }

    return result.isNotEmpty;
  }


  Future<bool> accessSignIn() async {

    String path = "/accessSignIn";
    String url = '$base$path';

    String token = await UserData.accessToken;

    final body = json.encode({
      "token": token,
    });

    final result = await postRequest(url, body, isSignIn: true, verifyToken: false);

    if (result.isNotEmpty) {
      await UserData.setUserId(result['data']['userId']);
      await UserData.setAccessToken(result['token']['accesstoken']);

      final prefs = Prefs();

      await prefs.setString('previousSignIn', DateTime.now().millisecondsSinceEpoch.toString());
      await prefs.setString('tokenExpiry', result['token']['tokenExpire'].toString().split(' ')[0]);
      await prefs.setString('lastVerification', DateTime.now().millisecondsSinceEpoch.toString());
    }

    return result.isNotEmpty;
  }

  Future<bool> verifyPin({required String pin}) async {
    final userPin = await UserData.pin;
    return userPin == pin;
  }

  Future<bool> setPin(String pin) async {
    if(pin.length != 4){
      Toast.show(message: "Pin should be a 4-digit number", type: ToastType.error);
      return false;
    }

    try {
      int.parse(pin);
    } on Exception catch (e) {
      if(kDebugMode) {
        print(e.toString());
      }

      Toast.show(message: "Pin should be a 4-digit number", type: ToastType.error);
      return false;
    }
    await UserData.setPin(pin);
    return true;
  }
}