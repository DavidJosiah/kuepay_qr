// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:kuepay_qr/logic/logic.dart';
import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/shared/shared.dart';

class QRTransaction {

  //Step 1 for Offline Receive
  static void createPayment (OfflineDetailsController controller) {
    String amount = controller.amount.value;
    String name = controller.name;
    DateTime time = DateTime.now();

    controller.time.value = time.millisecondsSinceEpoch;

    final data = {
      Constants.value: Utils.removeCommas(amount),
      Constants.currency: Constants.nairaSign,
      Constants.time: time.millisecondsSinceEpoch,
      Constants.description: controller.description.value,
      Constants.receiverID: controller.userId,
      Constants.receiverName: name,
      Constants.receiverWalletAddress: controller.walletAddress,
    };

    controller.decryptedData = data;

    controller.changeTab(1);
  }

  //Step 2 for Offline Receive
  static void scanForOfflineReceive (BuildContext context, Map data, OfflineDetailsController controller) {
    if (data[Constants.receiverID] == controller.userId
        && data[Constants.time] == controller.time.value
        && data[Constants.senderID] != null) {
      if (DateTime.now().difference(
          DateTime.fromMillisecondsSinceEpoch(data[Constants.time])).inMinutes <= 30) {
        final newData = {
          Constants.senderID: data[Constants.senderID],
          Constants.senderName: data[Constants.senderName],
          Constants.senderWalletAddress: data[Constants.senderWalletAddress],
        };

        completeOfflineReceive(context, newData, controller);

      } else {
        Utils.stopLoading();
        Toast.show(message: "Transaction has expired", type: ToastType.error);
        return;
      }
    }
    else {
      Utils.stopLoading();
      Toast.show(message: "Invalid Payment QR Code", type: ToastType.error);
      return;
    }
  }

  //Step 3 for Offline Receive
  static void completeOfflineReceive (BuildContext context, Map newData, OfflineDetailsController controller) async {
    final receiverData = controller.decryptedData;

    final value = num.parse(receiverData[Constants.value] ?? "0").ceil();

    //Update balance and limit
    Utils.startLoading();

    final currentLimit = await UserData.availableLimit;

    await UserData.setAvailableLimit(currentLimit - value);
    await OfflineWallet.credit(value.toDouble());

    //Save transaction details
    Map fullData = {};
    fullData.addEntries(receiverData.entries);
    fullData.addEntries(newData.entries);

    final encryptedData = await Utils.encryptVariable(fullData);

    await OfflineTransactions.add(context, encryptedData);
    Utils.stopLoading();


    //Create transaction object for next page
    String inReferenceID = '';
    String amount = (value).toString();
    String currency = fullData[Constants.currency] ?? Constants.nairaSign;
    DateTime time = DateTime.fromMillisecondsSinceEpoch(fullData[Constants.time] ?? 0);
    String description = fullData[Constants.description] ?? "";
    String senderName = fullData[Constants.senderName] ?? "";
    String receiverID = fullData[Constants.receiverID];
    String senderWalletAddress = fullData[Constants.senderWalletAddress];

    final transaction = Transaction(
      id: inReferenceID,
      uID: receiverID,
      value: amount,
      currency: currency,
      time: time,
      title: "Receive - $senderName",
      type: 'RCV',
      imagePath: "assets/icons/in_transaction.svg",
      colors: [CustomColors.primary[3]!],
      isInFlow: true,
      name: senderName,
      //todo TBD
      fee: 0.0,
      detail: senderWalletAddress,
      description: description,
      walletID: "1",
    );

    controller.completedTransaction.value = transaction;

    controller.changeTab(controller.currentTab.value + 1);
  }



  //Step 1 for Offline Send
  static Future<Map> extractData(String data) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    final time = (now / 1000 / 60).floor().toString();

    List<dynamic> result = await extract((int.parse(time) + 1).toString(), data);

    if(!result[0]){
      result = await extract(time, data);

      if(!result[0]){
        Toast.show(message: "Invalid or Expired Payment QR Code", type: ToastType.error);
        return {};
      }
    }

    final decrypted = result[1];
    final extractedData = jsonDecode(decrypted) as Map;

    if(extractedData.isEmpty){
      Toast.show(message: "Invalid Payment QR Code", type: ToastType.error);
      return {};
    }

    return extractedData;
  }

  //Step 2 for Offline Send
  static void scanForOfflineSend (Map data, OfflineDetailsController controller) async {
    if((data[Constants.receiverID] as String).isNotEmpty
        && data[Constants.senderID] == null){
      if (DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(data[Constants.time] ?? 0))
          .inMinutes <= 30) {

        controller.decryptedData = data;
        //TODO controller.isOnlineTransaction.value = false;

        controller.changeTab(1);
      } else {
        Toast.show(message: "Transaction has expired", type: ToastType.error);
        return;
      }
    } else {
      Toast.show(message: "Invalid Payment QR Code", type: ToastType.error);
      return;
    }
  }

  //Step 3 for Offline Send
  static void completeOfflineSend (BuildContext context, OfflineDetailsController controller) async {

    final receiverData = controller.decryptedData;

    final value = num.parse(receiverData[Constants.value].toString()).ceil();

    Utils.startSheetLoading();

    //Update balance and limit
    final currentLimit = await UserData.availableLimit;

    await OfflineWallet.debit(value.toDouble());
    await UserData.setAvailableLimit(currentLimit - value);

    final newData = {
      Constants.senderID: controller.userId,
      Constants.senderName: controller.name,
      Constants.senderWalletAddress: controller.walletAddress,
    };

    //Save transaction details
    Map fullData = {};
    fullData.addEntries(receiverData.entries);
    fullData.addEntries(newData.entries);

    final encryptedData = await Utils.encryptVariable(fullData);

    await OfflineTransactions.add(context, encryptedData);
    Utils.stopSheetLoading();

    //Encrypt data required for receiver to complete transaction
    final requiredData = {
      Constants.time: controller.decryptedData[Constants.time],
      Constants.receiverID: controller.decryptedData[Constants.receiverID],
      Constants.senderID: controller.userId,
      Constants.senderName: controller.name,
      Constants.senderWalletAddress: controller.walletAddress,
    };

    //Create transaction object for last page
    String outReferenceID = '';
    String amount = (value).toString();
    String currency = fullData[Constants.currency] ?? Constants.nairaSign;
    DateTime time = DateTime.fromMillisecondsSinceEpoch(fullData[Constants.time] ?? 0);
    String description = fullData[Constants.description] ?? "";
    String senderID = fullData[Constants.senderID];
    String receiverWalletAddress = fullData[Constants.receiverWalletAddress].toString();
    String receiverName = fullData[Constants.receiverName] ?? "";

    final transaction = Transaction(
      id: outReferenceID,
      uID: senderID,
      value: amount,
      currency: currency,
      time: time,
      title: "Send - $receiverName",
      type: 'WTRF',
      imagePath: "assets/icons/out_transaction.svg",
      colors: [CustomColors.secondaryOrange[3]!],
      isInFlow: false,
      name: receiverName,
      //todo TBD
      fee: 0.0,
      detail: receiverWalletAddress,
      description: description,
      walletID: "1",
    );

    controller.decryptedData = requiredData;

    Navigator.pop(context);

    controller.completedTransaction.value = transaction;

    controller.changeTab(controller.currentTab.value + 1);
  }



  static String generateKey() {
    final key = encrypt.Key.fromSecureRandom(16);
    return key.base64.toString();
  }

  static Future<List> extract (String time, String data) async {
    final fields = time.split('');

    List<String> result = [];

    int positionSum = 0;

    String key = "";

    for(int i = 0; i < 24; i++){
      final position = int.parse(fields[i % fields.length]);

      result.add(data.substring(positionSum, position + positionSum));

      if(positionSum != 0){
        key = key + data[positionSum - 1];
      }

      positionSum = positionSum + position + 1;
    }

    final last = data.split(result.last).last;

    key = key + last[0];

    result.add(last.substring(1));

    String encryptedString = "";

    for(String s in result){
      encryptedString = encryptedString + s;
    }

    String decrypted = "";

    try {
      Utils.startLoading();
      decrypted = await Utils.decryptVariableWithKey(key, encryptedString);
      Utils.stopLoading();
      return [
        true,
        decrypted,
      ];
    } catch (e) {
      Utils.stopLoading();
      if(kDebugMode){
        print(e.toString());
      }
      return [
        false,
      ];
    }
  }

  static String scrambleFields(String key, String data) {
    final now = DateTime.now().millisecondsSinceEpoch;

    final time = (now / 1000 / 60).ceil().toString();
    final fields = time.split('');

    List<String> result = [];

    int positionSum = 0;

    for(int i = 0; i < key.length; i++){
      final position = int.parse(fields[i % fields.length]);

      result.add(data.substring(positionSum, (position + positionSum)));

      positionSum = positionSum + position;
    }

    result.add(data.split(result.last).last);

    String output = "";

    for(int i = 0; i < result.length; i++) {

      if(i < key.length){
        output = output + result[i] + key[i];
      } else {
        output = output + result[i];
      }
    }

    return output;
  }

  static Future<String> encryptAndScramble(Map data) async {
    final key = generateKey();

    Utils.startLoading();
    final encrypted = await Utils.encryptVariableWithKey(key, data);
    Utils.stopLoading();

    return scrambleFields(key, encrypted);
  }

}