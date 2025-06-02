// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import '../models/product_model.dart';
//
// class ShoppingCardWidgets extends StatelessWidget {
//   final String productName;
//   final String price;
//   final String vendorId;
//   final String productId;
//   final String imageProduct;
//   final Function(Product) voidCallbackAction;
//   final bool isAdded;
//
//    ShoppingCardWidgets({
//     super.key,
//     required this.productName,
//     required this.price,
//     required this.imageProduct,
//     required this.voidCallbackAction,
//     required this.vendorId,
//     required this.productId,
//     this.isAdded = false,
//   });
// bool isFavorite=false;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xff304a62),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       margin: const EdgeInsets.symmetric(horizontal: 5.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Free Delivery",
//             style: TextStyle(color: CupertinoColors.lightBackgroundGray,fontWeight: FontWeight.bold),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.black),
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(),
//                     Text(productName,style:const TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
//                     InkWell(
//                         onTap: (){},
//                         child: Icon(Icons.favorite_border))
//                   ],
//                 ),
//                 const SizedBox(height: 5,),
//                 AspectRatio(
//                   aspectRatio: 1.5, // Ensures the image is square
//                   child: Image.network(
//                     imageProduct,
//                     fit: BoxFit.contain, // Ensures the image fills the container
//                     width: double.infinity,
//                     height: double.infinity,
//                   ),
//                 ),
//                 Text('Cost: $price'),
//                // const Text('Free delivery'),
//                //  ElevatedButton(
//                //    onPressed: () {
//                //      Product product = Product(
//                //        productName: productName,
//                //        price: price,
//                //        imageProduct: imageProduct,
//                //        isAdded: !isAdded,
//                //        vendorId: vendorId,
//                //        productId: productId,
//                //      );
//                //      voidCallbackAction(product);
//                //    },
//                //    child: Text(
//                //      isAdded ? 'Remove from cart' : 'Add to cart',
//                //      style: const TextStyle(fontSize: 10),
//                //    ),
//                //  ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Product product = Product(
//                       productName: productName,
//                              price: price,
//                              imageProduct: imageProduct,
//                              isAdded: !isAdded,
//                              vendorId: vendorId,
//                              productId: productId,
//                     );
//                     voidCallbackAction(product);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:const Color(0xff304a62),
//                     foregroundColor: const Color(0xff423f49),
//                     // backgroundColor:const Color(0xff295F98),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10), // Make the corners square
//                     ),
//                   ),
//                   child: Text(
//                    isAdded ? 'Remove from cart' : 'Add to cart',
//                     style: const TextStyle(fontSize: 13,color: Colors.white,fontWeight: FontWeight.bold),
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//




import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/product_model.dart';
import '../pages/product_descryption.dart';

class ShoppingCardWidgets extends StatefulWidget {
  final String productName;
  final String price;
  final String vendorId;
  final String productId;
  final String imageProduct;
  final String  description;
  final Function(ClientProduct) voidCallbackAction;
  final bool isAdded;

  ShoppingCardWidgets({
    super.key,
    required this.productName,
    required this.price,
    required this.imageProduct,
    required this.voidCallbackAction,
    required this.vendorId,
    required this.productId,
    this.isAdded = false,
    required this.description
  });

  @override
  _ShoppingCardWidgetsState createState() => _ShoppingCardWidgetsState();
}

class _ShoppingCardWidgetsState extends State<ShoppingCardWidgets> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:const Color(0xff304a62),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Free Delivery",
            style: TextStyle(color: CupertinoColors.lightBackgroundGray, fontWeight: FontWeight.bold),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   // Container(),
                    Text(
                      widget.productName,
                      style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                InkWell(
                  onTap: (){
                    if (kDebugMode) {
                      print("selected images: ${widget.imageProduct}");
                    }
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ViewProductsWithDescryption(image: widget.imageProduct, itemName: widget.productName, price: widget.price, description: widget.description,)));
                  },
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: Image.network(
                      widget.imageProduct,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),



                Text('Cost: ${widget.price}'),
                ElevatedButton(
                  onPressed: () {
                    ClientProduct product = ClientProduct(
                      productName: widget.productName,
                      price: widget.price,
                      imageProduct: widget.imageProduct,
                      isAdded: !widget.isAdded,
                      vendorId: widget.vendorId,
                      productId: widget.productId,
                    );
                    widget.voidCallbackAction(product);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff304a62),
                    foregroundColor: const Color(0xff423f49),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    widget.isAdded ? 'Remove from cart' : 'Add to cart',
                    style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
