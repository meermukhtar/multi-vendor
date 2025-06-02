import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final Timestamp createdAt;
  final String userId;
  final String imageProduct;
  final int quantity;
  final double price;
  final String productId;
  final String vendorId;
  final String productName;
  final double latitude;
  final double longitude;

  OrderModel({
    required this.productId,
    required this.vendorId,
    required this.createdAt,
    required this.userId,
    required this.imageProduct,
    required this.quantity,
    required this.price,
    required this.productName,
    required this.latitude,
    required this.longitude,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      createdAt: data['createdAt'] ?? Timestamp.now(),
      userId: data['userId'] ?? '',
      productId: data['productId'] ?? '',
      imageProduct: data['imageProduct'] ?? '',
      quantity: data['quantity'] ?? 0,
      price: (data['price'] is String ? double.tryParse(data['price']) ?? 0.0 : data['price'] as double),
      vendorId: data['vendorId'] ?? '',
      productName: data['productName'] ?? '',
      latitude: data['latitude']?.toDouble() ?? 0.0, // Fetch latitude
      longitude: data['longitude']?.toDouble() ?? 0.0, // Fetch longitude
    );
  }
}
