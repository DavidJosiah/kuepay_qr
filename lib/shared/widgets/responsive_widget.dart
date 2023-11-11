import 'package:flutter/material.dart';

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

        if (isLargeScreen(context)) {
          return largeScreen;
        } else if (isMediumScreen(context)) {
          return mediumScreen ?? largeScreen;
        } else if(isSmallScreen(context)){
          return smallScreen ?? largeScreen;
        }else {
          return extraSmallScreen ?? largeScreen;
        }
      },
    );
  }

  static bool isExtraSmallScreen(BuildContext context) {
    if(Dimen.width(context) <= Constants.extraSmallScreenSize){
      return true;
    }else if(MediaQuery.of(context).orientation == Orientation.landscape
        && Dimen.height(context) <= Constants.extraSmallScreenSize){
      return true;
    }else{
      return false;
    }
  }

  static bool isSmallScreen(BuildContext context) {
    return Dimen.width(context) > Constants.extraSmallScreenSize &&
        Dimen.width(context) <= Constants.smallScreenSize;
  }

  static bool isMediumScreen(BuildContext context) {
    return Dimen.width(context) > Constants.smallScreenSize &&
        Dimen.width(context) <= Constants.mediumScreenSize;
  }

  static bool isLargeScreen(BuildContext context) {
    return Dimen.width(context) > Constants.mediumScreenSize;
  }
}