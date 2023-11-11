import 'package:flutter/material.dart';

class Dimen {
  static double width (BuildContext context) => MediaQuery.of(context).size.width;
  static double height (BuildContext context) => MediaQuery.of(context).size.height;

  static double horizontalMarginWidth (BuildContext context) => width(context) * (1/14) * (1/4);
  static double verticalMarginHeight (BuildContext context) => height(context) * (1/9) * (1/6);
}