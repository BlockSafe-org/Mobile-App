import 'package:flutter/material.dart';
import 'package:flutter_identity_kyc/flutter_identity_kyc.dart';
import 'package:permission_handler/permission_handler.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> Function() requestPermissions = () async {
    await Permission.camera.request();

    await Permission.microphone.request();
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('IdentityPass Checkout Test'),
          ),
          body: Center(
            child: FlutterIdentityKyc(
                merchantKey:
                    "live_336iqkrz6h4tj9d8dkbk:xloZhoeAiY3INf0p7yyWlPLr8rY",
                email: "olayiwolakayode078@gmail.com",
                firstName: "kayode",
                lastName: "olayiwola",
                isTest: false,
                userRef: "ddddd",
                onCancel: (response) {
                  print(response);
                },
                onVerified: (response) {
                  print(response);
                },
                onError: (error) => print(error)),
          )),
    );
  }
}
