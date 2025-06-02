import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:multivendor/firebase_options.dart';
import 'package:multivendor/vendor/pages/email_verification_page.dart';
import 'package:multivendor/vendor/pages/order_accepted_rejected_tabs.dart';
import 'package:provider/provider.dart';
import 'client/model/cart_provider.dart';
import 'client/splash_screen/fase_in_splash.dart';
@pragma('vm:entry-point')
Future<void> _firebaseBackgorundhandler(RemoteMessage message) async{
  await Firebase.initializeApp();
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // Uncomment below if you want to support reverse portrait
    // DeviceOrientation.portraitDown,
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgorundhandler);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()), // Example provider
      ],
      child: const MyApp(),

    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Use GetMaterialApp instead of MaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Cloud Based POS System',
      // home:const  OrderAcceptedRejectedTabs(), // Set AppCombination as the home page
      home:  FadeInSplash(), // Set AppCombination as the home page
      builder: EasyLoading.init(),
      // home:  EmailVerificationPage(), // Set AppCombination as the home page
    );
  }
}
