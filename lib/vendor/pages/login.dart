
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:get/get.dart';
import 'package:multivendor/client/pages/home_page.dart';
import 'package:multivendor/client/pages/shopping_screen.dart';

import '../../client/utils/constant.dart';
import '../view/screen/dashbord.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void clearForm() {
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Sign in with Firebase Authentication
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.toString(),
          password: _passwordController.text.toString(),
        );

        // Now query Firestore to find the role based on email
        QuerySnapshot franchiseSnapshot = await _firestore
            .collection('Franchise')
            .where('email', isEqualTo: _emailController.text)
            .get();

        if (franchiseSnapshot.docs.isNotEmpty) {
          // Assuming email is unique in the 'Franchise' collection
          var userDoc = franchiseSnapshot.docs.first;
          String role = userDoc['role'] ?? '';  // Get the role from the document

          // Check the role and navigate accordingly
          if (role == 'Vendor') {
             if(FirebaseAuth.instance.currentUser!=null){
              Get.to(() =>const DashBoardScreen());
             }
              // Navigate to Vendor Screen
          } else if (role == 'Shop Keeper') {
             if(FirebaseAuth.instance.currentUser!=null){
              Get.to(() =>const ShoppingCartScreen());
             }
              // Navigate to Shopkeeper Screen
          } else {
            // If role is not 'Vendor' or 'Shop Keeper', handle accordingly
            ScaffoldMessenger.of(context).showSnackBar(
            const  SnackBar(
                content: Text('Unknown role for this user'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          // If no matching email is found in the 'Franchise' collection
          ScaffoldMessenger.of(context).showSnackBar(
            const   SnackBar(
              content: Text('No user found with this email'),
              backgroundColor: Colors.red,
            ),
          );
        }

        clearForm();
      } catch (e) {
        // Display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xffEAE4DD),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign in",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Stay Updated on your Professional World",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.start,  // Align text properly
                  readOnly: false,  // Ensure it's not read-only
                  enableInteractiveSelection: true,  // Enable selection of individual letters
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!value.contains("@") || !value.contains("gmail.com")) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FlutterPwValidator(
                  controller: _passwordController,
                  minLength: 8,
                  uppercaseCharCount: 1,
                  lowercaseCharCount: 1,
                  numericCharCount: 1,
                  specialCharCount: 1,
                  width: 200,
                  height: 150,
                  onSuccess: () {
                    return null; // Password is valid.
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // TextButton(
                    //   onPressed: () {
                    //     // Handle Forgot Password
                    //   },
                    //   child: const Text(
                    //     'Forgot Password?',
                    //     style: TextStyle(
                    //         color: Colors.blue), // Adjust the text style as needed
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child:
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Apply border radius of 10 to all sides
                      ),
                      backgroundColor: const Color(0xff304a62),
                      disabledForegroundColor: Colors.grey.withOpacity(0.38),
                      disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                      elevation: 10,
                      minimumSize: const Size(400, 50), // Ensures both buttons are same size
                      shadowColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 120),
                    ),
                    onPressed: _handleSignIn,
                    child: const Text("Sign In", style: TextStyle(color: Colors.white)),
                  ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
