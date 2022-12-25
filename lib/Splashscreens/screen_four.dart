import 'package:flutter/material.dart';
import 'screen_five.dart';
import '../Widgets/rectangle_painter.dart';

class ScreenFour extends StatelessWidget {
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
            top: 70,
            child: Image.asset(
              "assets/images/img3.png",
              scale: 1.8,
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height - 250,
              child: const Text(
                "Send money across borders\n at low costs instantly.",
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
                              builder: (context) => const ScreenFive()));
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
    ;
  }
}
