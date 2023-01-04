import 'package:blocksafe_mobile_app/Pages/Profile/verify.dart';
import 'package:blocksafe_mobile_app/Services/auth.dart';
import 'package:blocksafe_mobile_app/Widgets/title.dart';
import 'package:blocksafe_mobile_app/Widgets/wrapper.dart';
import 'package:blocksafe_mobile_app/styles/colors.dart';
import 'package:flutter/material.dart';

import '../Widgets/clickable_container.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            PageTitle(heading: "Profile"),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset("assets/images/dummy_pic.jpg",
                  width: 150, height: 150, fit: BoxFit.fill),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  ClickableContainer(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Verify()));
                      },
                      title: "My Account",
                      icon: Icons.person),
                  ClickableContainer(
                      onTap: () {}, title: "Settings", icon: Icons.settings),
                  ClickableContainer(
                      onTap: () {}, title: "Help Center", icon: Icons.help),
                  ClickableContainer(
                      onTap: () {},
                      title: "Privacy Policy",
                      icon: Icons.policy),
                  ClickableContainer(
                      onTap: () async {
                        await AuthService().logout().then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wrapper()));
                        });
                      },
                      title: "Log out",
                      icon: Icons.logout),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
