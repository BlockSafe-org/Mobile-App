import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference transactions =
      FirebaseFirestore.instance.collection("transactions");
  final CollectionReference stakes =
      FirebaseFirestore.instance.collection("stake");
  final CollectionReference borrows =
      FirebaseFirestore.instance.collection("borrow");
  final CollectionReference transfers =
      FirebaseFirestore.instance.collection("transfer");

  Future<void> addTransaction(String email, String transactionHash,
      int timeStamp, String name, int cost) async {
    await transactions.add({
      'email': email,
      'transactionHash': transactionHash,
      'timestamp': timeStamp,
      "transactionName": name,
      "transactionCost": cost,
    });
  }

  Future<void> addStakeTransaction(String transactionHash, int timeStamp,
      String name, int cost, double interest, int dateOfUnstake) async {
    await stakes.doc(uid).set({
      'transactionHash': transactionHash,
      'timestamp': timeStamp,
      "transactionName": name,
      "transactionCost": cost,
      "interest": interest,
      "dateOfUnstake": dateOfUnstake
    });
  }

  Future<void> addBorrowTransaction(String transactionHash, int timeStamp,
      String name, int cost, double interest) async {
    await borrows.doc(uid).set({
      'transactionHash': transactionHash,
      'timestamp': timeStamp,
      "transactionName": name,
      "transactionCost": cost,
      "interest": interest,
    });
  }

  Future<void> addTransferTransaction(String transactionHash, int timeStamp,
      String name, int cost, String to, String from, String message) async {
    await transfers.doc(uid).set({
      'transactionHash': transactionHash,
      'timestamp': timeStamp,
      "transactionName": name,
      "transactionCost": cost,
      "message": cost,
      "to": to,
      "from": from
    });
  }

  Stream<QuerySnapshot> get userTransactions {
    return transactions.snapshots();
  }
}
