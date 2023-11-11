import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/./controllers/controllers.dart';
import 'package:kuepay_qr/./logic/logic.dart';
import 'package:kuepay_qr/./shared/shared.dart';

import 'confirm_offline_details.dart';

class AuthorizeOfflineSend extends StatelessWidget {
  final String pin;
  AuthorizeOfflineSend({Key? key, required this.pin}) : super(key: key);

  final bucket = PageStorageBucket();
  late final List<Widget> screens;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OfflineDetailsController>();
    controller.currentAuthorizationTab = 0.obs;

    screens = [
      const ConfirmOfflineDetails(),

      PinKeyboard(
        offlinePin: pin,
        onButtonClick: () {
          QRTransaction.completeOfflineSend(context, controller);
        },
      )
    ];

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: GetX<OfflineDetailsController>(
            builder: (controller) {
              return PageStorage(
                  bucket: bucket,
                  child: screens[controller.currentAuthorizationTab.value]
              );
            })
    );
  }
}