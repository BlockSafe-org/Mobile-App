import 'package:blocksafe_mobile_app/Pages/loading.dart';
import 'package:blocksafe_mobile_app/Services/auth.dart';
import 'package:blocksafe_mobile_app/authentication/verify_phone_number.dart';
import 'package:blocksafe_mobile_app/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import '../Widgets/circle_painter.dart';

class VerifyEmail extends StatelessWidget {
  VerifyEmail({super.key});

  Future<bool?> checkVerified() async {
    bool? isVerified = await AuthService().showVerified();
    return isVerified;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkVerified(),
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(child: Text("Connection Problem!")),
                backgroundColor: AppColor.mainColor,
              );
            }
            if (snapshot.data == false) {
              FirebaseAuth.instance.currentUser?.sendEmailVerification();
            }
            return Scaffold(
                backgroundColor: const Color.fromRGBO(178, 216, 230, 1),
                body: SafeArea(
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                      CustomPaint(
                        painter: CirclePainter(),
                        child: Container(),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 120, 0, 0),
                        child: const Text("Verify Email",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                              child: snapshot.data == false
                                  ? const Text(
                                      "A verification link has been sent to your email, please check your mail to verify your email account, The email may be marked as spam. Please check your spam folder.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ))
                                  : const Text(
                                      "Your Email has been verified, proceed to the next Page!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ))),
                        ),
                      ),
                      const SizedBox(height: 60),
                      ElevatedButton(
                          onPressed: () {
                            if (snapshot.data == false) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => VerifyEmail())));
                            }
                            if (snapshot.data == true) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const VerifyPhoneNumber()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(12, 115, 254, 1),
                          ),
                          child: snapshot.data == false
                              ? const Text("Reload Page")
                              : const Text("Verify Phone Number"))
                    ]))));
          }
          return const Loading();
        });
  }
}
