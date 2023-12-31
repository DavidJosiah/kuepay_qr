import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/shared/shared.dart';

class ConfirmOfflineDetails extends StatelessWidget {
  const ConfirmOfflineDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<OfflineDetailsController>();

    final String value = controller.decryptedData[Constants.value];
    final String currency = controller.decryptedData[Constants.currency];
    final String receiversName = controller.decryptedData[Constants.receiverName];
    final String receiversAddress = controller.decryptedData[Constants.receiverWalletAddress];

    final String amount = double.parse(value).toStringAsFixed(1);

    //todo TBD
    const String fee = '0.0';

    final String total = (double.parse(Utils.removeCommas(value))
        + double.parse(Utils.removeCommas(fee))).toString();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: SVG(
                    'assets/icons/cancel.svg',
                    height: 24,
                    width: 24,
                    color: CustomColors.dynamicColor(
                        colorScheme: ColorThemeScheme.accent
                    ),
                    semanticsLabel: "Back"
                ),
              ),

              SizedBox(width: Dimen.horizontalMarginWidth(context))
            ],
            leading: const SizedBox(),
            title: CustomText(
              "CONFIRM DETAILS",
              style: TextStyles(
                  color: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.primaryHeader)
              ).displayBodyExtraSmall,
            ),
            backgroundColor : Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            width: Dimen.width(context),
            color: CustomColors.dynamicColor(
                colorScheme: ColorThemeScheme.background
            ),
            padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth(context) * 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: Dimen.verticalMarginHeight(context)),

                item(
                  context,
                  title: "Recipient Name",
                  value: receiversName,
                ),

                item(
                  context,
                  title: "Wallet Address",
                  value: receiversAddress,
                ),

                BrokenLineSeparator(color: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.greyAccentTwo)),

                item(
                  context,
                  title: "Amount",
                  value: '$currency$amount',
                ),

                item(
                  context,
                  title: "Fee",
                  value: '$currency$fee',
                ),

                BrokenLineSeparator(color: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.greyAccentTwo)),

                item(
                  context,
                  title: "Total Amount",
                  value: '$currency$total',
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: Dimen.verticalMarginHeight(context)),

                      CustomButton(
                        text: "Send",
                        onPressed: () {
                          _proceedWithTransaction(context, controller, total);
                        },
                      ),

                      SizedBox(height: Dimen.verticalMarginHeight(context) * 2),
                    ],
                  ),
                ),

              ],
            ),
          )
      ),
    );
  }

  Widget item(BuildContext context, {required String title, required String value}){
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Dimen.verticalMarginHeight(context) * 1.4,
          horizontal: Dimen.horizontalMarginWidth(context)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          CustomText(
            title,
            style: TextStyles(
              color: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.greyAccentOne),
            ).textBodyExtraLarge,
          ),

          SizedBox(width: Dimen.horizontalMarginWidth(context) * 2.5),

          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: CustomText(
                value,
                style: TextStyles(
                  color: CustomColors.dynamicColor(
                      colorScheme: ColorThemeScheme.accent
                  ),
                ).textTitleExtraLarge,
                textAlign: TextAlign.end,
                maxLines: 2,
              ),
            ),
          ),

        ],
      ),
    );
  }

  void _proceedWithTransaction(BuildContext context, OfflineDetailsController controller, String total) {

    if(controller.walletBalance.toDouble() < double.parse(total)){
      Snack.show(context, message: "Insufficient Balance", type: SnackBarType.error);
      return;
    }else if(controller.availableLimit.toDouble() < double.parse(total)){
      Snack.show(context, message: "Limit Exceeded", type: SnackBarType.error);
      return;
    }

    controller.changeAuthorizationTab(1);
  }
}