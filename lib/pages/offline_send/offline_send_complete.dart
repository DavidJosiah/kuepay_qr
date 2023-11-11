import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/shared/shared.dart';

class OfflineSendComplete extends StatelessWidget {
  const OfflineSendComplete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OfflineDetailsController>();

    final transaction = controller.completedTransaction.value;

    return TransactionDetails(
        transaction: transaction,
        isComplete: true,
        isOfflineTransaction: true,
        showOfflineDialog: !(controller.isOnlineTransaction.value
            || !Get.find<KuepayOfflineController>().isOffline.value)
    );
  }
}
