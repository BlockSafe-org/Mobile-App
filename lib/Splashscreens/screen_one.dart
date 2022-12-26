import "package:flutter/material.dart";
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:is_first_run/is_first_run.dart';
import '../Widgets/circle_painter.dart';
import "screen_two.dart";

class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
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
          Positioned(
            top: 70,
            child: Image.asset(
              "assets/images/Icons/blocksafe_white.png",
              scale: 1.2,
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height - 180,
              child: SizedBox(
                width: 180,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ScreenTwo()));
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
