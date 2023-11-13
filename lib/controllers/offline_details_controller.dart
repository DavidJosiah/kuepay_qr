import 'package:get/get.dart';

import 'package:kuepay_qr/logic/logic.dart';

class OfflineDetailsController extends GetxController{

  RxMap data = {}.obs;

  RxInt transactionStatus = 1.obs;

  RxInt currentTab = 0.obs;
  RxInt currentAuthorizationTab = 0.obs;

  RxInt time = 0.obs;

  RxBool isOnlineTransaction = false.obs;

  RxString amount = "".obs;
  RxString description = "".obs;

  RxString amountError = "".obs;

  final RxString _encryptedData = "".obs;
  final RxMap _decryptedData = {}.obs;

  void changeTab(int newTabIndex) {
    currentTab.value = newTabIndex;
  }

  void changeAuthorizationTab(int newTabIndex) {
    currentAuthorizationTab.value = newTabIndex;
  }

  set decryptedData(Map map){
    _decryptedData.value = map;
  }

  set encryptedData(String data){
    _encryptedData.value = data;
  }

  String get encryptedData  => _encryptedData.value;

  Map get decryptedData  => _decryptedData;

  String get userId => data["userId"];
  String get name => data["name"];
  String get walletAddress => data["walletAddress"];
  int get walletBalance => num.parse(data["walletBalance"].toString()).toInt();
  int get availableLimit => (data["availableLimit"] as num).toInt();
  String get pin => data["pin"];

  final RxInt _pendingBalance = 0.obs;

  int get pendingBalance => _pendingBalance.value;

  set pendingBalance (int value) => _pendingBalance.value = value;

  Rx<Transaction> completedTransaction = Transaction.empty().obs;

  RxString flow = "Money In".obs;

  final List<String> flows = ["Money In", "Money Out"];

  int getFlowIndex() {
    for(int i = 0; i < flows.length; i++){
      if(flows[i] == flow.value){
        return i;
      }
    }
    return 0;
  }

}