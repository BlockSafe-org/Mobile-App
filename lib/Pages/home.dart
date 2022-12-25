import 'dart:convert';
import 'package:blocksafe_mobile_app/Models/transaction.dart';
import 'package:blocksafe_mobile_app/Pages/borrow.dart';
import 'package:blocksafe_mobile_app/Pages/loading.dart';
import 'package:blocksafe_mobile_app/Pages/stake.dart';
import 'package:blocksafe_mobile_app/Pages/topup.dart';
import 'package:blocksafe_mobile_app/Pages/withdraw.dart';
import 'package:blocksafe_mobile_app/Widgets/title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:localstorage/localstorage.dart';
import 'package:web3dart/web3dart.dart';
import '../Services/eth_utils.dart';
import '../Widgets/balance.dart';
import '../Widgets/card_function.dart';
import "../styles/colors.dart";
import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
  Home({super.key});
  final EthUtils _ethUtils = EthUtils();
  final LocalStorage storage = LocalStorage("userAddress");
  late List<dynamic> balances;
  late dynamic _balance = null;

  Future<void> initState() async {
    _ethUtils.initialSetup();
    await _ethUtils.getUserContract(FirebaseAuth.instance.currentUser!.email!);
    await storage.ready;
    balances = await _ethUtils.loadBalances();
    //print(storage.getItem("userAddress"));
    await convert();
  }

  Future<void> convert() async {
    var val = EtherAmount.fromUnitAndValue(EtherUnit.wei, balances[0]);
    String url =
        'https://openexchangerates.org/api/latest.json?app_id=a0b1ffe3d063455db6f29cda92b93977&base=USD&symbols=UGX&prettyprint=false&show_alternative=false';
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    _balance = val.getInEther.toInt() * data["rates"]["UGX"];
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _userTxns =
        FirebaseFirestore.instance.collection('transactions').snapshots();
    return FutureBuilder(
        future: initState(),
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
                                          builder: (context) =>
                                              Stake(balance: _balance)));
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
                                        builder: (context) =>
                                            Withdraw(balance: _balance)));
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
                              balance: snapshot.connectionState !=
                                      ConnectionState.done
                                  ? "Loading.."
                                  : "${_balance} Ugx",
                            ),
                            Balance(
                              imageLink: "assets/images/Icons/gencoin.png",
                              scale: 2,
                              balance: "${balances[1]} Gencoin",
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
          return Loading();
        });
  }
}
