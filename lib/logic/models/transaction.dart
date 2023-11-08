import 'package:flutter/material.dart';

import 'package:kuepay_qr/config/config.dart';

class Transaction {
  late String id, uID, token, name, email, title, imagePath, currency, value, type,
      detail, description = "", _status = "Success", walletID, shopID;
  late List<Color> colors = [];
  late double fee;
  late bool isInFlow, hasBeenCleared;
  late DateTime time;
  late List<String> purchases = [];

  Transaction({required this.id, this.uID = "", this.token = "", required this.name, this.email = "",
    required this.imagePath, required this.colors,
    required this.title, required this.value, required this.type, required this.isInFlow,
    required this.currency, required this.time, required this.detail,
    this.description = '', required this.walletID,
    this.hasBeenCleared = false, this.shopID = "", required this.fee, this.purchases = const []});

  Transaction.empty(){
    id = "";
    uID = "";
    token = "";
    name = "";
    email = "";
    title = "";
    imagePath = "";
    colors = [CustomColors.primary[3]!];
    currency = "";
    value = "0";
    detail = "0";
    type = "";
    description = "";
    _status = "Success";
    isInFlow = true;
    walletID = "";
    shopID = "";
    fee = 0.0;
    time = DateTime.now();
    hasBeenCleared = false;
    purchases = [];
  }

  Transaction.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'] as String;
    uID = map['userId'] as String;
    token = map['fluterwaveReference'] ?? "";
    if(token.contains("BP")) {
      token = token.split("BP").last;
    }
    name = map['name'] as String;
    email = map['email'] as String;
    title = map['title'] as String;
    imagePath = map['imagePath'] as String;
    currency = map['currency'] as String;
    value = map['value'] as String;
    detail = map['detail'] as String;
    type = map['type'] as String;
    if(type.split(" ").length > 1
        && (type.toUpperCase().contains("ELECTRIC")
            || type.toUpperCase().contains("DISCO")
            || type.toUpperCase().contains("PREPAID")
            || type.toUpperCase().contains("POSTPAID"))
    ){
      type = "ELCT";
    }
    description = map['description'] as String;
    updateStatus(map['status'] as String);
    List<dynamic> colorCodes = convertToStringList(map['colors']);
    if(colorCodes.contains("string")){
      colors = [
        const Color(0xFF056348),
        const Color(0xFF07AC7D),
        const Color(0xFFB8EE00),
      ];
    } else {
      for (String code in colorCodes) {
        final List<String> channels = code.split('/');
        colors.add(
            Color.fromARGB(int.parse(channels[0]), int.parse(channels[1]),
                int.parse(channels[2]), int.parse(channels[3])));
      }
    }
    walletID = map['walletID'] as String;
    shopID = map['shopID'] as String;
    fee = (map['fee'] as num).toDouble();
    isInFlow = map['isInFlow'] as bool;
    hasBeenCleared = map['hasBeenCleared'] as bool;
    time = DateTime.fromMillisecondsSinceEpoch(int.parse(map['transactionTime'] as String));
    purchases = convertToStringList(map['purchases']);
  }

  String get status => _status;

  void updateStatus(String status) async {
    _status = status;
  }

  List<String> convertToStringList (List<dynamic> dynamicList){
    List<String> stringList = [];
    for (var dynamicItem in dynamicList) {
      stringList.add(dynamicItem.toString());
    }
    return stringList;
  }

}