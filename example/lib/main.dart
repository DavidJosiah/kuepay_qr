import 'package:flutter/material.dart';
import 'package:kuepay_qr/kuepay_qr.dart';

void main() {
  runApp(const MyApp());
  KuepayQRMethods().registerHeadlessTask(fetchHeadlessTask);
}

@pragma('vm:entry-point')
void fetchHeadlessTask(HeadlessTask task) {
  KuepayQRMethods().backgroundFetchHeadlessTask(task);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    KuepayQRMethods().initPlatformState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: KuepayOffline(
        darkMode: true ,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Kuepay QR example app'),
          ),
          body: const Center(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
