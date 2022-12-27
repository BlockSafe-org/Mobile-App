import 'dart:convert';

import 'package:http/http.dart' as http;

class PayStackPayments {
  _showPayStack(
    int amount,
  ) async {
    var headers = {
      'Authorization': 'pk_test_1d5a371a2d05d479450c6d2d785e51c4efa92cec',
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST', Uri.parse('https://api.paystack.co/transaction/initialize'));
    request.body = json.encode({
      "email": "g.ikwegbu@gmail.com",
      "amount": amount,
      "callback_url": "https://github.com/gikwegbu",
      "metadata": {"cancel_action": "https://www.google.com/"}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
