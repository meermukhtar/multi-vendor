import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../chat/floating_chat_button.dart';
import '../../../client/utils/constant.dart';
import '../../service/separate_user.dart';
import '../../service/swapping_analysis.dart';
import '../widgets/charts.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../widgets/drawer.dart';
import '../widgets/product_list.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  ColorsList colorsList = ColorsList();
  TextStyling textStyling = TextStyling();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  SwappingAnalysis swap=SwappingAnalysis();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    swap.getTotalOrder();

    // Listen to changes in OrderCollections to update in real-time
    swap.listenToOrderChanges();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAE4DD),
      floatingActionButton: const FloatingChatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,

      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff304a62),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the drawer icon color to white
        ),
        elevation: 0.5,
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: CustomBottomNavBar(color: Colors.white,
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CheckOuts",
                style: textStyling.headingTextStyle,
              ),
              const SizedBox(height: 16),
              // // AddsCardContainer(),
              // const SizedBox(height: 16),
              const MyCharts(),
             // const SizedBox(height: 16),
              // Text(
              //   "Your Added Products",
              //   style: textStyling.headingTextStyle,
              // ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    MyProductList(),
                    const SizedBox(width: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
