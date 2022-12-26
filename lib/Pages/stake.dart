import 'package:blocksafe_mobile_app/Models/stakeDetails.dart';
import 'package:blocksafe_mobile_app/Models/stakePeriod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Services/provider_widget.dart';
import '../styles/colors.dart';

class Stake extends StatefulWidget {
  Stake({super.key});
  late double interest;
  late int dateOfUnstake;

  @override
  State<Stake> createState() => _StakeState();
}

class _StakeState extends State<Stake> {
  String _amount = "0";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _userStake =
        FirebaseFirestore.instance.collection('stake').snapshots();
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.mainColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "Stake",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 70),
              const Text("Enter Amount To Stake:"),
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
                                Provider.of(context).balance) {
                              return "You cannot stake more than ${Provider.of(context).balance}";
                            }
                            if (int.parse(val) <= 1000) {
                              return "You cannot stake less than 1000 ugx";
                            }
                            return null;
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
              const Text("Lock Period"),
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                StakePeriod(
                    period: "30 days",
                    onTap: () {
                      widget.interest = 0.5;
                      widget.dateOfUnstake = DateTime.now()
                          .add(const Duration(days: 30))
                          .microsecondsSinceEpoch;
                    }),
                StakePeriod(
                    period: "90 days",
                    onTap: () {
                      widget.interest = 3;
                      widget.dateOfUnstake = DateTime.now()
                          .add(const Duration(days: 90))
                          .microsecondsSinceEpoch;
                    }),
                StakePeriod(
                    period: "180 days",
                    onTap: () {
                      widget.interest = 8;
                      widget.dateOfUnstake = DateTime.now()
                          .add(const Duration(days: 180))
                          .microsecondsSinceEpoch;
                    }),
                StakePeriod(
                    period: "360 days",
                    onTap: () {
                      widget.interest = 20;
                      widget.dateOfUnstake = DateTime.now()
                          .add(const Duration(days: 360))
                          .microsecondsSinceEpoch;
                    })
              ]),
              SizedBox(height: 40),
              Text("Current Balance"),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 50,
                    child: Card(
                        child: Center(
                            child:
                                Text("${Provider.of(context).balance} ugx")))),
              ),
              SizedBox(height: 40),
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
              SizedBox(height: 40),
              Text("Transactions"),
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: 500,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _userStake,
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
                        return StakeDetails(
                            transactionName: data["transactionName"],
                            timeStamp: data["timeStamp"],
                            transactionHash: data["transactionHash"],
                            rate: data["interest"],
                            cost: data["transactionCost"],
                            dateOfUnstake: data["dateOfUnstake"]);
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
