import 'package:flutter/material.dart';

import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/shared/shared.dart';

class BalanceWidget extends StatelessWidget {
  final String? text;
  final String balance;
  final String currency;
  final String? extraItemText;
  final String? extraItemBalance;
  final String? extraItemCurrency;
  const BalanceWidget ({Key? key, this.text, required this.balance,
    required this.currency, this.extraItemText, this.extraItemBalance,
    this.extraItemCurrency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimen.horizontalMarginWidth * 1.5,
              vertical: Dimen.verticalMarginHeight * 0.5
            ),
            decoration: BoxDecoration(
              border: Border.all(
                  color: CustomColors.dynamicColor(colorScheme: ColorThemeScheme.greyAccentTwo),
                  width: 1
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(8)
              ),
              color: CustomColors.dynamicColor(
                  colorScheme: ColorThemeScheme.custom,
                  lightMode: CustomColors.grey[6]!,
                  darkMode: CustomColors.grey[2]!
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    CustomText(
                      '${text ?? 'BALANCE'} :- ',
                      style: TextStyles(
                          color: CustomColors.dynamicColor(
                              colorScheme: ColorThemeScheme.greyAccentTwo,
                          )
                      ).textBodyExtraLarge,
                    ),

                    SizedBox(width: Dimen.horizontalMarginWidth),

                    CustomText(
                      balance,
                      style: TextStyles(
                          color: CustomColors.dynamicColor(
                            colorScheme: ColorThemeScheme.primaryHeader
                          )
                      ).textSubtitleExtraLarge,
                    ),
                  ],
                ),

                Builder(
                  builder: (context) {
                    if( extraItemBalance != null
                        && extraItemCurrency != null){
                      return Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            CustomText(
                              '${extraItemText ?? 'BALANCE'} :- ',
                              style: TextStyles(
                                  color: CustomColors.dynamicColor(
                                    colorScheme: ColorThemeScheme.greyAccentTwo,
                                  )
                              ).textBodyExtraLarge,
                            ),

                            SizedBox(width: Dimen.horizontalMarginWidth),

                            CustomText(
                              extraItemBalance ?? "$extraItemCurrency 0.00",
                              style: TextStyles(
                                  color: CustomColors.dynamicColor(
                                      colorScheme: ColorThemeScheme.primaryHeader
                                  )
                              ).textSubtitleExtraLarge,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }
                )
              ],
            )

        )
      ],
    );
  }
}
