// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/logic/logic.dart';
import 'package:kuepay_qr/shared/shared.dart';
import 'package:kuepay_qr/config/config.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

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

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        if(controller.backPresses.value == 1
            && DateTime.now().difference(controller.lastBackPress.value)
                <= const Duration(seconds: 3)){
          return exit(0);
        }
        else {
          controller.backPresses.value = 1;
          controller.lastBackPress.value = DateTime.now();

          Snack.show(context, message: "Press back again to exit", type: SnackBarType.warning);

          return Future(() => false);
        }
      },
      child: Scaffold(
        body: Container(
          color: CustomColors.dynamicColor(
              colorScheme: ColorThemeScheme.background
          ),
          padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth(context) * 3),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [

                  Expanded(
                    child: Column(
                      children: [

                        Expanded(
                          child: SVG(
                              'assets/images/offline.svg',
                              height: Dimen.width(context),
                              width: Dimen.width(context),
                              semanticsLabel: "Offline"
                          ),
                        ),

                        SizedBox(height: Dimen.height(context) * 0.1),

                      ],
                    ),
                  ),

                  Container(
                    height: 42,
                    width: Dimen.width(context) * 0.9,
                    decoration: BoxDecoration(
                      color: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.background),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(12)
                      ),
                    ),
                    child: MaterialButton(
                      height: 42,
                      minWidth:  Dimen.width(context) * 0.9,
                      padding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(12)
                        ),
                      ),
                      elevation: 0,
                      onPressed: () async {
                        Utils.startLoading();
                        final data = await getData();
                        Utils.stopLoading();

                        if(data.isNotEmpty) {
                          controller.data = data;
                          controller.history();
                        } else {
                          Snack.show(context, message: "Could not get user data", type: SnackBarType.error);
                        }
                      },
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              const Expanded(child: SizedBox()),

                              CustomText(
                                  "VIEW OFFLINE TRANSACTIONS",
                                  style: TextStyles(
                                    color: CustomColors.info,
                                  ).textBodyLarge
                              ),

                              const Expanded(child: SizedBox()),

                            ],
                          )
                      ),
                    ),
                  ),

                  SizedBox(height: Dimen.verticalMarginHeight(context)),

                ],
              ),

              Column(
                children: [

                  const Expanded(flex: 1, child: SizedBox()),

                  Container(
                    width: Dimen.width(context),
                    padding: EdgeInsets.symmetric(
                        vertical: Dimen.verticalMarginHeight(context),
                        horizontal: Dimen.horizontalMarginWidth(context) * 2
                    ),
                    decoration: BoxDecoration(
                        color: CustomColors.primary,
                        borderRadius: BorderRadius.circular(16)
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: CustomColors.primary[2],
                                  borderRadius: BorderRadius.circular(18)
                              ),
                              child: const Center(
                                child: SVG(
                                    'assets/icons/idea.svg',
                                    height: 24,
                                    width: 24,
                                    color: CustomColors.primary,
                                    semanticsLabel: "Idea"
                                ),
                              )
                          ),

                          SizedBox(width: Dimen.horizontalMarginWidth(context) * 2),

                          Expanded(
                            child: CustomText(
                              "You are currently offline but, you can still carry out an offline transaction",
                              style: TextStyles(
                                color: CustomColors.primary[3],
                              ).textBodyExtraLarge,
                              maxLines: 3,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ]
                    ),
                  ),

                  const Expanded(flex: 4, child: SizedBox()),

                  Row(
                    children: [

                      const Expanded(flex: 2, child: SizedBox()),

                      Expanded(
                        flex: 9,
                        child: item(
                          color: CustomColors.secondaryPurple,
                          icon: 'assets/icons/send.svg',
                          onPressed: () async {
                            Utils.startLoading();
                            final data = await getData();
                            Utils.stopLoading();

                            if(data.isNotEmpty) {
                              controller.data = data;
                              controller.offlineSend();
                            } else {
                              Snack.show(context, message: "Could not get user data", type: SnackBarType.error);
                            }
                          },
                          title: "Offline Send",
                        ),
                      ),

                      const Expanded(flex: 1, child: SizedBox()),

                      Expanded(
                        flex: 9,
                        child: item(
                          color: CustomColors.secondaryOrange,
                          icon: 'assets/icons/receive.svg',
                          onPressed: () async {
                            Utils.startLoading();
                            final data = await getData();
                            Utils.stopLoading();

                            if(data.isNotEmpty) {
                              final controller = Get.find<KuepayOfflineController>();
                              controller.data = data;
                              controller.offlineReceive();
                            } else {
                              Snack.show(context, message: "Could not get user data", type: SnackBarType.error);
                            }
                          },
                          title: "Offline Receive",
                        ),
                      ),

                      const Expanded(flex: 2, child: SizedBox()),

                    ],
                  ),

                  SizedBox(height: Dimen.verticalMarginHeight(context) * 1),

                  const PendingWalletItem(),

                  SizedBox(height: Dimen.verticalMarginHeight(context) * 1.5),

                  CustomButton(
                    text: "Reconnect to App",
                    onPressed: () {
                      if(controller.isOffline.value) {
                        Snack.show(context, message: "Could not connect to the internet", type: SnackBarType.error);
                      } else {
                        controller.hideScreen();
                        Utils.completeOfflineTransactions(context);
                      }
                    },
                    margin: EdgeInsets.zero,
                  ),

                  SizedBox(height: Dimen.verticalMarginHeight(context)),

                  const SizedBox(height: 42),

                  SizedBox(height: Dimen.verticalMarginHeight(context)),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget item ({
    required MaterialColor color,
    required String icon,
    required void Function() onPressed,
    required String title
  }) {
    return LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth;

          return Container(
            height: size * 0.84,
            width: size,
            decoration: BoxDecoration(
                color: color[3]!,
                borderRadius: const BorderRadius.all(
                    Radius.circular(16)
                )
            ),
            child: MaterialButton(
              height: size * 0.84,
              minWidth: size,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(16)
                  )
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: Dimen.horizontalMarginWidth(context) * 2.25,
                  vertical: Dimen.verticalMarginHeight(context)
              ),
              color: color[3]!,
              onPressed: onPressed,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  SizedBox(height: size * 0.065),

                  SVG(
                    icon,
                    height: size * 0.28,
                    width: size * 0.28,
                    color: color,
                    semanticsLabel: "Icon",
                  ),

                  const Expanded(child: SizedBox()),

                  CustomText(
                    title,
                    style: TextStyles(
                      color: color,
                    ).textTitleLarge,
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  static Future<Map> getData() async {
    final Map<String, dynamic> userData = await UserData.details;
    final Map<String, String> walletData = await OfflineWallet.details;

    final Map<String, dynamic> data = userData;

    data.addEntries(walletData.entries);

    return data;
  }
}


class PendingWalletItem extends StatefulWidget {
  const PendingWalletItem({Key? key}) : super(key: key);

  @override
  State<PendingWalletItem> createState() => _PendingWalletItemState();
}

class _PendingWalletItemState extends State<PendingWalletItem> {

  Wallet wallet = Wallet.empty();
  String availableBalance = "0";

  @override
  void initState() {

    getBalance();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    wallet.name = 'assets/images/tribal_bg.png';
    wallet.background = 'assets/images/tribal_bg.png';
    wallet.colors = [
      const Color(0xFF872626),
      const Color(0xFFD93030),
      const Color(0xFFFFF3F0)
    ];

    final balance = Utils.fillCommas(double.parse(Utils.removeCommas(wallet.balance)).toInt().toString());
    final available = Utils.fillCommas(double.parse(Utils.removeCommas(availableBalance)).toInt().toString());

    return Container(
      constraints: const BoxConstraints(
          maxHeight: 168
      ),
      margin: const EdgeInsets.only(right: 12),
      child: AspectRatio(
        aspectRatio: 2.8,
        child: LayoutBuilder(
            builder: (context, constraints) {
              final maxHeight = constraints.maxHeight;
              final maxWidth = constraints.maxWidth;
              return Container(
                width: Dimen.width(context),
                height: 100,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          wallet.colors[0],
                          wallet.colors[1]
                        ]
                    ),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            wallet.background,
                            package: 'kuepay_qr'
                        )
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(24)
                    )
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: maxHeight * 0.1,
                      horizontal: maxWidth * 0.075
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        "AVAILABLE BALANCE",
                                        style: TextStyles(
                                          color: CustomColors.white.withOpacity(0.54),
                                        ).textBodyLarge,
                                      ),

                                      SizedBox(height: maxHeight * 0.035),

                                      CustomText(
                                        '${wallet.currency}$available',
                                        style: available.length > 9 ? TextStyles(
                                          color: CustomColors.white,
                                        ).displayTitleMedium : TextStyles(
                                          color: CustomColors.white,
                                        ).displayTitleLarge,
                                      ),
                                    ],
                                  ),

                                  const Expanded(child: SizedBox()),

                                  SizedBox(width: Dimen.horizontalMarginWidth(context))
                                ],
                              ),
                            ),

                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        "PENDING BALANCE",
                                        style: TextStyles(
                                          color: CustomColors.white.withOpacity(0.54),
                                        ).textBodyLarge,
                                      ),

                                      SizedBox(height: maxHeight * 0.035),

                                      CustomText(
                                        '${wallet.currency}$balance',
                                        style: balance.length > 9 ? TextStyles(
                                          color: CustomColors.white,
                                        ).displayTitleMedium : TextStyles(
                                          color: CustomColors.white,
                                        ).displayTitleLarge,
                                      ),
                                    ],
                                  ),

                                  const Expanded(child: SizedBox()),

                                ],
                              ),
                            ),
                          ],
                        ),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              BrokenLineSeparator(
                                  dashWidth: 3,
                                  color: CustomColors.white.withOpacity(0.5)
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: maxHeight * 0.085),

                        Row(
                          children: [


                            SVG(
                                'assets/icons/notification_info.svg',
                                height: 16,
                                width: 16,
                                color: CustomColors.white.withOpacity(0.54),
                                semanticsLabel: "Info"
                            ),

                            SizedBox(width: Dimen.horizontalMarginWidth(context)),

                            Expanded(
                              child: CustomText(
                                "YOU NEED TO BE CONNECTED TO THE INTERNET TO SECURED THESE FUNDS",
                                style: TextStyles(
                                  color: CustomColors.white.withOpacity(0.54),
                                ).textSubtitleMedium,
                                maxLines: 3,
                                textAlign: TextAlign.start,
                              ),
                            ),

                          ],
                        ),

                      ]
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  void getBalance() async {
    double balance = 0.0;

    final stringTransactions = await OfflineTransactions.transactions;

    for (String encrypted in stringTransactions) {
      final decrypted = await Utils.decryptVariable(encrypted);
      final Map<String, dynamic> data = jsonDecode(decrypted) as Map<String, dynamic>;

      final value = num.parse(data[Constants.value] ?? "0").ceil();

      String amount = (value).toString();
      String receiverID = data[Constants.receiverID];
      bool isInflow = receiverID == Get.find<OfflineDetailsController>().userId;

      if(isInflow) balance = balance + num.parse(amount).toDouble();
    }

    final available = await OfflineWallet.balance;

    setState(() {
      wallet.balance = balance.floor().toString();
      availableBalance = available;
    });
  }
}
