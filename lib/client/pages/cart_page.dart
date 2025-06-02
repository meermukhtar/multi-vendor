import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:multivendor/client/pages/shopping_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Notification/services/send_notification_service.dart';
import '../../vendor/view/themes/colors.dart';
import '../model/cart_provider.dart';
import '../model/product_model.dart';
import '../payment/add_payment_method.dart';
import '../services/place_order.dart';
import '../widgets/cart_widget.dart';
import 'home_page.dart';


class CartPage extends StatefulWidget {
  final List<ClientProduct> cartItems;

  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  // void _placeOrder() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     try {
  //       // Fetch the user's profile data
  //       DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
  //           .collection('usersProfile')
  //           .doc(user.uid)
  //           .get();
  //
  //       if (userProfileSnapshot.exists) {
  //         var userProfileData = userProfileSnapshot.data() as Map<String, dynamic>;
  //
  //         double latitude = userProfileData['latitude']?.toDouble() ?? 0.0;
  //         double longitude = userProfileData['longitude']?.toDouble() ?? 0.0;
  //
  //         if (latitude == 0.0 && longitude == 0.0) {
  //           throw Exception("Latitude and Longitude not found or are zero.");
  //         }
  //
  //         List<Map<String, dynamic>> orderDetails = [];
  //
  //         // Iterate over each product in the cart to create the order data
  //         for (var product in widget.cartItems) {
  //           double price = double.parse(product.price);
  //           int quantity = product.quantity;
  //           double totalPrice = price * quantity;
  //
  //           Map<String, dynamic> orderData = {
  //             'productName': product.productName,
  //             'price': totalPrice,
  //             'quantity': product.quantity,
  //             'imageProduct': product.imageProduct,
  //             'userId': user.uid,
  //             'latitude': latitude,
  //             'longitude': longitude,
  //             'vendorId': product.vendorId,
  //             'productId': product.productId,
  //             'createdAt': Timestamp.now(),
  //           };
  //
  //           // Store the order in the "OrderCollections" for the vendor using the user's UID as the document ID
  //           await FirebaseFirestore.instance
  //               .collection('Franchise')
  //               .doc(product.vendorId)  // Use the vendorId to identify the vendor
  //               .collection('OrderCollections')
  //               .doc(user.uid)  // Use user.uid to store the order under the user's document
  //               .set(orderData);  // Use set() to store the order data under user.uid
  //
  //           // Add the order ID to the orderDetails
  //           orderData['orderId'] = product.vendorId + "_" + user.uid;  // You can create a unique orderId
  //           orderDetails.add(orderData);
  //         }
  //
  //         // Save the entire order in orderHistory for the user
  //         await FirebaseFirestore.instance
  //             .collection('orderHistory')
  //             .doc(user.uid)
  //             .collection('orders')
  //             .add({
  //           'orderDetails': orderDetails,
  //           'createdAt': Timestamp.now(),
  //         });
  //
  //         _showSuccessToast("Order Placed", "Your order has been placed successfully.");
  //         context.read<CartProvider>().clearCart();
  //         Navigator.pop(context);
  //       } else {
  //         _showErrorToast("User Profile Not Found", "Could not find user profile information.");
  //       }
  //     } catch (e) {
  //       _showErrorToast("Error", "Something went wrong: $e");
  //     }
  //   }
  // }

  Future<String?> _placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
            .collection('Franchise')
            // .collection('usersProfile')
            .doc(user.uid)
            .get();

        if (userProfileSnapshot.exists) {
          var userProfileData = userProfileSnapshot.data() as Map<String, dynamic>;

          double latitude = userProfileData['latitude']?.toDouble() ?? 0.0;
          double longitude = userProfileData['longitude']?.toDouble() ?? 0.0;

          if (latitude == 0.0 && longitude == 0.0) {
            throw Exception("Latitude and Longitude not found or are zero.");
          }

          List<Map<String, dynamic>> orderDetails = [];

          for (var product in widget.cartItems) {
            double price = double.parse(product.price);
            int quantity = product.quantity;
            double totalPrice = price * quantity;

            Map<String, dynamic> orderData = {
              'productName': product.productName,
              'price': totalPrice,
              'quantity': product.quantity,
              'imageProduct': product.imageProduct,
              'userId': user.uid,
              'latitude': latitude,
              'longitude': longitude,
              'vendorId': product.vendorId,
              'productId': product.productId,
              'createdAt': Timestamp.now(),
            };

            // Store each order directly in the top-level "orders" collection
            DocumentReference orderRef = await FirebaseFirestore.instance
                .collection('Franchise')
                .doc(product.vendorId)
                .collection('OrderCollections')
                .add(orderData);

            // Add the order ID to the order data for orderHistory
            orderData['orderId'] = orderRef.id;
            orderDetails.add(orderData);
          }

          // Save the entire order in orderHistory for the user
          await FirebaseFirestore.instance
              .collection('orderHistory')
              .doc(user.uid)
              .collection('orders') // Use a subcollection to keep historical data
              .add({
            'orderDetails': orderDetails,
            'createdAt': Timestamp.now(),
          });
        //  _showSuccessToast("Order Placed", "Your order has been placed successfully.");
          /*
          Frenchise currenid DeviceToke
           */
          String userId = FirebaseAuth.instance.currentUser!.uid;
          DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
              .collection('Franchise')
              .doc(userId)
              .get();

          if (docSnapshot.exists) {
            // Ensure 'DeviceToken' field exists
            String deviceToken = docSnapshot['DeviceToke'];
            // Corrected the field name
           if (kDebugMode) {
             print(deviceToken);
           }
            if (deviceToken.isNotEmpty) {
              EasyLoading.show();
              // Send the notification using the device token
           await   SendNotification.sendNotification(
                  token: deviceToken,
                  title: "Order Placed",
                  body: "Your order has been placed successfully.💐",
                  data: null // Optional data
              );
           EasyLoading.dismiss();
            }
            else
            {
              print("Device token is empty or not found.");
              // Handle case where device token is empty
            }
          }
          else {
            print("Franchise document not found for the user.");
          }
          context.read<CartProvider>().clearCart();
        } else {
          _showErrorToast("User Profile Not Found", "Could not find user profile information.");
        }
      } catch (e) {
        _showErrorToast("Error", "Something went wrong: $e");
      }
    }
  }



  void _showSuccessToast(String title, String message) {
    Fluttertoast.showToast(
      msg: "$title: $message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    print("Success Toast: $title - $message");
  }

  void _showErrorToast(String title, String message) {
    Fluttertoast.showToast(
      msg: "$title: $message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    print("Error Toast: $title - $message");
  }
  @override
  Widget build(BuildContext context) {
    ColorsList colorsList = ColorsList();
    final cartProvider = Provider.of<CartProvider>(context);

    if (cartProvider.cartItems.isEmpty) {
      print("Cart is empty.");
      return Scaffold(
        backgroundColor:const Color(0xffEAE4DD),
        appBar: AppBar(
          title: const Text("Cart",style: TextStyle(color: Colors.white),),
          // backgroundColor: colorsList.backgroundColor,
          backgroundColor:const Color( 0xff304a62),
          elevation: 1.0,
          leading: IconButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const ShoppingCartScreen()));},icon:  const Icon(Icons.arrow_back,color: Colors.white,),),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/anilot.json',
                width: 400,
                height: 400,
                fit: BoxFit.fill,
              ),
              const Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:const Color(0xffEAE4DD),
    //  floatingActionButton: FloatingActionButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>AddPaymentMethod()));},child: Text("Payment"),),
      appBar: AppBar(
        title: const Text("Cart",style: TextStyle(color: Colors.white),),
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const ShoppingCartScreen()));
        },icon:const Icon(Icons.arrow_back,color: Colors.white,),),

        backgroundColor:const Color( 0xff304a62),
        elevation: 1.0,
        //   centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CartWidget(cartItems: cartProvider.cartItems),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlacingOrder(placeOrderCallback: _placeOrder),
                    ),
                  );


                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:const Color( 0xff304a62), // Background color
                  foregroundColor: Colors.white, // Text color
                  elevation: 5, // Shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Button border radius
                  ),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.8, // 80% of the screen width
                    MediaQuery.of(context).size.height * 0.07, // 7% of the screen height
                  ),
                  padding: EdgeInsets.zero, // Remove internal padding
                ),
                child:const Text(
                  "Proceed to next",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}