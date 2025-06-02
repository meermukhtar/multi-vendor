import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../client/splash_screen/fase_in_splash.dart';
import '../vendor/pages/splash.dart';

class AppCombination extends StatelessWidget {
  const AppCombination({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ComboApp"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                //  await _initializeFirebase('Vendor'); // Initialize Vendor Firebase
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => FadeInSplashScreen()),
                );
              },
              child: const Text("Vendor"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                //  await _initializeFirebase('Client'); // Initialize Client Firebase
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => FadeInSplash()),
                );
              },
              child: const Text("Client"),
            ),
          ],
        ),
      ),
    );
  }
}
