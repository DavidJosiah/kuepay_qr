// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/shared/shared.dart';

import 'package:qr_flutter/qr_flutter.dart';

class QRDialog {
  QRDialog.show(BuildContext context, {required String data}){
    final GlobalKey repaintKey = GlobalKey();

    showDialog(context: context, builder: (BuildContext context) {
      final width = Dimen.width(context) * 0.9;
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
          padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: 5),
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
                        padding: EdgeInsets.all(Dimen.horizontalMarginWidth(context)),
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
                                size: availableWidth -
                                    (Dimen.horizontalMarginWidth(context) * 2),
                              ),

                              SVG(
                                  'assets/images/qr_logo_green.svg',
                                  height: (availableWidth -
                                      (Dimen.horizontalMarginWidth(context) * 2)) * 0.17,
                                  width: (availableWidth -
                                      (Dimen.horizontalMarginWidth(context) * 2)) * 0.17,
                                  semanticsLabel: "QR Logo"
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    CustomButton(
                      height: Dimen.height(context) * 0.06,
                      onPressed: () {
                        _saveQR(context, repaintKey);
                      },
                      text: "Save",
                    ),

                    const SizedBox(height: 10),

                    CustomButton(
                      height: Dimen.height(context) * 0.06,
                      onPressed: () {
                        Navigator.pop(context);
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
        Navigator.pop(context);
        Snack.show(context, message: "QR saved successfully", type: SnackBarType.info);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return;
    }
  }

}