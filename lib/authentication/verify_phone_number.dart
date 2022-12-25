import 'dart:async';
import 'dart:io';

import 'package:blocksafe_mobile_app/Pages/loading.dart';
import 'package:blocksafe_mobile_app/Services/auth.dart';
import 'package:blocksafe_mobile_app/Widgets/Navigation/navigationbar.dart';
import 'package:blocksafe_mobile_app/authentication/send_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../Widgets/circle_painter.dart';
import '../styles/colors.dart';

class VerifyPhoneNumber extends StatefulWidget {
  const VerifyPhoneNumber({super.key});

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  TextEditingController phoneController = TextEditingController();
  String? _verificationId;
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          User? user = await AuthService().showUser();
          await user?.updatePhoneNumber(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e);
        },
        codeSent: (String verificationId, int? pin) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String val) {});
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService().showUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(child: Text("Connection Problem !")),
                backgroundColor: AppColor.mainColor,
              );
            }
            if (FirebaseAuth.instance.currentUser!.phoneNumber == null ||
                FirebaseAuth.instance.currentUser!.phoneNumber == "") {
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
                            margin: const EdgeInsets.fromLTRB(0, 125, 0, 0),
                            child: const Text("Add Phone Number",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(height: 100),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 320,
                                  height: 70,
                                  child: IntlPhoneField(
                                    keyboardType: TextInputType.phone,
                                    onChanged: (val) {
                                      phoneController.text = val.completeNumber;
                                      //print(phoneController.text);
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: 'Phone Number',
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    initialCountryCode: 'UG',
                                  ),
                                ),
                                const SizedBox(height: 40),
                                SizedBox(
                                  width: 200,
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        //"+256702932328");
                                        _verificationId == null
                                            ? await verifyPhoneNumber(
                                                phoneController.text)
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) => SendOTP(
                                                        verId:
                                                            _verificationId))));
                                      },
                                      child: Center(
                                        child: _verificationId == null
                                            ? const Text("Get Code")
                                            : const Text("Enter OTP"),
                                      )),
                                )
                              ],
                            ),
                          )
                        ]),
                  )));
            }
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const NavBar())));
          }
          return const Loading();
        });
  }
}
