// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:multivendor/Notification/services/fcm.dart';
// import 'package:multivendor/Notification/services/get_service_key.dart';
// import 'package:multivendor/Notification/services/notification_service.dart';
// import 'package:multivendor/client/pages/login_page.dart';
// import 'package:multivendor/client/pages/shopping_screen.dart';
// import 'package:multivendor/client/pages/term_and_policy.dart';
// import 'package:multivendor/client/splash_screen/fase_in_splash.dart';
// import 'package:multivendor/vendor/pages/register.dart';
// import 'package:multivendor/vendor/pages/splash.dart';
// import '../widgets/home_page_cards.dart';
// import '../widgets/search_widget.dart';
// import 'cart_page.dart';
// import 'client_review.dart';
// import 'favourite_product.dart';
// import 'order_history.dart';
//
// // Define constants
// const Color drawerHeaderColor = Color(0xff295F98);
// const Color companyNameBackgroundColor = Colors.blueGrey;
// const Color companyNameTextColor = Colors.black;
// const double drawerHeaderFontSize = 24.0;
// const double drawerEmailFontSize = 16.0;
// const double locationTextSize = 14.0;
// const String companyName = 'Company Name';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
//
// class _HomePageState extends State<HomePage> {
//   late Future<DocumentSnapshot> _userProfileFuture;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// NotificationService notificationService=NotificationService();
//
//   @override
//   void initState() {
//     super.initState();
//     _userProfileFuture = _fetchUserProfile();
//     //here we pass the request to the screen if allow already request so it will work other wise it ask users to allow the permissions
//     notificationService.requestNotificationPermission();
//     notificationService.getDeviceToken();
//     FCMService.firebaseInit();
//     notificationService.firebaseInit(context);
//     notificationService.setUPInterActMessage(context);
//   }
//
//   Future<DocumentSnapshot> _fetchUserProfile() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       return FirebaseFirestore.instance
//           .collection('Franchise')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .get();
//     } else {
//       throw Exception("User not logged in");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       // backgroundColor: Colors.white,
//       backgroundColor:const Color(0xffEAE4DD),
//       appBar: AppBar(
//
//         backgroundColor:const Color( 0xff304a62),
//         title:const Text("Home Page",style: TextStyle(color: Colors.white),),
//         leading: IconButton(
//           icon:const Icon(Icons.menu,color: Colors.white),
//
//           onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//         ),
//         actions: [IconButton(onPressed: ()async{
//
//           GetServerKey getServerKey=GetServerKey();
//           String accessToken= await getServerKey.getServerKeyToken();
//           print("<===============There is get server key==================>");
//           print(accessToken);
//         }, icon:const Icon(Icons.info,color: Colors.white,))],
//       ),
//       drawer: Drawer(
//         child: FutureBuilder<DocumentSnapshot>(
//           future: _userProfileFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData) {
//               return const Center(child: Text('No Data Found'));
//             }
//
//             var userProfileData = snapshot.data!.data() as Map<String, dynamic>;
//
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView(
//                     padding: EdgeInsets.zero,
//                     children: [
//                       DrawerHeader(
//                         decoration: const BoxDecoration(
//                           color: Color(0xff304a62),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 (userProfileData['storeName'] ?? 'N/A').toUpperCase(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: drawerHeaderFontSize,
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 userProfileData['email'] ?? 'N/A',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: drawerEmailFontSize,
//                                 ),
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         '${userProfileData['latitude']} ${userProfileData['longitude']}',
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: locationTextSize,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const Icon(Icons.pin_drop_outlined, color: Colors.red),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       _buildListTile(
//                         icon: Icons.shopping_bag_outlined,
//                         title: 'Shopping',
//                         onTap: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (context) => const ShoppingCartScreen()),
//                           );
//                         },
//                       ),
//                       _buildListTile(
//                         icon: Icons.add_shopping_cart,
//                         title: 'Check cart',
//                         onTap: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (context) => const CartPage(cartItems: [])),
//                           );
//                         },
//                       ),
//                       _buildListTile(
//                         icon: Icons.history,
//                         title: 'Order History',
//                         onTap: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (_) => OrderHistory()),
//                           );
//                         },
//                       ),
//                       _buildListTile(
//                         icon: Icons.favorite_border,
//                         title: 'Favourite',
//                         onTap: () async {
//                           await Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>const FavouritesProducts()));
//                         },
//                       ),
//                       _buildListTile(
//                         icon: Icons.feedback_rounded,
//                         title: 'Feedback',
//                         onTap: () async {
//                           await Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>const ClientReview()));
//                         },
//                       ), _buildListTile(
//                         icon: Icons.policy_outlined,
//                         title: 'Terms & Policies',
//                         onTap: () async {
//                           await Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>const TermAndPolicy()));
//                         },
//                       ),
//                       _buildListTile(
//                         icon: Icons.logout,
//                         title: 'Logout',
//                         onTap: () async {
//                           await FirebaseAuth.instance.signOut();
//                           await Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FadeInSplash()));
//                         },
//                       ),
//                       // Add other list tiles as needed
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(10.0),
//                   color: Color(0xffEAE4DD),
//                   child: const Center(
//                     child: Text(
//                       companyName,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: companyNameTextColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             const SearchWidget(),
//             const SizedBox(height: 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         HomePageCards(
//                           cardName: "Shopping",
//                           cardIcon: Icons.more_vert,
//                           cardIconButton: Icons.shopping_bag_sharp,
//                           cartTotalProduct: "",
//                           myCallback: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => const ShoppingCartScreen()));
//                           },
//                         ),
//                         HomePageCards(
//                           cardName: "Cart",
//                           cardIcon: Icons.more_vert,
//                           cardIconButton: Icons.add_shopping_cart,
//                           cartTotalProduct: "",
//                           myCallback: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => const CartPage(cartItems: [])));
//                           },
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         HomePageCards(
//                           cardName: "Offers",
//                           cardIcon: Icons.more_vert,
//                           cardIconButton: Icons.local_offer_outlined,
//                           cartTotalProduct: "",
//                           myCallback: () {},
//                         ),
//                         HomePageCards(
//                           cardName: "Wishlist",
//                           cardIcon: Icons.more_vert,
//                           cardIconButton: Icons.add_shopping_cart,
//                           cartTotalProduct: "",
//                           myCallback: () {},
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
// Widget _buildListTile({
//   required IconData icon,
//   required String title,
//   required VoidCallback onTap,
// }) {
//   return ListTile(
//     onTap: onTap,
//     title: Row(
//       children: [
//         Icon(icon, color: Colors.black),
//         const SizedBox(width: 10), // Space between the icon and the line
//         Container(
//           width: 2, // Width of the vertical line
//           height: 24, // Height of the line (adjust as needed)
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.grey.withOpacity(0), // Transparent at the top
//                 Colors.grey, // Solid color in the middle
//                 Colors.grey.withOpacity(0), // Transparent at the bottom
//               ],
//               stops: const [0.0, 0.5, 1.0], // Control the gradient stops
//             ),
//           ),
//         ),
//         const SizedBox(width: 10), // Space between the line and text
//         Text(
//           title,
//           style: const TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//       ],
//     ),
//   );
// }
