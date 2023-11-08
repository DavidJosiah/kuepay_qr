import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/shared/shared.dart';

import 'package:qr_flutter/qr_flutter.dart';

class QRDialog {
  QRDialog.show({required String data}){

    final GlobalKey repaintKey = GlobalKey();

    showDialog(context: Get.context!, builder: (BuildContext context) {
      final width = Dimen.width * 0.9;
      const horizontalPadding = 20.0;

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
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
                Radius.circular(13)
            ),
            color: CustomColors.dynamicColor(
                colorScheme: ColorThemeScheme.background
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(height: 15),

                  RepaintBoundary(
                    key: repaintKey,
                    child: Container(
                      height: availableWidth,
                      width: availableWidth,
                      padding: EdgeInsets.all(Dimen.horizontalMarginWidth),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: CustomColors.primary[3],
                      ),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            QrImageView(
                              data: data,
                              size: availableWidth - (Dimen.horizontalMarginWidth * 2),
                            ),

                            SvgPicture.asset(
                                'assets/images/qr_logo_green.svg',
                                height: (availableWidth - (Dimen.horizontalMarginWidth * 2)) * 0.17,
                                width: (availableWidth - (Dimen.horizontalMarginWidth * 2)) * 0.17,
                                semanticsLabel: "QR Logo"
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  CustomButton(
                    height: Dimen.height * 0.06,
                    onPressed: () {
                      _saveQR(context, repaintKey);
                    },
                    text: "Save",
                  ),

                  const SizedBox(height: 10),

                  CustomButton(
                    height: Dimen.height * 0.06,
                    onPressed: () {
                      Get.back();
                    },
                    isOutlined: true,
                    text: "Cancel",
                  ),

                  const SizedBox(height: 10),
                ],
              );
            }
          ),
        ),
      );
    });
  }

  void _saveQR (BuildContext context, GlobalKey repaintKey) async {
    try {
      RenderRepaintBoundary? boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if(boundary == null) return null;

      Utils.startLoading();

      final result = await Utils.saveWidgetAsImage(boundary, "qr");

      Utils.stopLoading();

      if(result) {
        Get.back();
        Snack.show(message: "QR saved successfully", type: SnackBarType.info);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return;
    }
  }

}