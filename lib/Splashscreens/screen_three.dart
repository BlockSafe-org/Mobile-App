import 'package:flutter/material.dart';
import '../Widgets/rectangle_painter.dart';
import 'screen_four.dart';

class ScreenThree extends StatelessWidget {
  const ScreenThree({super.key});

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
              "assets/images/img2.png",
              scale: 7,
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height - 250,
              child: const Text(
                "Borrow money at low interest\n rates and no time period.",
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
                              builder: (context) => ScreenFour()));
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
