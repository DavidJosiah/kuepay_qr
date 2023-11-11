import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SVG extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;
  final Color? color;
  final String? semanticsLabel;
  const SVG(this.path, {Key? key, this.height, this.width, this.color, this.semanticsLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      height: height,
      width: width,
      package: "kuepay_qr",
      semanticsLabel: semanticsLabel,
      colorFilter: color == null ? null : ColorFilter.mode(
        color!,
        BlendMode.srcIn,
      ),
    );
  }
}
