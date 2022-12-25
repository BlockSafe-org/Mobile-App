import "package:flutter/material.dart";

class PageTitle extends StatelessWidget {
  PageTitle({
    Key? key,
    required this.heading,
  }) : super(key: key);
  String heading;

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }
}
