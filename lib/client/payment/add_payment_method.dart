import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multivendor/client/pages/product_descryption.dart';
import 'package:multivendor/vendor/view/screen/dashbord.dart';

import '../pages/shopping_screen.dart';
import 'add_payment_method1.dart';
import 'bank_category.dart';
class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  late List<bool> isSelected1;

  @override
  void initState() {
    super.initState();
    isSelected1 = List.generate(3, (index) => false);// Initialize all items as not selected
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const  Color(0xff304a62),
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(onPressed: (){  Navigator.push(context, MaterialPageRoute(builder: (context)=>const ShoppingCartScreen()));},icon:const Icon(Icons.arrow_back,color: Colors.white,),),
              ),
      actions: [Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(onPressed: (){}, icon:const Text("skip",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
      )],
      ),
        backgroundColor: const Color(0xffEAE4DD),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right:
                    15,top: 10),
                    child: Row(
                      children: [
                    RichText(
                    text: TextSpan(children: [
                        TextSpan(text: 'Add your\n', style: GoogleFonts.lato(fontSize: 25,color:const Color(0xff252B5C))),
                      TextSpan(text: 'Payment method\n\n', style: GoogleFonts.lato(fontSize: 25,fontWeight: FontWeight.w900,color:const Color(0xff234F68))),
                      TextSpan(text: "You can edit this later on your account settings",style: GoogleFonts.poppins(fontSize: 14,color:const Color(0xff53587A)))
                      ]),)
                      ],
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                   Image.asset("assets/images/pngwing.com.png",height: 280,)
                  ],),
                  Padding(
                   padding: const EdgeInsets.only(left:10.0,right: 10.0),
                  child: Container(
                  height: 55,
                   child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: [
                        BankCategory(
                          press: () {
                            setState(() {
                              for (int i = 0; i < isSelected1.length; i++) {
                                isSelected1[i] = false;
                              }
                              isSelected1[0] = true; // Select the first item
                            });
                          },
                          title: "PayPal",
                          imagePath: "assets/images/Paypal - White.png",
                          isSelected: isSelected1[0], // Pass the selection state
                        ),
                        BankCategory(
                          press: () {
                            setState(() {
                              for (int i = 0; i < isSelected1.length; i++) {
                                isSelected1[i] = false;
                              }
                              isSelected1[1] = true; // Select the second item
                            });
                          },
                          title: "MasterCard",
                          imagePath: "assets/images/Mastercard - Normal.png",
                          isSelected: isSelected1[1], // Pass the selection state
                        ),
                        BankCategory(
                          press: () {
                            setState(() {
                              for (int i = 0; i < isSelected1.length; i++) {
                                isSelected1[i] = false;
                              }
                              isSelected1[2] = true; // Select the third item
                            });
                          },
                          title: "Visa",
                          imagePath: "assets/images/Visa - Normal.png",
                          isSelected: isSelected1[2], // Pass the selection state
                        ),
                      ],
                    ),
                  ],
                ),),
    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            suffixIcon: Icon(Icons.person_outline_rounded,color:Color(0xff252B5C) ,)
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              suffixIcon: Icon(Icons.email_outlined,color:Color(0xff252B5C))
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(bottom:100,left:0,right:0,child: Center(
              child: InkWell(
                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPaymentMethod1()));},

                child: Container(height: 60,width: 200,
                  decoration: BoxDecoration(
                      color: Color(0xff185A80),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text("Submit",style: GoogleFonts.poppins(fontSize: 20,color:Colors.white,fontWeight: FontWeight.bold ),),),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
