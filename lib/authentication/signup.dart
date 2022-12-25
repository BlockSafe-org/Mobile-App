import 'package:blocksafe_mobile_app/Services/auth.dart';
import 'package:blocksafe_mobile_app/Services/eth_utils.dart';
import 'package:blocksafe_mobile_app/Widgets/input.dart';
import 'package:blocksafe_mobile_app/authentication/login.dart';
import 'package:blocksafe_mobile_app/authentication/verify_email.dart';
import 'package:flutter/material.dart';
import '../Widgets/circle_painter.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final EthUtils _ethUtils = EthUtils();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _ethUtils.initialSetup();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(178, 216, 230, 1),
      body: SafeArea(
          child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          CustomPaint(
            painter: CirclePainter(),
            child: Container(),
          ),
          const Positioned(
            top: 120,
            child: Text("Sign Up",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 30),
          Positioned(
              top: 240,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputData(
                        validator: (val) =>
                            val!.isEmpty ? "Invalid Email!" : null,
                        inputType: TextInputType.emailAddress,
                        controller: emailController,
                        hint: "Email Address",
                        isObscure: false),
                    const SizedBox(height: 30),
                    InputData(
                        validator: (val) => val!.length < 6
                            ? "Enter a password with more than 6 characters!"
                            : null,
                        controller: passwordController,
                        hint: "Password",
                        isObscure: true),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: 180,
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _auth
                                  .registerWithEmailAndPassword(
                                      emailController.text,
                                      passwordController.text)
                                  .then((value) {
                                if (value != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              VerifyEmail())));
                                }
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(12, 115, 254, 1),
                          ),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        },
                        child: Column(
                          children: const [
                            Text(
                              "Already have an account?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              "Click here to sign in.",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        ))
                  ],
                ),
              ))
        ],
      )),
    );
  }
}
