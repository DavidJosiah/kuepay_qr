// ignore_for_file: use_build_context_synchronously

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/logic/logic.dart';
import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/controllers/controllers.dart';
import 'package:kuepay_qr/shared/shared.dart';

class TransactionReceipt extends StatefulWidget {
  final Transaction transaction;
  const TransactionReceipt({Key? key, required this.transaction}) : super(key: key);

  @override
  State<TransactionReceipt> createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends State<TransactionReceipt> {
  final GlobalKey _repaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String amount = widget.transaction.value;

    String value = Utils.fillCommas(double.parse(amount).toString());

    return Scaffold(
      body: Container(
        width: Dimen.width(context),
        color: CustomColors.primary[3],
        padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth(context) * 0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppBar(
                      actions: [

                        SizedBox(
                            height: 24,
                            width: 24,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => Navigator.pop(context),
                              icon: const SVG(
                                  'assets/icons/cancel.svg',
                                  height: 24,
                                  width: 24,
                                  color: CustomColors.grey,
                                  semanticsLabel: "Cancel"
                              ),
                            )
                        ),

                        SizedBox(width: Dimen.horizontalMarginWidth(context) * 3),

                      ],
                      automaticallyImplyLeading: false,
                      backgroundColor: CustomColors.primary[3],
                      elevation: 0,
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight(context)),

                    Builder(
                        builder: (context) {
                          final List<bool> visibility = getVisibility();
                          double height = Dimen.height(context) * 0.21;

                          int count = 0;
                          for(bool visible in visibility){
                            if(visible) {
                              count++;
                            }
                          }

                          height = height + (Dimen.height(context) * .085 * (count + 3));

                          return RepaintBoundary(
                            key: _repaintKey,
                            child: Container(
                              color: CustomColors.primary[3],
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimen.verticalMarginHeight(context) * 0.75,
                                  horizontal: Dimen.horizontalMarginWidth(context) * 1.5
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: height,
                                    decoration: const BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(16)
                                      )
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: Dimen.height(context) * 0.08,
                                          padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth(context) * 2.5),
                                          child: Row(
                                            children: [
                                              CustomText(
                                                  "PAYMENT RECEIPT",
                                                  style: TextStyles(
                                                      color: CustomColors.grey[3]
                                                  ).textBodyLarge
                                              ),

                                              const Expanded(child: SizedBox()),

                                              SizedBox(
                                                width: Dimen.width(context) * 0.225,
                                                height:Dimen.height(context) * 0.05,
                                                child: const AspectRatio(
                                                  aspectRatio: 3.11,
                                                  child: SVG(
                                                      'assets/images/kuepay_logo_dark.svg',
                                                      height: 36,
                                                      width: 112,
                                                      semanticsLabel: "Kuepay Logo"
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: Dimen.horizontalMarginWidth(context))
                                            ],
                                          ),
                                        ),

                                        Container(
                                          height: 1,
                                          width: double.infinity,
                                          color: CustomColors.grey[3],
                                        ),

                                        SizedBox(height: Dimen.verticalMarginHeight(context) * 3),

                                        SizedBox(
                                          width: Dimen.width(context) * 0.75,
                                          child: Center(
                                            child: CustomText(
                                              '${widget.transaction.currency}$value',
                                              style: (value.characters.length > 20)
                                                  ?  TextStyles(
                                                  color: CustomColors.grey,
                                              ).displayTitleLarge : TextStyles(
                                                  color: CustomColors.grey,
                                              ).displayTitleExtraLarge,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: Dimen.verticalMarginHeight(context) * 0.5),

                                        SizedBox(
                                          width: Dimen.width(context) * 0.8,
                                          child: CustomText(
                                            DateFormat
                                              ("LLLL dd, yyyy hh:mm aa")
                                                .format(widget.transaction.time).toUpperCase(),
                                            style: TextStyles(
                                                color: CustomColors.grey[2]
                                            ).textBodyExtraLarge,
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                          ),
                                        ),

                                        SizedBox(height: Dimen.verticalMarginHeight(context) * 1.5),

                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth(context) * 2.5),
                                          child: Column(
                                            children: [
                                              item(
                                                visible: true,
                                                title: "Transaction Type",
                                                value: Constants.transactionType[widget.transaction.type]
                                                    ?? widget.transaction.type,
                                              ),

                                              item(
                                                visible: visibility[0],
                                                title: "Description",
                                                value: widget.transaction.description,
                                              ),

                                              item(
                                                visible: visibility[1],
                                                title: "Token",
                                                value: widget.transaction.token,
                                              ),
                                              Builder(
                                                  builder: (context) {
                                                    String value = "";

                                                    if(widget.transaction.isInFlow) {
                                                      value = widget.transaction.name;
                                                    } else {
                                                      value = Get.find<OfflineDetailsController>().name;
                                                    }

                                                    return item(
                                                      visible: true,
                                                      title: "Sender Name",
                                                      value: value ,
                                                    );
                                                  }
                                              ),

                                              item(
                                                visible: visibility[2],
                                                title: "Sender Details",
                                                value: widget.transaction.detail,
                                              ),

                                              Builder(
                                                  builder: (context) {
                                                    String value = "";

                                                    if(widget.transaction.isInFlow) {
                                                      value = Get.find<OfflineDetailsController>().name;
                                                    } else {
                                                      value = widget.transaction.name;
                                                    }

                                                    return item(
                                                      visible: visibility[3],
                                                      title: "Recipient Name",
                                                      value: value ,
                                                    );
                                                  }
                                              ),

                                              item(
                                                visible: visibility[4],
                                                title: "Recipient Details",
                                                value: widget.transaction.detail,
                                              ),

                                              item(
                                                  visible: visibility[5],
                                                  title: "Reference ID",
                                                  value: widget.transaction.id
                                              ),

                                              item(
                                                  visible: true,
                                                  title: "Status",
                                                  value: widget.transaction.status,
                                                  showSeparator: false
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],

                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth(context) * 2),
                                    child: bottomSerration(),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight(context) * 2),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: CustomColors.primary,
                              ),
                              child: MaterialButton(
                                shape: const CircleBorder(),
                                color: CustomColors.primary,
                                onPressed: () {
                                  _saveReceipt(context);
                                },
                                elevation: 0,
                                padding: const EdgeInsets.all(0),
                                child: Center(
                                  child: SVG(
                                      'assets/icons/download.svg',
                                      height: 24,
                                      width: 24,
                                      color: CustomColors.primary[2],
                                      semanticsLabel: "Save"
                                  ),
                                ),
                              )
                          ),

                          const SizedBox(width: 50),

                          Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: CustomColors.primary[3],
                                  border: Border.all(
                                      color: CustomColors.primary,
                                      width: 1.5
                                  )
                              ),
                              child: MaterialButton(
                                shape: const CircleBorder(),
                                color: CustomColors.primary[3],
                                onPressed: () => _share(),
                                elevation: 0,
                                padding: const EdgeInsets.all(0),
                                child: const Center(
                                  child: SVG(
                                      'assets/icons/share.svg',
                                      height: 28,
                                      width: 28,
                                      color: CustomColors.primary,
                                      semanticsLabel: "Share"
                                  ),
                                ),
                              )
                          ),

                        ]
                    ),

                    SizedBox(height: Dimen.verticalMarginHeight(context) * 2),

                  ],
                ),
              )
            ),

          ],
        ),
      ),
    );
  }

  Widget item({required bool visible, required String title, required String value, bool showSeparator = true}){
    return Visibility(
      visible: visible,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Dimen.verticalMarginHeight(context) * 1.35),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                CustomText(
                  title,
                  style: TextStyles(
                    color: CustomColors.grey[2],
                  ).textBodyLarge,
                ),

                SizedBox(width: Dimen.horizontalMarginWidth(context) * 4),

                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      value,
                      style: TextStyles(
                        color: CustomColors.grey,
                      ).textTitleLarge,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                    ),
                  ),
                ),

              ],
            ),
          ),

          if(showSeparator)
            BrokenLineSeparator(color: CustomColors.grey[4]),

        ],
      ),
    );
  }

  void _saveReceipt (BuildContext context) async {
    try {
      RenderRepaintBoundary? boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if(boundary == null) return null;

      Utils.startLoading();

      final result = await Utils.saveWidgetAsImage(boundary, "transaction_receipt");

      Utils.stopLoading();

      if(result) Snack.show(context, message: "Receipt saved successfully", type: SnackBarType.info);

    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return;
    }
  }

  void _share() async {

    RenderRepaintBoundary? boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if(boundary == null) return null;

    Utils.shareWidgetAsImage(boundary, "transaction_receipt");

  }

  Widget bottomSerration () {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const double circleDiameter = 10.0;
        final circleCount = (boxWidth / (1.5 * circleDiameter)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(circleCount, (_) {
            return Container(
              height: circleDiameter * 0.5,
              width: circleDiameter,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(circleDiameter)
                ),
                color: CustomColors.primary[3]
              ),
            );
          }),
        );
      },
    );
  }
  List<bool> getVisibility() {
    final output = [false, false, false, false, false, false, false, false, false, false];

    output[0] = widget.transaction.description.isNotEmpty;

    output[1] = widget.transaction.token.isNotEmpty && widget.transaction.type == "ELCT";

    output[2] = widget.transaction.isInFlow && widget.transaction.detail.isNotEmpty;

    final noName = widget.transaction.name.isEmpty;

    output[3] = !(noName && !widget.transaction.isInFlow);

    output[4] = !widget.transaction.isInFlow && widget.transaction.detail != "";

    return output;

  }
}
