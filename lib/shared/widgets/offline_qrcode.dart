import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/logic/logic.dart';

import 'package:kuepay_qr/shared/shared.dart';

class OfflineQRCode extends StatefulWidget {
  final Map data;
  final double? maxWidth;
  const OfflineQRCode(this.data, {this.maxWidth, Key? key}) : super(key: key);

  @override
  State<OfflineQRCode> createState() => _OfflineQRCodeState();
}

class _OfflineQRCodeState extends State<OfflineQRCode> {

  late Timer qrTimer;
  String data = "";

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setData();
    });

    qrTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      setData();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final maxWidth = widget.maxWidth ?? 320;

    return Container(
      width: maxWidth,
      padding: EdgeInsets.symmetric(vertical: maxWidth * 0.075),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(10)
        ),
        color: CustomColors.primary[3],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(height: Dimen.verticalMarginHeight(context)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SVG(
                  'assets/icons/square_error.svg',
                  height: 24,
                  width: 24,
                  color: CustomColors.primary,
                  semanticsLabel: "Square Error"
              ),

              const SizedBox(width: 16),

              CustomText(
                "Transaction QR Code",
                style: TextStyles(
                  color: CustomColors.primary,
                ).displayTitleSmall,
              ),

              const SizedBox(width: 16),

            ],
          ),

          SizedBox(height: Dimen.verticalMarginHeight(context)),

          Container(
            color: CustomColors.primary[3],
            child: Stack(
              alignment: Alignment.center,
              children: [
                QrImageView(
                  data: data,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.circle,
                    color: Colors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle,
                    color: Colors.black,
                  ),
                  size: maxWidth * 0.9,
                ),

                SVG(
                    'assets/images/qr_logo_green.svg',
                    height: maxWidth * 0.9 * 0.165,
                    width: maxWidth * 0.9 * 0.165,
                    semanticsLabel: "QR Logo"
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  void setData() async {
    if(widget.data.isNotEmpty) {
      final mData = await QRTransaction.encryptAndScramble(widget.data);

      if(mounted) {
        setState(() {
          data = mData;
        });
      }
    }
  }
}
