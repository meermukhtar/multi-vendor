import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../service/microphone.dart';
import '../service/order_number.dart';
import '../service/separate_user.dart';

class UploadedProductFields extends StatefulWidget {
  final String productName;
  final String price;
  final String discountedPrice;
  final String description;
  final String imageProduct;
  final String productId;

  const UploadedProductFields({
    Key? key,
    required this.productName,
    required this.price,
    required this.discountedPrice,
    required this.description,
    required this.imageProduct,
    required this.productId,
  }) : super(key: key);

  @override
  _UploadedProductFieldsState createState() => _UploadedProductFieldsState();
}

OrderNumberGenerator _OrderNumberGenerator = OrderNumberGenerator();

class _UploadedProductFieldsState extends State<UploadedProductFields> {
  File? _imageFile;
  ImagePicker _picker = ImagePicker();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _productId = TextEditingController();
  ButtonState state = ButtonState.init;

  Future<void> _showImageSourceOptions() async {
    showModalBottomSheet(
      backgroundColor: Colors.grey,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .13,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    setState(() {
                      _imageFile = File(pickedImage.path);
                    });
                    print("Picked image path: ${pickedImage.path}");
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context); // Close the bottom sheet
                  final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _imageFile = File(pickedImage.path);
                    });
                    print("Picked image path: ${pickedImage.path}");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void _uploadDataToFirebase() async {
    if (_imageFile == null ||
        _productNameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _productId.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Missing product information",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    // Ensure the user is authenticated
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Fluttertoast.showToast(
        msg: "You must be logged in to upload data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      state = ButtonState.loading;
    });

    try {
      // Upload image to Firebase Storage
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(_imageFile!);
      String imageUrl = await ref.getDownloadURL();
      print("Image uploaded successfully: $imageUrl");

      // Upload product data
      ProductUploadService productUploadService = ProductUploadService();
      await productUploadService.uploadProduct(
        _productNameController.text,
        _priceController.text,
        _descriptionController.text,
        imageUrl,
        // _productId.text, // Include the product ID if necessary
      );
      print("Product data uploaded successfully");

      Fluttertoast.showToast(
        msg: "Product uploaded successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      clear();
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error uploading product: $error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        state = ButtonState.init;
      });
    }
  }


  void clear() {
    _productNameController.clear();
    _priceController.clear();
    _productId.clear();
    _descriptionController.clear();
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool isDone = state == ButtonState.done;
    bool isStretch = state == ButtonState.init;

    return Column(
      children: [
        GestureDetector(
          onTap: _showImageSourceOptions, // Open bottom sheet for image selection
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              // color:const Color(0xffEAE4DD),
              boxShadow:const [
                BoxShadow(color: Colors.black,spreadRadius: .5,blurRadius: 4)
              ]
            ),
            child: _imageFile != null
                ? Image.file(
              _imageFile!,
              fit: BoxFit.contain,
            )
                : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Upload Data"),
                  Text(
                    "Make sure your image is clear",
                    style: TextStyle(color: Colors.black45, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: "Product Name",
                  border: const OutlineInputBorder(),
                  suffixIconColor: Colors.indigo,
                  suffixIcon: IconButton(
                    onPressed: () {
                      SpeechToTextField(_productNameController, () {
                        setState(() {});
                      }).listen();
                    },
                    icon: const Icon(FontAwesomeIcons.microphoneSlash),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.none,
          controller: _productId,
          // enabled: false,
          onTap: () {
            setState(() {
              _productId.text = _OrderNumberGenerator.generateProductId();
            });
          },
          decoration: const InputDecoration(
            labelText: "Key",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          maxLines: null,
          decoration: InputDecoration(
            suffixIconColor: Colors.indigo,
            suffixIcon: IconButton(
              onPressed: () {
                SpeechToTextField(_descriptionController, () {
                  setState(() {});
                }).listen();
              },
              icon: const Icon(FontAwesomeIcons.microphoneSlash),
            ),
            labelText: "Description",
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: state == ButtonState.init ? width : 70,
          height: 70,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isStretch ? _buildButton() : _buildSmallButton(isDone),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallButton(bool isDone) {
    Color color = isDone ? Colors.green : Colors.indigo;
    return Center(
      child: isDone
          ? Icon(
        Icons.done_all_sharp,
        size: 50,
        color: color,
      )
          : const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  Widget _buildButton() => OutlinedButton(
    onPressed: _uploadDataToFirebase,
    style: OutlinedButton.styleFrom(
      elevation: 5,
      backgroundColor:const Color( 0xff304a62),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Set border radius to 10
      ),
      // side: const BorderSide(width: 2, color: Colors.indigo),
    ),
    child: const Text(
      "Submit",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 15
      ),
    ),
  );
}

enum ButtonState { init, loading, done }
