import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/shared/shared.dart';


class OfflineDisplayQR extends StatelessWidget {
  OfflineDisplayQR({Key? key}) : super(key: key);

  final controller = Get.find<OfflineDetailsController>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        controller.changeTab(controller.currentTab.value - 1);
        return false;
      },
      child: Scaffold(
        backgroundColor: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.background),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.changeTab(controller.currentTab.value - 1);
            },
            icon: SVG(
                'assets/icons/back_arrow.svg',
                height: 24,
                width: 24,
                color: CustomColors.dynamicColor(
                    colorScheme: ColorThemeScheme.accent
                  ),
                semanticsLabel: "Back"
            ),
          ),
          elevation: 0,
          backgroundColor: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.background),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {

            //TODO Remove all similar conditions that were added just for the pitch
            if(constraints.maxHeight > 650) {
              return const _Body(isFull: true);
            } else {
              return const SingleChildScrollView(child: _Body(isFull: false));
            }
          },
        ),
      ),
    );
  }

}

class _Body extends StatelessWidget {
  final bool isFull;
  const _Body({Key? key, required this.isFull}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OfflineDetailsController>();

    return Container(
      width: Dimen.width(context),
      padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth(context) * 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(height: Dimen.verticalMarginHeight(context) * 2),

          SizedBox(
              width: Dimen.width(context) - Dimen.horizontalMarginWidth(context) * 6,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return OfflineQRCode(
                      controller.decryptedData,
                      maxWidth: constraints.maxWidth
                  );
                }
              )
          ),

          SizedBox(height: Dimen.verticalMarginHeight(context) * 2),

          Container(
              width: double.infinity,
              padding: EdgeInsets.all(Dimen.horizontalMarginWidth(context) * 2),
              decoration: BoxDecoration(
                  color: CustomColors.primary,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: CustomColors.primary[2],
                            borderRadius: BorderRadius.circular(18)
                        ),
                        child: const Center(
                          child: SVG(
                              'assets/icons/idea.svg',
                              height: 24,
                              width: 24,
                              color: CustomColors.primary,
                              semanticsLabel: "Idea"
                          ),
                        )
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: Dimen.verticalMarginHeight(context) * 0.5),
                              child: Builder(
                                  builder: (context) {
                                    String text = "";
                                    if(controller.currentTab.value == 1){
                                      text =  "Ask the sender to scan this QR code to"
                                          " confirm this transaction. "
                                          "\nClick on continue once the sender has"
                                          " scanned the QR.";
                                    } else if(controller.currentTab.value == 2){
                                      text =  "Ask the receiver to scan this QR code to"
                                          " confirm this transaction. "
                                          "\nClick on continue once the receiver has"
                                          " scanned the QR.";
                                    }
                                    return CustomText(
                                      text,
                                      style: TextStyles(
                                        lineHeight: 1.4,
                                        color: CustomColors.primary[3],
                                      ).textBodyLarge,
                                      textAlign: TextAlign.start,
                                      maxLines: 4,
                                    );
                                  }
                              ),
                            ),
                          ]
                      ),
                    )
                  ]
              )
          ),

          Builder(
            builder: (context) {
              if(isFull){
                return Expanded(child: SizedBox(height: Dimen.verticalMarginHeight(context) * 2));
              } else {
                return SizedBox(height: Dimen.verticalMarginHeight(context) * 2);
              }
            }
          ),

          CustomButton(
              text: controller.currentTab.value == 2 ? "Finish" : "Continue",
              onPressed: () async {
                controller.currentTab.value == 2
                    ? confirmReceiverScan(context, controller)
                    : controller.changeTab(controller.currentTab.value + 1);
              }
          ),

          SizedBox(height: Dimen.verticalMarginHeight(context) * 3),
        ],
      ),
    );
  }

  void confirmReceiverScan (BuildContext context, OfflineDetailsController controller) {
    showConfirmationDialog(
        parentContext: context,
        icon: 'assets/icons/round_error.svg',
        title: "Finish Transaction",
        confirmationText: "Confirmed",
        subtitle: "Please confirm that the receiver has scanned this code before you continue",
        onConfirm: () {
          controller.changeTab(3);
          Get.back();
        }
    );
  }

}

