import 'package:blocksafe_mobile_app/Pages/loading.dart';
import 'package:blocksafe_mobile_app/Services/auth.dart';
import 'package:blocksafe_mobile_app/Widgets/Navigation/navigationbar.dart';
import 'package:blocksafe_mobile_app/authentication/signup.dart';
import 'package:blocksafe_mobile_app/authentication/verify_email.dart';
import 'package:blocksafe_mobile_app/authentication/verify_phone_number.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';

class Wrapper extends StatefulWidget {
  Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService().showUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(child: Text("Connection Problem!")),
                backgroundColor: AppColor.mainColor,
              );
            }
            if (snapshot.data != null) {
              if (snapshot.data!.emailVerified == true) {
                if (snapshot.data!.phoneNumber == null ||
                    snapshot.data!.phoneNumber == "") {
                  return const VerifyPhoneNumber();
                }
                return const NavBar();
              }
              return VerifyEmail();
            }
            return const SignUp();
          }
          return const Loading();
        });
  }
}
