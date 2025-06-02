import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:multivendor/vendor/pages/tabview_selection.dart';

import '../view/screen/dashbord.dart';

class FadeInSplashScreen extends StatefulWidget {
  @override
  _FadeInSplashScreenState createState() => _FadeInSplashScreenState();
}

class _FadeInSplashScreenState extends State<FadeInSplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate based on authentication status after 5 seconds
    Timer(const Duration(seconds: 5), () {
      // Check if the user is logged in
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // If the user is logged in, navigate to the HomePage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>const DashBoardScreen(),
          ),
        );
      } else {
        // If the user is not logged in, navigate to the LoginPageScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>const SelectionPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAE4DD), // Set background color to your desired color
      body: Center(
        child: SizedBox(
          height: 500,
          width: 300,
          child: Lottie.asset(
            "assets/animations/vendor.json",
            fit: BoxFit.contain, // Ensure the animation fits nicely within the box
          ),
        ),
      ),
    );
  }
}
