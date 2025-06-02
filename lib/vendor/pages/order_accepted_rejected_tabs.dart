import 'package:flutter/material.dart';
import 'package:multivendor/vendor/pages/rejected_order.dart';
import 'package:multivendor/vendor/view/screen/dashbord.dart';

import '../../client/utils/constant.dart';
import 'accepted_order.dart';



class OrderAcceptedRejectedTabs extends StatefulWidget {
  const OrderAcceptedRejectedTabs({Key? key}) : super(key: key);

  @override
  _OrderAcceptedRejectedTabsState createState() => _OrderAcceptedRejectedTabsState();
}

class _OrderAcceptedRejectedTabsState extends State<OrderAcceptedRejectedTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ColorsList colorsList=ColorsList();
  TextStyling textStyling=TextStyling();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xffEAE4DD),
      appBar: AppBar(
        backgroundColor: const Color(0xffEAE4DD),
        // automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => DashBoardScreen(),
            transitionDuration: Duration(seconds: 0), // No animation
          ),
        );
        },icon: Icon(Icons.arrow_back,color: Colors.black,),),
        bottom: TabBar(
          dividerColor:
          Colors.black,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.person_add), // Icon for Sign Up
              child: Text('Accepted', style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            Tab(
              icon: Icon(Icons.person), // Icon for Sign In
              child: Text('Rejected', style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:const <Widget>[

          AcceptedOrder(),
          RejectedOrder(),

        ],
      ),
    );
  }
}
