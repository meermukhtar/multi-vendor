import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:multivendor/client/pages/home_page.dart';
import 'package:multivendor/client/pages/shopping_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  /// Request notification permissions
  Future<void> requestNotificationPermission() async {
    try {
      // Request Firebase Messaging notification permissions
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );

      // Handle permission responses
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print("User granted notification permission.");
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print("User granted provisional notification permission.");
      } else {
        print("User denied notification permission.");
        Get.snackbar(
          'Notifications Permission Denied',
          'Please enable notifications to receive updates.',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Redirect to settings after a short delay
        Future.delayed(const Duration(seconds: 3), () {
          AppSettings.openAppSettings(type: AppSettingsType.notification);
        });
      }
    } catch (e) {
      print("Error requesting notification permission: $e");
    }
  }

  /// Request additional permissions for Android 13+
  Future<void> requestAndroidNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      PermissionStatus status = await Permission.notification.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        Get.snackbar(
          'Notifications Permission Needed',
          'Please enable notifications to receive updates.',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Open app settings for user to manually enable notifications
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      }
    }
  }

  /// Initialize Firebase Messaging and request necessary permissions
  Future<void> initializeNotificationService() async {
    await requestNotificationPermission();

    // For Android 13+ ensure notification permissions are granted
    if (Theme.of(Get.context!).platform == TargetPlatform.android) {
      await requestAndroidNotificationPermission();
    }

    // Retrieve the Firebase Messaging token (optional)
    String? token = await messaging.getToken();
    print("Firebase Messaging Token: $token");
  }

  Future<String> getDeviceToken () async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    String ? token = await messaging.getToken();
    print("DeviceToke=$token");
    return token!;
  }
  
  //init
void initLocalNotifications(BuildContext context,RemoteMessage message) async{
    var androidInitSettings=const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosSettings=const DarwinInitializationSettings();
    var initialaizationSetting=InitializationSettings(
      android: androidInitSettings,
      iOS: iosSettings
    );
    await flutterLocalNotificationsPlugin.initialize(
        initialaizationSetting,onDidReceiveNotificationResponse:(payload){
          handleMessage(context, message);
    } );
}
/*
this below for foreground notification
 */
//firebase inint
void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message){
      RemoteNotification? notification=message.notification;
      AndroidNotification? android=message.notification!.android;
      if(kDebugMode){
        print("notification title :${notification!.title}");
        print("notification body :${notification.body}");
      }
      if(Platform.isIOS){
        foreGroundMessage();
      }
      if(Platform.isAndroid){
        initLocalNotifications(context, message);
        showNotificaations(message);
       // handleMessage(context, message);
      }
    });
}
//ios message
Future foreGroundMessage() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );


}
//Messge handler
  Future<void> handleMessage(BuildContext context,RemoteMessage message) async{
Navigator.push(context, MaterialPageRoute(builder: (context)=>const ShoppingCartScreen()));
  }

//back groudn and terminated state
Future setUPInterActMessage(BuildContext context) async{
  FirebaseMessaging.onMessage.listen((message){
    handleMessage(context, message);
  });

  //terminated state
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage?message){
    if(message!=null && message.data.isNotEmpty){
      handleMessage(context, message);
    }
  });
}
//show notificaations
Future <void> showNotificaations(RemoteMessage message) async{
  AndroidNotificationChannel channel=AndroidNotificationChannel(message.notification!.android!.channelId.toString(),message.notification!.android!.channelId.toString(),importance: Importance.high,showBadge: true,playSound: true);
AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails(channel.id.toString(),channel.name.toString(), channelDescription: "Channel Description",importance: Importance.high,priority: Priority.high,playSound: true,sound: channel.sound);

//ios settings
DarwinNotificationDetails darwinNotificationDetails=DarwinNotificationDetails(presentAlert: true,presentBadge: true,presentSound: true);

NotificationDetails notificationDetails=NotificationDetails(
  android: androidNotificationDetails,
  iOS: darwinNotificationDetails
);
//show notification
Future.delayed(Duration.zero,(){
  flutterLocalNotificationsPlugin.show(0, message.notification!.title.toString(),  message.notification!.body.toString(), notificationDetails,payload: "my_data");
});
}
}
