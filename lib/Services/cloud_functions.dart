import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctions {
  FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<String> getCredentials() async {
    HttpsCallable callable = functions.httpsCallable('getCredentials');
    final results = await callable();
    return results.data; // Private Key
  }

   Future<String> getSecretKey() async {
    HttpsCallable callable = functions.httpsCallable('flutterwaveSecretKey');
    final results = await callable();
    return results.data; // Private Key
  }
}
