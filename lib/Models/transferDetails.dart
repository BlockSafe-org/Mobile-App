import 'package:flutter/material.dart';
import '../styles/colors.dart';
import 'package:intl/intl.dart';

class TransferDetails extends StatelessWidget {
  TransferDetails(
      {super.key, required this.timeStamp, required this.id, this.img});
  String? img;
  int timeStamp;
  String id;

  String makeDate() {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(timeStamp);
    return DateFormat('E, d MMM, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColor.backgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 5),
            CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: img != null ? Image.asset(img!) : null),
            Text(id, overflow: TextOverflow.ellipsis),
            Text(makeDate().toString())
          ],
        ),
      ),
    );
  }
}
