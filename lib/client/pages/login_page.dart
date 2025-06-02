import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multivendor/client/pages/register_page.dart';
import 'package:multivendor/client/pages/shopping_screen.dart';

import 'home_page.dart';

class LoginPageScreen extends StatefulWidget {
  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  bool _isLoading = false;
  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.toString(),
          password: _passwordController.text.toString(),
        );

        await Future.delayed(const Duration(seconds: 1)); // Simulate async operation
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ShoppingCartScreen()));
        clearForm();
      } catch (e) {
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
      backgroundColor: Color(0xffEAE4DD),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lamp Images at the top
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/light-1.png',
                  color:const Color(0xff5D7FA4),
                ),
                SizedBox(width: 5),
                Image.asset(
                  'assets/images/light-2.png',
                  color: Color(0xff445E7A),
                  height: 50, // Adjust the height according to your need
                ),
              ],
            ),
            const SizedBox(height: 10), // Small light between lamps and login card
            Container(
              width: 60,
              height: 30,
              decoration:const BoxDecoration(
                shape: BoxShape.circle, // Makes the container circular
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffDECFAD),
                    spreadRadius: 10, // Adjust the spread to control the blur effect
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            //  SizedBox(height: 20), // Space between the small light and login card

            // Login Form Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:const Color(0xffEAE4DD),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset:const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FadeInUp(
                        duration: const Duration(milliseconds: 1400),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email is required";
                            }
                            if (!value.contains("@")) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                          decoration:const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1600),
                        child: TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            if (value.length < 8) {
                              return "Password must be at least 8 characters";
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration:const InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeInUp(
                        duration: const Duration(milliseconds: 1800),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!_isLoading) {
                                _handleSignIn();
                              }
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor:const Color(0xff295F98),
                              padding:const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),

                            ),
                            child: _isLoading
                                ?const CircularProgressIndicator(color: Colors.white,)
                                :const Text('Login', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeInUp(
                        duration: const Duration(milliseconds: 2000),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                              child:const Text('Register', style: TextStyle(color: Color(0xff295F98))),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                // Handle forgot password
                              },
                              child:const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Color(0xff295F98)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
