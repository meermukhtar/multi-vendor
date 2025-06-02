
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'order_item.dart';
import '../model/product_model.dart';

class CartProvider with ChangeNotifier {
  List<ClientProduct> _cartItems = [];
  double _total = 0.0;
     // Define a fixed platform fee amount

  List<ClientProduct> get cartItems => _cartItems;
  double get total => _total;

  void addToCart(ClientProduct product) {
    final existingProductIndex = _cartItems
        .indexWhere((item) => item.productName == product.productName);
    if (existingProductIndex != -1) {
      _cartItems[existingProductIndex].quantity++;
    } else {
      _cartItems.add(product);
    }
    calculateTotal();
    notifyListeners();
  }

  void removeFromCart(ClientProduct product) {
    final existingProductIndex = _cartItems
        .indexWhere((item) => item.productName == product.productName);
    if (existingProductIndex != -1) {
      _cartItems.removeAt(existingProductIndex);
      calculateTotal();
      notifyListeners();
    }
  }

  void decreaseQuantity(ClientProduct product) {
    final existingProductIndex = _cartItems
        .indexWhere((item) => item.productName == product.productName);
    if (existingProductIndex != -1) {
      if (_cartItems[existingProductIndex].quantity > 1) {
        _cartItems[existingProductIndex].quantity--;
        calculateTotal();
        notifyListeners();
      }
    }
  }

  void increaseQuantity(ClientProduct product) {
    final existingProductIndex = _cartItems
        .indexWhere((item) => item.productName == product.productName);
    if (existingProductIndex != -1) {
      _cartItems[existingProductIndex].quantity++;
      calculateTotal();
      notifyListeners();
    }
  }

  void calculateTotal() {
    _total = 0.0;
    for (var product in _cartItems) {
      double productPrice = double.parse(product.price as String);
      _total += (productPrice * product.quantity);
    }
    notifyListeners();
  }

  //Update the total There we can also use the updated total
  void updateCartTotal() {
    _total = _cartItems.fold(
        0.0,
            (total, product) =>
        total + (double.parse(product.price) * product.quantity));
    print("This is the updated quantity of total price:${_total}");
    notifyListeners();
  }

//First, update the CartProvider class to include the vendorId and productId when adding products to the cart:
  bool isProductInCart({required String productId, required String vendorId}) {
    return _cartItems.any(
            (item) => item.productId == productId && item.vendorId == vendorId);
  }
  Future<void> placeOrder() async {
    List<OrderItem> orderItems = [];
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore _db = FirebaseFirestore.instance;
    if (user != null) {
      QuerySnapshot productSnapshot = await _db
          .collection('Franchise')
          .doc(user.uid)
          .collection('ProductCollection')
          .get();

      for (DocumentSnapshot productDoc in productSnapshot.docs) {
        Map<String, dynamic> productData =
        productDoc.data() as Map<String, dynamic>;
        String productId = productData['productId'];
        String vendorId = user.uid;
        int quantity =
            _cartItems.firstWhere((p) => p.productId == productId).quantity;
        double totalPrice = quantity * double.parse(productData['price']);

        orderItems.add(
          OrderItem(
            vendorId: vendorId,
            productId: productId,
            quantity: quantity,
            totalPrice: totalPrice,
          ),
        );
      }

      // Send the order items to the server
      for (final orderItem in orderItems) {
        print("<------------------------------------------------------------------------->");
        print(
            "Sending order item to server: ${orderItem.productId}, ${orderItem.quantity}, ${orderItem.totalPrice}");
        print("Sending order item to vendor: ${orderItem.vendorId}");
        await FirebaseFirestore.instance
            .collection('Franchise')
            .doc(orderItem.vendorId)
            .collection('OrderCollection')
            .add({
          'productId': orderItem.productId,
          'quantity': orderItem.quantity,
          'totalPrice': orderItem.totalPrice,
        }).catchError((error) {
          print("Error saving order item: $error");
        });
      }

      // Clear the cart after successful order placement
      _cartItems.clear();
      _total = 0.0;
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _total = 0.0;
    notifyListeners();
  }


}
