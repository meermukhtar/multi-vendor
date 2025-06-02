// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class AcceptedOrder extends StatefulWidget {
//   const AcceptedOrder({super.key});
//
//   @override
//   _AcceptedOrderState createState() => _AcceptedOrderState();
// }
//
// class _AcceptedOrderState extends State<AcceptedOrder> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   List<Map<String, dynamic>> acceptedOrders = []; // Store fetched orders
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch the accepted orders when the screen loads
//     fetchAcceptedOrders();
//   }
//
//   // Function to fetch accepted orders
//   Future<void> fetchAcceptedOrders() async {
//     User? user = _auth.currentUser;
//
//     if (user != null) {
//       try {
//         // Get the reference to the "Accepted" sub-collection of the user
//         QuerySnapshot ordersSnapshot = await _firestore
//             .collection("OrderList")
//             .doc(user.uid)
//             .collection("Accepted")
//             .get(); // Fetch all documents in the "Accepted" collection
//
//         // Clear the current list of accepted orders
//         acceptedOrders.clear();
//         if (ordersSnapshot.docs.isEmpty) {
//           print('No accepted orders found.');
//         }
//         // Iterate over the documents in the "Accepted" collection
//         for (var doc in ordersSnapshot.docs) {
//           Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;
//           acceptedOrders.add(orderData); // Add each order to the list
//         }
//
//         setState(() {}); // Update the UI with the new orders
//
//       } catch (e) {
//         print('Error fetching accepted orders: $e');
//       }
//     } else {
//       print('No user is currently logged in.');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffEAE4DD),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: SingleChildScrollView(  // To make the content scrollable
//           child: Column(
//             children: <Widget>[
//               // Check if orders are available and display them
//               if (acceptedOrders.isEmpty)
//                 const Center(child: CircularProgressIndicator()) // Show a loader if data is empty
//               else
//               // Loop through the fetched orders and display each in its own Card
//                 for (var orderData in acceptedOrders)
//                   Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0), // Space between cards
//                     elevation: 4.0,  // Card shadow for better visibility
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Row(
//                         children: <Widget>[
//                           // Product Image
//                           Container(
//                             width: 100,
//                             height: 100,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8), // Rounded corners
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.grey,
//                                 ),
//                               ],
//                             ),
//                             child: Image.network(
//                               '${orderData['productImage']}', // Product Image URL from Firestore
//                               width: 100,
//                               height: 100,
//                               fit: BoxFit.cover, // Ensures the image fills the container
//                             ),
//                           ),
//                           const SizedBox(width: 10.0),
//                           // Product Details
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Product: ${orderData['productName']}', // Dynamically use fetched data
//                                       style: const TextStyle(
//                                         fontSize: 16.0,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Container(
//                                       width: 10.0,
//                                       height: 10.0,
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.green, // Assuming green status for accepted orders
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5.0),
//                                 Text('Order Date: ${orderData['orderDate']}'), // Dynamically use fetched date
//                                 const SizedBox(height: 5.0),
//                                 Text('Quantity: ${orderData['quantity']}'), // Dynamically use quantity
//                                 const SizedBox(height: 5.0),
//                                 Text('Price: ${orderData['price']} rs'), // Dynamically use price
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

class AcceptedOrder extends StatefulWidget {
  const AcceptedOrder({super.key});

  @override
  _AcceptedOrderState createState() => _AcceptedOrderState();
}

class _AcceptedOrderState extends State<AcceptedOrder> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> acceptedOrders = []; // Store fetched orders

  @override
  void initState() {
    super.initState();
    // Fetch the accepted orders when the screen loads
    fetchAcceptedOrders();
  }

  // Function to fetch accepted orders
  Future<void> fetchAcceptedOrders() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Get the reference to the "Accepted" sub-collection of the user
        QuerySnapshot ordersSnapshot = await _firestore
            .collection("OrderList")
            .doc(user.uid)
            .collection("Accepted")
            .get(); // Fetch all documents in the "Accepted" collection

        // Clear the current list of accepted orders
        acceptedOrders.clear();
        if (ordersSnapshot.docs.isEmpty) {
          print('No accepted orders found.');
        }
        // Iterate over the documents in the "Accepted" collection
        for (var doc in ordersSnapshot.docs) {
          Map<String, dynamic> orderData = doc.data() as Map<String, dynamic>;
          acceptedOrders.add(orderData); // Add each order to the list
        }

        setState(() {}); // Update the UI with the new orders

      } catch (e) {
        print('Error fetching accepted orders: $e');
      }
    } else {
      print('No user is currently logged in.');
    }
  }

  // Function to format the timestamp to a readable date format
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate(); // Convert Firestore Timestamp to DateTime
    DateFormat dateFormat = DateFormat('dd MMM yyyy,'); // Customize your date format here
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAE4DD),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(  // To make the content scrollable
          child: Column(
            children: <Widget>[
              // Check if orders are available and display them
              if (acceptedOrders.isEmpty)
                const Center(child: CircularProgressIndicator()) // Show a loader if data is empty
              else
              // Loop through the fetched orders and display each in its own Card
                for (var orderData in acceptedOrders)
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0), // Space between cards
                    elevation: 4.0,  // Card shadow for better visibility
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: <Widget>[
                          // Product Image
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            child: Image.network(
                              '${orderData['productImage']}', // Product Image URL from Firestore
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover, // Ensures the image fills the container
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text(
                                      'Product: ${orderData['productName']}', // Dynamically use fetched data
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green, // Assuming green status for accepted orders
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
                                // Format and display the order date
                                Text('Order Date: ${formatTimestamp(orderData['orderDate'])}'), // Display formatted date
                                const SizedBox(height: 5.0),
                                Text('Quantity: ${orderData['quantity']}'), // Dynamically use quantity
                                const SizedBox(height: 5.0),
                                Text('Price: ${orderData['price']} rs'), // Dynamically use price
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
