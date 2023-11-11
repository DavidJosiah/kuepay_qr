import 'package:background_fetch/background_fetch.dart' as background;
import 'package:kuepay_qr/config/config.dart';

class KuepayQRMethods {

  /// Register to receive BackgroundFetch events after app is terminated.
  /// Requires {stopOnTerminate: false, enableHeadless: true}
  /// Call this method after runApp(...);
  void registerHeadlessTask (Function fetchHeadlessTask){
    background.BackgroundFetch.registerHeadlessTask(
        fetchHeadlessTask
    );
  }

  ///Call this outside your main method and pass as the value for registerHeadless().
  ///Add the tag @pragma('vm:entry-point') to the top of the method as well
  /// i.e.
  ///      @pragma('vm:entry-point')
  ///      void fetchHeadlessTask(HeadlessTask task) {
  ///         KuepayQRMethods().backgroundFetchHeadlessTask(task);
  ///      }
  ///
  /// then,
  ///     ...
  ///     runApp(...);
  ///     KuepayQRMethods().registerHeadlessTask(fetchHeadlessTask);
  ///

  void backgroundFetchHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    if (isTimeout) {
      background.BackgroundFetch.finish(taskId);
      return;
    }
    background.BackgroundFetch.finish(taskId);
  }

  ///Call this as a top level method
  Future<void> initPlatformState() async {
    await background.BackgroundFetch.configure(
        background.BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: background.NetworkType.ANY
        ), (String taskId) async {
      await Utils.completeOfflineTransactions(null, isBackground: true);
      background.BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      background.BackgroundFetch.finish(taskId);
    });
  }

  Future<void> fundWallet() async {
    //TODO
    //TODO OfflineWallet.credit
  }

  Future<void> getWalletDetails() async {
    //TODO
  }

  Future<void> beginBalanceSync() async {
    //TODO
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    //TODO
    return [];
  }
}

class HeadlessTask extends background.HeadlessTask {
  HeadlessTask(super.taskId, super.timeout);
}


