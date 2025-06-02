import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:multivendor/client/pages/home_page.dart';
import 'package:multivendor/client/pages/shopping_screen.dart';
import 'package:multivendor/vendor/pages/tabview_selection.dart';
import 'package:multivendor/vendor/view/screen/dashbord.dart';


class FadeInSplash extends StatefulWidget {
  @override
  _FadeInSplashState createState() => _FadeInSplashState();
}

class _FadeInSplashState extends State<FadeInSplash> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _navigateBasedOnRole();
  }

  Future<void> _navigateBasedOnRole() async {
    Timer(const Duration(seconds: 3), () async {
      User? user = _auth.currentUser;

      if (user != null) {
        // Fetch user role from Firestore
        try {
          final snapshot = await _firestore
              .collection('Franchise')
              .where('email', isEqualTo: user.email)
              .limit(1)
              .get();

          if (snapshot.docs.isNotEmpty) {
            final userData = snapshot.docs.first.data();
            final role = userData['role'];

            if (role == 'Vendor') {
              // Navigate to ScreenA
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>const DashBoardScreen(),
                ),
              );
            } else if (role == 'Shop Keeper') {
              // Navigate to ScreenB
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>const ShoppingCartScreen(),
                ),
              );
            } else {
              // Handle unknown roles
              _showErrorToast("Unknown role: $role");
            }
          } else {
            // No matching document found
            _showErrorToast("No user data found in Firestore.");
          }
        } catch (e) {
          // Handle errors
          _showErrorToast("Error fetching role: $e");
        }
      } else {
        // User not logged in, navigate to login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>const  SelectionPage(), // Replace with your LoginPage
          ),
        );
      }
    });
  }

  void _showErrorToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAE4DD),
      body: Center(
        child: SizedBox(
          height: 500,
          width: 300,
          child: Lottie.asset(
            "assets/animations/splash.json",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
