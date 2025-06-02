import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:get/get.dart';
import 'package:multivendor/Notification/services/notification_service.dart';
import 'package:multivendor/vendor/pages/email_verification_page.dart';
import 'package:multivendor/vendor/pages/tabview_selection.dart';
import 'package:multivendor/vendor/pages/login.dart';
import '../../client/location/location.dart';
import '../../client/utils/constant.dart';
import '../service/separate_user.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  ColorsList colorsList = ColorsList();
  TextStyling textStyling = TextStyling();
  bool _isPasswordVisible = false;
  bool _isRePasswordVisible = false;
  GeoLocation _geoLocation = GeoLocation();

  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final String DeviceToken="";
  double? _latitude;
  double? _longitude;

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _selectedRole = 'Vendor'; // Default role is 'Vendor'
  final List<String> _roles = ['Vendor', 'Shop Keeper']; // Available roles

  void clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _rePasswordController.clear();
    _storeNameController.clear();
    _locationController.clear();
  }

  Future<void> _handleSignUp() async {
    NotificationService notificationService=NotificationService();
    if (_formKey.currentState!.validate()) {
      try {
        // Create user in Firebase Authentication
        final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
       await userCredential.user?.sendEmailVerification();
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const EmailVerificationPage()));
        final String userId = userCredential.user!.uid;

        // Use FireStoreService to create user profile
        await FireStoreService().createUserProfile(
          userCredential.user!,
          _storeNameController.text.trim(),
          _latitude!,
          _longitude!,
          _selectedRole,
           await notificationService.getDeviceToken()
        );

        // Navigate to the selection page
        Get.to(() => const SelectionPage());

        // Clear the form fields
        clearForm();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // Display error message in case of failure
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
        _locationController.text = 'Lat: $_latitude, Long: $_longitude';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAE4DD),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Store name is required";
                    }
                    return null;
                  },
                  controller: _storeNameController,
                  decoration: const InputDecoration(
                    labelText: 'Store Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.storefront_sharp),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(

                  keyboardType: TextInputType.emailAddress,  // Ensuring proper keyboard
                  textAlign: TextAlign.start,  // Align text properly
                  readOnly: false,  // Ensure it's not read-only
                  enableInteractiveSelection: true,  // Enable selection of individual letters
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!value.contains("@")) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.none,
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
                const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: InputDecoration(
                labelText: 'Select Role',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
               //   borderSide: const BorderSide(color: Colors.blue), // Outline border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
               //   borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0), // Focused border color
                ),
                labelStyle: const TextStyle(color: Colors.black), // Label text color
              ),
              dropdownColor: Colors.white, // Dropdown menu background color
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue!;
                });
              },
              items: _roles.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(
                    role,
                    style: const TextStyle(color: Colors.black), // Dropdown item text color
                  ),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Role selection is required";
                }
                return null;
              },
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
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please re-enter your password";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  controller: _rePasswordController,
                  obscureText: !_isRePasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Re-enter Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isRePasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isRePasswordVisible = !_isRePasswordVisible;
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
                    return null; // Password is valid
                  },
                ),
                const SizedBox(height: 20),
                // Dropdown to select role

                Center(
                  child:
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Apply border radius of 10 to all sides
                      ),
                      shadowColor: Colors.black,
                      elevation: 10,
                      disabledForegroundColor: Colors.grey.withOpacity(0.38),
                      disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                      backgroundColor:const Color( 0xff304a62),
                      minimumSize: const Size(400, 50),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 120),
                    ),
                    onPressed: _handleSignUp,
                    child: const Text("SignUp",style: TextStyle(color: Colors.white),),
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
