import 'package:get/get.dart';

class KuepayOfflineController extends GetxController {

  RxBool isOffline = false.obs;
  RxBool hasBeenOffline = false.obs;

  RxInt backPresses = 0.obs;
  Rx<DateTime> lastBackPress = DateTime.now().obs;

  final RxBool _isShowingScreen = false.obs;

  void showScreen() {
    _isShowingScreen.value = true;
  }

  void hideScreen() {
    _isShowingScreen.value = false;
  }

  bool get isShowingScreen => _isShowingScreen.value;


  final RxBool _isLoading = false.obs;

  final RxBool _isSheetLoading = false.obs;

  final RxBool _isCompletingOffline = false.obs;

  final RxBool _isDataComplete = false.obs;

  bool get isLoading => _isLoading.value;

  bool get isCompletingOffline => _isCompletingOffline.value;

  bool get isDataComplete => _isDataComplete.value;

  void startLoading() => _isLoading.value = true;

  void stopLoading() => _isLoading.value = false;

  void startSheetLoading() => _isSheetLoading.value = true;

  void stopSheetLoading() => _isSheetLoading.value = false;

  void startCompletingOffline() => _isCompletingOffline.value = true;

  void stopCompletingOffline() => _isCompletingOffline.value = false;

  set isDataComplete(bool value) => _isDataComplete.value = value;

  final RxMap _data = {}.obs;

  Map get data => _data;

  set data (Map data) {
    _data.value = data;
  }
  RxInt currentTab = 0.obs;

  void changeTab(int newTabIndex) {
    currentTab.value = newTabIndex;
  }

  void home() {
    changeTab(0);
  }

  void history() {
    changeTab(1);
  }

  void offlineSend() {
    changeTab(2);
  }

  void offlineReceive() {
    changeTab(3);
  }
}