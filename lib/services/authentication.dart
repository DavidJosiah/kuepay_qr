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

    final data = await postRequest(url, body, isSignUp: true);

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

    final result = await postRequest(url, body, isSignIn: true);

    if (result.isNotEmpty) {
      final userID = result['data']['userId'];
      final name = result['data']['name'];

      final walletAddress = result['data']['walletAddress'];
      final walletId = result['data']['walletId'];

      UserData.setUserId(userID);
      UserData.setName(name);
      UserData.resetLimit();

      OfflineWallet.setAddress(walletAddress);
      OfflineWallet.setBalance("0");
      OfflineWallet.setCurrency(Constants.nairaSign);
      OfflineWallet.setId(walletId);

      UserData.setAccessToken(result['token']['accesstoken']);
    }

    return result.isNotEmpty;
  }

  Future<bool> verifyPin({required String pin}) async {
    final userPin = await UserData.pin;
    return userPin == pin;
  }

  Future<void> setPin(String pin) async {
    if(pin.length != 4){
      Toast.show(message: "Pin should be a 4-digit number", type: ToastType.error);
      return;
    }

    try {
      int.parse(pin);
    } on Exception catch (e) {
      if(kDebugMode) {
        print(e.toString());
      }

      Toast.show(message: "Pin should be a 4-digit number", type: ToastType.error);
      return;
    }

    UserData.setPin(pin);
  }
}