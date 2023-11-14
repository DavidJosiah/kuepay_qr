import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/logic/logic.dart';
import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/shared/shared.dart';

class CreatePayment extends StatelessWidget {

  const CreatePayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final TextEditingController amount = TextEditingController();
    final TextEditingController description = TextEditingController();

    final controller = Get.find<OfflineDetailsController>();

    const String currency = Constants.nairaSign;
    final String walletAddress = controller.walletAddress;
    final int walletBalance = controller.walletBalance - controller.pendingBalance;
    final int availableLimit = controller.availableLimit;

    return WillPopScope(
      onWillPop: () async {
        Get.find<KuepayOfflineController>().home();
        return false;
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
                  Get.find<KuepayOfflineController>().home();
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


                    SizedBox(height: Dimen.verticalMarginHeight(context) * 0.5),

                    OfflineWalletItem(
                      title: "Offline Wallet",
                      subtitle: walletAddress,
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight(context) * 2),

                    GetX<OfflineDetailsController>(
                        builder: (controller) {

                          if(amount.text != controller.amount.value) {
                            amount.text = controller.amount.value;
                          }

                          return CustomTextField(
                              controller: amount,
                              hintText: "500 - 500,000",
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
                              suffix: SizedBox(
                                  height: 20,
                                  width: 40,
                                  child: TextButton(
                                    onPressed: () {
                                      amount.text = controller.availableLimit.toString();
                                      controller.amount.value = amount.text;
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: 18,
                                        child: Text(
                                          "MAX",
                                          style: TextStyles(
                                              color: CustomColors.primary
                                          ).textBodyLarge,
                                        ),
                                      ),
                                    ),
                                  )
                              ),
                              errorText: controller.amountError.value == "" ? null : controller.amountError.value,
                              labelText: "Amount",
                              onChanged: (newValue) {
                                controller.amount.value = newValue;
                              },
                              keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                              inputFormatters: CustomFormatter.validAmount
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

                    GetX<OfflineDetailsController>(
                        builder: (controller) {
                          if(controller.description.value != "" && description.text == ""){
                            description.text = controller.description.value;
                          }
                          return CustomTextField(
                            controller: description,
                            hintText: "Food, Bills, etc",
                            labelText: "Description",
                            maxLength: 50,
                            onChanged: (value) {
                              controller.description.value = value;
                            },
                            keyboardType: TextInputType.name,
                          );
                        }
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
                              _proceedWithTransaction(controller, amount.text, description.text);
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

  bool validateField (OfflineDetailsController controller, String amount){
    FocusManager.instance.primaryFocus?.unfocus();

    const String currency = Constants.nairaSign;

    if(amount == ""){
      controller.amountError.value = "Amount should be at least $currency${Utils.resolveLimits(currency, 1)}";
      return false;
    }

    final double amountValue = double.parse(Utils.removeCommas(amount));

    if (amount.characters.isEmpty) {
      controller.amountError.value = "Amount should be at least $currency${Utils.resolveLimits(currency, 1)}";
      return false;
    }
    else{
      if (amountValue < double.parse(Utils.removeCommas(Utils.resolveLimits(currency, 1)))) {
        controller.amountError.value = "Amount should be at least $currency${Utils.resolveLimits(currency, 1)}";
        return false;
      }else if (amountValue > double.parse(Utils.removeCommas(Utils.resolveLimits(currency, 2)))) {
        controller.amountError.value = "Amount should be at most $currency${Utils.resolveLimits(currency, 2)}";
        return false;
      } else if (amountValue > controller.availableLimit) {
        controller.amountError.value = "Limit Exceeded";
        return false;
      } else {
        controller.amountError.value = "";
      }
    }

    return true;
  }

  Future<void> _proceedWithTransaction (OfflineDetailsController controller, String amount, String description) async {
    if(validateField(controller, amount)){

      QRTransaction.createPayment(controller);
    }
  }
}
