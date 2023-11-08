import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/logic/logic.dart';
import 'package:kuepay_qr/shared/shared.dart';
import 'package:kuepay_qr/controllers/controllers.dart';

import 'qr_dialog.dart';
import 'transaction_receipt.dart';

class TransactionDetails extends StatelessWidget {
  final Transaction transaction;
  final bool isComplete;
  final bool hideViewQR;
  final bool isOfflineTransaction;
  final bool showOfflineDialog;
  const TransactionDetails ({
    Key? key,
    required this.transaction,
    this.isComplete = false,
    this.hideViewQR = false,
    this.isOfflineTransaction = false,
    this.showOfflineDialog = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String value = Utils.fillCommas(double.parse(transaction.value).toString());

    return Scaffold(
      backgroundColor: CustomColors.dynamicColor(
          colorScheme: ColorThemeScheme.background
      ),
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset(
              'assets/icons/back_arrow.svg',
              height: 24,
              width: 24,
              color: CustomColors.dynamicColor(
                colorScheme: ColorThemeScheme.accent,
              ),
              semanticsLabel: "Back"
          ),
        ),
        title: CustomText(
          isComplete ? "" : "Transaction Details",
          style: TextStyles(
            color: CustomColors.dynamicColor(
              colorScheme: ColorThemeScheme.primaryHeader,
            ),
          ).displayTitleSmall,
        ),
        actions: [
          if(transaction.type == "PRCHS" && !hideViewQR)
            TextButton(
              onPressed: () {
                QRDialog.show(data: transaction.id);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth),
              ),
              child: CustomText(
                isComplete ? "VIEW PURCHASE QR" : "VIEW QR",
                style: TextStyles(
                  color: CustomColors.info,
                ).textBodyLarge,
              ),
            ),

          if(transaction.type == "PRCHS" && !hideViewQR)
            SizedBox(width: Dimen.horizontalMarginWidth * 3)
        ],
        elevation: 0,
        backgroundColor: CustomColors.dynamicColor(
            colorScheme: ColorThemeScheme.background
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth * 3),
                child: Column(
                  children: [

                    Builder(
                      builder: (context) {
                        if(isOfflineTransaction && showOfflineDialog){
                          return Column(
                            children: [
                              SizedBox(height: Dimen.verticalMarginHeight),

                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    width: Dimen.width * 0.9,
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimen.verticalMarginHeight,
                                        horizontal: Dimen.horizontalMarginWidth * 2
                                    ),
                                    decoration: BoxDecoration(
                                      color: CustomColors.error[3],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          SvgPicture.asset(
                                              'assets/icons/round_error.svg',
                                              height: 28,
                                              width: 28,
                                              color: CustomColors.error,
                                              semanticsLabel: "Round Error"
                                          ),

                                          SizedBox(width: Dimen.horizontalMarginWidth * 2),

                                          Expanded(
                                            child: CustomText(
                                              "Please ensure you connect the app to the "
                                                  "internet within 48 hours to prevent potential fund loss.".toUpperCase(),
                                              style: TextStyles(
                                                lineHeight: 1.2,
                                                color: CustomColors.error,
                                              ).textSubtitleLarge,
                                              maxLines: 5,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ]
                                    )
                                ),
                              ),

                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      }
                    ),

                    Builder(
                      builder: (context) {
                        if(isComplete){
                          return Column(
                            children: [
                              SizedBox(
                                width: Dimen.height * 0.24,
                                height: Dimen.height * 0.24,
                                child: Image.asset(
                                  fit: BoxFit.cover,
                                  "assets/images/successful_gif.gif",
                                  width: Dimen.height * 0.24,
                                  height: Dimen.height * 0.24,
                                ),
                              ),

                              SizedBox(
                                width: Dimen.width * 0.8,
                                child: CustomText(
                                  "Transaction Successful",
                                  style: TextStyles(
                                      color: CustomColors.success
                                  ).displayTitleExtraSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              SizedBox(height: Dimen.verticalMarginHeight * 0.5),

                            ],
                          );
                        } else {
                          return Column(
                            children: [

                              SizedBox(height: Dimen.verticalMarginHeight * 3),

                              Container(
                                  width: Dimen.height * 0.12,
                                  height: Dimen.height * 0.12,
                                  decoration: BoxDecoration(
                                      color: transaction.colors[0],
                                      shape: BoxShape.circle,
                                      gradient: transaction.colors.length > 1
                                          ? LinearGradient(
                                          colors: [
                                            transaction.colors[0],
                                            transaction.colors[1]
                                          ]
                                      ) : null
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(Dimen.horizontalMarginWidth * 0.5),
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child:  SvgPicture.asset(
                                            transaction.imagePath,
                                            color: transaction.imagePath == 'assets/icons/cart.svg'
                                                ? CustomColors.white : null,
                                            height: Dimen.height * 0.12 * 0.4,
                                            width: Dimen.height * 0.12 * 0.4,
                                            semanticsLabel: "Image"
                                        ),
                                      ),
                                    ),
                                  )
                              ),

                              SizedBox(height: Dimen.verticalMarginHeight * 1.5),
                            ],
                          );
                        }
                      }
                    ),

                    SizedBox(
                      width: Dimen.width * 0.75,
                      child: Center(
                        child: CustomText(
                          '${transaction.currency}$value',
                          style: (value.characters.length > 20)
                              ? TextStyles(
                            color: CustomColors.dynamicColor(
                              colorScheme: ColorThemeScheme.accent,
                            ),
                          ).displayTitleLarge : TextStyles(
                            color: CustomColors.dynamicColor(
                              colorScheme: ColorThemeScheme.accent,
                            ),
                          ).displayTitleExtraLarge,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight * 0.5),

                    SizedBox(
                      width: Dimen.width * 0.8,
                      child: CustomText(
                        transaction.description.toUpperCase().isEmpty
                            ? transaction.title.toUpperCase() : transaction.description.toUpperCase(),
                        style: TextStyles(
                            color: CustomColors.dynamicColor(
                              colorScheme: ColorThemeScheme.greyAccentOne,
                            )
                        ).textBodyExtraLarge,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight * 2),

                    item(
                      title: "Transaction Type",
                      value: Constants.transactionType[transaction.type] ?? transaction.type,
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight * 0.5),

                    item(
                      title: "Transaction Fee",
                      value: '${transaction.currency}${transaction.fee.ceil()}',
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight * 0.5),

                    if(transaction.type == "ELCT")
                      item(
                        title: "Token",
                        value: transaction.token,
                      ),

                    if(transaction.token.isNotEmpty)
                      SizedBox(height: Dimen.verticalMarginHeight * 0.5),

                    item(
                      title: "Transaction Date",
                      value: DateFormat("LLLL dd, yyyy").format(transaction.time),
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight * 0.5),

                    item(
                      title: "Transaction Time",
                      value: DateFormat("hh:mm aa").format(transaction.time),
                    ),

                    if(transaction.name != "")
                      SizedBox(height: Dimen.verticalMarginHeight * 0.5),

                    if(transaction.name != "")
                      item(
                        title: transaction.isInFlow ? "Sender Name" : "Recipient Name",
                        value: transaction.name,
                      ),

                    if(transaction.detail != "")
                      SizedBox(height: Dimen.verticalMarginHeight * 0.5),

                    if(transaction.detail != "")
                      item(
                        title: transaction.isInFlow ? "Sender Details" : "Recipient Details",
                        value: transaction.detail,
                        showSeparator: !isOfflineTransaction
                      ),

                    Builder(
                        builder: (context) {
                          if(isOfflineTransaction) {
                            return const SizedBox();
                          } else {
                            return Column(
                              children: [
                                SizedBox(height: Dimen.verticalMarginHeight * 0.5),

                                item(
                                    title: "Reference ID",
                                    value: transaction.id,
                                    showSeparator: false
                                ),
                              ],
                            );
                          }

                        }
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight * 0.5),

                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: Dimen.verticalMarginHeight * 2),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(isComplete)
                CustomButton(
                  width: Dimen.width * 0.42,
                  text: "Done",
                  onPressed: () {
                    if(isOfflineTransaction){
                      Get.find<KuepayOfflineController>().home();
                    } else {
                      Get.back();
                    }
                  },
                  margin: EdgeInsets.only(left: Dimen.horizontalMarginWidth * 3),
                  isOutlined: true
                ),

              if(isComplete)
                const Expanded(child: SizedBox()),

              CustomButton(
                  width: isComplete ? Dimen.width * 0.42 : null,
                  text: "Show Receipt",
                  onPressed: () {
                    Get.to(() => TransactionReceipt(
                        transaction: transaction,
                    ), transition: Transition.fadeIn);
                  },
                  margin: EdgeInsets.only(
                    right: isComplete ? Dimen.horizontalMarginWidth * 3 : 0
                  ),
              ),
            ],
          ),

          SizedBox(height: Dimen.verticalMarginHeight * 2),

        ],
      ),
    );
  }

  Widget item({required String title, required String value, bool showSeparator = true}){
    return Column(
      children: [

        SizedBox(height: Dimen.verticalMarginHeight * 1.35),

        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            SizedBox(
              child: CustomText(
                title,
                style: TextStyles(
                  color: CustomColors.dynamicColor(
                    colorScheme: ColorThemeScheme.greyAccentOne,
                  ),
                ).textBodyLarge,
              ),
            ),

            SizedBox(width: Dimen.horizontalMarginWidth * 4),

            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomText(
                      value,
                      style: TextStyles(
                        color: CustomColors.dynamicColor(
                          colorScheme: ColorThemeScheme.accent,
                        ),
                      ).textSubtitleLarge,
                      maxLines: 3,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),

            if(title == "Token")
              SizedBox(width: Dimen.horizontalMarginWidth),

            if(title == "Token")
              SizedBox(
                height: 20,
                width: 20,
                child: MaterialButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: value));
                    Snack.show(message: "Token copied successfully", type: SnackBarType.success);
                  },
                  child: Center(
                    child: SvgPicture.asset(
                        'assets/icons/copy_address.svg',
                        height: 20,
                        width: 20,
                        color: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.accent),
                        semanticsLabel: "Copy"
                    ),
                  ),
                ),
              )

          ],
        ),

        SizedBox(height: Dimen.verticalMarginHeight * 1.4),

        if(showSeparator)
          Container(
            height: 0.5,
            color: CustomColors.dynamicColor(
              colorScheme: ColorThemeScheme.greyAccentOne,
            ),
          )
      ],
    );
  }

}
