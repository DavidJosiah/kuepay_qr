import 'dart:convert';

import 'package:kuepay_qr/config/config.dart';
import 'services.dart';

class TransactionDatabase{

  final String transactionsBase = "${Api().base}/transaction";
  final String flutterwaveBase = "${Api().base}/Flutterwave";
  final String billsBase = "${Api().base}/bills";
  final postRequest = Api().postRequest;
  final getRequest = Api().getRequest;
  final getAllRequest = Api().getAllRequest;

  //TODO modify to decrypt using keystore and encrypt using new key from database
  Future<bool> completeOfflineTransaction ({
    required String encryptedData
  }) async {

    String path = "/completeOfflineTransaction";
    String url = '$transactionsBase$path';

    //TODO
    final String hmacEncryption = encryptedData;

    final body = json.encode({
      "encryptedValue": hmacEncryption,
      "transactionDetails": encryptedData,
    });

    final data = await postRequest(url, body);

    return data["success"] ?? false;
  }

  Future<List<dynamic>> sendToKuepayWallet ({
    required int time,
    required String value,
    required String currency,
    required String description,
    required String receiverName,
    required String receiverWalletAddress,
    required String senderID,
    required String senderName,
    required String senderWalletAddress,
  }) async {

    String path = "/sendToKuepayWallet";
    String url = '$transactionsBase$path';

    final input = {
      "t": time.toString(),
      "v": value,
      "c": currency,
      "des": description,
      "r_N": receiverName,
      "r_WA": receiverWalletAddress,
      "s_ID": senderID,
      "s_N": senderName,
      "s_WA": senderWalletAddress,
    };

    //TODO
    final encryptedData = await Utils.encryptVariable(input);
    final String hmacEncryption = encryptedData;

    final body = json.encode({
      "encryptedValue": hmacEncryption,
      "transactionDetails": encryptedData,
    });

    final data = await postRequest(url, body);

    if(data["success"] ?? false) {
      return [
        true,
        data["data"]["transactionReference"]
      ];
    } else {
      return [
        false,
        ""
      ];
    }
  }

  Future<List<dynamic>> sendToBankAccount ({
    required int time,
    required String value,
    required String currency,
    required String fee,
    required String description,
    required String iconPath,
    required List <String> colorCodes,
    required String receiverName,
    required String bankName,
    required String bankCode,
    required String accountNumber,
    required String senderID,
    required String senderName,
    required String senderWalletAddress,
  }) async {

    String path = "/sendToBankAccount";
    String url = '$transactionsBase$path';

    final input = {
      "t": time.toString(),
      "v": value,
      "c": currency,
      "f": fee,
      "des": description,
      "img": iconPath,
      "col": colorCodes,
      "r_N": receiverName,
      "b_N": bankName,
      "b_C": bankCode,
      "r_A": accountNumber,
      "s_ID": senderID,
      "s_N": senderName,
      "s_WA": senderWalletAddress,
    };

    //TODO
    final encryptedData = await Utils.encryptVariable(input);
    final String hmacEncryption = encryptedData;

    final body = json.encode({
      "encryptedValue": hmacEncryption,
      "transactionDetails": encryptedData,
    });

    final data = await postRequest(url, body, returnData: false);

    if(data["success"] ?? false) {
      final String reference = data["data"]["data"]?["transactionReference"] ?? "";
      return [
        true,
        reference.split(" ").last
      ];
    } else{
      return [
        false,
        null
      ];
    }
  }

}