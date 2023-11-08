import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/config/config.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;
  final Widget? extraSmallScreen;
  const ResponsiveWidget({required this.largeScreen, this.mediumScreen, this.smallScreen, this.extraSmallScreen, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? mediumScreen = this.mediumScreen;
    Widget? smallScreen= this.smallScreen;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (smallScreen != null && mediumScreen == null) {
          mediumScreen = smallScreen;
        }

        if (isLargeScreen()) {
          return largeScreen;
        } else if (isMediumScreen()) {
          return mediumScreen ?? largeScreen;
        } else if(isSmallScreen()){
          return smallScreen ?? largeScreen;
        }else {
          return extraSmallScreen ?? largeScreen;
        }
      },
    );
  }

  static bool isExtraSmallScreen() {
    if(Dimen.width <= Constants.extraSmallScreenSize){
      return true;
    }else if(MediaQuery.of(Get.context!).orientation == Orientation.landscape
        && Dimen.height <= Constants.extraSmallScreenSize){
      return true;
    }else{
      return false;
    }
  }

  static bool isSmallScreen() {
    return Dimen.width > Constants.extraSmallScreenSize &&
        Dimen.width <= Constants.smallScreenSize;
  }

  static bool isMediumScreen() {
    return Dimen.width > Constants.smallScreenSize &&
        Dimen.width <= Constants.mediumScreenSize;
  }

  static bool isLargeScreen() {
    return Dimen.width > Constants.mediumScreenSize;
  }
}