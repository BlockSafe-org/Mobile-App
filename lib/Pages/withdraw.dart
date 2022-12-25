import 'package:blocksafe_mobile_app/Models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/borrowDetails.dart';
import '../styles/colors.dart';

class Withdraw extends StatefulWidget {
  Withdraw({super.key, required this.balance});
  double balance;
  String _amount = "0";
  final _formKey = GlobalKey<FormState>();

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _userStake = FirebaseFirestore.instance
        .collection('transactions')
        .where("transactionName", isEqualTo: "withdraw")
        .snapshots();
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.mainColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text("Withdraw", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 70),
              const Text("Enter Amount To Withdraw:"),
              const SizedBox(height: 30),
              Center(
                child: Form(
                    key: widget._formKey,
                    child: SizedBox(
                        width: 300,
                        height: 60,
                        child: TextFormField(
                          validator: (val) {
                            if (int.parse(val!) > widget.balance) {
                              return "You cannot withdraw more than ${widget.balance}";
                            }
                            if (int.parse(val) <= 1000) {
                              return "You cannot withdraw less than 1000 ugx";
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              widget._amount = val;
                            });
                          },
                          initialValue: widget._amount.toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              focusColor: Colors.white,
                              hintText: "Amount"),
                        ))),
              ),
              const SizedBox(height: 40),
              const Text("Current Balance"),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 50,
                    child: Card(
                        child: Center(child: Text("${widget.balance} ugx")))),
              ),
              const SizedBox(height: 40),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 70,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget._formKey.currentState!.validate()) {
                        print(widget._amount);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.backgroundColor),
                    child: const Text("Confirm"),
                  )),
              const SizedBox(height: 40),
              const Text("Withdraw History:"),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 500,
                  child: ListView.builder(itemBuilder: (context, index) {
                    return TransactionDetails(
                      transactionName: "Withdraw",
                      timeStamp: DateTime.now().microsecondsSinceEpoch,
                      transactionHash:
                          "0xa90ce9f2569dce56c55a5fe0a764ca4b675e1b586a3617546651df427c18e9da",
                      cost: 4000,
                    );
                  }))
            ]),
      ),
    ));
  }
}
