import 'package:blocksafe_mobile_app/Widgets/amountInput.dart';
import 'package:blocksafe_mobile_app/Widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/borrowDetails.dart';
import '../styles/colors.dart';

class Borrow extends StatefulWidget {
  Borrow({super.key});

  @override
  State<Borrow> createState() => _BorrowState();
}

class _BorrowState extends State<Borrow> {
  String _amount = "0";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _userStake = FirebaseFirestore.instance
        .collection('transactions')
        .where("transactionName", isEqualTo: "borrow")
        .snapshots();
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.mainColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "Borrow",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 70),
              const Text("Enter Amount To Borrow:"),
              const SizedBox(height: 30),
              Center(
                  child: Form(
                      key: _formKey,
                      child: SizedBox(
                          width: 300,
                          height: 60,
                          child: TextFormField(
                            validator: (val) {
                              if (int.parse(val!) > 423234) {
                                return "You cannot borrow more than 123334 ugx";
                              }
                              if (int.parse(val) <= 1000) {
                                return "You cannot borrow less than 1000 ugx";
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                _amount = val;
                              });
                            },
                            initialValue: _amount.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                focusColor: Colors.white,
                                hintText: "Amount"),
                          )))),
              const SizedBox(height: 40),
              const Text("You can borrow up to:"),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 50,
                    child: Card(child: Center(child: Text("123,334 ugx")))),
              ),
              const SizedBox(height: 40),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 70,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(_amount);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.backgroundColor),
                    child: const Text("Confirm"),
                  )),
              const SizedBox(height: 40),
              const Text("Pending debts:"),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 500,
                  child: ListView.builder(itemBuilder: (context, index) {
                    return BorrowDetails(
                        transactionName: "Borrow",
                        timeStamp: DateTime.now().microsecondsSinceEpoch,
                        transactionHash:
                            "0xa90ce9f2569dce56c55a5fe0a764ca4b675e1b586a3617546651df427c18e9da",
                        rate: 1.5,
                        cost: 3000,
                        dateOfUnstake: DateTime.now()
                            .add(const Duration(days: 30))
                            .microsecondsSinceEpoch);
                  }))
            ]),
      ),
    ));
  }
}
