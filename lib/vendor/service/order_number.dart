import 'dart:math';

class OrderNumberGenerator {
  String generateProductId() {
    String chars = "1234567890";
    final random = Random();
    var length = 8;
    String id = '';
    for (var i = 0; i < length; i++) {
      id += chars[random.nextInt(chars.length)];
    }
    return id;
  }
}
