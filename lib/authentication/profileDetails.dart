import 'package:flutter/material.dart';

import '../Widgets/circle_painter.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
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
                child: const Text("Create Profile",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w500)),
              ),
            ]))));
    ;
  }
}
