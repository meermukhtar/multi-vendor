import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multivendor/client/pages/term_and_policy.dart';
import 'package:provider/provider.dart';
import '../../Notification/services/fcm.dart';
import '../../Notification/services/get_service_key.dart';
import '../../Notification/services/notification_service.dart';
import '../model/cart_provider.dart';
import '../model/product_model.dart';
import '../splash_screen/fase_in_splash.dart';
import '../widgets/polygon_clipper.dart';
import '../widgets/search_widget.dart';
import '../widgets/shopping_card_widget.dart';
import 'cart_page.dart';
import 'client_review.dart';
import 'favourite_product.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'order_history.dart';

const Color drawerHeaderColor = Color(0xff295F98);
const Color companyNameBackgroundColor = Colors.blueGrey;
const Color companyNameTextColor = Colors.black;
const double drawerHeaderFontSize = 24.0;
const double drawerEmailFontSize = 16.0;
const double locationTextSize = 14.0;
const String companyName = 'Company Name';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  String currentUserFranchiseId = '';
  late Future<DocumentSnapshot> _userProfileFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  NotificationService notificationService = NotificationService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; final List<String> imageUrls = [
    "assets/images/img4.jpg",
    "assets/images/img5.jpg",
    "assets/images/img.png",
    "assets/images/img2.png",
    "assets/images/img3.png"
  ];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _userProfileFuture = _fetchUserProfile();
    //here we pass the request to the screen if allow already request so it will work other wise it ask users to allow the permissions
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken();
    FCMService.firebaseInit();
    notificationService.firebaseInit(context);
    notificationService.setUPInterActMessage(context);
    _getCurrentUserFranchiseId();
  }

  Future<DocumentSnapshot> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('Franchise')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
    } else {
      throw Exception("User not logged in");
    }
  }

  // Fetch the current user's franchise ID
  Future<void> _getCurrentUserFranchiseId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userProfileSnapshot = await FirebaseFirestore.instance
          .collection('usersProfile')
          .doc(user.uid)
          .get();

      if (userProfileSnapshot.exists) {
        setState(() {
          currentUserFranchiseId =
              userProfileSnapshot.data()?['franchiseId'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffEAE4DD),
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(280.0), // Adjust the height

        child: AppBar(
          title: const Text(
            "Shop New from there",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff304a62),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          actions: [
            // IconButton(
            //   onPressed: () async {
            //     // Perform your server key fetch
            //     print("<=============== Fetching Server Key ===============>");
            //   },
            //   icon: const Icon(Icons.info, color: Colors.white),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CartPage(cartItems: cartProvider.cartItems),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  if (cartProvider.cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            '${cartProvider.cartItems.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchWidget(),
                        // SizedBox(height: 5),

                      ],
                    ),
                  ),
                  // SearchWidget(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     const Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Product Popular",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Polygon_Clipper(label: '', image: ''),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: FutureBuilder<DocumentSnapshot>(
          future: _userProfileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No Data Found'));
            }

            var userProfileData = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Color(0xff304a62),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (userProfileData['storeName'] ?? 'N/A')
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: drawerHeaderFontSize,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                userProfileData['email'] ?? 'N/A',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: drawerEmailFontSize,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${userProfileData['latitude']} ${userProfileData['longitude']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: locationTextSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.pin_drop_outlined,
                                      color: Colors.red),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildListTile(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Shopping',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ShoppingCartScreen()),
                          );
                        },
                      ),
                      _buildListTile(
                        icon: Icons.add_shopping_cart,
                        title: 'Check cart',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CartPage(cartItems: [])),
                          );
                        },
                      ),
                      _buildListTile(
                        icon: Icons.history,
                        title: 'Order History',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => OrderHistory()),
                          );
                        },
                      ),
                      // _buildListTile(
                      //   icon: Icons.favorite_border,
                      //   title: 'Favourite',
                      //   onTap: () async {
                      //     await Navigator.pushReplacement(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (_) => const FavouritesProducts()));
                      //   },
                      // ),
                      _buildListTile(
                        icon: Icons.feedback_rounded,
                        title: 'Feedback',
                        onTap: () async {
                          await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ClientReview()));
                        },
                      ),
                      _buildListTile(
                        icon: Icons.policy_outlined,
                        title: 'Terms & Policies',
                        onTap: () async {
                          await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const TermAndPolicy()));
                        },
                      ),
                      _buildListTile(
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => FadeInSplash()));
                        },
                      ),
                      // Add other list tiles as needed
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Color(0xffEAE4DD),
                  child: const Center(
                    child: Text(
                      companyName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: companyNameTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  // Carousel Slider
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.9, // Adjust width if necessary
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20), // Container border radius
                      boxShadow: const [
                        BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 2),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Same border radius for the image
                      child: CarouselSlider(
                        items: imageUrls.map((imageUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Image.asset(
                                imageUrl,
                                fit: BoxFit.cover, // BoxFit.cover ensures the image fills the container
                                width: MediaQuery.of(context).size.width,
                              );
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          autoPlay: true, // Automatically move to the next image
                          autoPlayInterval: const Duration(seconds: 3), // Duration between slides
                          autoPlayAnimationDuration: const Duration(milliseconds: 800), // Animation duration
                          enlargeCenterPage: true, // Enlarge the current image
                          viewportFraction: 1.0, // Ensures image fills the container
                          aspectRatio: 16 / 9, // Aspect ratio of the images
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index; // Update the index when page changes
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Space between carousel and dots

                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(imageUrls.length, (index) {
                      return AnimatedContainer(
                        duration:const Duration(milliseconds: 300),
                        margin:const EdgeInsets.symmetric(horizontal: 5),
                        width: _currentIndex == index ? 12 : 8, // Active dot is larger
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index ?  Color(0xff304a62) : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
    //     Center(
    //     child: Container(
    //     height: MediaQuery.of(context).size.height * 0.2,
    //     width: MediaQuery.of(context).size.width * 0.9, // Adjust width if necessary
    //     decoration: BoxDecoration(
    //       color: Colors.transparent,
    //       borderRadius: BorderRadius.circular(20), // Container border radius
    //       boxShadow: const [
    //         BoxShadow(color: Colors.grey, blurRadius: 2, spreadRadius: 2),
    //       ],
    //     ),
    //     // Wrapping image in ClipRRect to apply the same border radius
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(20), // Same border radius for the image
    //       child: CarouselSlider(
    //         items: imageUrls.map((imageUrl) {
    //           return Builder(
    //             builder: (BuildContext context) {
    //               return Image.asset(
    //                 imageUrl,
    //                 fit: BoxFit.cover, // BoxFit.cover ensures the image fills the container
    //                 width: MediaQuery.of(context).size.width,
    //               );
    //             },
    //           );
    //         }).toList(),
    //         options: CarouselOptions(
    //             autoPlay: true, // Automatically move to the next image
    //             autoPlayInterval: const Duration(seconds: 3), // Duration between slides
    //             autoPlayAnimationDuration: const Duration(milliseconds: 800), // Animation duration
    //             enlargeCenterPage: true, // Enlarge the current image
    //             viewportFraction: 1.0, // Ensures image fills the container
    //             aspectRatio: 16 / 9, // Aspect ratio of the images
    // onPageChanged: (index, reason) {
    //   setState(() {
    //     _currentIndex = index; // Update the index when page changes
    //   });
    // })
    //       ),
    //     ),
    //           ),
    //
    //     ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // Filter franchises to only those where role == 'vendor'
                stream: FirebaseFirestore.instance
                    .collection('Franchise')
                    .where('role', isEqualTo: 'Vendor') // Adding the filter
                    .snapshots(),
                builder: (context, franchiseSnapshot) {
                  if (!franchiseSnapshot.hasData || franchiseSnapshot.data!.docs.isEmpty) {

                    return const Center(child: Text("...")); // Show a loading indicator if no data
                  }

                  var franchisees = franchiseSnapshot.data!.docs;

                  return ListView.builder(
                    itemCount: franchisees.length,
                    itemBuilder: (context, franchiseIndex) {
                      var franchiseData =
                      franchisees[franchiseIndex].data() as Map<String, dynamic>;
                      var franchiseName = franchiseData['storeName'];
                      var franchiseId = franchisees[franchiseIndex].id;

                      // Skip the franchise if it's the current user's franchise
                      if (franchiseId == currentUserFranchiseId) {
                        return Container(); // Hide this franchise
                      }

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Franchise')
                            .doc(franchiseId)
                            .collection('ProductCollection')
                            .snapshots(),
                        builder: (context, productSnapshot) {
                          if (!productSnapshot.hasData) {
                          //  EasyLoading.show(status: 'Loading...');
                            return const Center(child: Text("")); // Show a loading indicator for products
                          }

                          var products = productSnapshot.data!.docs;

                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // Padding(
                                //   padding: const EdgeInsets.all(10.0),
                                //   child: Text(
                                //     franchiseName,
                                //     style: const TextStyle(
                                //       fontSize: 18,
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(height: 5),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: products.map((product) {
                                      var productData =
                                      product.data() as Map<String, dynamic>;
                                      return SizedBox(
                                        width: MediaQuery.of(context).size.width / 2 - 13,
                                        child: ShoppingCardWidgets(
                                          productName: productData['productName'],
                                          price: productData['price'].toString(),
                                          imageProduct: productData['imageProduct'],
                                          voidCallbackAction: (ClientProduct product) {
                                            cartProvider.addToCart(product);
                                          },
                                          vendorId: franchiseId,
                                          productId: product.id,
                                          description: productData['description'],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )

    );
  }
}

Widget _buildListTile({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    onTap: onTap,
    title: Row(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 10), // Space between the icon and the line
        Container(
          width: 2, // Width of the vertical line
          height: 24, // Height of the line (adjust as needed)
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.withOpacity(0), // Transparent at the top
                Colors.grey, // Solid color in the middle
                Colors.grey.withOpacity(0), // Transparent at the bottom
              ],
              stops: const [0.0, 0.5, 1.0], // Control the gradient stops
            ),
          ),
        ),
        const SizedBox(width: 10), // Space between the line and text
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}
