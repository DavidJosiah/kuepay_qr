package com.viicsoft.kuepay_qr;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** KuepayQrPlugin */
public class KuepayQrPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private static final String DECRYPT_STRING = "decryptString";
  private static final String ENCRYPT_STRING = "encryptString";


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "kuepay_qr");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals(DECRYPT_STRING)) {
      String data = call.argument("data");
      decryptString(result, data);
    } else if (call.method.equals(ENCRYPT_STRING)) {
      String data = call.argument("data");
      encryptString(result, data);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void decryptString(MethodChannel.Result result, String data){
    Encryption encryption = new Encryption();
    result.success((String) encryption.decryptData(data));
  }

  private void encryptString(MethodChannel.Result result, String data){
    Encryption encryption = new Encryption();
    result.success((String) encryption.encryptString(data));
  }
}
