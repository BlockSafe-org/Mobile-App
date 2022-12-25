import 'package:blocksafe_mobile_app/Pages/home.dart';
import 'package:blocksafe_mobile_app/Splashscreens/screen_one.dart';
import 'package:blocksafe_mobile_app/Widgets/Navigation/navigationbar.dart';
import 'package:blocksafe_mobile_app/Widgets/wrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:is_first_run/is_first_run.dart';

import 'Pages/loading.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  bool isRun = await IsFirstRun.isFirstRun();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
  );
  runApp(BlockSafe(isRun: isRun));
}

class BlockSafe extends StatelessWidget {
  BlockSafe({required this.isRun, super.key});

  bool isRun;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: isRun ? "/start" : "/",
        routes: {
          "/": (context) => Wrapper(),
          "/home": (context) => Home(),
          "/navigation": (context) => const NavBar(),
          "/start": (context) => const ScreenOne(),
        });
  }
}
