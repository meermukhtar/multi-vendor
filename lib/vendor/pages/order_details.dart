






import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../Notification/services/send_notification_service.dart';
import '../model/product_model.dart';
import '../service/order_display.dart';
import '../view/screen/dashbord.dart';

class OrdersPage extends StatefulWidget {
  final String orderId;
  const OrdersPage({
    Key? key,
    required this.orderId,

  }) : super(key: key);
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

// Future<void> storeOrderStatus(OrderModel order, String status) async {
//   String userUid = FirebaseAuth.instance.currentUser!.uid;
//
//   CollectionReference ordersRef = FirebaseFirestore.instance
//       .collection('OrderStatus')
//       .doc(userUid)
//       .collection(status);
//
//   Map<String, dynamic> orderData = {
//     'productId': order.productId,
//     'productName': order.productName,
//     'price': order.price,
//     'quantity': order.quantity,
//     'orderDate': order.createdAt,
//     'userId': order.userId,
//     'latitude': order.latitude,
//     'longitude': order.longitude,
//
//     'productImage':order.imageProduct
//   };
//
//   try {
//     await ordersRef.add(orderData);
//     Fluttertoast.showToast(msg: 'Order has been $status successfully.');
//   } catch (e) {
//     Fluttertoast.showToast(msg: 'Error storing order: $e');
//   }
// }
Future<void> storeOrderInFrenchise(OrderModel order, String status) async {
  String userUid = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference ordersRef = FirebaseFirestore.instance
      .collection('Franchise')
      .doc(userUid)
      .collection("Accepted");

  Map<String, dynamic> orderData = {
    'productId': order.productId,
    'productName': order.productName,
    'price': order.price,
    'quantity': order.quantity,
    'orderDate': order.createdAt,
    'userId': order.userId,
    'latitude': order.latitude,
    'longitude': order.longitude,
    'productImage':order.imageProduct
  };

  try {
    await ordersRef.add(orderData);
    Fluttertoast.showToast(msg: 'Order has been $status successfully.');
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error storing order: $e');
  }
}
Future<void> storeOrderStatus(OrderModel order, String status) async {
  String userUid = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference ordersRef = FirebaseFirestore.instance
      .collection('OrderList')
      .doc(userUid)
      .collection(status);

  Map<String, dynamic> orderData = {
    'productId': order.productId,
    'productName': order.productName,
    'price': order.price,
    'quantity': order.quantity,
    'orderDate': order.createdAt,
    'userId': order.userId,
    'latitude': order.latitude,
    'longitude': order.longitude,

    'productImage':order.imageProduct
  };

  try {
    await ordersRef.add(orderData);
    Fluttertoast.showToast(msg: 'Order has been $status successfully.');
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error storing order: $e');
  }
}
class _OrdersPageState extends State<OrdersPage> {
  final ProductFetchService productFetchService = ProductFetchService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAE4DD),
      appBar: AppBar(
        backgroundColor: const Color(0xff304a62),
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const DashBoardScreen()));
          },
        ),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: productFetchService.getUserProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: (){
                    // _productFetchService.showDeleteDialog(context,);
                    print(index);
                  },
                  child: OrderWidget(order: orders[index]));
            },
          );
        },
      ),
    );
  }
}

class OrderWidget extends StatefulWidget {
  final OrderModel order;

  const OrderWidget({super.key, required this.order});

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  String orderStatus = 'none';
  bool isButtonDisabled = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _loadButtonState();
  }

  // Load the state of the buttons from SharedPreferences
  _loadButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String productId = '${widget.order.productId}-${widget.order.userId}-${widget.order.createdAt.millisecondsSinceEpoch}';
    // String productId = '${widget.order.productId}-${widget.order.userId}';

    bool? isOrderAccepted = prefs.getBool('$productId-accepted');
    bool? isOrderRejected = prefs.getBool('$productId-rejected');

    if (isOrderAccepted == true || isOrderRejected == true) {
      setState(() {
        isButtonDisabled = true; // Disable both buttons if the order has been accepted or rejected
      });
    }
  }

  // Save the state of the buttons to SharedPreferences
  _saveButtonState(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String productId = '${widget.order.productId}-${widget.order.userId}-${widget.order.createdAt.millisecondsSinceEpoch}';

    if (status == 'Accepted') {
      await prefs.setBool('$productId-accepted', true);
      await prefs.setBool('$productId-rejected', false);
    } else if (status == 'Rejected') {
      await prefs.setBool('$productId-accepted', false);
      await prefs.setBool('$productId-rejected', true);
    }
  }
  final ProductFetchService productFetchService = ProductFetchService();

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    final String formattedDate = formatter.format(widget.order.createdAt.toDate());

    Color statusColor;
    if (orderStatus == 'accepted') {
      statusColor = Colors.green;
    } else if (orderStatus == 'rejected') {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.transparent;
    }

    return GestureDetector(
      onLongPress:


      (){
        print(widget.order.productId);
        productFetchService.showDeleteDialog(context,widget.order.productId);},
      child: Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[

                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), // Rounded corners if desired
                      boxShadow:const [
                        BoxShadow(
                          color: Colors.grey,
                          // blurRadius: 4,
                          // offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Image.network(
                      widget.order.imageProduct,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover, // Ensures the image fills the container
                    ),
                  ),

                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              'Product: ${widget.order.productName}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 10.0,
                              height: 10.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Text('Order Date: $formattedDate'),
                        const SizedBox(height: 5.0),
                        Text('Quantity: ${widget.order.quantity}'),
                        const SizedBox(height: 5.0),
                        Text('Price: ${widget.order.price.toStringAsFixed(2)} rs'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total: ${(widget.order.price.toStringAsFixed(2))} rs',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: isButtonDisabled
                        ? null // Disable button if already accepted or rejected
                        : () async {
                      setState(() {
                        orderStatus = 'accepted'; // Update status to accepted
                        isButtonDisabled = true; // Disable both buttons
                      });

                      // await storeOrderStatus(widget.order, "Accepted");
                      await storeOrderInFrenchise(widget.order, "Accepted");
                      await storeOrderStatus(widget.order, "Accepted");
                      await _saveButtonState("Accepted");

                      DocumentSnapshot docSnapshot = await FirebaseFirestore
                          .instance
                          .collection('Franchise')
                          .doc(widget.order.userId)
                          .get();
                      if (docSnapshot.exists) {
                        String deviceToken = docSnapshot['DeviceToke'];
                        if (deviceToken.isNotEmpty) {
                          EasyLoading.show();
                          await SendNotification.sendNotification(
                            token: deviceToken,
                            title: "Order Placed",
                            body: "Your order has been Accepted Successfully.💐",
                            data: {},
                          );
                          EasyLoading.dismiss();
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                    child: const Text('Accept'),
                  ),
                  const SizedBox(width: 10.0),
                  TextButton(
                    onPressed: isButtonDisabled
                        ? null // Disable button if already accepted or rejected
                        : () async {
                      setState(() {
                        orderStatus = 'rejected'; // Update status to rejected
                        isButtonDisabled = true; // Disable both buttons
                      });

                      await storeOrderStatus(widget.order, "Rejected");
                      await _saveButtonState("Rejected");

                      DocumentSnapshot docSnapshot = await FirebaseFirestore
                          .instance
                          .collection('Franchise')
                          .doc(widget.order.userId)
                          .get();
                      if (docSnapshot.exists) {
                        String deviceToken = docSnapshot['DeviceToke'];
                        if (deviceToken.isNotEmpty) {
                          EasyLoading.show();
                          await SendNotification.sendNotification(
                            token: deviceToken,
                            title: "Order Placed",
                            body: "Your order has been Rejected Successfully.💐",
                            data: {},
                          );
                          EasyLoading.dismiss();
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Reject'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
