import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/logic/logic.dart';
import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/shared/shared.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final bool isOfflineTransaction;
  const TransactionItem({Key? key, required this.transaction, this.isOfflineTransaction = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String value = double.parse(transaction.value).toInt().toString();

    List<Color> colors = transaction.colors;

    if(colors.isEmpty) {
      colors = [CustomColors.primary[3]!];
    }

    return Container(
      width: Dimen.width(context),
      height: 72,
      margin: const EdgeInsets.only(top: 2, bottom: 2),
      decoration: BoxDecoration(
          color: CustomColors.dynamicColor(
              colorScheme: ColorThemeScheme.background
          ),
          borderRadius: const BorderRadius.all(
              Radius.circular(8)
          ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: MaterialButton(
        onPressed: () {
          Get.to(() => TransactionDetails(
            transaction: transaction,
          ), transition: Transition.fadeIn);
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(8)
          ),
        ),
        padding: EdgeInsets.zero,
        elevation: 0,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;

            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: height * 0.65,
                            height: height * 0.65,
                            decoration: BoxDecoration(
                              color: colors[0],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12)
                              ),
                              gradient: colors.length > 1
                                ? LinearGradient(
                                  colors: [
                                    colors[0],
                                    colors[1]
                                  ]
                                )
                                : null
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: SVG(
                                    transaction.imagePath,
                                    color: transaction.imagePath == 'assets/icons/cart.svg'
                                        ? CustomColors.white : null,
                                    semanticsLabel: "Image"
                                  ),
                                ),
                              ),
                            )
                        ),

                        const SizedBox(width: 10),
                      ],
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: constraints.maxWidth * 0.65,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          const SizedBox(height: 5),

                                          CustomText(
                                            transaction.title,
                                            style: TextStyles(
                                              color: CustomColors.dynamicColor(
                                                colorScheme: ColorThemeScheme.accent,
                                              ),
                                            ).textTitleExtraLarge,
                                            textAlign: TextAlign.start,
                                          ),

                                          const SizedBox(height: 5),

                                          CustomText(
                                            Utils.getDate(transaction.time),
                                            style: TextStyles(
                                              color: CustomColors.dynamicColor(
                                                colorScheme: ColorThemeScheme.greyAccentOne,
                                              ),
                                            ).textSubtitleLarge,
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Expanded(child: SizedBox(height: 40)),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: constraints.maxWidth * 0.35,
                                          child: CustomText(
                                            transaction.isInFlow ? '+ ${transaction.currency}$value' :
                                            '- ${transaction.currency}$value',
                                            style: (value.characters.length < 8)
                                                ? TextStyles(
                                              color: transaction.isInFlow ? CustomColors.primary : CustomColors.secondaryRed,
                                            ).textTitleExtraLarge
                                                : TextStyles(
                                              color: transaction.isInFlow ? CustomColors.primary : CustomColors.secondaryRed,
                                            ).textBodyExtraLarge,
                                            textAlign: TextAlign.end,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    )
                                  ]
                                );
                              }
                            ),
                          )
                        ],
                      ),
                    ),
                  ]
              ),
            );
          }
        ),
      ),
    );
  }
}
