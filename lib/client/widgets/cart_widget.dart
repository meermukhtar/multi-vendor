import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/cart_provider.dart';
import '../model/product_model.dart';


class CartWidget extends StatefulWidget {
  final List<ClientProduct> cartItems;

  const CartWidget({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var product in widget.cartItems)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(product.imageProduct, fit: BoxFit.cover),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rs ${(double.parse(product.price) * product.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (product.quantity > 1) {
                                  product.quantity--;
                                  cartProvider.updateCartTotal();
                                }
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${product.quantity}'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                product.quantity++;
                                cartProvider.updateCartTotal();
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cartProvider.removeFromCart(product);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
