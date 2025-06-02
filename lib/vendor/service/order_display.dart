import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';

class ProductFetchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<OrderModel>> getUserProducts() {
    User? user = _auth.currentUser;
    if (user != null) {
      print('Fetching orders for user: ${user.uid}');

      return _db
          .collection('Franchise')
          .doc(user.uid)
          .collection('OrderCollections')
          .snapshots()
          .map((snapshot) {
        print('Snapshot received with ${snapshot.docs.length} documents');
        return snapshot.docs.map((doc) {
          print('Document data: ${doc.data()}');
          return OrderModel.fromFirestore(doc);
        }).toList();
      });
    } else {
      print('No user currently logged in.');
      return const Stream.empty();
    }
  }

  void showDeleteDialog(BuildContext context, String orderId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Order'),
          content: const Text('Are you sure you want to delete this order?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _deleteOrder(context, orderId); // Pass the orderId to the delete function
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Delete the specific order using the document ID
  Future<void> _deleteOrder(BuildContext context, String productId) async {
    User? user = _auth.currentUser;

    try {
      // Query Firestore to find the document where productId matches
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Franchise')
          .doc(user!.uid)
          .collection('OrderCollections')
          .where('productId', isEqualTo: productId) // Use the productId to query
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If documents exist, delete them
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete(); // Delete the document
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order(s) deleted successfully!')),
        );
      } else {
        // No documents found for the productId
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No matching order found!')),
        );
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete the order')),
      );
    }
  }

}

