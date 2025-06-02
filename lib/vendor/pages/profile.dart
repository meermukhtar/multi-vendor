import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../client/utils/constant.dart';
import '../view/screen/dashbord.dart';

class ProfilePage extends StatelessWidget {
  // Fetch user data from Firestore
  Future<Map<String, dynamic>> _getUserData() async {
    // Get the current user ID (you can adjust this depending on your auth method)
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user data from the 'Franchise' collection based on the current user ID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Franchise')
          .doc(user.uid)  // Assuming each franchise document is identified by the user ID
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Error loading profile data"));
        }

        // Extract the user data
        Map<String, dynamic> userData = snapshot.data!;

        return Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xff304a62),
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const DashBoardScreen()));
              },
            ),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Header Section with 50% gradient
                Container(
                  height: MediaQuery.of(context).size.height * 0.2, // 35% of screen height
                  width: MediaQuery.of(context).size.width * 4, // 90% width
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff295F98),
                        Color.fromARGB(255, 66, 107, 150),
                        Color.fromARGB(255, 187, 164, 138),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile Picture Section
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Color(0xff295F98),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userData['storeName'] ?? 'No Store Name',  // Store Name from Firestore
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Profile Details Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: ListView(
                      children: [
                        ProfileCard(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: userData['email'] ?? 'Not Available',  // Email from Firestore
                        ),
                        ProfileCard(
                          icon: Icons.store_mall_directory_outlined,
                          title: 'Store Name',
                          value: userData['storeName'] ?? 'Not Available',
                        ),
                        ProfileCard(
                          icon: Icons.location_on_outlined,
                          title: 'Latitude',
                          value: userData['latitude']?.toString() ?? 'Not Available',
                        ),
                        ProfileCard(
                          icon: Icons.location_on,
                          title: 'Longitude',
                          value: userData['longitude']?.toString() ?? 'Not Available',
                        ),
                        ProfileCard(
                          icon: Icons.verified_user_outlined,
                          title: 'Role',
                          value: userData['role'] ?? 'Not Available',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xff295F98),
                Color.fromARGB(255, 66, 107, 150),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
