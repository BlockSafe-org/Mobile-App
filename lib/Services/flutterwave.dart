import 'dart:convert';

import 'package:blocksafe_mobile_app/Services/cloud_functions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutterwave_standard/flutterwave.dart";
import 'package:http/http.dart' as http;

class PaymentService {
  final User _user = FirebaseAuth.instance.currentUser!;
  FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<ChargeResponse> handlePayment(BuildContext context, int amount) async {
    final Customer customer = Customer(
        name: _user.uid, phoneNumber: _user.phoneNumber!, email: _user.email!);
    final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey: "FLWPUBK_TEST-751160970f4e7874030b0478523b3ccb-X",
        currency: "UGX",
        redirectUrl: "/",
        txRef: "ref ${DateTime.now()}",
        amount: "$amount",
        customer: customer,
        paymentOptions: "ussd, card, mobilemoneyuganda",
        customization: Customization(title: "BlockSafe Deposit"),
        isTestMode: true);
    final ChargeResponse response = await flutterwave.charge();
    return response;
  }

  Future<dynamic> withdraw(BuildContext context, int amount) async {
    String url = 'https://api.flutterwave.com/v3/transfers';
    String secretKey = await CloudFunctions().getSecretKey();
    String body = json.encode({
      "account_bank": "MPS",
      "account_number": "2540782773934",
      "amount": amount,
      "currency": "KES",
      "beneficiary_name": "Akinyi Kimwei",
      "meta": {
        "sender": "Flutterwave Developers",
        "sender_country": "ZA",
        "mobile_number": "23457558595"
      }
    });
    dynamic response = await http.post(Uri.parse(url), body: body, headers: {
      "Authorization": secretKey,
      "Content-Type": "application/json",
    });
    print(response);
  }
}
