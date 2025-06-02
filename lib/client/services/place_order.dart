import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:multivendor/client/pages/shopping_screen.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

import '../model/cart_provider.dart';
import '../pages/home_page.dart';

class PlacingOrder extends StatefulWidget {
  final VoidCallback placeOrderCallback;

  const PlacingOrder({super.key, required this.placeOrderCallback});

  @override
  State<PlacingOrder> createState() => _PlacingOrderState();
}
double platformFee = 5.0;
class _PlacingOrderState extends State<PlacingOrder> {
  bool _isPlacingOrder = false;
  void _showConfirmationDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm Order'),
          content: const Text('Are you sure you want to place this order?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _isPlacingOrder = true;
                });
                await _placeOrderAndAnimate();
              },
              child: const Text('Confirm',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _placeOrderAndAnimate() async {
    widget.placeOrderCallback();

    // Show the animation for 4 seconds
    await Future.delayed(const Duration(seconds: 30));

    // Navigate back to the ShoppingCartScreen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>const ShoppingCartScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffEAE4DD),
      appBar: AppBar(
        title: const Text(
          "Place Order",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color( 0xff304a62),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const ShoppingCartScreen()));
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: _isPlacingOrder
          ? Center(
        child: Lottie.asset(
          'assets/animations/congrats.json',
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
          repeat: false,
        ),
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('NetBill:'),
                    Text('Total: Rs ${cartProvider.total.toStringAsFixed(2)}'),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Platform Charges'),
                    Text('5.0'),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Charges'),
                    Text('0.0'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total: '),
                    Text('Rs ${(cartProvider.total+platformFee).toStringAsFixed(2)}'),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color( 0xff304a62), // Background color
                    foregroundColor: Colors.white, // Text color
                    elevation: 5, // Shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Button border radius
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.8, // 80% of the screen width
                      MediaQuery.of(context).size.height * 0.07, // 7% of the screen height
                    ),
                  ),
                  child: const Text("Place Order"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
