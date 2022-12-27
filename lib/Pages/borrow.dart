import 'package:blocksafe_mobile_app/Services/provider_widget.dart';
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
    Stream<QuerySnapshot> _userBorrow =
        FirebaseFirestore.instance.collection('borrow').snapshots();
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
                              if (int.parse(val!) >
                                  Provider.of(context).stakeBalance) {
                                return "You cannot borrow more than ${Provider.of(context).stakeBalance} ugx";
                              }
                              if (int.parse(val) <=
                                  Provider.of(context).stakeBalance) {
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
                    child: Card(
                        child: Center(
                            child: Text(
                                "${Provider.of(context).stakeBalance} ugx")))),
              ),
              const SizedBox(height: 40),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 70,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        try {
                          // String _txn = await _ethUtils.userBorrow(
                          //     int.parse(_amount),
                          //     _user.email!);
                          // await DatabaseService(
                          //         uid: _user.uid)
                          //     .addBorrowTransaction(
                          //         _txn,
                          //         DateTime.now().microsecondsSinceEpoch,
                          //         "Stake",
                          //         int.parse(_amount),
                          //         2.5
                          //         );
                        } catch (e) {
                          print(e);
                        }
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: _userBorrow,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No data Available"));
                    }
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return BorrowDetails(
                          transactionName: data["transactionName"],
                          timeStamp: data["timeStamp"],
                          transactionHash: data["transactionHash"],
                          rate: data["interest"],
                          cost: data["transactionCost"],
                        );
                      }).toList(),
                    );
                  },
                ),
              )
            ]),
      ),
    ));
  }
}
