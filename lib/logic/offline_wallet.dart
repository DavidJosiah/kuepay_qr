import 'dart:convert';

import 'package:get/get.dart';
import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/controllers/controllers.dart';

import 'offline_transactions.dart';

class OfflineWallet {

  static final prefs = Prefs();

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
    final String mId = await prefs.getString('walletId') ?? "1";
    final decrypted = await Utils.decryptVariable(mId);
    return jsonDecode(decrypted);
  }

  static Future<String> get address async {
    final String mAddress = await prefs.getString('address') ?? await Utils.encryptVariable("ADDRESS");
    final decrypted = await Utils.decryptVariable(mAddress);
    return jsonDecode(decrypted);
  }

  static Future<String> get currency async {
    final String mCurrency = await prefs.getString('currency') ?? await Utils.encryptVariable(Constants.nairaSign);
    final decrypted = await Utils.decryptVariable(mCurrency);
    return jsonDecode(decrypted);
  }

  static Future<String> get balance async {
    final String mBalance = await prefs.getString('balance') ?? await Utils.encryptVariable("00.00");
    final decrypted = await Utils.decryptVariable(mBalance);
    return jsonDecode(decrypted);
  }

  static Future<void> setId(String value) async {
    if(value.trim().isNotEmpty){
      await prefs.setString('walletId', await Utils.encryptVariable(value));
    }
  }

  static Future<void> setAddress(String value) async {
    if(value.trim().isNotEmpty){
      await prefs.setString('address', await Utils.encryptVariable(value));
    }
  }

  static Future<void> setCurrency(String value) async {
    if(value.trim().isNotEmpty) {
      await prefs.setString('currency', await Utils.encryptVariable(value));
    }
  }

  static Future<void> setBalance(String value) async {
    if(value.trim().isNotEmpty){
      await prefs.setString('balance', await Utils.encryptVariable(value));
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

  static Future<String> get pendingBalance async {
    double balance = 0.0;

    final stringTransactions = await OfflineTransactions.transactions;

    for (String encrypted in stringTransactions) {
      final decrypted = await Utils.decryptVariable(encrypted);
      final Map<String, dynamic> data = jsonDecode(decrypted) as Map<String, dynamic>;

      final value = num.parse(data[Constants.value] ?? "0").ceil();

      String amount = (value).toString();
      String receiverID = data[Constants.receiverID];
      bool isInflow = receiverID == Get.find<KuepayOfflineController>().data["userId"];

      if(isInflow) balance = balance + num.parse(amount).toDouble();
    }

    return balance.floor().toString();
  }
}