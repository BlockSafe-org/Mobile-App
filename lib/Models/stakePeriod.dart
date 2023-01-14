import 'package:blocksafe_mobile_app/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class StakePeriod extends StatefulWidget {
  StakePeriod({super.key, required this.period, required this.onTap});
  String period;
  Function() onTap;
  @override
  State<StakePeriod> createState() => _StakePeriodState();
}

class _StakePeriodState extends State<StakePeriod> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 70,
        height: 80,
        child: Card(
          child: Center(child: Text(widget.period)),
        ),
      ),
    );
  }
}
