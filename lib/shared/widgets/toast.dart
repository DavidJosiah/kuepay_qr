import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'as fluttertoast;

import 'package:kuepay_qr/config/config.dart';

class Toast {

  Toast.show({required String message, required ToastType type, int toastLength = 1}){

    fluttertoast.Fluttertoast.showToast(
        msg: message,
        toastLength: toastLength == 1
            ? fluttertoast.Toast.LENGTH_SHORT
            : fluttertoast.Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        gravity: fluttertoast.ToastGravity.BOTTOM,
        backgroundColor: getBackgroundColor(type),
        textColor: Colors.white,
        fontSize: 14.0
    );
  }

  Color getBackgroundColor(ToastType type) {
    if (type == ToastType.error) return CustomColors.error;
    if (type == ToastType.warning) return CustomColors.warning;
    if (type == ToastType.success) return CustomColors.success;
    if (type == ToastType.info) return CustomColors.info;
    return CustomColors.grey;
  }

}

enum ToastType {info, success, warning, error}