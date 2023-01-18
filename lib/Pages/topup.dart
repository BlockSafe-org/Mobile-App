import 'package:blocksafe_mobile_app/Models/transaction.dart';
import 'package:blocksafe_mobile_app/Services/database.dart';
import 'package:blocksafe_mobile_app/Services/flutterwave.dart';
import 'package:blocksafe_mobile_app/Widgets/Navigation/navigationbar.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blocksafe_mobile_app/Services/eth_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
//import 'package:flutter_paystack_client/flutter_paystack_client.dart';
import '../styles/colors.dart';

class TopUp extends StatefulWidget {
  TopUp({super.key});

  @override
  State<TopUp> createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  String _amount = "";
  final _formKey = GlobalKey<FormState>();
  final User _user = FirebaseAuth.instance.currentUser!;
  final EthUtils _ethUtils = EthUtils();
  CurrencyFormatterSettings settings = CurrencyFormatterSettings(
    // formatter settings for euro
    symbol: 'UGX',
    symbolSide: SymbolSide.right,
    thousandSeparator: ',',
    decimalSeparator: '.',
    symbolSeparator: ' ',
  );

  @override
  Widget build(BuildContext context) {
    _ethUtils.initialSetup();
    Stream<QuerySnapshot> _userTopUp = FirebaseFirestore.instance
        .collection('transactions')
        .where("transactionName", isEqualTo: "TopUp")
        .where("email", isEqualTo: _user.email)
        .snapshots();
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.mainColor,
        iconTheme: const IconThemeData(
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
                          initialValue: _amount,
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate() == true) {
                        // ChargeResponse response = await PaymentService()
                        //     .handlePayment(context, int.parse(_amount));
                        String txn = await _ethUtils.userDeposit(
                            int.parse(_amount), _user.email!);
                        // await DatabaseService(uid: _user.uid).addTransaction(
                        //     _user.email!,
                        //     txn,
                        //     DateTime.now().microsecondsSinceEpoch,
                        //     "TopUp",
                        //     int.parse(_amount));
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => NavBar()));
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
                          timeStamp: data["timestamp"],
                          transactionHash: data["transactionHash"],
                          cost: CurrencyFormatter.format(
                              data["transactionCost"], settings,
                              decimal: 2),
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
