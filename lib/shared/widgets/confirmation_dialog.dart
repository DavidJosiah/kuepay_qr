import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/config/config.dart';

import 'custom_button.dart';
import 'custom_text.dart';
import 'svg.dart';

void showConfirmationDialog ({
  required BuildContext parentContext,
  required String icon,
  required String title,
  required String subtitle,
  String dismissText = "Cancel",
  void Function()? onDismiss,
  String confirmationText = "Confirm",
  required void Function() onConfirm,
  }){

  onDismiss ??= (){
    Get.back();
  };

  showDialog(context: parentContext, builder: (BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.dynamicColor(
        colorScheme: ColorThemeScheme.background
      ),
      contentPadding: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(13)
          )
      ),
      content: Container(
        width: 350,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(13)
          ),
          color: CustomColors.dynamicColor(
              colorScheme: ColorThemeScheme.background
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 15),

            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.error[3],
              ),
              child: Center(
                child: SVG(
                    icon,
                    height: 58,
                    width: 58,
                    color: CustomColors.error[2],
                    semanticsLabel: "Icon"
                ),
              ),
            ),

            const SizedBox(height: 15),

            CustomText(
              title,
              style: TextStyle(
                color: CustomColors.error[2],
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            CustomText(
              subtitle,
              style: TextStyles(
                color: CustomColors.dynamicColor(
                  colorScheme: ColorThemeScheme.greyAccentOne,
                ),
              ).textBodyLarge,
              maxLines: 4,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 10,
                  child: Center(
                    child: CustomButton(
                      height: 48,
                      color: CustomColors.primary[3],
                      onPressed: onDismiss!,
                      text: dismissText,
                      isOutlined: true,
                    ),
                  ),
                ),

                const Expanded(
                    flex: 1,
                    child: SizedBox()
                ),

                Expanded(
                  flex: 10,
                  child: CustomButton(
                    height: 48,
                    onPressed: onConfirm,
                    text: confirmationText,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  });
}