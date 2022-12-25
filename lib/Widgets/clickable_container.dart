import 'package:blocksafe_mobile_app/styles/colors.dart';
import 'package:flutter/material.dart';

class ClickableContainer extends StatelessWidget {
  ClickableContainer(
      {Key? key, required this.title, required this.icon, required this.onTap})
      : super(key: key);
  IconData icon;
  String title;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 60,
            decoration: BoxDecoration(
                color: AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 10),
                Icon(icon),
                const SizedBox(width: 10),
                Text(title)
              ],
            ),
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
