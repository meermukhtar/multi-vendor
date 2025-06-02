// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating/flutter_rating.dart';
// import 'package:multivendor/client/pages/shopping_screen.dart';
//
// class ViewProductsWithDescryption extends StatefulWidget {
//   var id;
//   String image;
//   String itemName;
//   String price;
//   String description;
//   ViewProductsWithDescryption(
//       {Key? mykey,
//         this.id,
//         required this.image,
//         required this.itemName,
//         required this.price,
//         required this.description})
//       : super(key: mykey);
//
//   @override
//   State<ViewProductsWithDescryption> createState() => _ViewProductsWithDescryptionState();
// }
// String _capitalizeFirstLetter(String text) {
//   if (text.isEmpty) {
//     return text; // Return the original text if empty
//   }
//   return text[0].toUpperCase() + text.substring(1).toLowerCase();
// }
// class _ViewProductsWithDescryptionState extends State<ViewProductsWithDescryption> {
//   @override
//   Widget build(BuildContext context) {
//     double rating = 3.5;
//     int starCount = 5;
//     return Scaffold(
//         backgroundColor: const Color(0xffEAE4DD),
//       appBar: AppBar(
//         title: const Text(
//           'View Products'
//           ,style: TextStyle(color: Colors.white),
//         ),
//         elevation: 0,
//         backgroundColor:const Color( 0xff304a62),
//         leading: IconButton(onPressed:() {
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const ShoppingCartScreen()));
//         },icon:const Icon(Icons.arrow_back_outlined,color: Colors.white,),),
//         // actions: const [notification()],
//       ),
//       body: Container(
//         color: Colors.white,
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height*.45,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                 ),
//                 child: SizedBox.fromSize(
//                     size: const Size.fromRadius(140), // Image radius
//                     child: Image(
//                         image: NetworkImage(widget.image),
//                         fit: BoxFit.contain))),
//             Padding(
//               padding: const EdgeInsets.all(25),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           _capitalizeFirstLetter(widget.itemName),
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Text(
//                           widget.price + ' rs',
//                           //ak amount get krni ha
//                           style: const TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20),
//                         ),
//                       ],
//                     ),
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.end,  // Align containers to the right
//                     //   children: [ // Space between containers
//                     //     StarRating(
//                     //       size: 30.0,
//                     //       rating: rating,
//                     //       color: Colors.orange,
//                     //       borderColor: Colors.grey,
//                     //       allowHalfRating: true,
//                     //       starCount: starCount,
//                     //       onRatingChanged: (rating) => setState(() {
//                     //         rating;
//                     //       }),
//                     //     ),
//                     //
//                     //   ],
//                     // ),
//                     Row(
//                       children: [
//                         const  Icon(Icons.wine_bar_outlined,color: Color(0xff3a7e32),size: 30,),
//                         Row(
//                           children: [
//                            const Text("# Best Seller in  ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Color(
//                                0xff3a7e32)),),
//                             Text( _capitalizeFirstLetter(widget.itemName),style:const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     ConstrainedBox(
//                       constraints: const BoxConstraints(maxHeight: 100),
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.vertical,
//                         child: Text(
//                           widget.description,
//                           style: const TextStyle(
//                             fontSize: 15,),
//                           textAlign: TextAlign.justify,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 3)]
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.car_crash_sharp,size: 30,color: Color(0xff3a7e32),),
//                               const Text("Free shipping on all orders  ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Color(
//                                   0xff3a7e32)),),
//                             ],
//                           ),
//                           Text("Get a Rs.280 credit for late delivery"),
//                           Row(children: [
//                             Text("Courier company"),
//                             Icon(Icons.table_chart_sharp)
//                           ],)
//                         ],
//                       ),
//                     ),
//
//                     Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 3)]
//                       ),
//                       child: Column(
//                         children: [
//                           Expanded(child: Row(children: [
//                             Text("data"),
//                             Text("data"),
//
//                           ],)),
//                           Expanded(child:  Row(children: [
//                             Text("data"),
//                             Text("data"),
//                           ],)),
//                         ],
//                       ),
//                     )
//
//                     // Items_Counter(
//                     //   price: widget.price,
//                     //   item_name: widget.item_name,
//                     //   image: widget.image,
//                     // ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:multivendor/client/pages/shopping_screen.dart';
import 'package:multivendor/client/widgets/simple_elevated_button.dart';

import '../payment/add_payment_method.dart';

class ViewProductsWithDescryption extends StatefulWidget {
  var id;
  String image;
  String itemName;
  String price;
  String description;
  ViewProductsWithDescryption(
      {Key? mykey,
        this.id,
        required this.image,
        required this.itemName,
        required this.price,
        required this.description})
      : super(key: mykey);

  @override
  State<ViewProductsWithDescryption> createState() => _ViewProductsWithDescryptionState();
}

String _capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text; // Return the original text if empty
  }
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

class _ViewProductsWithDescryptionState extends State<ViewProductsWithDescryption> {
  @override
  Widget build(BuildContext context) {
    double rating = 3.5;
    int starCount = 5;
    return Scaffold(
      backgroundColor: const Color(0xffEAE4DD),
      appBar: AppBar(
        title: const Text(
          'View Products'
          ,style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor:const Color( 0xff304a62),
        leading: IconButton(onPressed:() {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const ShoppingCartScreen()));
        },icon:const Icon(Icons.arrow_back_outlined,color: Colors.white,),),
      ),
      body: SingleChildScrollView( // Wrap the entire body in a SingleChildScrollView
        child: Container(
          padding: EdgeInsets.only(top: 8),
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width*5,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(140), // Image radius
                  child: Image(
                    image: NetworkImage(widget.image),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _capitalizeFirstLetter(widget.itemName),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          widget.price + ' rs',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.wine_bar_outlined, color: Color(0xff3a7e32), size: 30),
                        Row(
                          children: [
                            const Text(
                              "# Best Seller in  ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xff3a7e32),
                              ),
                            ),
                            Text(
                              _capitalizeFirstLetter(widget.itemName),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 100),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          widget.description,
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration:const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3)],
                      ),
                      child:const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.car_crash_sharp, size: 30, color: Color(0xff3a7e32)),
                                 Text(
                                  "Free shipping on all orders  ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xff3a7e32),
                                  ),
                                ),
                              ],
                            ),
                            Text("Get a Rs.280 credit for late delivery"),
                            Row(
                              children: [
                                Text("Courier company"),
                                Icon(Icons.table_chart_sharp),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration:const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3)],
                      ),
                      child:const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First Row: Security Title
                            Row(
                              children: [
                                Icon(
                                  Icons.security,
                                  color: Color(0xff3a7e32),
                                  size: 25,
                                ),
                                SizedBox(width: 8), // Add spacing between the icon and text
                                Text(
                                  "Shopping security",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xff3a7e32),
                                  ),
                                ),
                              ],
                            ),
                            // First Row of Features: Safety Payment Options, Secure logistics
                            Padding(
                              padding:  EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, // Align all items to the start
                                children: [
                                  Text(". Safety Payment Options"),
                                  Spacer(), // Add a spacer to push the next row to the far right
                                  Text(". Secure logistics option"),
                                ],
                              ),
                            ),
                            // Second Row of Features: Security Privacy, Purchase Protection
                            Padding(
                              padding:  EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, // Align all items to the start
                                children: [
                                  Text(". Security privacy"),
                                  Spacer(), // Add a spacer to push the next row to the far right
                                  Text(". Purchase protection app"),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              // SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8),
                child: SimpleElevatedButtonWidget(title: "Payment Procedure Select", color: Color( 0xff304a62), textColor: Colors.white, callback: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>AddPaymentMethod()));
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
