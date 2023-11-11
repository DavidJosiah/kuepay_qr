import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'package:kuepay_qr/config/config.dart';

class DefaultTransactionItem extends StatelessWidget {
  const DefaultTransactionItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Utils.getRandomColorSet(sampleSpace: [
      [
        const Color(0xFF00966D),
        const Color(0xFF33BB72),
        const Color(0xFFF3FCF7),
      ],
      [
        const Color(0xFFDE0000),
        const Color(0xFFFB3836),
        const Color(0xFFFFEFEF),
      ]
    ]);

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

                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(12)
                          ),
                          child: Shimmer(
                            child: Container(
                                width: height * 0.65,
                                height: height * 0.65,
                                decoration: BoxDecoration(
                                    color: colors[2].withOpacity(0.75),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)
                                    ),
                                ),
                            ),
                          ),
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

                                              Shimmer(
                                                child: Container(
                                                  height: 16,
                                                  width: Dimen.width(context) * 0.35,
                                                  color: colors[2].withOpacity(0.5),
                                                ),
                                              ),

                                              const SizedBox(height: 5),

                                              Shimmer(
                                                child: Container(
                                                  height: 16,
                                                  width: Dimen.width(context) * 0.28,
                                                  color: colors[2].withOpacity(0.5),
                                                ),
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
                                              child:  Shimmer(
                                                child: Container(
                                                  height: 24,
                                                  width: Dimen.width(context) * 0.25,
                                                  color: colors[2].withOpacity(0.5),
                                                ),
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
    );
  }
}
