import 'package:flutter/material.dart';

import 'package:kuepay_qr/config/config.dart';

import 'responsive_widget.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double? maxFontSize;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  static int referenceSize = 0;
  const CustomText(this.text, {Key? key, required this.style,
    this.maxFontSize, this.maxLines, this.overflow, this.textAlign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ResponsiveWidget(
          largeScreen: getChild(0),
          mediumScreen: getChild(1),
          smallScreen: getChild(2),
          extraSmallScreen: getChild(3),
        );
      }
    );
  }

  Text getChild(int currentIndex){
    return Text(
        text,
        style: responsiveStyle(style, currentIndex: currentIndex),
        maxLines: maxLines ?? 1,
        overflow: overflow ?? TextOverflow.ellipsis,
        textAlign: textAlign ?? TextAlign.center
    );
  }

  static TextStyle responsiveStyle(TextStyle textStyle, {int currentIndex = -1}){
    List<TextStyle> textStyles = [

      TextStyles(color: textStyle.color).textBodySmall,
      TextStyles(color: textStyle.color).textBodyMedium,
      TextStyles(color: textStyle.color).textBodyLarge,
      TextStyles(color: textStyle.color).textBodyExtraLarge,
      TextStyles(color: textStyle.color).displayBodyExtraSmall,
      TextStyles(color: textStyle.color).displayBodySmall,
      TextStyles(color: textStyle.color).displayBodyMedium,
      TextStyles(color: textStyle.color).displayBodyLarge,
      TextStyles(color: textStyle.color).displayBodyExtraLarge,

      TextStyles(color: textStyle.color).textSubtitleSmall,
      TextStyles(color: textStyle.color).textSubtitleMedium,
      TextStyles(color: textStyle.color).textSubtitleLarge,
      TextStyles(color: textStyle.color).textSubtitleExtraLarge,
      TextStyles(color: textStyle.color).displaySubtitleExtraSmall,
      TextStyles(color: textStyle.color).displaySubtitleSmall,
      TextStyles(color: textStyle.color).displaySubtitleMedium,
      TextStyles(color: textStyle.color).displaySubtitleLarge,
      TextStyles(color: textStyle.color).displaySubtitleExtraLarge,

      TextStyles(color: textStyle.color).textTitleSmall,
      TextStyles(color: textStyle.color).textTitleMedium,
      TextStyles(color: textStyle.color).textTitleLarge,
      TextStyles(color: textStyle.color).textTitleExtraLarge,
      TextStyles(color: textStyle.color).displayTitleExtraSmall,
      TextStyles(color: textStyle.color).displayTitleSmall,
      TextStyles(color: textStyle.color).displayTitleMedium,
      TextStyles(color: textStyle.color).displayTitleLarge,
      TextStyles(color: textStyle.color).displayTitleExtraLarge,
    ];

    List<int> screenSizes = [
      Constants.largeScreenSize,
      Constants.mediumScreenSize,
      Constants.smallScreenSize,
      Constants.extraSmallScreenSize,
    ];

    int currentStyleIndex = -1;
    int fontWeightGroup = -1;

    for(int a = 0; a < textStyles.length; a++){
      if(textStyle == textStyles[a]){
        currentStyleIndex = a;
        break;
      }
    }

    if(currentStyleIndex == -1) return textStyle;

    fontWeightGroup = ((currentStyleIndex + 1) / 9).ceil();

    int referenceIndex = -1;

    for(int a = 0; a < screenSizes.length; a++){
      if(referenceSize == screenSizes[a]){
        referenceIndex = a;
        break;
      }
    }

    if(currentIndex == -1) {
      if (ResponsiveWidget.isLargeScreen()) {
        currentIndex = 0;
      }
      else if (ResponsiveWidget.isMediumScreen()) {
        currentIndex = 1;
      }
      else if (ResponsiveWidget.isSmallScreen()) {
        currentIndex = 2;
      }
      else if (ResponsiveWidget.isExtraSmallScreen()) {
        currentIndex = 3;
      }
    }

    if(referenceIndex == -1 || currentIndex == -1) return textStyle;

    int sizeDifference = referenceIndex - currentIndex;
    final newStyleIndex = currentStyleIndex + sizeDifference;

    if(((newStyleIndex + 1) / 9).ceil() != fontWeightGroup) return textStyles[9 * (fontWeightGroup - 1)];

    return textStyles[currentStyleIndex + sizeDifference];
  }

}