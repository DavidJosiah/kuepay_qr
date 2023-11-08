import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dimen {
  static double get width => MediaQuery.of(Get.context!).size.width;
  static double get height => MediaQuery.of(Get.context!).size.height;

  static double get horizontalMarginWidth => width * (1/14) * (1/4);
  static double get verticalMarginHeight => height * (1/9) * (1/6);
}