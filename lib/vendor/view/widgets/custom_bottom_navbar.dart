import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../client/splash_screen/fase_in_splash.dart';
import '../../../client/utils/constant.dart';
import '../../pages/frenchise_data_upload.dart';
import '../../service/separate_user.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Color color; // This is the color you want to pass for the button.

  CustomBottomNavBar({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    ColorsList colorsList = ColorsList();
    TextStyling textStyling = TextStyling();
    final AuthService _authService = AuthService();
    void _showSignOutDialog(BuildContext context) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Sign Out', style: textStyling.headingTextStyle),
            content: Text(
              'Are you sure you want to sign out?',
              style: textStyling.textStyle,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  'Cancel',
                  style: textStyling.headingTextStyle.copyWith(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context); // Dismiss the dialog
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  'Confirm',
                  style: textStyling.headingTextStyle.copyWith(color: Colors.green),
                ),
                onPressed: () {
                  // Log out the user if confirmed
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Log Out Success",
                      style: textStyling.headingTextStyle,
                    ),
                    backgroundColor: colorsList.backgroundColor,
                  ));
                  _authService.signOut();
                  Future.delayed(const Duration(seconds: 0), () {
                    Get.to(() => FadeInSplash());
                  });
                },
              ),
            ],
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color with some opacity
            blurRadius: 8, // Blur radius from Figma
            spreadRadius: 0, // Spread radius from Figma
            offset: const Offset(0, 0), // X and Y offsets from Figma
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomAppBar(
          color: const Color(0xffEAE4DD), // Set the BottomAppBar color to white
          shape: const CircularNotchedRectangle(), // Creates the curved notch
          notchMargin: 8, // Margin around the notch
          elevation: 100, // Set elevation to 0 to rely on boxShadow
          child: Padding(
            padding: const EdgeInsets.only(left: 50,right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // "Add Folder Button" or some other button

                InkWell(
                  onTap: () {
                    // Handle the folder button tap
                    print("Folder button tapped");

                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>const  FranchiseUploadedData(),
                        transitionDuration: Duration.zero, // No animation
                      ),
                    );
                  },
                  child: const Image(image: AssetImage("assets/images/upload.png"),width: 50,height: 50),
                ),

               // const SizedBox(width: 50),
                InkWell(
                  onTap: () {
                    print("Log out button tapped");
                    _showSignOutDialog(context);
                    // // Handle the folder button tap
                    // print("Folder button tapped");
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   content: Text(
                    //     "Log Out Success",
                    //     style: textStyling.headingTextStyle,
                    //   ),
                    //   backgroundColor: colorsList.backgroundColor,
                    // ));
                    // _authService.signOut();
                    // Future.delayed(const Duration(seconds: 2));
                    // Get.to(() =>  FadeInSplash());
                  },

                    child: const Image(image: AssetImage("assets/images/icons8-log-out-64.png"),width: 50,height: 50,)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
