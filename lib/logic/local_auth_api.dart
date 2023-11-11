import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:local_auth/local_auth.dart';
import 'package:local_auth_ios/types/auth_messages_ios.dart' as ios;
import 'package:local_auth_android/local_auth_android.dart' as android;

import 'package:kuepay_qr/shared/shared.dart';

class LocalAuthApi {

  static final LocalAuthentication localAuth = LocalAuthentication();

  static Future<bool> authenticate(BuildContext context) async {
    final bool canAuthenticate = await localAuth.canCheckBiometrics;

    if(!canAuthenticate) return false;

    try {
      return await localAuth.authenticate(
        localizedReason: " ",
        authMessages: const [
          ios.IOSAuthMessages(),
          android.AndroidAuthMessages(
            signInTitle: "Kuepay",
            biometricHint: "",
          )
        ],
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      if(kDebugMode){
        print(e.message);
      }
      // ignore: use_build_context_synchronously
      Snack.show(context, message: e.message ?? "An error occurred", type: SnackBarType.error);
      return false;
    }
  }

  static Future<bool> canAuthenticate() async {

    final bool canAuthenticate = await localAuth.canCheckBiometrics;

    if(!canAuthenticate) return false;

    return true;
  }
}