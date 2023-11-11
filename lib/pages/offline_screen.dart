import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/shared/shared.dart';

import 'offline_receive/offline_receive.dart';
import 'offline_send/offline_send.dart';

import 'home.dart';
import 'offline_history.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CustomText.referenceSize = Constants.extraSmallScreenSize;

    return GetMaterialApp(
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          fontFamily: "DMSans",
          package: "kuepay_qr",
          primaryColor: CustomColors.primary,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: CustomColors.primary,
            selectionColor: CustomColors.primary[2],
            selectionHandleColor: CustomColors.primary,
          ),
        ),
        initialRoute: '/',
        getPages: [
          GetPage(name: "/", page: () => const _Default()),
        ],
        locale: const Locale('en', '')
    );
  }
}

class _Default extends StatefulWidget {
  const _Default({Key? key}) : super(key: key);

  @override
  State<_Default> createState() => _DefaultState();
}

class _DefaultState extends State<_Default> {

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
  Widget build(BuildContext context) {
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
