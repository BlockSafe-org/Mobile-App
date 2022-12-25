import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Widgets/Navigation/navigationbar.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      return e;
    }
  }

  Future<User?> showUser() async {
    User? user = _auth.currentUser;
    await user?.reload();
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<bool?> showVerified() async {
    User? user = await showUser();
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    } else {
      return null;
    }
  }

  // Sign in with phone number

  Stream<User?> get user {
    return _auth.authStateChanges().map((user) => null);
  }

  // Register with email, password and phone number.
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return user;
    } catch (e) {
      return e;
    }
  }

  Future logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
