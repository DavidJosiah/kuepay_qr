import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/controllers/controllers.dart';

import '../offline_scan_qr.dart';
import '../offline_display_qr.dart';

import 'create_payment.dart';
import 'offline_receive_complete.dart';

class OfflineReceive extends StatefulWidget {
  OfflineReceive({Key? key}) : super(key: key){
    Get.delete<OfflineDetailsController>();
    Get.put (OfflineDetailsController());
  }

  @override
  State<OfflineReceive> createState() => _OfflineReceiveState();
}

class _OfflineReceiveState extends State<OfflineReceive> {

  @override
  void initState() {
    final controller = Get.find<OfflineDetailsController>();

    controller.data.value = Get.find<KuepayOfflineController>().data;
    controller.decryptedData = {};

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return _Default();
  }
}

class _Default extends StatelessWidget {
  _Default({Key? key}) : super(key: key);

  final bucket = PageStorageBucket();
  late final List<Widget> screens;

  @override
  Widget build(BuildContext context) {

    screens = [const CreatePayment(), OfflineDisplayQR(), const OfflineScanQR(), const OfflineReceiveComplete()];

    return Scaffold(
        body: GetX<OfflineDetailsController>(builder: (controller) {
          return PageStorage(
              bucket: bucket,
              child: screens[controller.currentTab.value]
          );
        })
    );
  }
}