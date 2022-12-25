import 'package:blocksafe_mobile_app/Pages/Transfer.dart';
import 'package:blocksafe_mobile_app/Pages/home.dart';
import 'package:blocksafe_mobile_app/Pages/market_place.dart';
import 'package:blocksafe_mobile_app/Pages/profile.dart';
import 'package:blocksafe_mobile_app/Services/database.dart';
import 'package:blocksafe_mobile_app/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 2;
  final screens = [MarketPlace(), Transfer(), Home(), const Profile()];
  void onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: screens[currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.backgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.storefront), label: "Market"),
          BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz), label: "Transfer"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
        currentIndex: currentIndex,
        onTap: onTapped,
      ),
    );
  }
}
