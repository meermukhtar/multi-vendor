class OrderItem {
  final String vendorId;
  final String productId;
  final int quantity;
  final double totalPrice;

  OrderItem({
    required this.vendorId,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
  });
}