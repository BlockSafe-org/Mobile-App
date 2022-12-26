import 'package:blocksafe_mobile_app/Models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../styles/colors.dart';

class TopUp extends StatefulWidget {
  TopUp({super.key});

  @override
  State<TopUp> createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  String _amount = "0";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _userTopUp = FirebaseFirestore.instance
        .collection('transactions')
        .where("transactionName", isEqualTo: "TopUp")
        .snapshots();
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.mainColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "TopUp",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 70),
              const Text("Enter Amount To TopUp:"),
              const SizedBox(height: 30),
              Center(
                child: Form(
                    key: _formKey,
                    child: SizedBox(
                        width: 300,
                        height: 60,
                        child: TextFormField(
                          validator: (value) {
                            if (int.parse(value!) < 5000) {
                              return "Cannot deposit less than 5000 ugx!";
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
                        ))),
              ),
              const SizedBox(height: 40),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 70,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() == true) {
                        print(_amount);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.backgroundColor),
                    child: const Text("Confirm"),
                  )),
              SizedBox(height: MediaQuery.of(context).size.height - 600),
              const Text("TopUp History:"),
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: 500,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _userTopUp,
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
