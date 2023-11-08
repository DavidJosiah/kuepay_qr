import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/shared/shared.dart';

class OfflineWalletItem extends StatelessWidget {
  final String title;
  final String subtitle;
  const OfflineWalletItem({Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = CustomColors.secondaryYellow;
    const icon = 'assets/icons/credit_card.svg';

    return Container(
      width: Dimen.width,
      padding: EdgeInsets.symmetric(
          vertical: Dimen.verticalMarginHeight * 0.5,
          horizontal: Dimen.horizontalMarginWidth
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(10)
        ),
        color: color[3],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimen.verticalMarginHeight * 0.25),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth),
            child: CustomText(
              "Wallet",
              style: TextStyles(
                color: color,
              ).textTitleLarge,
            ),
          ),

          SizedBox(height: Dimen.verticalMarginHeight * 0.25),

          SizedBox(
            height: Dimen.verticalMarginHeight * 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: Dimen.horizontalMarginWidth),

                Container(
                  width: Dimen.verticalMarginHeight * 3,
                  height: Dimen.verticalMarginHeight * 3,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                        icon,
                        height: 24,
                        width: 24,
                        color: CustomColors.white,
                        semanticsLabel: "Icon"
                    ),
                  ),
                ),

                SizedBox(width: Dimen.horizontalMarginWidth * 2),

                Builder(
                    builder: (context) {
                      if(subtitle == 'ADDRESS'){
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[

                            CustomText(
                              "'/data_purchasea wallet",
                              style: TextStyles(
                                  color: CustomColors.grey
                              ).textTitleLarge,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          CustomText(
                            title,
                            style: TextStyles(
                                color: CustomColors.grey
                            ).textTitleExtraLarge,
                          ),

                          if(subtitle.isNotEmpty)
                            SizedBox(height: Dimen.verticalMarginHeight * 0.35),

                          if(subtitle.isNotEmpty)
                            CustomText(
                              subtitle,
                              style: TextStyles(
                                  color: CustomColors.grey
                              ).textBodyLarge,
                            )

                        ],
                      );
                    }
                ),

                const Expanded(child: SizedBox()),

                SizedBox(width: Dimen.horizontalMarginWidth),
              ],
            ),
          )
        ],
      ),
    );
  }
}