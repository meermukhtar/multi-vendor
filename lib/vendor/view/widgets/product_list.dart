// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:frenchiseemanagement/pages/admin_update_data.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../../services/separate_user_fields.dart';
// import '../themes/colors_file.dart';
//
// class MyProductList extends StatefulWidget {
//
//   MyProductList({
//     super.key,
//   });
//
//   @override
//   State<MyProductList> createState() => _MyProductListState();
// }
// // You should pass this from your authentication state
// final AuthService authService = AuthService();
//
// class _MyProductListState extends State<MyProductList> {
//   //this is passed as services to retrieve the product list from firebase
//   ProductFetchService fetch = ProductFetchService();
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     ColorsList colorsList = ColorsList();
//     TextStyling textStyling = TextStyling();
//     return StreamBuilder<List<Product>>(
//       stream: fetch.getUserProducts(),
//       builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(
//               backgroundColor: CupertinoColors.systemPink,
//             ),
//           );
//         }
//
//         if (!snapshot.hasData) {
//           Fluttertoast.showToast(
//             msg: "No data found",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 10,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//           return const Center(child: Text('No data found'));
//         }
//
//         List<Product> products = snapshot.data!;
//
//         //final ve=adminUID
//         return SizedBox(
//           height: MediaQuery.of(context).size.height * 0.4,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             shrinkWrap: true,
//             itemCount: products.length,
//             itemBuilder: (context, int index) {
//               Product product = products[index];
//
//               return Container(
//                 margin: const EdgeInsets.all(15),
//                 width: MediaQuery.of(context).size.width * 0.6,
//                 height: MediaQuery.of(context).size.height * 0.4,
//                 decoration: BoxDecoration(
//                   color: Colors.white, // Update to a valid color
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black45.withOpacity(0.8),
//                       blurRadius: 3,
//                       spreadRadius: 1.0,
//                       offset: Offset.zero,
//                     )
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Container(
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: NetworkImage(product.imageProduct),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   product.productName,
//                                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Update to your text style
//                                 ),
//                                 IconButton(
//                                   onPressed: () async {
//                                     showDialog(
//                                       context: context,
//                                       builder: (ctx) => CupertinoAlertDialog(
//                                         title: const Text("Product deleted"),
//                                         content: const Text("Are you sure you want to delete"),
//                                         actions: <Widget>[
//                                           CupertinoDialogAction(onPressed: (){
//                                             Navigator.of(ctx).pop();
//                                           }, child: Text("No")),
//                                           CupertinoDialogAction(onPressed: () async{
//                                             final user = FirebaseAuth.instance.currentUser;
//                                             String? adminUID = user?.uid;
//
//                                             if (adminUID != null) {
//                                               try {
//                                                 String selectedProductId = product.id;
//
//                                                 await FirebaseFirestore.instance
//                                                     .collection('Franchise')
//                                                     .doc(adminUID)
//                                                     .collection('ProductCollection')
//                                                     .doc(selectedProductId)
//                                                     .delete();
//
//                                                 print("Product with ID $selectedProductId deleted successfully");
//
//                                                 ScaffoldMessenger.of(context).showSnackBar(
//                                                  const SnackBar(content: Text('Product deleted successfully',style: TextStyle(color: Colors.white),),backgroundColor: Colors.black45,),
//                                                 );
//                                               } catch (e) {
//                                                 print("Failed to delete product: $e");
//
//                                                 ScaffoldMessenger.of(context).showSnackBar(
//                                                   const     SnackBar(content: Text('Failed to delete product',style: TextStyle(color: Colors.white),),backgroundColor: Colors.black45,),
//                                                 );
//                                               }
//                                             }
//
//                                             Navigator.of(ctx).pop();
//                                           }, child: Text("Yes")),
//                                         ],
//                                       ),
//                                     );
//
//                                   },
//
//                                   icon: const Icon(Icons.delete, color: Colors.red),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   '\$${product.price}', // Assuming "price" is stored as a number in Firebase
//                                   style: textStyling.priceTextStyle, // Update to your price text style
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     // var id = product.id; // Uncomment if you have product ID
//                                     Get.to(() => FranchiseAdminUpdateData(), arguments: {
//                                       'productName': product.productName,
//                                       'imageProduct': product.imageProduct,
//                                       'price': product.price,
//                                       // 'id': id, // Uncomment if you have product ID
//                                     });
//                                   },
//                                   child:  Icon(
//                                     Icons.update_disabled,
//                                     color: colorsList.iconsColor, // Update to your icon color
//                                     size: 30,
//                                   ),
//                                 ),
//                                 // Add additional fields if needed
//                                 // Text(product.time.toString()), // Uncomment if you have time field
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//
//   }
//
//
//   void alerMessageDialog(){
//     showDialog(
//       context: context,
//       builder: (ctx) => CupertinoAlertDialog(
//         title: const Text("Product deleted"),
//         content: const Text("Are you sure you want to delete"),
//         actions: <Widget>[
//           CupertinoDialogAction(onPressed: (){
//             Navigator.of(ctx).pop();
//           }, child: Text("No")),
//           CupertinoDialogAction(onPressed: () async{
//
//             Navigator.of(ctx).pop();
//           }, child: Text("Yes")),
//         ],
//       ),
//     );
//   }
//
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../service/separate_user.dart';
import '../../../client/model/product_model.dart';
import '../../../client/utils/constant.dart';
import '../../service/separate_user.dart';

class MyProductList extends StatefulWidget {
  MyProductList({super.key});

  @override
  State<MyProductList> createState() => _MyProductListState();
}

// You should pass this from your authentication state
final AuthService authService = AuthService();

class _MyProductListState extends State<MyProductList> {
  // This is passed as services to retrieve the product list from Firebase
  ProductFetchService fetch = ProductFetchService();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ColorsList colorsList = ColorsList();
    TextStyling textStyling = TextStyling();

    return StreamBuilder<List<Product>>(
      stream: fetch.getUserProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        // Debug print for connection state
        print("Connection State: ${snapshot.connectionState}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              ),
          );
        }
        List<Product> products = snapshot.data!;

        // Debug print for retrieved products
        print("Retrieved products: ${products.length}");
        products.forEach((product) {
          print("Product ID: ${product.id}, Name: ${product.productName}, Price: ${product.price}");
        });

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, int index) {
              Product product = products[index];

              return Container(
                margin: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Color(0xffEAE4DD),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 3,
                      //spreadRadius: 1.0,
                      //offset: Offset.zero,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child:
                          GestureDetector(
                            // Trigger onLongPress to show the delete confirmation dialog
                            onLongPress: () async {
                              // Show the delete confirmation dialog
                              showDialog(
                                context: context,
                                builder: (ctx) => CupertinoAlertDialog(
                                  title: const Text("Product deleted"),
                                  content: const Text("Are you sure you want to delete?"),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.of(ctx).pop(); // Close the dialog without deleting
                                      },
                                      child: Text("No"),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () async {
                                        final user = FirebaseAuth.instance.currentUser;
                                        String? adminUID = user?.uid;

                                        if (adminUID != null) {
                                          try {
                                            String selectedProductId = product.id;

                                            // Deleting the product from Firebase
                                            await FirebaseFirestore.instance
                                                .collection('Franchise')
                                                .doc(adminUID)
                                                .collection('ProductCollection')
                                                .doc(selectedProductId)
                                                .delete();

                                            print("Product with ID $selectedProductId deleted successfully");

                                            // Show a confirmation message
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Product deleted successfully',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                backgroundColor: Colors.black45,
                                              ),
                                            );
                                          } catch (e) {
                                            print("Failed to delete product: $e");

                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Failed to delete product',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                backgroundColor: Colors.black45,
                                              ),
                                            );
                                          }
                                        }

                                        Navigator.of(ctx).pop(); // Close the dialog after the action
                                      },
                                      child: Text("Yes"),
                                    ),
                                  ],
                                ),
                              );
                            },

                          child: Container(
                           // width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xffEAE4DD),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(product.imageProduct),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              // Trigger onLongPress to show the delete confirmation dialog
                              onLongPress: () async {
                                // Show the delete confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (ctx) => CupertinoAlertDialog(
                                    title: const Text("Product deleted"),
                                    content: const Text("Are you sure you want to delete?"),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(); // Close the dialog without deleting
                                        },
                                        child: Text("No"),
                                      ),
                                      CupertinoDialogAction(
                                        onPressed: () async {
                                          final user = FirebaseAuth.instance.currentUser;
                                          String? adminUID = user?.uid;

                                          if (adminUID != null) {
                                            try {
                                              String selectedProductId = product.id;

                                              // Deleting the product from Firebase
                                              await FirebaseFirestore.instance
                                                  .collection('Franchise')
                                                  .doc(adminUID)
                                                  .collection('ProductCollection')
                                                  .doc(selectedProductId)
                                                  .delete();

                                              print("Product with ID $selectedProductId deleted successfully");

                                              // Show a confirmation message
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Product deleted successfully',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                  backgroundColor: Colors.black45,
                                                ),
                                              );
                                            } catch (e) {
                                              print("Failed to delete product: $e");

                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Failed to delete product',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                  backgroundColor: Colors.black45,
                                                ),
                                              );
                                            }
                                          }

                                          Navigator.of(ctx).pop(); // Close the dialog after the action
                                        },
                                        child: Text("Yes"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      // Text(
                                      //   "PName:",
                                      //   style: textStyling.headingTextStyle,
                                      // ),
                                      // const SizedBox(width: 4,),
                                      Text(
                                        product.productName,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  // No delete icon here, only long press functionality
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Price:",
                                      style: textStyling.headingTextStyle,
                                    ),
                                    const SizedBox(width: 4,),
                                    Text(
                                      '${product.price} rs',
                                      style: textStyling.priceTextStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )

                        /*
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "PName:",
                                      style: textStyling.headingTextStyle,
                                    ),
                                    const  SizedBox(width: 4,),Text(
                                      product.productName,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => CupertinoAlertDialog(
                                        title: const Text("Product deleted"),
                                        content: const Text("Are you sure you want to delete"),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: Text("No"),
                                          ),
                                          CupertinoDialogAction(
                                            onPressed: () async {
                                              final user = FirebaseAuth.instance.currentUser;
                                              String? adminUID = user?.uid;

                                              if (adminUID != null) {
                                                try {
                                                  String selectedProductId = product.id;

                                                  await FirebaseFirestore.instance
                                                      .collection('Franchise')
                                                      .doc(adminUID)
                                                      .collection('ProductCollection')
                                                      .doc(selectedProductId)
                                                      .delete();

                                                  print("Product with ID $selectedProductId deleted successfully");

                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Product deleted successfully',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                      backgroundColor: Colors.black45,
                                                    ),
                                                  );
                                                } catch (e) {
                                                  print("Failed to delete product: $e");

                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Failed to delete product',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                      backgroundColor: Colors.black45,
                                                    ),
                                                  );
                                                }
                                              }

                                              Navigator.of(ctx).pop();
                                            },
                                            child: Text("Yes"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Price:",
                                      style: textStyling.headingTextStyle,
                                    ),
                                    const   SizedBox(width: 4,),

                                    Text(
                                      '\$${product.price}',
                                      style: textStyling.priceTextStyle,
                                    ),
                                  ],
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     Get.to(() => FranchiseAdminUpdateData(), arguments: {
                                //       'productName': product.productName,
                                //       'imageProduct': product.imageProduct,
                                //       'price': product.price,
                                //     });
                                //   },
                                //   child: Icon(
                                //     Icons.update_disabled,
                                //     color: colorsList.iconsColor,
                                //     size: 30,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),

                         */
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
