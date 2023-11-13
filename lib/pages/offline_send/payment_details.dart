import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/shared/shared.dart';

import 'authorize_offline_send.dart';

class PaymentDetails extends StatelessWidget {

  const PaymentDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<OfflineDetailsController>();

    final TextEditingController amount = TextEditingController();
    final TextEditingController description = TextEditingController();

    final String value = controller.decryptedData[Constants.value] ?? "0";
    final String currency = controller.decryptedData[Constants.currency] ?? Constants.nairaSign;
    final String receiversAddress = controller.decryptedData[Constants.receiverWalletAddress] ?? "";
    final String receiversName = controller.decryptedData[Constants.receiverName] ?? "";
    final String descriptionText = controller.decryptedData[Constants.description] ?? "";

    final String walletAddress = controller.walletAddress;
    final int walletBalance = controller.walletBalance - controller.pendingBalance;
    final int availableLimit = controller.availableLimit;

    amount.text = value;
    description.text = descriptionText.isEmpty ? "Nil" : descriptionText;

    return WillPopScope(
      onWillPop: () async {
        controller.changeTab(controller.currentTab.value - 1);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            backgroundColor: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.background),
            appBar: AppBar(
              centerTitle: false,
              title: CustomText(
                "Payment Details",
                style: TextStyles(
                    color: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.primaryHeader)
                ).displayTitleSmall,
              ),
              leading: IconButton(
                onPressed: () {
                  controller.changeTab(controller.currentTab.value - 1);
                },
                icon: SVG(
                    'assets/icons/back_arrow.svg',
                    height: 24,
                    width: 24,
                    color: CustomColors.dynamicColor(
                        colorScheme: ColorThemeScheme.accent
                    ),
                    semanticsLabel: "Back"
                ),
              ),
              backgroundColor: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.background),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Container(
                height: Dimen.height(context) - 96,
                width: Dimen.width(context),
                padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth(context) * 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: Dimen.width(context) - Dimen.horizontalMarginWidth(context) * 6,
                        margin: EdgeInsets.symmetric(vertical: Dimen.verticalMarginHeight(context)),
                        color: Colors.transparent,
                        child: _ReceiversDetails(
                          receiversAddress: receiversAddress,
                          receiversName: receiversName,
                        )
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight(context) * 0.5),

                    OfflineWalletItem(
                      title: "Offline Wallet",
                      subtitle: walletAddress,
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight(context) * 2),

                    GetX<OfflineDetailsController>(
                        builder: (controller) {
                          return CustomTextField(
                            controller: amount,
                            enabled: false,
                            hintText: Utils.resolveLimits(currency, 0),
                            prefix: SizedBox(
                                height: 20,
                                width: 20,
                                child: CustomText(
                                  Constants.nairaSign,
                                  style: TextStyles(
                                      color: CustomColors.dynamicColor(
                                          colorScheme: ColorThemeScheme.accent
                                      )
                                  ).textTitleExtraLarge,
                                  textAlign: TextAlign.center,
                                )
                            ),
                            errorText: controller.amountError.value == "" ? null : controller.amountError.value,
                            labelText: "Amount",
                          );
                        }
                    ),

                    const SizedBox(height: 10),

                    Builder(
                        builder: (controller) {
                          String balance = '$currency'
                              '${walletBalance.toDouble().toStringAsFixed(2)}';
                          String limit = '$currency'
                              '${availableLimit.toDouble().toStringAsFixed(2)}';
                          return BalanceWidget(
                              balance: balance,
                              currency: currency,
                              extraItemText: "AVAILABLE LIMIT",
                              extraItemBalance: limit,
                              extraItemCurrency: currency
                          );
                        }
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight(context)),

                    CustomTextField(
                      enabled: false,
                      controller: description,
                      hintText: "Food, Bills, etc",
                      labelText: "Description",
                      maxLength: 50,
                      keyboardType: TextInputType.name,
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight(context) * 2),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(height: Dimen.verticalMarginHeight(context)),

                          CustomButton(
                            text: "Proceed",
                            onPressed: () {
                              _proceedWithTransaction(context, controller);
                            },
                            margin: EdgeInsets.zero,
                          ),

                          SizedBox(height: Dimen.verticalMarginHeight(context) * 2),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
            )
        ),
      ),
    );
  }

  bool validateField (OfflineDetailsController controller){
    FocusManager.instance.primaryFocus?.unfocus();

    final double amountValue = double.parse(controller.decryptedData[Constants.value] ?? 0);

    if (amountValue > (controller.walletBalance - controller.pendingBalance)) {
      controller.amountError.value = "Insufficient Balance";
      return false;
    } else if (amountValue > controller.availableLimit) {
      controller.amountError.value = "Limit Exceeded";
      return false;
    }

    return true;
  }

  Future<void> _proceedWithTransaction (BuildContext context, OfflineDetailsController controller) async {
    if(validateField(controller)){

      showModalBottomSheet(
        context: context,
        backgroundColor: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.background),
        constraints: const BoxConstraints(maxHeight: 560),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            )
        ),
        builder: (context) => AuthorizeOfflineSend(pin: controller.pin),
      );
    }
  }
}

class _ReceiversDetails extends StatelessWidget {
  final String receiversName;
  final String receiversAddress;

  const _ReceiversDetails({
    required this.receiversName,
    required this.receiversAddress,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(10)
        ),
        color: CustomColors.secondaryPurple[3],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)
                    ),
                    color: CustomColors.primary,
                  ),
                  child: const ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10)
                      ),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          height: 45,
                          width: 45,
                          child: Center(
                            child: SVG(
                                'assets/icons/profile.svg',
                                height: 22,
                                width: 22,
                                color: CustomColors.white,
                                semanticsLabel: "Profile"
                            ),
                          ),
                        ),
                      )
                  ),
                ),

                const SizedBox(width: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        "Profile name",
                        style: TextStyles(
                            color: CustomColors.grey
                        ).textSubtitleLarge
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight(context) * 0.25),

                    CustomText(
                      receiversName,
                      style: TextStyles(
                        color: CustomColors.secondaryPurple,
                      ).textTitleExtraLarge,

                    )
                  ],
                ),

              ],
            ),
          ),

          Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: BrokenLineSeparator(color: CustomColors.grey[2])
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 10
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                SizedBox(
                  height: 18,
                  child: CustomText(
                    "Wallet Address",
                    style: TextStyles(
                        color: CustomColors.grey
                    ).textBodyLarge,
                  ),
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        receiversAddress,
                        style: TextStyles(
                            color: CustomColors.grey
                        ).textSubtitleLarge,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}