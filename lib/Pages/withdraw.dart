import 'package:blocksafe_mobile_app/Models/transaction.dart';
import 'package:blocksafe_mobile_app/Services/flutterwave.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/Navigation/navigationbar.dart';
import '../styles/colors.dart';

class Withdraw extends StatefulWidget {
  Withdraw({super.key, required this.balance});
  String balance;
  String _amount = "0";
  final _formKey = GlobalKey<FormState>();

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _userWithdraw = FirebaseFirestore.instance
        .collection('transactions')
        .where("transactionName", isEqualTo: "Withdraw")
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
                            if (int.parse(val!) <= 1000) {
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
                    child: Card(child: Center(child: Text(widget.balance)))),
              ),
              const SizedBox(height: 40),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 70,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (widget._formKey.currentState!.validate()) {
                        dynamic result = await PaymentService()
                            .withdraw(context, int.parse(widget._amount))
                            .then(((value) {
                          print(value);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => NavBar())));
                        }));
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: _userWithdraw,
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
                        return TransactionDetails(
                          transactionName: data["transactionName"],
                          timeStamp: data["timeStamp"],
                          transactionHash: data["transactionHash"],
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
