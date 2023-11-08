import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/config/config.dart';

class Snack {

  Snack.show({
      required String message,
      required SnackBarType type,
      bool floating = false,
      bool permanent = false,
      Widget? action,
      Widget? icon
  }){
    final double maxWidth = floating
        ? Dimen.width - (Dimen.horizontalMarginWidth * 6) <= 500
          ? Dimen.width - (Dimen.horizontalMarginWidth * 6) : 500
        : Dimen.width;

    final EdgeInsets margin = floating
        ? const EdgeInsets.only(bottom: 20)
        : EdgeInsets.zero;

    Get.showSnackbar(
        GetSnackBar(
          messageText: Text(
            message,
            style: TextStyle(
              color: type == SnackBarType.progress
                  ? CustomColors.grey : CustomColors.grey[6]!,
              letterSpacing: 0.03, 
              fontSize: 14.0,
              fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.start,
            maxLines: 4,
          ),
          icon: icon,
          mainButton: action,
          borderRadius:  floating ? 12 : 0,
          maxWidth: maxWidth,
          snackStyle: floating ? SnackStyle.FLOATING : SnackStyle.GROUNDED,
          margin: margin,
          snackPosition: floating ? SnackPosition.TOP : SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: permanent ? null : const Duration(milliseconds: 1500),
          backgroundColor: getBackgroundColor(type),
          padding: floating ? EdgeInsets.symmetric(
            horizontal: Dimen.horizontalMarginWidth * 3,
            vertical: 20,
          ) : const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 20,
          ),
        )
    );
  }

  static showMade({required GetSnackBar snackBar}){
    Get.showSnackbar(
        snackBar
    );
  }

  static Color getBackgroundColor(SnackBarType type) {
    if (type == SnackBarType.error) return CustomColors.error;
    if (type == SnackBarType.warning) return CustomColors.warning;
    if (type == SnackBarType.success) return CustomColors.success;
    if (type == SnackBarType.info) return CustomColors.info;
    if (type == SnackBarType.progress) {
      return CustomColors.grey[6]!;
    }
    return CustomColors.grey;
  }

}
 
enum SnackBarType {info, success, warning, error, progress}