import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../vendor/location/location.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GeoLocation _geoLocation = GeoLocation();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoenNumber = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double? _latitude;
  double? _longitude;

  void clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _phoenNumber.clear();
    _userName.clear();
    _locationController.clear();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.toString(),
          password: _passwordController.text.toString(),
        );
        final String userId = userCredential.user!.uid;
        await FirebaseFirestore.instance
            .collection('usersProfile')
            .doc(userId)
            .set({
          'email': _emailController.text.toString(),
          'Username': _userName.text.toString(),
          'phone': _phoenNumber.text.toString(),
          'UserId': userId,
          'latitude': _latitude,
          'longitude': _longitude,
        });

        // Simulate async operation (e.g., sign in with Firebase)
        await Future.delayed(const Duration(seconds: 3));
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => LoginPageScreen()));
        clearForm();
      } catch (e) {
        // Display a Snackbar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _getLocation() async {
    try {
      Map<String, double> location = await _geoLocation.requestLocationPermission();
      setState(() {
        _latitude = location['latitude'];
        _longitude = location['longitude'];
        _locationController.text = 'Lat: ${_latitude}, Long: ${_longitude}';
      });
    } catch (e) {
      // Display a Snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Password Field obscureText Handler
  bool _isHidden = true;
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'REGISTER NOW',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xff295F98),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginPageScreen()));
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Card(
              color: Colors.white.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      TextFormField(
                        controller: _userName,
                        validator: (value) {
                          var availableValue = value ?? '';
                          if (availableValue.isEmpty) {
                            return 'Username is required';
                          }
                          if (availableValue.length < 3) {
                            return 'Username must be at least 3 characters long';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Username',
                          fillColor: Colors.transparent,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          var availableValue = value ?? '';
                          if (availableValue.isEmpty) {
                            return "Email is required";
                          }
                          if (!availableValue.contains("@") ||
                              !availableValue.endsWith("gmail.com")) {
                            return "Email should be a valid Gmail address";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          fillColor: Colors.transparent,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _phoenNumber,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: const Icon(Icons.phone),
                          fillColor: Colors.transparent,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 8) {
                            return "Password must be at least 8 characters long";
                          }
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return "Password must contain at least one uppercase letter";
                          }
                          if (!value.contains(RegExp(r'[a-z]'))) {
                            return "Password must contain at least one lowercase letter";
                          }
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return "Password must contain at least one numeric character";
                          }
                          if (!value.contains(
                              RegExp(r'[!@#\$%^&*()<>?/|}{~:]'))) {
                            return "Password must contain at least one special character";
                          }
                          return null;
                        },
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: _isHidden
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: _toggleVisibility,
                          ),
                          fillColor: Colors.transparent,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _locationController,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Location is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Location',
                          prefixIcon: const Icon(Icons.location_on),
                          fillColor: Colors.transparent,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onTap: _getLocation,
                      ),
                      const SizedBox(height: 30.0),
                      ElevatedButton(
                        onPressed: _handleSignUp,
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
