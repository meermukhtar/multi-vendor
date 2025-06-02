import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multivendor/vendor/pages/upload_product_field.dart';

import '../../client/utils/constant.dart';
import '../view/screen/dashbord.dart';
import '../view/widgets/drawer.dart';


class FranchiseUploadedData extends StatelessWidget {
  const FranchiseUploadedData({super.key});

  @override
  Widget build(BuildContext context) {
    ColorsList clrList = ColorsList();
    return Scaffold(
      backgroundColor:const Color(0xffEAE4DD),
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Upload Data",style: TextStyle(color: Colors.white),),
        backgroundColor:const Color( 0xff304a62),
        leading:  IconButton(onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (_) => const DashBoardScreen()));}, icon: Icon(Icons.arrow_back,color: Colors.white,),),
      ),
      drawer:const IconTheme(
          data:  IconThemeData(color: Colors.white),
          child:  MyDrawer()),
      body:  const Padding(
        padding:EdgeInsets.only(left: 20, right: 20, top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              //Product details
              UploadedProductFields(productName: '', price: '', discountedPrice: '', description: '', imageProduct: '', productId: '',),

            ],
          ),
        ),
      ),
    );
  }
}
