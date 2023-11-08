import 'package:flutter/material.dart';

import 'package:kuepay_qr/config/config.dart';

class Wallet {
  late String id = "", uID, name, address, currency;
  late String balance = "00.00";
  late bool isLocked = false;
  List<Color> colors = [];
  String background = '';

  Wallet({required this.uID, required this.name, required this.address, required this.balance, required this.colors,  required this.background, required this.currency});

  Wallet.empty(){
    id = "";
    uID = "";
    name = "Name";
    address = "ADDRESS";
    colors = [
      const Color(0xFF056348),
      const Color(0xFF07AC7D),
      const Color(0xFFB8EE00),
    ];
    background = 'assets/images/circular_bg.png';
    currency = Constants.nairaSign;
    balance = "0.00";
    isLocked = false;
  }

  Wallet.fromMap(Map<dynamic, dynamic> map){
    id = (map["id"] as int).toString();
    uID = map["userId"] as String;
    name = map["name"] as String;
    address = map["address"] as String;
    currency = map["currency"] as String;
    if(currency == "NGN") {
      currency = Constants.nairaSign;
    }
    balance = (map["balance"] as num).toString();
    background = map["background"] as String;
    isLocked = map["isLocked"] ?? false;
    List<dynamic> colorCodes = map["color"] ?? <String> [];
    for(String code in colorCodes){
      final List<String> channels = code.split('/');
      colors.add(Color.fromARGB(int.parse(channels[0]), int.parse(channels[1]),
          int.parse(channels[2]), int.parse(channels[3])));
    }
  }
}