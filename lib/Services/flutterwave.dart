import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutterwave_standard/flutterwave.dart";

class PaymentService {
  final User _user = FirebaseAuth.instance.currentUser!;

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

  Future<void> handleWithdraw(BuildContext context, int amount) async {
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
  }
}
