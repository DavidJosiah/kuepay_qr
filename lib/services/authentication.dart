import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:kuepay_qr/config/config.dart';

import 'services.dart';

class Auth {

  final String base = "${Api().base}/account";
  final postRequest = Api().postRequest;
  final getRequest = Api().getRequest;

  void showErrorMessage (String message) {
    Api.showErrorMessage(message);
  }

  Future<Map> accessSignIn() async {

    String path = "/accessSignIn";
    String url = '$base$path';

    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('accessToken') ?? "";

    final body = json.encode({
      "token": token,
    });

    final results = await postRequest(url, body, isSignIn: true, verifyToken: false);

    return results;
  }

  Future<String> getPin() async {
    if(Utils.uID.isEmpty) return "";

    String path = "/getPin?userId=${Utils.uID}";
    String url = '$base$path';

    final data = await getRequest(url);
    return data["pin"] ?? "";
  }

  Future<bool> verifyPin({
    required String pin,
  }) async {

    String path = "/verifyPin";
    String url = '$base$path';

    final body = json.encode({
      "pin": pin,
    });

    final data = await postRequest(url, body);
    return data["success"] ?? false;
  }

  Future<bool> createTransactionPin({
    required String pin,
  }) async {

    String path = "/transaction-pin-setup";
    String url = '$base$path';

    final body = json.encode({
      "transactionPin": pin,
      "isNew": true
    });

    final data = await postRequest(url, body);
    return data["success"] ?? false;
  }

  Future<bool> updateTransactionPin({
    required String pin,
  }) async {

    String path = "/transaction-pin-setup";
    String url = '$base$path';

    final body = json.encode({
      "transactionPin": pin,
      "isNew": false
    });

    final data = await postRequest(url, body);
    if(data["success"] ?? false){
      Utils.getPin();
    }
    return data["success"] ?? false;
  }

  Future<String> sendOtp({
    required String phoneNumber,
    String emailAddress = "",
  }) async {

    String path = "/sendOtp";
    String url = '$base$path';


    final body = json.encode({
      "phoneNumber": phoneNumber,
      "emailAddress": emailAddress,
    });

    final data = await postRequest(url, body, verifyToken: false);

    return data["data"]?["otpCode"] ?? "";
  }

}