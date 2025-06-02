import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../pages/frenchise_data_upload.dart';
import '../../pages/order_accepted_rejected_tabs.dart';
import '../../pages/order_details.dart';
import '../../pages/profile.dart';
import '../../pages/term_and_policies.dart';
import '../screen/dashbord.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<DocumentSnapshot>? _userProfileStream;

  @override
  void initState() {
    super.initState();
    _initializeUserProfileStream();
  }

  void _initializeUserProfileStream() {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      _userProfileStream = FirebaseFirestore.instance
          .collection('Franchise')
          .doc(currentUser.uid) // Assuming UID is used as the document ID
          .snapshots();
    }
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
        stream: _userProfileStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No Data Found'));
          }

          Map<String, dynamic> userProfileData =
          snapshot.data!.data() as Map<String, dynamic>;

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
                              (userProfileData['storeName'] ?? 'N/A').toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              userProfileData['email'] ?? 'N/A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${userProfileData['latitude'] ?? 'N/A'}, ${userProfileData['longitude'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.pin_drop_outlined,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildListTile(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Dashboard',
    onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                      const DashBoardScreen(),
                    ),
                  );
                },
                    ),

                    _buildListTile(
                      icon: Icons.history,
                      title: 'Inventory ',
                      onTap: () {
                        // Navigate to Order History Screen
                        Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                        const FranchiseUploadedData()),
                  );
                      },
                    ),

                    _buildListTile(
                      icon: Icons.production_quantity_limits_rounded,
                      title: 'Orders ',
                      onTap: () async {
                        Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => OrdersPage(orderId: '',)
                      // OrderAcceptReject()
                    ),
                  );
                      },
                    ),

                    _buildListTile(
                      icon: Icons.access_alarms,
                      title: 'Accepted-Rejected',
                      onTap: () async {
                        Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) =>const OrderAcceptedRejectedTabs()
                      // OrderAcceptReject()
                    ),
                  );
                      },
                    ),
                    _buildListTile(
                      icon: Icons.favorite_border,
                      title: 'Profile',
                      onTap: () {
                        // Navigate to Favourites Screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) => ProfilePage()),
                        );
                      },
                    ),
                    _buildListTile(
                      icon: Icons.policy_outlined,
                      title: 'Terms & Policies',
                      onTap: () {
                        // Navigate to Terms & Policies Screen TermAndPolicies
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) => TermAndPolicies()),
                        );
                      },
                    ),

                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                color: const Color(0xffEAE4DD),
                child:  Center(
                  child: Text(
                    userProfileData['storeName'].toString().toUpperCase()+ '\tGroup\'s'.toUpperCase(), // Replace with your company name
                    style:const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
