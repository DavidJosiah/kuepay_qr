import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:kuepay_qr/logic/logic.dart';
import 'package:kuepay_qr/config/config.dart';
import 'package:kuepay_qr/services/services.dart';
import 'package:kuepay_qr/shared/shared.dart';

class PinKeyboard extends StatelessWidget {

  final String? action; /// title to be displayed on the  Default is 'Please enter your Kuepay PIN'

  final String? buttonText;  /// submit button text.

  final Function onButtonClick; /// on pressed function to be called when the submit button is pressed.

  final Function(String)? onCompleted;  /// on competed function to be called when the pin code is complete.

  final int maxLength; /// maximum length of pin.

  final bool isForAuthorization; /// is the keyboard being used to authorize.

  final bool showCancel; /// show Cancel button or not.

  /// Text for cancel button
  final String? cancelText;

  final void Function()? onCancelClick;

  final String? offlinePin; /// Pin for offline transactions

  PinKeyboard({Key? key, this.action, this.buttonText, required this.onButtonClick,
    this.maxLength = 4, this.onCompleted,
    this.isForAuthorization = true, this.showCancel = true,
    this.cancelText, this.onCancelClick,  this.offlinePin})
      : assert(maxLength > 0 && maxLength < 7), super(key: key){
    Get.put(PinKeyboardController());
  }

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<PinKeyboardController>();
    controller.pin = "";

    isFingerprintActivated(controller);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 45),

            SizedBox(
              height: 24,
              child: CustomText(
                (action ?? "Please input your account pin").toUpperCase(),
                style: TextStyles(
                  color: CustomColors.dynamicColor(
                      colorScheme: ColorThemeScheme.primaryHeader
                  ),
                ).textSubtitleExtraLarge,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < maxLength; i++)
                  GetX<PinKeyboardController>(
                      builder: (controller) {
                        return PinCodeField(
                          key: Key('pinField$i'),
                          pin: controller.pin,
                          pinCodeFieldIndex: i,
                        );
                      }
                  ),
              ],
            ),

            const SizedBox(height: 10),

            GetX<PinKeyboardController>(
                builder: (controller) {
                  return CustomText(
                    controller.pinError,
                    style: TextStyles(
                      color: CustomColors.error[2],
                    ).textBodyLarge,
                  );
                }
            ),

            Container(
              width: Dimen.width,
              height: 260,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  buildNumberRow(controller, [1, 2, 3]),
                  buildNumberRow(controller, [4, 5, 6]),
                  buildNumberRow(controller, [7, 8, 9]),
                  buildSpecialRow(controller),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Expanded(child: SizedBox()),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth * 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  if(showCancel)
                    Expanded(
                      child: CustomButton(
                        height: 60,
                        isOutlined: true,
                        text: cancelText ?? "Cancel",
                        margin: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth * 1.5),
                        onPressed: () {
                          if(onCancelClick == null){
                            Get.back();
                          } else {
                            onCancelClick!();
                          }
                        },
                      ),
                    ),

                  Expanded(
                    child: CustomButton(
                      height: 60,
                      margin: EdgeInsets.symmetric(horizontal: Dimen.horizontalMarginWidth * 1.5),
                      text: buttonText ?? "Ok",
                      onPressed: () async {
                        if(controller.pin.length == maxLength) {
                          if(isForAuthorization){
                            bool isPinCorrect = false;
                            if(offlinePin != null){
                              Utils.startSheetLoading();
                              final inputtedPin = await Utils.encryptVariableHMAC(controller.pin);
                              Utils.stopSheetLoading();
                              isPinCorrect = inputtedPin == offlinePin;
                            } else {
                              isPinCorrect = await _validatePin(controller, controller.pin);
                            }

                            if(isPinCorrect) {
                              onButtonClick();
                            }else{
                              controller.pinError = "Incorrect pin";
                            }
                          }else{
                            onButtonClick();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: Dimen.verticalMarginHeight * 2),
          ],
        ),
      ),
    );
  }

  Widget buildNumberButton({int? number, Widget? icon, Function()? onPressed}) {
    getChild() {
      if (icon != null) {
        return icon;
      } else {
        return SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CustomText(
              number?.toString() ?? "",
              style: TextStyles(
                  color: CustomColors.dynamicColor(
                      colorScheme: ColorThemeScheme.accent
                  )
              ).displayTitleSmall,
            ),
          ),
        );
      }
    }

    return InkResponse(
      onTap: onPressed,
      key: icon?.key ?? Key("btn$number"),
      child: Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(child: getChild())),
    );
  }

  Widget buildNumberRow(PinKeyboardController controller, List<int> numbers) {
    List<Widget> buttonList = numbers.map((buttonNumber) => buildNumberButton(
      number: buttonNumber,
      onPressed: () async {
        if (controller.pin.length < maxLength) {
          controller.pin = controller.pin + buttonNumber.toString();
        }
        if (controller.pin.length >= 4 && onCompleted != null) {
          onCompleted!(controller.pin);
        }
      },
    )).toList();
    return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buttonList,
        ));
  }

  Widget buildSpecialRow(PinKeyboardController controller) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GetX<PinKeyboardController>(
              builder: (controller) {
                return buildNumberButton(
                    icon: controller.useFingerprint.value && isForAuthorization
                        ? Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: CustomColors.primaryGradient,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                            'assets/images/fingerprint.svg',
                            height: 30,
                            width: 30,
                            semanticsLabel: "Fingerprint"
                        ),
                      ),
                    ) : const SizedBox(),
                    onPressed: () async {
                      if(controller.useFingerprint.value && isForAuthorization) {
                        bool didAuthenticate;
                        try {
                          didAuthenticate = await LocalAuthApi.authenticate();
                        } on Exception catch (e) {
                          if (kDebugMode) {
                            print(e.toString());
                          }
                          didAuthenticate = false;
                        }

                        if (!didAuthenticate) return;

                        onButtonClick();
                      }

                    }
                );
              }
          ),

          buildNumberButton(
            number: 0,
            onPressed: () async {
              if (controller.pin.length < maxLength) {
                controller.pin = controller.pin + 0.toString();
              }
              if (controller.pin.length >= 4 && onCompleted != null) {
                await onCompleted!(controller.pin);
              }
            },
          ),

          buildNumberButton(
              icon: SvgPicture.asset(
                  key: const Key('backspace'),
                  'assets/icons/backspace.svg',
                  height: 24,
                  width: 24,
                  color: CustomColors.dynamicColor(
                      colorScheme: ColorThemeScheme.accent
                  ),
                  semanticsLabel: "Backspace"
              ),
              onPressed: () {
                if (controller.pin.isNotEmpty) {
                  controller.pin = controller.pin.substring(0, controller.pin.length - 1);
                }
              }
          ),
        ],
      ),
    );
  }

  void isFingerprintActivated(PinKeyboardController controller) async {
    controller.useFingerprint.value = await Utils.isFingerprintActivated();
  }

  Future<bool> _validatePin(PinKeyboardController controller, String pin) async {
    Utils.startSheetLoading();
    final result = await Auth().verifyPin(pin: pin);
    Utils.stopSheetLoading();

    if(result) {
      controller.passwordError.value = "";
      return true;
    }
    return false;
  }
}

class PinCodeField extends StatelessWidget {
  const PinCodeField({Key? key, required this.pin, required this.pinCodeFieldIndex,}) : super(key: key);

  final String pin;                /// The pin code
  final int pinCodeFieldIndex;     /// The index of the pin code field


  Color get getFillColorFromIndex {
    final Color activeFillColor = CustomColors.dynamicColor(
        colorScheme: ColorThemeScheme.background
    );
    const Color selectedFillColor = CustomColors.primary;
    final Color inactiveFillColor = CustomColors.dynamicColor(
        colorScheme: ColorThemeScheme.background
    );

    if (pin.length > pinCodeFieldIndex) {
      return activeFillColor;
    } else if (pin.length == pinCodeFieldIndex) {
      return selectedFillColor;
    }
    return inactiveFillColor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 50,
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration:  BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(14)
        ),
        border: Border.all(
            color: CustomColors.primary.withOpacity(1),
            width: 1
        ),
        color: getFillColorFromIndex,
      ),
      duration: const Duration(milliseconds: 50),
      child: pin.length > pinCodeFieldIndex
          ? Center(
        child: SvgPicture.asset(
            'assets/images/asterisk.svg',
            height: 12,
            width: 12,
            color: CustomColors.dynamicColor(
                colorScheme: ColorThemeScheme.accent
            ),
            semanticsLabel: "Asterisk"
        ),
      )
          : const SizedBox(),
    );
  }
}

class PinKeyboardController extends GetxController {
  final RxString _pin = "".obs;
  final RxString _pinError = "".obs;

  RxString password = "".obs;
  RxString passwordError = "".obs;

  RxBool isPasswordVisible = false.obs;

  RxBool useFingerprint = false.obs;

  String get pin => _pin.value;
  String get pinError => _pinError.value;

  set pin(String pin) {
    _pin.value = pin;
    pinError = "";
  }
  set pinError(String pinError) => _pinError.value = pinError;
}