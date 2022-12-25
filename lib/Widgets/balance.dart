import 'package:blocksafe_mobile_app/styles/colors.dart';
import 'package:flutter/material.dart';

class Balance extends StatelessWidget {
  Balance({
    Key? key,
    required this.balance,
    required this.imageLink,
    this.scale,
  }) : super(key: key);
  String balance;
  String imageLink;
  double? scale = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Card(
          color: AppColor.backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                imageLink,
                scale: scale,
              ),
              const SizedBox(height: 30),
              Text(balance),
            ],
          )),
    );
  }
}
