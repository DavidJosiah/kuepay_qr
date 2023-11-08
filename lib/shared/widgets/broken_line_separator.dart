import 'package:flutter/material.dart';

import 'package:kuepay_qr/config/colors.dart';

class BrokenLineSeparator extends StatelessWidget {
  final double? dashWidth;
  final Color? color;
  const BrokenLineSeparator({Key? key, this.dashWidth, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        double mDashWidth = dashWidth ?? 3.0;
        final dashCount = (boxWidth / (2 * mDashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              height: 1.0,
              width: mDashWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color ?? CustomColors.grey[2]),
              ),
            );
          }),
        );
      },
    );
  }
}
