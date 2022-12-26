import 'package:blocksafe_mobile_app/Services/auth.dart';
import 'package:blocksafe_mobile_app/authentication/register.dart';
import 'package:blocksafe_mobile_app/authentication/verify_email.dart';
import 'package:blocksafe_mobile_app/authentication/verify_phone_number.dart';
import "package:flutter/material.dart";
import '../Widgets/circle_painter.dart';
import "../Widgets/input.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
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
            child: Text("Sign In",
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
                        inputType: TextInputType.emailAddress,
                        validator: (val) =>
                            val!.isEmpty ? "Enter an Email!" : null,
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
                                    .signInWithEmailAndPassword(
                                        emailController.text,
                                        passwordController.text)
                                    .then((value) {
                                  if (value != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VerifyEmail()));
                                  } else {
                                    print(value);
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(12, 115, 254, 1),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 20),
                            ))),
                    const SizedBox(
                      height: 60,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        },
                        child: Column(
                          children: const [
                            Text(
                              "Don't have an account?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              "Click here to sign up.",
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
