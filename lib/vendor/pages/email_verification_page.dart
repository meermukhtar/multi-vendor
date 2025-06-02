
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multivendor/vendor/pages/tabview_selection.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer timer;
  bool isButtonEnabled = false;  // Variable to control button's enabled/disabled state

  @override
  void initState() {
    super.initState();

    // Send the verification email initially
    _auth.currentUser?.sendEmailVerification();

    // Disable button for the first 20 seconds
    setState(() {
      isButtonEnabled = false;
    });

    // Timer to wait for 20 seconds before enabling the button
    Timer(Duration(seconds: 5), () {
      setState(() {
        isButtonEnabled = true; // Enable the button after 20 seconds
      });
    });

    // Reload current user data every 3 seconds
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _auth.currentUser?.reload();
      if (_auth.currentUser?.emailVerified == true) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>const SelectionPage()));
      }
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Don't forget to cancel the timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Check Your Email",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "We have sent a Email verification link \n Click on provided link to register.",
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: const Color(0xff304a62),
                  elevation: 20,
                  minimumSize: const Size(400, 50),
                 // shadowColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 120),
                ),
                onPressed: isButtonEnabled
                    ? () {
                  _auth.currentUser?.sendEmailVerification(); // Resend email on button press
                }
                    : null, // Disable the button by passing null to onPressed
                child: const Text("Resend Email", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
