import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:kuepay_qr/logic/logic.dart';
import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/shared/shared.dart';

class OfflineScanQR extends StatefulWidget {
  const OfflineScanQR({Key? key}) : super(key: key);

  @override
  State<OfflineScanQR> createState() => _OfflineScanQRState();
}

class _OfflineScanQRState extends State<OfflineScanQR> {

  MobileScannerController cameraController = MobileScannerController();

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OfflineDetailsController>();

    return WillPopScope(
      onWillPop: () async {

        final controller = Get.find<KuepayOfflineController>();
        if(controller.currentTab.value == 0){
          controller.home();
        } else if(controller.currentTab.value == 2) {
          controller.changeTab(controller.currentTab.value - 1);
        }

        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                final controller = Get.find<KuepayOfflineController>();
                if(controller.currentTab.value == 0){
                  controller.home();
                } else if(controller.currentTab.value == 2) {
                  controller.changeTab(controller.currentTab.value - 1);
                }
              },
              icon: SvgPicture.asset(
                  'assets/icons/back_arrow.svg',
                  height: 24,
                  width: 24,
                  color: CustomColors.dynamicColor(
                      colorScheme: ColorThemeScheme.accent
                  ),
                  semanticsLabel: "Back"
              ),
            ),
            backgroundColor : CustomColors.dynamicColor(
                colorScheme: ColorThemeScheme.background
            ),
            elevation: 0,
          ),
          body:  Container(
            width: Dimen.width,
            color: CustomColors.dynamicColor(
                colorScheme: ColorThemeScheme.background
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Expanded(flex: 4, child: SizedBox()),

                SizedBox(height: Dimen.verticalMarginHeight),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    SvgPicture.asset(
                        'assets/icons/square_error.svg',
                        height: 24,
                        width: 24,
                        color: CustomColors.primary,
                        semanticsLabel: "Square Error"
                    ),

                    const SizedBox(width: 16),

                    SizedBox(
                      height: 24,
                      child: CustomText(
                        "Scan QR Code",
                        style: TextStyles(
                          color: CustomColors.dynamicColor(
                              colorScheme: ColorThemeScheme.accent
                          ),
                        ).displayTitleSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(width: 40),
                  ],
                ),

                SizedBox(height: Dimen.verticalMarginHeight),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                        'assets/images/scan_code.svg',
                        height: Dimen.width * 0.85,
                        width: Dimen.width * 0.85,
                        color: CustomColors.primary,
                        semanticsLabel: "Scan Code"
                    ),

                    Container(
                      height: Dimen.width * 0.825,
                      width: Dimen.width * 0.825,
                      color: CustomColors.dynamicColor(
                          colorScheme: ColorThemeScheme.background
                      ),
                      child: MobileScanner(
                          allowDuplicates: false,
                          controller: cameraController,
                          onDetect: (barcode, args) async {
                            if (barcode.rawValue == null) {
                              Toast.show(message: "Failed to scan QR Code", type: ToastType.error);
                            }
                            else {
                              final String code = barcode.rawValue!;
                              _handleQR(controller, code);
                            }
                          }
                      ),
                    ),
                  ],
                ),

                const Expanded(flex: 4, child: SizedBox()),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Expanded(child: SizedBox()),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: CustomColors.dynamicColor(
                                      colorScheme: ColorThemeScheme.primaryFill
                                  ),
                                  width: 1.5
                              )
                          ),
                          child: MaterialButton(
                              height: 64,
                              minWidth: 64,
                              elevation: 0,
                              color: CustomColors.primary[3],
                              shape: const CircleBorder(),
                              child: ValueListenableBuilder(
                                valueListenable: cameraController.torchState,
                                builder: (context, state, child) {
                                  switch (state) {
                                    case TorchState.off:
                                      return SvgPicture.asset(
                                          'assets/icons/flash_activate.svg',
                                          height: 24,
                                          width: 24,
                                          color: CustomColors.primary,
                                          semanticsLabel: "Activate Flash"
                                      );
                                    case TorchState.on:
                                      return SvgPicture.asset(
                                          'assets/icons/flash_deactivate.svg',
                                          height: 24,
                                          width: 24,
                                          color: CustomColors.primary,
                                          semanticsLabel: "Deactivate Flash"
                                      );
                                  }
                                },
                              ),
                              onPressed: () {
                                cameraController.toggleTorch();
                              }
                          ),
                        ),

                        SizedBox(height: Dimen.verticalMarginHeight * 0.5),

                        CustomText(
                            "Flash",
                            style: TextStyles(
                              color: CustomColors.dynamicColor(
                                  colorScheme: ColorThemeScheme.accent
                              ),
                            ).textBodyLarge
                        ),
                      ],
                    ),

                    const Expanded(child: SizedBox()),

                  ],

                ),

                const Expanded(flex: 5, child: SizedBox()),

              ],
            ),
          )
      ),
    );
  }

  Future<void> _handleQR (OfflineDetailsController controller, String encrypted) async {
    Map data = {};

    data = await QRTransaction.extractData(encrypted);

    if(data.isEmpty){
      return;
    }

    if(controller.currentTab.value == 0){
      QRTransaction.scanForOfflineSend(data, controller);
    } else if(controller.currentTab.value == 2) {
      QRTransaction.scanForOfflineReceive(data, controller);
    }
  }
}
