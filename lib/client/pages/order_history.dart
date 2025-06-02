// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:multivendor/client/pages/shopping_screen.dart';
//
// import 'home_page.dart';
//
// // Ensure Product and Order models are defined
// class Product {
//   final String name;
//   final int quantity;
//   final double price;
//
//   Product({required this.name, required this.quantity, required this.price});
// }
//
// class Order {
//   final String id;
//   final String dateTime;
//   final double total;
//   final List<String> vendorIds;
//   final List<Product> products;
//
//   Order({
//     required this.id,
//     required this.dateTime,
//     required this.total,
//     required this.vendorIds,
//     required this.products,
//   });
// }
// class OrderHistory extends StatefulWidget {
//   @override
//   _OrderHistoryState createState() => _OrderHistoryState();
// }
//
// class _OrderHistoryState extends State<OrderHistory> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   List<Order> _orders = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchOrderHistory();
//   }
//
//   Future<void> _fetchOrderHistory() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         QuerySnapshot querySnapshot = await _firestore
//             .collection('orderHistory')
//             .doc(user.uid)
//             .collection('orders')
//             .get();
//
//         if (querySnapshot.docs.isNotEmpty) {
//           List<Order> orders = [];
//
//           for (var doc in querySnapshot.docs) {
//             Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//             Timestamp createdAt = data['createdAt'] as Timestamp;
//             List<dynamic> orderDetails = data['orderDetails'] ?? [];
//
//             double totalPrice = 0.0;
//             List<String> vendorIds = [];
//             List<Product> products = [];
//
//             // Parse the orderDetails array
//             for (var detail in orderDetails) {
//               Map<String, dynamic> orderDetail = detail as Map<String, dynamic>;
//
//               double price = (orderDetail['price'] as num).toDouble();
//               int quantity = (orderDetail['quantity'] as num).toInt();
//               totalPrice += price * quantity;
//
//               if (!vendorIds.contains(orderDetail['vendorId'])) {
//                 vendorIds.add(orderDetail['vendorId']);
//               }
//
//               products.add(Product(
//                 name: orderDetail['productName'] ?? '',
//                 quantity: quantity,
//                 price: price,
//               ));
//             }
//
//             orders.add(Order(
//               id: doc.id, // Use document ID as order ID
//               dateTime: createdAt.toDate().toString(),
//               total: totalPrice,
//               vendorIds: vendorIds,
//               products: products,
//             ));
//           }
//
//           setState(() {
//             _orders = orders;
//           });
//         } else {
//           print("No orders found.");
//         }
//       }
//     } catch (e) {
//       print("Error fetching order history: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffEAE4DD),
//       appBar: AppBar(
//         backgroundColor: const Color(0xff304a62),
//         title:const Text('Order History',style: TextStyle(color: Colors.white),),
//         leading: IconButton(onPressed: (){
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const ShoppingCartScreen()));
//         },icon:const Icon(Icons.arrow_back,color: Colors.white,),),
//       ),
//       body: ListView.builder(
//         itemCount: _orders.length,
//         itemBuilder: (context, index) {
//           final order = _orders[index];
//           return OrderCard(order: order);
//         },
//       ),
//     );
//   }
// }
// class OrderCard extends StatefulWidget {
//   final Order order;
//
//   OrderCard({required this.order});
//
//   @override
//   _OrderCardState createState() => _OrderCardState();
// }
//
// class _OrderCardState extends State<OrderCard> {
//   bool _expanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin:const EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//           //  title: Text('Order ID: ${widget.order.id}', style:const TextStyle(fontWeight: FontWeight.bold)),
//             title:const Text("Check order..",style:const TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text('Placed on: ${widget.order.dateTime}'),
//             trailing: Text('${widget.order.total} Rs', style:const TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 15)),
//           ),
//
//           if (_expanded) ...[
//             Padding(
//               padding:const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: _buildProductList(widget.order.products),
//               ),
//             ),
//           ],
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _expanded = !_expanded;
//               });
//             },
//             child: Text(_expanded ? 'View Less' : 'View More',style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildProductList(List<Product> products) {
//     return products.map((product) {
//       return Padding(
//         padding: const EdgeInsets.all(10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start, // Align to the start
//                 children: [
//                   const    Text("Product Name", style:  TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:15)),
//                   Text(product.name,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,)),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 20), // Add some space between the columns
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start, // Align to the start
//                 children: [
//                   const    Text('Total Amount', style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:15)),
//                   Text('${product.quantity} x ${product.price}',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }).toList();
//   }
//
// }
// class VendorBadge extends StatelessWidget {
//   final String id;
//
//   VendorBadge({required this.id});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin:const EdgeInsets.only(right: 8.0),
//       padding:const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: Text(id, style:const TextStyle(color: Colors.white)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multivendor/client/pages/shopping_screen.dart';

class Product {
  final String name;
  final int quantity;
  final double price;

  Product({required this.name, required this.quantity, required this.price});
}

class Order {
  final String id;
  final String dateTime;
  final double total;
  final List<String> vendorIds;
  final List<Product> products;

  Order({
    required this.id,
    required this.dateTime,
    required this.total,
    required this.vendorIds,
    required this.products,
  });
}

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrderHistory();
  }

  Future<void> _fetchOrderHistory() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('orderHistory')
            .doc(user.uid)
            .collection('orders')
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          List<Order> orders = [];

          for (var doc in querySnapshot.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            Timestamp createdAt = data['createdAt'] as Timestamp;
            List<dynamic> orderDetails = data['orderDetails'] ?? [];

            double totalPrice = 0.0;
            List<String> vendorIds = [];
            List<Product> products = [];

            for (var detail in orderDetails) {
              Map<String, dynamic> orderDetail = detail as Map<String, dynamic>;

              double price = (orderDetail['price'] as num).toDouble();
              int quantity = (orderDetail['quantity'] as num).toInt();
              totalPrice += price * quantity;

              if (!vendorIds.contains(orderDetail['vendorId'])) {
                vendorIds.add(orderDetail['vendorId']);
              }

              products.add(Product(
                name: orderDetail['productName'] ?? '',
                quantity: quantity,
                price: price,
              ));
            }

            orders.add(Order(
              id: doc.id,
              dateTime: createdAt.toDate().toString(),
              total: totalPrice,
              vendorIds: vendorIds,
              products: products,
            ));
          }

          setState(() {
            _orders = orders;
          });
        } else {
          print("No orders found.");
        }
      }
    } catch (e) {
      print("Error fetching order history: $e");
    }
  }

  Future<void> _deleteOrder(String orderId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore
            .collection('orderHistory')
            .doc(user.uid)
            .collection('orders')
            .doc(orderId)
            .delete();

        setState(() {
          _orders.removeWhere((order) => order.id == orderId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order deleted successfully!')),
        );
      }
    } catch (e) {
      print('Error deleting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting order')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAE4DD),
      appBar: AppBar(
        backgroundColor: const Color(0xff304a62),
        title: const Text(
          'Order History',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const ShoppingCartScreen()));
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return OrderCard(order: order, onDelete: _deleteOrder);
        },
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;
  final Future<void> Function(String) onDelete;

  OrderCard({required this.order, required this.onDelete});

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _expanded = false;

  Future<void> _showDeleteDialog() async {
    bool deleteConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Order'),
          content: const Text('Are you sure you want to delete this order?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (deleteConfirmed) {
      widget.onDelete(widget.order.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onLongPress: _showDeleteDialog,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text(
                "Check order..",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Placed on: ${widget.order.dateTime}'),
              trailing: Text(
                '${widget.order.total} Rs',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
              ),
            ),
            if (_expanded) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildProductList(widget.order.products),
                ),
              ),
            ],
            TextButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: Text(
                _expanded ? 'View Less' : 'View More',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProductList(List<Product> products) {
    return products.map((product) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Product Name",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    product.name,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    '${product.quantity} x ${product.price}',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class VendorBadge extends StatelessWidget {
  final String id;

  VendorBadge({required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(id, style: const TextStyle(color: Colors.white)),
    );
  }
}
