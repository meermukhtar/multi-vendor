// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:multivendor/chat/service/chat_service.dart';
// import 'package:multivendor/vendor/view/screen/dashbord.dart';
// import 'chating_page.dart';
//
// class ChatUserAvailable extends StatelessWidget {
//   ChatUserAvailable({super.key});
//
//   // Chat auth services
//   final ChatService _chatService = ChatService();
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffEAE4DD),
//       appBar: AppBar(
//         backgroundColor: const Color(0xff304a62),
//         title: const Text(
//           "Check and swap",
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const DashBoardScreen()),
//             );
//           },
//           icon: const Icon(
//             Icons.arrow_back_outlined,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: _buildUserList(),
//     );
//   }
//
//   // Build the DataTable for user list
//   Widget _buildUserList() {
//     return StreamBuilder(
//       stream: _chatService.getUserStream(),
//       builder: (context, snapshot) {
//         // Handle errors and empty state
//         if (snapshot.hasError) {
//           print("Error ${snapshot.error}");
//           return const Center(child: Text("An error occurred"));
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: Text("Loading users..."));
//         }
//
//         // Check if there is no data
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text("No users available"));
//         }
//
//         // Return DataTable with the user data
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Padding(
//             padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
//             child: DataTable(
//               border: TableBorder.all(),
//               columns: const [
//                 DataColumn(label: Text('Store Name')),
//                 DataColumn(label: Text('High Demanding')),
//                 DataColumn(label: Text('Low Demanding')),
//               ],
//               rows: snapshot.data!
//                   .where((userData) =>
//               userData['user_id'] != FirebaseAuth.instance.currentUser!.uid) // Exclude current user
//                   .map<DataRow>((userData) => DataRow(
//                 cells: [
//                   // Inside _buildUserList() method
//                   DataCell(
//                     Text(userData['storeName'] ?? 'Unknown Store'),
//                     onTap: () {
//                       // Navigate to the ChatingPage for the selected user
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => ChatingPage(
//                             receiverEmail: userData['email'],
//                             receiverId: userData['user_id'], // Pass the user_id (receiverId)
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   DataCell(FutureBuilder<DocumentSnapshot>(
//                     future: _db
//                         .collection('ProductAnalysis')
//                         .doc(userData['user_id'])
//                         .get(),
//                     builder: (context, productAnalysisSnapshot) {
//                       if (productAnalysisSnapshot.connectionState == ConnectionState.waiting) {
//                         return const Text("Loading...");
//                       }
//                       if (productAnalysisSnapshot.hasError) {
//                         return const Text("Error");
//                       }
//                       if (productAnalysisSnapshot.hasData) {
//                         var productAnalysisData =
//                         productAnalysisSnapshot.data?.data() as Map<String, dynamic>?;
//                         if (productAnalysisData == null) {
//                           return const Text('0');
//                         }
//                         String highDemanding = productAnalysisData['highDemanding'] ?? 'Not Available';
//                         return Text(highDemanding.toUpperCase());
//                       } else {
//                         return const Text('Not Available');
//                       }
//                     },
//                   )),
//                   DataCell(FutureBuilder<DocumentSnapshot>(
//                     future: _db
//                         .collection('ProductAnalysis')
//                         .doc(userData['user_id'])
//                         .get(),
//                     builder: (context, productAnalysisSnapshot) {
//                       if (productAnalysisSnapshot.connectionState == ConnectionState.waiting) {
//                         return const Text("Loading...");
//                       }
//                       if (productAnalysisSnapshot.hasError) {
//                         return const Text("Error");
//                       }
//                       if (productAnalysisSnapshot.hasData) {
//                         var productAnalysisData =
//                         productAnalysisSnapshot.data?.data() as Map<String, dynamic>?;
//                         if (productAnalysisData == null) {
//                           return const Text('0');
//                         }
//                         String lowDemanding = productAnalysisData['lowDemanding'] ?? 'Not Available';
//                         return Text(lowDemanding.toUpperCase());
//                       } else {
//                         return const Text('Not Available');
//                       }
//                     },
//                   )),
//                 ],
//               ))
//                   .toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multivendor/chat/service/chat_service.dart';
import 'package:multivendor/vendor/view/screen/dashbord.dart';
import 'chating_page.dart';

class ChatUserAvailable extends StatelessWidget {
  ChatUserAvailable({super.key});

  // Chat auth services
  final ChatService _chatService = ChatService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAE4DD),
      appBar: AppBar(
        backgroundColor: const Color(0xff304a62),
        title: const Text(
          "Check and swap",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashBoardScreen()),
            );
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: StreamBuilder(
          stream: _chatService.getUserStream(), // Your stream
          builder: (context, snapshot) {
            // Handle errors and empty state
            if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
              return const Center(child: Text("An error occurred"));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Loading users..."));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No users available"));
            }

            // Return DataTable with the user data
            return Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start, // Align the content to the top
                crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 12, // You can adjust the column spacing
                        border: TableBorder.all(),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Store Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'High Demanding',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Low Demanding',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: snapshot.data!
                            .where((userData) =>
                        userData['user_id'] != FirebaseAuth.instance.currentUser!.uid) // Exclude current user
                            .map<DataRow>((userData) => DataRow(
                          cells: [
                            DataCell(
                              // Store Name with multi-line support
                              Text(
                                userData['storeName'] ?? 'Unknown Store',
                                maxLines: 2, // Limit to two lines if needed
                                overflow: TextOverflow.ellipsis, // Ensure no overflow
                              ),
                              onTap: () {
                                // Navigate to the ChatingPage for the selected user
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatingPage(
                                      receiverEmail: userData['email'],
                                      receiverId: userData['user_id'], // Pass the user_id (receiverId)
                                    ),
                                  ),
                                );
                              },
                            ),
                            DataCell(
                              // High Demanding Products with multi-line support
                              FutureBuilder<DocumentSnapshot>(
                                future: _db
                                    .collection('ProductAnalysis')
                                    .doc(userData['user_id'])
                                    .get(),
                                builder: (context, productAnalysisSnapshot) {
                                  if (productAnalysisSnapshot.connectionState == ConnectionState.waiting) {
                                    return const Text("Loading...");
                                  }
                                  if (productAnalysisSnapshot.hasError) {
                                    return const Text("Error");
                                  }
                                  if (productAnalysisSnapshot.hasData) {
                                    var productAnalysisData =
                                    productAnalysisSnapshot.data?.data() as Map<String, dynamic>?;
                                    if (productAnalysisData == null) {
                                      return const Text('0');
                                    }
                                    String highDemanding =
                                        productAnalysisData['highDemanding'] ?? 'Not Available';
                                    return Text(
                                      highDemanding.toUpperCase(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis, // Avoid overflow
                                    );
                                  } else {
                                    return const Text('Not Available');
                                  }
                                },
                              ),
                            ),
                            DataCell(
                              // Low Demanding Products with multi-line support
                              FutureBuilder<DocumentSnapshot>(
                                future: _db
                                    .collection('ProductAnalysis')
                                    .doc(userData['user_id'])
                                    .get(),
                                builder: (context, productAnalysisSnapshot) {
                                  if (productAnalysisSnapshot.connectionState == ConnectionState.waiting) {
                                    return const Text("Loading...");
                                  }
                                  if (productAnalysisSnapshot.hasError) {
                                    return const Text("Error");
                                  }
                                  if (productAnalysisSnapshot.hasData) {
                                    var productAnalysisData =
                                    productAnalysisSnapshot.data?.data() as Map<String, dynamic>?;
                                    if (productAnalysisData == null) {
                                      return const Text('0');
                                    }
                                    String lowDemanding =
                                        productAnalysisData['lowDemanding'] ?? 'Not Available';
                                    return Text(
                                      lowDemanding.toUpperCase(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis, // Avoid overflow
                                    );
                                  } else {
                                    return const Text('Not Available');
                                  }
                                },
                              ),
                            ),
                          ],
                        ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


