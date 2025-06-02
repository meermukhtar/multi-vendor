

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:multivendor/vendor/pages/profile.dart';

import '../../client/utils/constant.dart';
import '../view/screen/dashbord.dart';
import 'frenchise_data_upload.dart';

class FranchiseAdminUpdateData extends StatelessWidget {
  FranchiseAdminUpdateData({super.key});
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ColorsList clrList = ColorsList();
    return Scaffold(
      backgroundColor: clrList.backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xff295F98),
        title: Text(Get.arguments['productName'].toString()),
        actions: [
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Upload"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Profile"),
                  ),
                ];
              }, onSelected: (value) {
            if (value == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const FranchiseUploadedData()));
            } else if (value == 1) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfilePage()));

              if (kDebugMode) {
                print("Settings menu is selected.");
              }
            } else if (value == 2) {
              if (kDebugMode) {
                print("Logout menu is selected.");
              }
            }
          }),
        ],
      ),
      //   drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Wrap(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _itemNameController
                    ..text = "${Get.arguments['productName']}",
                  decoration: const InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _priceController
                    ..text = Get.arguments['price'].toString(),
                  decoration: const InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple,
                      disabledForegroundColor: Colors.grey.withOpacity(0.38),
                      disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                      side: const BorderSide(color: Colors.black, width: 1),
                      elevation: 20,
                      minimumSize: const Size(150, 50),
                      shadowColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 120)),
                  onPressed: () async {
                    String id = Get.arguments['id']
                        .toString(); // Accessing the ID from arguments
                    print(id);
                    try {
                      await FirebaseFirestore.instance
                          .collection('products')
                          .doc(id)
                          .update({
                        'productName': _itemNameController.text.toString(),
                        'price': _priceController.text.toString(),
                        // Add your fields to update here
                      });
                      // Handle success
                      print('Data updated successfully!');
                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DashBoardScreen()));
                      });
                    } catch (error) {
                      // Handle error
                      print('Error updating data: $error');
                    }
                  },
                  child: const Text("Button"),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
