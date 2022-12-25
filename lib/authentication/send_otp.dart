import 'dart:async';
import 'dart:math';

import 'package:blocksafe_mobile_app/Services/auth.dart';
import 'package:blocksafe_mobile_app/Services/database.dart';
import 'package:blocksafe_mobile_app/Services/eth_utils.dart';
import 'package:blocksafe_mobile_app/Widgets/Navigation/navigationbar.dart';
import 'package:blocksafe_mobile_app/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:pin_code_fields/pin_code_fields.dart';
import '../Widgets/circle_painter.dart';

class SendOTP extends StatefulWidget {
  const SendOTP({required this.verId, super.key});
  final String? verId;
  @override
  State<SendOTP> createState() => _SendOTPState();
}

class _SendOTPState extends State<SendOTP> {
  TextEditingController codeController = TextEditingController();
  var errorController = StreamController<ErrorAnimationType>();
  String currentText = "";
  bool hasError = false;
  final EthUtils _ethUtils = EthUtils();
  bool loading = false;

  void initState() {
    _ethUtils.initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.verId);
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
                  child: const Text("OTP Code",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w500)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                          "A verification code has been sent to your number, please check your phone and copy the one-time code below.",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PinCodeTextField(
                        onChanged: (value) {
                          setState(() {
                            currentText = value;
                          });
                        },
                        appContext: context,
                        pastedTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 6,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 60,
                            fieldWidth: 40,
                            inactiveColor: AppColor.mainColor,
                            activeColor: AppColor.mainColor),
                        cursorColor: Colors.black,
                        textStyle: const TextStyle(fontSize: 20, height: 1.6),
                        controller: codeController,
                        keyboardType: TextInputType.number,
                        boxShadows: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: WillPopScope(
                          onWillPop: () async => false,
                          child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: widget.verId!,
                                        smsCode: codeController.text);
                                User? _user = FirebaseAuth.instance.currentUser;
                                String _txn =
                                    await _ethUtils.addUser(_user!.email!);
                                await DatabaseService(uid: _user.uid)
                                    .addTransaction(
                                  _user.email!,
                                  _txn,
                                  DateTime.now().microsecondsSinceEpoch,
                                  "Creation",
                                  0,
                                );
                                await FirebaseAuth.instance.currentUser!
                                    .updatePhoneNumber(credential)
                                    .then((value) {
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const NavBar())));
                                });
                              },
                              child: Center(
                                child: loading
                                    ? const CircularProgressIndicator(
                                        color: Color.fromARGB(255, 15, 210, 21),
                                      )
                                    : const Text("Submit"),
                              )),
                        ),
                      ),
                      const SizedBox(height: 20),
                      loading
                          ? const Text(
                              "Creating Account, Please Wait...",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            )
                          : const Text('')
                    ],
                  ),
                )
              ]),
        )));
  }
}
