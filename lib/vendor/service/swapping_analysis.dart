/*
This code is for least product count having the with quantity
 */
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class SwappingAnalysis {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // Method to fetch the total count of orders and analyze productId occurrences
//   Future<void> getTotalOrder() async {
//     try {
//       // Get the current user
//       User? user = _auth.currentUser;
//       if (user != null) {
//         // Reference to the OrderCollections sub-collection
//         var ordersCollectionRef = _db.collection('Franchise').doc(user.uid).collection("OrderCollections");
//
//         // Fetch the documents
//         var snapshot = await ordersCollectionRef.get();
//
//         // Initialize the map to track productId occurrences and product quantities
//         Map<String, int> productCountMap = {};
//         Map<String, int> productQuantityMap = {}; // To track the total quantity for each productId
//         Map<String, String> productNameMap = {};  // To store productName for each productId
//
//         // Check if documents are present
//         if (snapshot.docs.isNotEmpty) {
//           // Loop through each document to analyze productId, productName, and quantity
//           for (var doc in snapshot.docs) {
//             var data = doc.data();
//             String productId = data['productId'] ?? ''; // Assuming 'productId' exists in the document
//             String productName = data['productName'] ?? ''; // Assuming 'productName' exists in the document
//             int quantity = data['quantity'] ?? 1; // Assuming 'quantity' exists in the document
//
//             // Count the occurrences of productId
//             if (productCountMap.containsKey(productId)) {
//               productCountMap[productId] = productCountMap[productId]! + 1;
//               productQuantityMap[productId] = productQuantityMap[productId]! + quantity; // Update quantity
//             } else {
//               productCountMap[productId] = 1;
//               productQuantityMap[productId] = quantity; // Initialize quantity
//               productNameMap[productId] = productName; // Store productName for productId
//             }
//           }
//
//           // Now calculate the most and least repeated productId considering quantity
//           String mostRepeatedProductId = '';
//           String leastRepeatedProductId = '';
//           int maxCount = 0;
//           int maxQuantity = 0; // To track max quantity for products with same occurrence count
//           int minCount = 999999; // Start with a large number for minCount
//           int minQuantity = 999999; // Start with a large number for minQuantity
//
//           productCountMap.forEach((productId, count) {
//             int currentQuantity = productQuantityMap[productId] ?? 0;
//
//             // Track the most repeated productId
//             if (count > maxCount || (count == maxCount && currentQuantity > maxQuantity)) {
//               maxCount = count;
//               maxQuantity = currentQuantity;
//               mostRepeatedProductId = productId;
//             }
//
//             // Track the least repeated productId
//             if (count < minCount || (count == minCount && currentQuantity < minQuantity)) {
//               minCount = count;
//               minQuantity = currentQuantity;
//               leastRepeatedProductId = productId;
//             }
//           });
//
//           // Fetch productName for the most and least repeated productId from the map
//           String mostRepeatedProductName = productNameMap[mostRepeatedProductId] ?? 'Unknown';
//           String leastRepeatedProductName = productNameMap[leastRepeatedProductId] ?? 'Unknown';
//
//           // Print out the results for most and least repeated productId
//           print('<==============================>Total Orders in this user: ${snapshot.docs.length}');
//           print('Most repeated productId: $mostRepeatedProductId with $maxCount occurrences and total quantity: $maxQuantity, Name: $mostRepeatedProductName');
//           print('Least repeated productId: $leastRepeatedProductId with $minCount occurrences and total quantity: $minQuantity, Name: $leastRepeatedProductName');
//
//           // Now update the ProductAnalysis collection with the most and least repeated products
//           var productAnalysisRef = _db.collection('ProductAnalysis').doc(user.uid);
//
//           await productAnalysisRef.set({
//             'highDemanding': mostRepeatedProductName,
//             'lowDemanding': leastRepeatedProductName,
//           }, SetOptions(merge: true)); // Using merge to update without overwriting other fields
//         } else {
//           print('No orders found in the collection.');
//         }
//       } else {
//         print('User not logged in.');
//       }
//     } catch (e) {
//       // Handle any errors that occur during the fetch
//       print('Error fetching orders: $e');
//     }
//   }
//
//   // Real-time listener for OrderCollections to update ProductAnalysis in real-time
//   void listenToOrderChanges() {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       var ordersCollectionRef = _db.collection('Franchise').doc(user.uid).collection("OrderCollections");
//
//       // Set up the real-time listener
//       ordersCollectionRef.snapshots().listen((snapshot) {
//         // Trigger product analysis update on every change
//         getTotalOrder(); // Re-run the analysis whenever there is a change
//       });
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SwappingAnalysis {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to fetch the total count of orders and analyze productId occurrences
  Future<void> getTotalOrder() async {
    try {
      // Get the current user
      User? user = _auth.currentUser;
      if (user != null) {
        // Reference to the OrderCollections sub-collection
        var ordersCollectionRef = _db.collection('Franchise').doc(user.uid).collection("OrderCollections");

        // Fetch the documents
        var snapshot = await ordersCollectionRef.get();

        // Initialize the map to track productId occurrences and product quantities
        Map<String, int> productCountMap = {};
        Map<String, int> productQuantityMap = {}; // To track the total quantity for each productId
        Map<String, String> productNameMap = {};  // To store productName for each productId

        // Check if documents are present
        if (snapshot.docs.isNotEmpty) {
          // Loop through each document to analyze productId, productName, and quantity
          for (var doc in snapshot.docs) {
            var data = doc.data();
            String productId = data['productId'] ?? ''; // Assuming 'productId' exists in the document
            String productName = data['productName'] ?? ''; // Assuming 'productName' exists in the document
            int quantity = data['quantity'] ?? 1; // Assuming 'quantity' exists in the document

            // Count the occurrences of productId
            if (productCountMap.containsKey(productId)) {
              productCountMap[productId] = productCountMap[productId]! + 1;
              productQuantityMap[productId] = productQuantityMap[productId]! + quantity; // Update quantity
            } else {
              productCountMap[productId] = 1;
              productQuantityMap[productId] = quantity; // Initialize quantity
              productNameMap[productId] = productName; // Store productName for productId
            }
          }

          // Now calculate the most and least repeated productId considering quantity
          String mostRepeatedProductId = '';
          String leastRepeatedProductId = '';
          int maxCount = 0;
          int maxQuantity = 0; // To track max quantity for products with same occurrence count
          int minCount = 999999; // Start with a large number for minCount
          int minQuantity = 999999; // Start with a large number for minQuantity

          productCountMap.forEach((productId, count) {
            int currentQuantity = productQuantityMap[productId] ?? 0;

            // Track the most repeated productId
            if (count > maxCount || (count == maxCount && currentQuantity > maxQuantity)) {
              maxCount = count;
              maxQuantity = currentQuantity;
              mostRepeatedProductId = productId;
            }

            // Track the least repeated productId
            if (count < minCount || (count == minCount && currentQuantity < minQuantity)) {
              minCount = count;
              minQuantity = currentQuantity;
              leastRepeatedProductId = productId;
            }
          });

          // Fetch productName for the most and least repeated productId from the map
          String mostRepeatedProductName = productNameMap[mostRepeatedProductId] ?? 'Unknown';
          String leastRepeatedProductName = productNameMap[leastRepeatedProductId] ?? 'Unknown';

          // Print out the results for most and least repeated productId
          print('<==============================>Total Orders in this user: ${snapshot.docs.length}');
          print('Most repeated productId: $mostRepeatedProductId with $maxCount occurrences and total quantity: $maxQuantity, Name: $mostRepeatedProductName');
          print('Least repeated productId: $leastRepeatedProductId with $minCount occurrences and total quantity: $minQuantity, Name: $leastRepeatedProductName');

          // Now update the ProductAnalysis collection with the most and least repeated products
          var productAnalysisRef = _db.collection('ProductAnalysis').doc(user.uid);

          await productAnalysisRef.set({
            'highDemanding': mostRepeatedProductName,
            'lowDemanding': leastRepeatedProductName,
            'lowDemandingQuantity': minQuantity,  // Add quantity for least repeated product
          }, SetOptions(merge: true)); // Using merge to update without overwriting other fields
        } else {
          print('No orders found in the collection.');
        }
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      print('Error fetching orders: $e');
    }
  }

  // Real-time listener for OrderCollections to update ProductAnalysis in real-time
  void listenToOrderChanges() {
    User? user = _auth.currentUser;
    if (user != null) {
      var ordersCollectionRef = _db.collection('Franchise').doc(user.uid).collection("OrderCollections");
      // Set up the real-time listener
      ordersCollectionRef.snapshots().listen((snapshot) {
        // Trigger product analysis update on every change
        getTotalOrder(); // Re-run the analysis whenever there is a change
      });
    }
  }
}
