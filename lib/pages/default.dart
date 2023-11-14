import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/logic/logic.dart';
import 'package:kuepay_qr/services/services.dart';
import 'package:kuepay_qr/shared/shared.dart';

import 'offline_screen.dart';

class KuepayOffline extends StatefulWidget {
  final Widget child;
  final bool darkMode;
  KuepayOffline({Key? key, required this.child, this.darkMode = false}) : super(key: key){
    Get.put(KuepayOfflineController());
  }

  @override
  State<KuepayOffline> createState() => _KuepayOfflineState();
}

class _KuepayOfflineState extends State<KuepayOffline> {

  final controller = Get.find<KuepayOfflineController>();

  final networkConnectivity = NetworkConnectivity.instance;

  Map _source = {ConnectivityResult.none: false};

  Timer offlineTimer = Timer.periodic(const Duration(seconds: 5), (_) {});

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((_) {

      networkConnectivity.initialise();

      networkConnectivity.stream.listen((source) {
        _source = source;

        final controller = Get.find<KuepayOfflineController>();

        switch (_source.keys.toList()[0]) {
          case ConnectivityResult.mobile:
            if(_source.values.toList()[0]) {
              controller.isOffline.value = false;
              if(controller.hasBeenOffline.value) {
                Utils.completeOfflineTransactions(context);
                controller.hasBeenOffline.value = false;
                Snack.show(
                  context,
                  message: "You are now online",
                  type: SnackBarType.info,
                );
              }
            } else if (!controller.isShowingScreen) {
              controller.hasBeenOffline.value = true;
              controller.showScreen();
            }
            break;
          case ConnectivityResult.wifi:
            if(_source.values.toList()[0]){
              controller.isOffline.value = false;

              if(controller.hasBeenOffline.value) {
                Utils.completeOfflineTransactions(context);
                controller.hasBeenOffline.value = false;
                Snack.show(
                  context,
                  message: "You are now online",
                  type: SnackBarType.info,
                );
              }

            } else if (!controller.isShowingScreen) {
              controller.hasBeenOffline.value = true;
              controller.showScreen();
            }
            break;
          case ConnectivityResult.none:
            controller.isOffline.value = true;

            if (!controller.isShowingScreen) {
              controller.hasBeenOffline.value = true;
              controller.showScreen();
            }
            break;
          default:
            controller.isOffline.value = true;

            if (!controller.isShowingScreen) {
              controller.hasBeenOffline.value = true;
              controller.showScreen();
            }
        }
      });

      offlineTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        Utils.completeOfflineTransactions(context);
      });

      if(controller.isOffline.value == false){
        Utils.completeOfflineTransactions(context);
      }

      _setData();
    });

    super.initState();
  }

  @override
  void dispose() {
    if(controller.hasListeners){
      controller.removeListener(() {});
    }

    offlineTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Utils.isDarkMode = widget.darkMode;

    return Stack(
      alignment: Alignment.center,
      children: [

        widget.child,

        GetX<KuepayOfflineController>(
          builder: (controller) {
            if(controller.isShowingScreen && controller.isDataComplete){
              return const OfflineScreen();
            } else {
              return const SizedBox();
            }
          }
        ),
      ],
    );
  }

  static Future<void> _setData() async {
    if (await UserData.isDataComplete()) {
      final Map<String, dynamic> userData = await UserData.details;
      final Map<String, String> walletData = await OfflineWallet.details;

      final Map<String, dynamic> data = userData;

      data.addEntries(walletData.entries);

      Get.find<KuepayOfflineController>().data = data;
    }
  }
}
