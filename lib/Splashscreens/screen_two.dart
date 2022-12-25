import "package:flutter/material.dart";
import "../Widgets/rectangle_painter.dart";
import 'screen_three.dart';

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({super.key});

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
            top: 100,
            child: Image.asset(
              "assets/images/img1.png",
              scale: 3,
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height - 250,
              child: const Text(
                "Save your money securely on \nthe Ethereum blockchain and \n earn passive income.",
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
                              builder: (context) => const ScreenThree()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(12, 115, 254, 1),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 20),
                    )),
              ))
        ],
      )),
    );
  }
}
