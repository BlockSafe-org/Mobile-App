import 'package:blocksafe_mobile_app/authentication/signup.dart';
import 'package:flutter/material.dart';
import '../Widgets/rectangle_painter.dart';

class ScreenSix extends StatelessWidget {
  const ScreenSix({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(178, 216, 230, 1),
      body: SafeArea(
          child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          CustomPaint(
            foregroundPainter: RectanglePainter(),
            child: Container(),
          ),
          Positioned(
            top: 55,
            child: Image.asset(
              "assets/images/img5.png",
              scale: 5,
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height - 250,
              child: const Text(
                "Start saving and earning today\n on the Blockchain.",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              )),
          Positioned(
              top: MediaQuery.of(context).size.height - 100,
              child: SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(12, 115, 254, 1),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(fontSize: 20),
                    )),
              ))
        ],
      )),
    );
    ;
  }
}
