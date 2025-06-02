//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import '../../../client/utils/constant.dart';
//
// class MyCharts extends StatefulWidget {
//   const MyCharts({super.key});
//
//   @override
//   State<MyCharts> createState() => _MyChartsState();
// }
//
// class _MyChartsState extends State<MyCharts> {
//   int acceptedCount = 0;
//   int rejectedCount = 0;
//   int totalCount = 0;
//
//   // Function to fetch the count of accepted orders
//   Future<void> fetchAcceptedOrders() async {
//     try {
//       QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
//           .collection("OrderStatus")
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection("Accepted")
//           .get();  // Fetch all documents in the "Accepted" collection
//
//       setState(() {
//         acceptedCount = ordersSnapshot.size;  // Set the accepted orders count
//         calculateTotalOrders();  // Recalculate total orders after fetching accepted
//       });
//     } catch (e) {
//       print('Error fetching accepted orders: $e');
//     }
//   }
//
//   // Function to fetch the count of rejected orders
//   Future<void> fetchRejectedOrders() async {
//     try {
//       QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
//           .collection("OrderStatus")
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .collection("Rejected")
//           .get();  // Fetch all documents in the "Rejected" collection
//
//       setState(() {
//         rejectedCount = ordersSnapshot.size;  // Set the rejected orders count
//         calculateTotalOrders();  // Recalculate total orders after fetching rejected
//       });
//     } catch (e) {
//       print('Error fetching rejected orders: $e');
//     }
//   }
//   double totalWorth = 0; // This will hold the total worth of the products
//   String formattedTotalWorth = "0"; // This will hold the formatted total worth
//   double rejectedPercentage = 0.3; // Example percentage, this would depend on your actual logic
//   int rejectedCounts = 5; // Example rejected count, this would depend on your actual logic
//
//   // Calculate total orders
//   void calculateTotalOrders() {
//     totalCount = acceptedCount + rejectedCount;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAcceptedOrders();
//     fetchRejectedOrders();
//     _calculateTotalWorth();
//   }
//   // Function to fetch data from Firestore and calculate total worth
//   Future<void> _calculateTotalWorth() async {
//     final FirebaseFirestore _db = FirebaseFirestore.instance;
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//
//     try {
//       // Get the current user's UID
//       String currentUserId = _auth.currentUser!.uid;
//
//       // Get the accepted orders for the current user from the OrderStatus collection
//       QuerySnapshot snapshot = await _db
//           .collection('OrderStatus') // Your collection name
//           .doc(currentUserId) // Access the document of the current user using their UID
//           .collection('Accepted') // Assuming 'Accepted' is a subcollection
//           .get();
//
//       double total = 0;
//
//       // Loop through each document in the snapshot
//       for (var doc in snapshot.docs) {
//         // Assuming each document has a list of products with 'quantity' and 'price' fields
//         var products = doc['products'] as List<dynamic>; // Adjust based on your structure
//
//         // Loop through each product in the 'products' list
//         for (var product in products) {
//           double quantity = product['quantity'] ?? 0;
//           double price = product['price'] ?? 0;
//
//           // Multiply quantity and price, and add to total
//           total += quantity * price;
//         }
//       }
//
//       // Set the total worth and format it
//       setState(() {
//         totalWorth = total;
//         formattedTotalWorth = _formatNumber(total);
//       });
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }
//
//   // Function to format numbers to 'k', 'M', etc.
//   String _formatNumber(double value) {
//     if (value >= 1000000) {
//       return "${(value / 1000000).toStringAsFixed(1)}M"; // For millions
//     } else if (value >= 1000) {
//       return "${(value / 1000).toStringAsFixed(1)}k"; // For thousands
//     } else {
//       return value.toStringAsFixed(0); // For values less than 1000
//     }
//   }
//
//   TextStyling textStyling=TextStyling();
//   @override
//   Widget build(BuildContext context) {
//     // Calculate the percentages
//     double acceptedPercentage = totalCount == 0 ? 0 : (acceptedCount / totalCount);
//     double rejectedPercentage = totalCount == 0 ? 0 : (rejectedCount / totalCount);
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [BoxShadow(color: Colors.white10)],
//       ),
//       padding: const EdgeInsets.only(top: 10, bottom: 10),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               Column(
//                 children: [
//                   // CircularPercentIndicator(
//                   //   radius: 45.0,
//                   //   lineWidth: 8.0,
//                   //   percent: rejectedPercentage, // Show the rejected percentage
//                   //   center: Text("$rejectedCount", style: textStyling.headingTextStyle),
//                   //   progressColor: Colors.indigo,
//                   // ),
//                   CircularPercentIndicator(
//                     radius: 45.0,
//                     lineWidth: 8.0,
//                     percent: rejectedPercentage, // Display rejected percentage
//                     center: Text(
//                       formattedTotalWorth, // Display formatted total worth here
//                       style: TextStyle(
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.indigo,
//                       ),
//                     ),
//                     progressColor: Colors.indigo,
//                   ),
//                   const SizedBox(height: 5),
//                   Text("Total Worth", style: textStyling.textStyle),
//                 ],
//               ),
//               Column(
//                 children: [
//                   CircularPercentIndicator(
//                     radius: 45.0,
//                     lineWidth: 8.0,
//                     percent: acceptedPercentage, // Show the accepted percentage
//                     center: Text("${acceptedCount+rejectedCount}", style: textStyling.headingTextStyle),
//                     progressColor: Colors.yellowAccent,
//                   ),
//                   const SizedBox(height: 5),
//                   Text("Total Orders", style: textStyling.textStyle),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Column(
//                 children: [
//                   CircularPercentIndicator(
//                     radius: 45.0,
//                     lineWidth: 8.0,
//                     percent: acceptedPercentage, // Percentage of accepted orders
//                     center: Text("$acceptedCount", style: textStyling.headingTextStyle),
//                     progressColor: Colors.green,
//                   ),
//                   const SizedBox(height: 5),
//                   Text("Accepted Orders", style: textStyling.textStyle),
//                 ],
//               ),
//               Column(
//                 children: [
//                   CircularPercentIndicator(
//                     radius: 45.0,
//                     lineWidth: 8.0,
//                     percent: rejectedPercentage, // Percentage of rejected orders
//                     center: Text("$rejectedCount", style: textStyling.headingTextStyle),
//                     progressColor: Colors.red,
//                   ),
//                   const SizedBox(height: 5),
//                   Text("Rejected Orders", style: textStyling.textStyle),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../client/utils/constant.dart';

class MyCharts extends StatefulWidget {
  const MyCharts({super.key});

  @override
  State<MyCharts> createState() => _MyChartsState();
}

class _MyChartsState extends State<MyCharts> {
  int acceptedCount = 0;
  int rejectedCount = 0;
  int totalCount = 0;
  double totalWorth = 0; // This will hold the total worth of the products
  String formattedTotalWorth = "0"; // This will hold the formatted total worth

  // Function to fetch the count of accepted orders
  Future<void> fetchAcceptedOrders() async {
    try {
      QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection("Franchise")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Accepted")
          .get();  // Fetch all documents in the "Accepted" collection

      setState(() {
        acceptedCount = ordersSnapshot.size;  // Set the accepted orders count
        calculateTotalOrders();  // Recalculate total orders after fetching accepted
      });
    } catch (e) {
      print('Error fetching accepted orders: $e');
    }
  }

  // Function to fetch the count of rejected orders
  Future<void> fetchRejectedOrders() async {
    try {
      QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection("OrderList")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Rejected")
          .get();  // Fetch all documents in the "Rejected" collection

      setState(() {
        rejectedCount = ordersSnapshot.size;  // Set the rejected orders count
        calculateTotalOrders();  // Recalculate total orders after fetching rejected
      });
    } catch (e) {
      print('Error fetching rejected orders: $e');
    }
  }

  // Calculate total orders
  void calculateTotalOrders() {
    totalCount = acceptedCount + rejectedCount;
  }

  @override
  void initState() {
    super.initState();
    fetchAcceptedOrders();
    fetchRejectedOrders();
    _calculateTotalWorth();
  }

  // Function to fetch data from Firestore and calculate total worth
  Future<void> _calculateTotalWorth() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      String currentUserId = _auth.currentUser!.uid;

      // Fetch the accepted orders for the current user
      QuerySnapshot snapshot = await _db
          .collection('OrderList')
          .doc(currentUserId)
          .collection('Accepted')
          .get();

      if (snapshot.docs.isEmpty) {
        print('No accepted orders found for user: $currentUserId');
      }

      double total = 0;

      for (var doc in snapshot.docs) {
        // Debug: Check the doc data
        print('Document data: ${doc.data()}');

        // Assuming each document has 'price' and 'quantity'
        double price = (doc['price'] ?? 0).toDouble();
        double quantity = (doc['quantity'] ?? 0).toDouble();

        // Debug: print the product price and quantity
        print('Product price: $price, quantity: $quantity');

        total += quantity * price;
      }

      // Set the total worth and format it
      setState(() {
        totalWorth = total;
        formattedTotalWorth = _formatNumber(total);
      });

      print('Total worth calculated: $totalWorth');
    } catch (e) {
      print('Error fetching data: $e');
    }
  }





  // Function to format numbers to 'k', 'M', etc.
  String _formatNumber(double value) {
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M"; // For millions
    } else if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}k"; // For thousands
    } else {
      return value.toStringAsFixed(0); // For values less than 1000
    }
  }

  TextStyling textStyling = TextStyling();

  @override
  Widget build(BuildContext context) {
    // Calculate the percentages
    double acceptedPercentage = totalCount == 0 ? 0 : (acceptedCount / totalCount);
    double rejectedPercentage = totalCount == 0 ? 0 : (rejectedCount / totalCount);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.white10)],
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 8.0,
                    percent: rejectedPercentage, // Display rejected percentage
                    center: Text(
                      formattedTotalWorth, // Display formatted total worth here
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    progressColor: Colors.indigo,
                  ),

    // CircularPercentIndicator(
                  //   radius: 45.0,
                  //   lineWidth: 8.0,
                  //   percent: rejectedPercentage, // Display rejected percentage
                  //   center: Text(
                  //     formattedTotalWorth, // Display formatted total worth here
                  //     style: TextStyle(
                  //       fontSize: 20.0,
                  //       fontWeight: FontWeight.bold,
                  //       color: Colors.indigo,
                  //     ),
                  //   ),
                  //   progressColor: Colors.indigo,
                  // ),
                  const SizedBox(height: 5),
                  Text("Total Worth", style: textStyling.textStyle),
                ],
              ),
              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 8.0,
                    percent: acceptedPercentage, // Show the accepted percentage
                    center: Text("${acceptedCount + rejectedCount}", style: textStyling.headingTextStyle),
                    progressColor: Colors.yellowAccent,
                  ),
                  const SizedBox(height: 5),
                  Text("Total Orders", style: textStyling.textStyle),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 8.0,
                    percent: acceptedPercentage, // Percentage of accepted orders
                    center: Text("$acceptedCount", style: textStyling.headingTextStyle),
                    progressColor: Colors.green,
                  ),
                  const SizedBox(height: 5),
                  Text("Accepted Orders", style: textStyling.textStyle),
                ],
              ),
              Column(
                children: [
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 8.0,
                    percent: rejectedPercentage, // Percentage of rejected orders
                    center: Text("$rejectedCount", style: textStyling.headingTextStyle),
                    progressColor: Colors.red,
                  ),
                  const SizedBox(height: 5),
                  Text("Rejected Orders", style: textStyling.textStyle),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
