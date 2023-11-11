import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/controllers/controllers.dart';

import '../offline_scan_qr.dart';
import '../offline_display_qr.dart';

import 'payment_details.dart';
import 'offline_send_complete.dart';

class OfflineSend extends StatefulWidget {
  OfflineSend({Key? key}) : super(key: key){
    Get.put (OfflineDetailsController());
  }

  @override
  State<OfflineSend> createState() => _OfflineSendState();
}

class _OfflineSendState extends State<OfflineSend> {

  @override
  void initState() {
    final controller = Get.find<OfflineDetailsController>();

    controller.changeTab(0);
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
    screens = [const OfflineScanQR(), const PaymentDetails(), OfflineDisplayQR(), const OfflineSendComplete()];

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
