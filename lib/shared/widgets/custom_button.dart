import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kuepay_qr/config/config.dart';

import 'custom_text.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final double? height;
  final double? width;
  Color? color;
  Color? textColor;
  Color? borderColor;
  final EdgeInsets? margin;
  final bool? isOutlined;
  final String? icon;
  CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.color,
    this.textColor,
    this.borderColor,
    this.margin,
    this.isOutlined,
    this.icon,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    if(isOutlined ?? false){
      borderColor ??= CustomColors.dynamicColor(
        colorScheme: ColorThemeScheme.primaryFill
      );
      color ??= CustomColors.primary[3];
      textColor ??= CustomColors.primary;
    }

    final borderRadius = (height ?? 62) * 0.25;

    return Container(
      height: height ?? 62,
      width: width ?? Dimen.width * 0.9,
      decoration: BoxDecoration(
        color: color ?? CustomColors.primary,
        borderRadius: BorderRadius.all(
            Radius.circular(borderRadius)
        ),
        border: borderColor != color ? Border.all(
          color: borderColor ?? color ?? CustomColors.primary,
          width: 1.5,
        ) : null
      ),
      margin: margin ?? EdgeInsets.zero,
      child: MaterialButton(
        height: height ?? 62,
        minWidth: width ?? Dimen.width * 0.9,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(borderRadius)
          ),
        ),
        elevation: 0,
        onPressed: onPressed,
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Expanded(child: SizedBox()),

                CustomText(
                    text,
                    style: TextStyles(
                        color: textColor ?? CustomColors.white,
                    ).textSubtitleExtraLarge
                ),

                if(icon != null)
                  SizedBox(width: Dimen.horizontalMarginWidth),

                if(icon != null)
                  SvgPicture.asset(
                    icon!,
                    height: 24,
                    width: 24,
                    color: textColor ?? CustomColors.white,
                    semanticsLabel: ""
                  ),

                const Expanded(child: SizedBox()),

              ],
            )
        ),
      ),
    );
  }
}
