import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/controllers/controllers.dart';

import 'offline_receive/offline_receive.dart';
import 'offline_send/offline_send.dart';

import 'home.dart';
import 'offline_history.dart';

class OfflineScreen extends StatefulWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {

  final controller = Get.find<KuepayOfflineController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isOffline.listen((isOffline){
        if(!isOffline && controller.isShowingScreen) {
            controller.hideScreen();
        }
      });
    });

    super.initState();
  }

  final bucket = PageStorageBucket();

  final List<Widget> screens = [
    const Home(),
    OfflineHistory(),
    OfflineSend(),
    OfflineReceive(),
  ];

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
        body: GetX<KuepayOfflineController>(
            builder: (controller) {
              return PageStorage(
                  bucket: bucket,
                  child: screens[controller.currentTab.value]
              );
            })
    );
  }
}