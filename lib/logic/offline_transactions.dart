import 'package:shared_preferences/shared_preferences.dart';

import 'package:kuepay_qr/shared/shared.dart';
import 'package:kuepay_qr/config/config.dart';

class OfflineTransactions {

  static SharedPreferences? prefInstance;

  static Future<SharedPreferences> get _pref async {
    prefInstance ??= await SharedPreferences.getInstance();
    return prefInstance!;
  }

  static Future<List<String>> get transactions async {
    final pref = await _pref;
    final offlineTransactions = pref.getStringList("offlineTransactions") ?? [];
    return offlineTransactions;
  }

  static Future<bool> isDataIntact () async {
    final pref = await _pref;

    final offlineTransactionsList = await transactions;
    final offlineTransactionsString = pref.getString("offlineTransactionsString") ?? "";

    String decryptedOfflineTransactions = "";

    if(offlineTransactionsString.isNotEmpty){
      decryptedOfflineTransactions = await Utils.decryptVariable(offlineTransactionsString);

      if(decryptedOfflineTransactions.isEmpty){
        Snack.show(message: "User data has been compromised", type: SnackBarType.error);
        return false;
      }
    } else if(offlineTransactionsList.isNotEmpty) {
      Snack.show(message: "User data has been compromised", type: SnackBarType.error);
      return false;
    }
    
    return true;
  }

  static Future<void> add (String encrypted) async {
    final pref = await _pref;

    final isIntact = await isDataIntact();

    if(isIntact){
      final offlineTransactionsList = await transactions;
      offlineTransactionsList.add(encrypted);
      final decryptedOfflineTransactions = offlineTransactionsList.toString();
      final encryptedOfflineTransactions = await Utils.encryptVariable(decryptedOfflineTransactions);

      await pref.setString("offlineTransactionsString", encryptedOfflineTransactions);
      await pref.setStringList("offlineTransactions", offlineTransactionsList);
    }
  }

  static Future<void> remove (String encrypted) async {
    final pref = await _pref;

    final isIntact = await isDataIntact();

    if(isIntact){
      final offlineTransactionsList = await transactions;
      offlineTransactionsList.remove(encrypted);
      final decryptedOfflineTransactions = offlineTransactionsList.toString();
      final encryptedOfflineTransactions = await Utils.encryptVariable(decryptedOfflineTransactions);

      await pref.setString("offlineTransactionsString", encryptedOfflineTransactions);
      await pref.setStringList("offlineTransactions", offlineTransactionsList);
    }
  }
}