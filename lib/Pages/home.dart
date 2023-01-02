import 'package:blocksafe_mobile_app/Models/transaction.dart';
import 'package:blocksafe_mobile_app/Pages/borrow.dart';
import 'package:blocksafe_mobile_app/Pages/loading.dart';
import 'package:blocksafe_mobile_app/Pages/stake.dart';
import 'package:blocksafe_mobile_app/Pages/topup.dart';
import 'package:blocksafe_mobile_app/Pages/withdraw.dart';
import 'package:blocksafe_mobile_app/Services/eth_utils.dart';
import 'package:blocksafe_mobile_app/Widgets/title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:localstorage/localstorage.dart';
import '../Widgets/balance.dart';
import '../Widgets/card_function.dart';
import "../styles/colors.dart";

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalStorage storage = LocalStorage("userAddress");
  final EthUtils _ethUtils = EthUtils();

  // ignore: avoid_init_to_null

  Future<void> initial() async {
    _ethUtils.initialSetup();
    await storage.ready;
    await _ethUtils.getUserContract(FirebaseAuth.instance.currentUser!.email!);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    final Stream<QuerySnapshot> _userTxns = FirebaseFirestore.instance
        .collection('transactions')
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email!)
        .snapshots();
    return FutureBuilder(
        future: initial(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Scaffold(
                body: Center(child: Text("Connection Problem!")),
                backgroundColor: AppColor.mainColor,
              );
            }
            return Scaffold(
                backgroundColor: AppColor.mainColor,
                body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(child: PageTitle(heading: "Home")),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CardFunction(
                              icon: Icons.attach_money,
                              label: "Top up",
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => TopUp())));
                              },
                            ),
                            CardFunction(
                                icon: Icons.receipt,
                                label: "Stake",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Stake(
                                                balance: storage
                                                    .getItem("balances")[0],
                                              )));
                                }),
                            CardFunction(
                              icon: Icons.arrow_downward,
                              label: "Borrow",
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Borrow()));
                              },
                            ),
                            CardFunction(
                              icon: Icons.arrow_upward,
                              label: "Withdraw",
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Withdraw(
                                            balance: storage
                                                .getItem("balances")[0])));
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(child: PageTitle(heading: "Balances")),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Balance(
                              imageLink: "assets/images/Icons/tether.png",
                              balance: "${storage.getItem("balances")[0]} Ugx",
                            ),
                            Balance(
                              imageLink: "assets/images/Icons/gencoin.png",
                              scale: 2,
                              balance:
                                  "${storage.getItem("balances")[1]} Gencoin",
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(child: PageTitle(heading: "Transactions")),
                        const SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width - 20,
                              height: 500,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: _userTxns,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }

                                  return ListView(
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;
                                      return TransactionDetails(
                                          transactionName:
                                              data["transactionName"],
                                          timeStamp: data["timestamp"],
                                          transactionHash:
                                              data["transactionHash"],
                                          cost: 0);
                                    }).toList(),
                                  );
                                },
                              )),
                        )
                      ]),
                ));
          }
          return const Loading();
        });
  }
}
