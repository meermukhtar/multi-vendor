
import 'package:flutter/material.dart';
import 'package:multivendor/vendor/pages/login.dart';
import 'package:multivendor/vendor/pages/register.dart';

import '../../client/utils/constant.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({Key? key}) : super(key: key);

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ColorsList colorsList=ColorsList();
  TextStyling textStyling=TextStyling();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 1, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: const Color(0xffEAE4DD),
      appBar: AppBar(
        backgroundColor: const Color(0xffEAE4DD),
        // automaticallyImplyLeading: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: Icon(Icons.arrow_back,color: Colors.black,),),
        bottom: TabBar(
          dividerColor:
          Colors.black,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.person_add), // Icon for Sign Up
              child: Text('Sign Up', style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            Tab(
              icon: Icon(Icons.person), // Icon for Sign In
              child: Text('Sign In', style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SignUpPage(),
          const SignInPage(),
        ],
      ),
    );
  }
}
