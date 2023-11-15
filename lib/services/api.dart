import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/logic/logic.dart';

import 'package:kuepay_qr/shared/shared.dart';

import 'authentication.dart';

class Api {

  String base = 'https://kuepay.co/api';

  //TODO add secret key

  Future<Map<String, String>> get baseHeader async  {
    final accessToken = await UserData.accessToken;
    if(accessToken.isNotEmpty){
      return {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        "Content-Type": "application/json",
      };
    } else {
      return {
        "Content-Type": "application/json",
      };
    }
  }

  static void showErrorMessage(String message, {bool isLong = false}) {
    if(message.contains("FormatException")) return;
    if(message.toLowerCase().contains("insufficient funds")) return;
    if(message == "Failed") return;
    if(message == "Failed host lookup: 'kuepay.co'") return;
    if(message == "Request failed") return;

    Toast.show(
        message: message,
        toastLength: isLong ? 2 : 1,
        type: ToastType.error
    );
  }

  Future<Map> postRequest(String url, String body, {
    bool isSignIn = false,
    bool isSignUp = false,
    bool returnData = true,
    bool verifyToken = true,
  }) async {
    Map data = {};

    try {
      final isVerified = verifyToken ? await verifyAccessToken() : true;

      if(!isVerified) return data;

      final Uri uri = Uri.parse(url);

      final header = await baseHeader;

      final response = await http.post(uri, headers: header, body: body);

      Map decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

      String error = "";

      if(!(decodedResponse['success'] ?? false)){
        if(isSignUp) {
          error = decodedResponse['result']['error']['validationMessages'].toString();
        } else {
          error = decodedResponse['result']['message'];
        }
      }

      //TODO
      print("url $url");
      //TODO
      print("decoded $decodedResponse");

      if (response.statusCode == 200 || response.statusCode == 00) {
        final retrievedData = returnData ? decodedResponse['result']['data'] : null;
        if(isSignIn) {
          data = {
            "data": retrievedData ?? decodedResponse['result'],
            "token": decodedResponse['result']['token'],
          };
        } else {
          data = {
            "data": retrievedData ?? decodedResponse['result'],
            "success": decodedResponse['success'] ?? false,
          };
        }
      }else {
        showErrorMessage(error, );
      }
    } on Exception catch (e) {
      showErrorMessage(e.toString());
      if(kDebugMode){
        print(e.toString());
      }
    }

    return data;
  }

  Future<Map> getRequest(String url) async {
    Map data = {};

    try {

      final isVerified = await verifyAccessToken();

      if(!isVerified) return data;

      final Uri uri = Uri.parse(url);

      final header = await baseHeader;

      final response = await http.get(uri, headers: header,);

      Map decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

      String error = "";

      if(!(decodedResponse['success'] ?? false)){
        error = decodedResponse['result']['message'];
      }

      if (response.statusCode == 200 || response.statusCode == 00) {
        data = decodedResponse['result']['data'];
      }else {
        if(error.toLowerCase() != "record not found"
            && error.toLowerCase() != "wallet does not exist"
            && error.toLowerCase() != "transcion not found") {
          showErrorMessage(error);
        }
      }
    } on Exception catch (e) {
      showErrorMessage(e.toString());
      if(kDebugMode){
        print(e.toString());
      }
    }

    return data;
  }

  Future<List<dynamic>> getAllRequest(String base, String path, Map<String, dynamic>? query) async {
    List<dynamic> data = [];

    try {

      final isVerified = await verifyAccessToken();

      if(!isVerified) return data;

      final Uri uri = Uri.https(base, path, query);

      final header = await baseHeader;

      final response = await http.get(uri, headers: header);

      Map decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

      String error = "";

      if(!(decodedResponse['success'] ?? false)){
        error = decodedResponse['result']['message'];
      }

      if (response.statusCode == 200) {
        data = decodedResponse['result']['data'];
      }else {
        if(error != "User notification not found" && error != "User not found" && error != "Record not found") {
          showErrorMessage(error);
        }
      }
    } on Exception catch (e) {
      showErrorMessage(e.toString());
      if(kDebugMode){
        print(e.toString());
      }
    }

    return data;
  }

  static Future<bool> verifyAccessToken() async {

    final prefs = Prefs();

    final previousSignIn = await prefs.getString('previousSignIn') ?? "0";
    final tokenExpiry = await prefs.getString('tokenExpiry') ?? '2';

    final expiration = Duration(minutes: int.parse(tokenExpiry));
    final tokenInitializationTime = DateTime.fromMillisecondsSinceEpoch(int.parse(previousSignIn));
    final hasExpired = DateTime.now().difference(tokenInitializationTime) > expiration;

    if(hasExpired) {
      return await Auth().accessSignIn();
    } else {
      return true;
    }
  }
}