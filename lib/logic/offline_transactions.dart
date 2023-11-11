// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';

import 'package:kuepay_qr/shared/shared.dart';
import 'package:kuepay_qr/config/config.dart';

class OfflineTransactions {

  static final prefs = Prefs();

  static Future<List<String>> get transactions async {
    final offlineTransactions = await prefs.getStringList("offlineTransactions") ?? [];
    return offlineTransactions;
  }

  static Future<bool> isDataIntact (BuildContext context) async {

    final offlineTransactionsList = await transactions;
    final offlineTransactionsString = await prefs.getString("offlineTransactionsString") ?? "";

    String decryptedOfflineTransactions = "";

    if(offlineTransactionsString.isNotEmpty){
      decryptedOfflineTransactions = await Utils.decryptVariable(offlineTransactionsString);

      if(decryptedOfflineTransactions.isEmpty){
        Snack.show(context, message: "User data has been compromised", type: SnackBarType.error);
        return false;
      }
    } else if(offlineTransactionsList.isNotEmpty) {
      Snack.show(context, message: "User data has been compromised", type: SnackBarType.error);
      return false;
    }
    
    return true;
  }

  static Future<void> add (BuildContext context, String encrypted) async {

    final isIntact = await isDataIntact(context);

    if(isIntact){
      final offlineTransactionsList = await transactions;
      offlineTransactionsList.add(encrypted);
      final decryptedOfflineTransactions = offlineTransactionsList.toString();
      final encryptedOfflineTransactions = await Utils.encryptVariable(decryptedOfflineTransactions);

      await prefs.setString("offlineTransactionsString", encryptedOfflineTransactions);
      await prefs.setStringList("offlineTransactions", offlineTransactionsList);
    }
  }

  static Future<void> remove (BuildContext context, String encrypted) async {

    final isIntact = await isDataIntact(context);

    if(isIntact){
      final offlineTransactionsList = await transactions;
      offlineTransactionsList.remove(encrypted);
      final decryptedOfflineTransactions = offlineTransactionsList.toString();
      final encryptedOfflineTransactions = await Utils.encryptVariable(decryptedOfflineTransactions);

      await prefs.setString("offlineTransactionsString", encryptedOfflineTransactions);
      await prefs.setStringList("offlineTransactions", offlineTransactionsList);
    }
  }
}