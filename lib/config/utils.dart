import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/logic/logic.dart';
import 'package:kuepay_qr/services/services.dart';

class Utils {

  static String accessToken = "";
  static String uID = "";
  static bool isDarkMode = false;

  static void startLoading() => Get.find<KuepayOfflineController>().startLoading();

  static void stopLoading() => Get.find<KuepayOfflineController>().stopLoading();

  static void startSheetLoading() => Get.find<KuepayOfflineController>().startSheetLoading();

  static void stopSheetLoading() => Get.find<KuepayOfflineController>().stopSheetLoading();


  static void startCompletingOffline() => Get.find<KuepayOfflineController>().startCompletingOffline();

  static void stopCompletingOffline() => Get.find<KuepayOfflineController>().stopCompletingOffline();


  static Future<void> getPin() async {
    final pin = await Auth().getPin();

    if(pin.isNotEmpty){
      await UserData.setPin(pin);
    }
  }

  static List<ui.Color> getRandomColorSet({required List<List<ui.Color>> sampleSpace}){
    Random random = Random();
    int colorSet = random.nextInt(sampleSpace.length);

    return sampleSpace[colorSet];
  }

  static String resolveLimits(String currency, int type) {
    final String lowerLimit;
    final String upperLimit;

    //todo
    if (currency == Constants.nairaSign) {
      lowerLimit = "100.00";
      upperLimit = "5,000,000.00";
    } else if (currency == '\$') {
      lowerLimit = "1.00";
      upperLimit = "1000.00";
    }
    else {
      lowerLimit = "1,000.00";
      upperLimit = "50,000,000.00";
    }

    switch (type) {
      case 0:
        return '$lowerLimit - $upperLimit';
      case 1:
        return lowerLimit;
      case 2:
        return upperLimit;
    }
    return " ";
  }

  static Future<bool> saveWidgetAsImage(RenderRepaintBoundary widgetBoundary, String title) async {
    try {

      ui.Image image = await widgetBoundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if(byteData == null) return false;

      Uint8List pngBytes = byteData.buffer.asUint8List();

      final now = DateTime.now();
      final name = '${title}_${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';

      await ImageGallerySaver.saveImage(pngBytes, quality: 60, name: name);

      return true;
    } catch (e) {
      if (kDebugMode) print(e);

      return false;
    }
  }

  static void shareWidgetAsImage(RenderRepaintBoundary boundary, String title) async {
    try {

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if(byteData == null) return;

      Uint8List pngBytes = byteData.buffer.asUint8List();

      final String dir = (await getApplicationDocumentsDirectory()).path;

      final now = DateTime.now();
      final name = '${title}_${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';

      final imagePath = '$dir/$name.png';

      final capturedFile = File(imagePath);

      await capturedFile.writeAsBytes(pngBytes);

      Share.shareFiles([imagePath]);

      return;
    } catch (e) {
      if (kDebugMode) print(e);
      return;
    }
  }

  static String fillCommas(String input) {
    String output = "";
    String suffix = "";

    if (input.length > 2) {
      final lastDigits = input.substring(input.length - 2);
      if (lastDigits.substring(0, 1) == ".") {
        suffix = input.substring(input.length - 2);
        input = input.substring(0, input.length - 2);
      }
    }

    if (input.length > 3) {
      final lastDigits = input.substring(input.length - 3);
      if (lastDigits.substring(0, 1) == ".") {
        suffix = input.substring(input.length - 3);
        input = input.substring(0, input.length - 3);
      }
    }

    if (input.trim().length <= 3) return input;
    int counter = 0;

    for (int i = input.length; i > 0; i--) {
      String char = input[i -1];

      output = char + output;

      counter++;

      if(counter % 3 == 0 && i > 1){
        output = ',$output';
        counter = 0;
      }
    }
    return output + suffix;
  }

  static String removeCommas(String input) {
    String output = "";

    for (int a = 0; a < input.length; a++) {
      String currentCharacter = input.substring(a, a + 1);
      if (currentCharacter != ",") {
        output += currentCharacter;
      }
    }

    return output;
  }

  static String getDate(DateTime inputTime) {
    if (inputTime.day == DateTime.now().day
        && inputTime.month == DateTime.now().month
        && inputTime.year == DateTime.now().year) {
      return DateFormat.jm().format(inputTime);
    } else {
      return DateFormat("hh:mm aa, dd LLL yyyy ").format(inputTime);
    }
  }

  static Future<String> encryptVariable (Object object) async {
    return await KuepayQrPlatform.instance.encryptString(json.encode(object));
  }

  static Future<String> decryptVariable (String string) async {
    return await KuepayQrPlatform.instance.decryptString(string);
  }

  static Future<String> encryptVariableWithKey (String key, Object object) async {
    final encryptionService = EncryptionService(encrypt.Encrypter(encrypt.AES(
        encrypt.Key.fromUtf8(key),
        mode: encrypt.AESMode.cbc
    )));

    final encrypted = encryptionService.encrypt(json.encode(object));

    return encrypted;
  }

  static Future<String> decryptVariableWithKey (String key, String string) async {
    final encryptionService = EncryptionService(encrypt.Encrypter(encrypt.AES(
        encrypt.Key.fromUtf8(key),
        mode: encrypt.AESMode.cbc
    )));

    final decrypted = encryptionService.decrypt(string);

    return decrypted;
  }

  static Future<String> encryptVariableHMAC (String string) async {

    final hmac = Hmac(sha512, utf8.encode(Constants.hmacEncryptionKey));

    final digest = hmac.convert(utf8.encode(Constants.hmacEncryptionKey + string));

    return digest.toString().toUpperCase();
  }

  static Future<String> getDeviceIP() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var response = await http.get(Uri.parse('https://api.ipify.org'));
      if (response.statusCode == 200) {
        return response.body;
      }
    }
    return '';
  }

  static Future<bool> isFingerprintActivated () async {

    final prefs = await SharedPreferences.getInstance();

    final result = prefs.getBool('isFingerprintActivated');

    return result ?? false;
  }



  static Future<void> completeOfflineTransactions({bool isBackground = false}) async {
    if(isBackground
        || (!Get.find<KuepayOfflineController>().isOffline.value
            && !Get.find<KuepayOfflineController>().isCompletingOffline)) {

        if(!isBackground) Utils.startCompletingOffline();
        final isIntact = await OfflineTransactions.isDataIntact();

        if(isIntact) {
          final transactions = await OfflineTransactions.transactions;
          for (String encrypted in transactions) {

            final result = await TransactionDatabase().
            completeOfflineTransaction(encryptedData: encrypted);

            if(result){
              await OfflineTransactions.remove(encrypted);
            }
          }

          if(!isBackground) Utils.stopCompletingOffline();
        } else {
          if(!isBackground) Utils.stopCompletingOffline();
        }
    }
  }
}