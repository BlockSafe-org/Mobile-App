import 'package:blocksafe_mobile_app/styles/colors.dart';
import 'package:flutter/material.dart';

class CardFunction extends StatelessWidget {
  CardFunction(
      {Key? key, required this.label, required this.icon, required this.onTap})
      : super(key: key);

  String label;
  IconData icon;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        width: 90,
        height: 120,
        child: GestureDetector(
          onTap: onTap,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: AppColor.backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon),
                const SizedBox(
                  height: 20,
                ),
                Text(label)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
