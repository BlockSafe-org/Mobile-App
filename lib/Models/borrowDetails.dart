import "package:flutter/material.dart";

import '../styles/colors.dart';

class BorrowDetails extends StatelessWidget {
  BorrowDetails({
    super.key,
    required this.transactionName,
    required this.timeStamp,
    required this.transactionHash,
    required this.rate,
    required this.cost,
  });

  String transactionName;
  String transactionHash;
  int timeStamp;
  double cost;
  double rate;

  String makeDate() {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(timeStamp);
    return "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.9),
            barrierColor: Colors.transparent,
            context: context,
            builder: (BuildContext bc) {
              return Container(
                height: MediaQuery.of(context).size.height - 180,
                child: Column(
                    children: <Widget>[const Text("Transaction Details")]),
              );
            });
      },
      child: Container(
        width: 100,
        height: 70,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: <Widget>[
                  Text(transactionName),
                  const SizedBox(height: 20),
                  Text(makeDate())
                ],
              ),
              Column(children: [
                const Text("Interest Rate:"),
                const SizedBox(height: 10),
                Text("$rate%")
              ]),
              Text("$cost ugx")
            ],
          ),
        ),
      ),
    );
  }
}
