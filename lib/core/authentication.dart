import 'package:kuepay_qr/services/authentication.dart';

class KuepayQRAuthentication {

  Future<String> signUp({
    required String name,
    required String phoneNumber,
    required String password,
    required String pin,
  }) async {
    final result = await Auth().signUp(name: name, phoneNumber: phoneNumber, password: password, pin: pin);
    return result;
  }

  Future<bool> signIn({
    required String userID,
    required String password,
  }) async {

    final result = await Auth().signIn(userID: userID, password: password);
    return result;
  }

  Future<bool> setPin(String pin) async {
    return await Auth().setPin(pin);
  }
}