import 'package:cloud_firestore/cloud_firestore.dart';
class ClientProduct {
  final String productName;
  final String  price;
  final String imageProduct;
  final String vendorId;
  final String productId;
  int quantity;
  bool isAdded;

  ClientProduct({
    required this.productName,
    required this.price,
    required this.imageProduct,
    required this.vendorId,
    required this.productId,
    this.quantity = 1,
    this.isAdded = false,
  }) {
    print("Product created:");
    print("Product name: $productName");
    print("Vendor ID: $vendorId");
    print("Product ID: $productId");
  }

  factory ClientProduct.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ClientProduct(
      productName: data['productName'],
      price: data['price'],
      imageProduct: data['imageProduct'],
      vendorId: doc.reference.parent.parent!.id,
      productId: doc.id,
      quantity: 1,
      isAdded: false,
    );
  }
}
