import 'dart:io';

import 'package:blocksafe_mobile_app/Models/transferDetails.dart';
import 'package:blocksafe_mobile_app/Widgets/title.dart';
import 'package:blocksafe_mobile_app/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Transfer extends StatefulWidget {
  Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  final TextEditingController transferController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

  double charge = 0;
  String _amount = "";

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _userTransfer = FirebaseFirestore.instance
        .collection('transactions')
        .where("transactionName", isEqualTo: "transfer")
        .snapshots();
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            PageTitle(heading: "Transfer"),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: 50,
                child: TextFormField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      focusColor: Colors.white,
                      hintText: "Enter email or Ethereum Address"),
                  controller: addressController,
                ),
              ),
            ),
            const SizedBox(height: 20),
            PageTitle(heading: "Recent Transactions"),
            const SizedBox(height: 20),
            SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                height: 180,
                child: StreamBuilder<QuerySnapshot>(
                    stream: _userTransfer,
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
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return TransferDetails(
                              timeStamp: data["timeStamp"], id: data["to"]);
                        }).toList(),
                      );
                    })),
            const SizedBox(height: 20),
            PageTitle(heading: "Amount"),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width - 30,
              height: 200,
              child: Card(
                borderOnForeground: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 10,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          _amount = val;
                          setState(() {
                            charge = double.parse(val) * (10 / 100);
                          });
                          return;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            hintText: "Amount"),
                        controller: transferController,
                      ),
                    ),
                    SizedBox(height: 20),
                    const Text("Transaction Cost:"),
                    SizedBox(height: 20),
                    Text("$charge ugx"),
                    SizedBox(height: 20),
                    const Text("Total Cost:"),
                    SizedBox(height: 20),
                    Text("${charge + int.parse(_amount)} ugx"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            PageTitle(heading: "Message"),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: TextFormField(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    focusColor: Colors.white,
                    hintText: "Message"),
                controller: messageController,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
                width: MediaQuery.of(context).size.width - 70,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.backgroundColor),
                  child: const Text("Proceed"),
                )),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
