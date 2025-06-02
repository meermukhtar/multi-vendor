
import 'dart:math'; // Importing dart:math for random number generation
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Polygon_Clipper extends StatefulWidget {
  final String label;
  final String image;
  final int sides; // Number of sides for the polygon
  final double borderRadius; // Border radius for the polygon
  final double rotate; // Rotation angle for the polygon

  Polygon_Clipper({
    super.key,
    required this.label,
    required this.image,
    this.sides = 6,
    this.borderRadius = 5.0,
    this.rotate = 90.0,
  });

  @override
  State<Polygon_Clipper> createState() => _Polygon_ClipperState();
}

class _Polygon_ClipperState extends State<Polygon_Clipper> {
  final _franchiseStream = FirebaseFirestore.instance.collection("Franchise").snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _franchiseStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SnackBar(
            content: Text('Failed to load, there was an error.'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text("Loading..", style: TextStyle(color: Colors.white),),
          );
        }
        var docs = snapshot.data?.docs; // Get franchise documents
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var index = 0; index < (docs?.length ?? 0); index++)
                if (docs?[index]['role'] == 'Vendor')
                // Fetch two random products from ProductCollection of each Vendor
                  FutureBuilder<List<Map<String, dynamic>>?>(
                    future: fetchRandomProducts(docs![index].id), // Pass the Franchise doc ID
                    builder: (context, productSnapshot) {
                      if (productSnapshot.hasError) {
                        return const Center(child:Text("Loading..", style: TextStyle(color: Colors.white),));
                      }

                      var products = productSnapshot.data;
                      if (products == null || products.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: ClipPolygon(
                                  sides: widget.sides,
                                  borderRadius: widget.borderRadius,
                                  rotate: widget.rotate,
                                  boxShadows: [
                                    PolygonBoxShadow(
                                      color: Colors.black,
                                      elevation: 1.0,
                                    ),
                                    PolygonBoxShadow(
                                      color: Colors.grey,
                                      elevation: 5.0,
                                    ),
                                  ],
                                  child: ClipPath(
                                    clipper: PolygonClipper(sides: widget.sides),
                                    child: Image.network(
                                      "https://th.bing.com/th/id/OIP.zvPJUmdZ-yeS1krbfltIkAHaHd?w=156&h=180&c=7&r=0&o=5&pid=1.7",
                                      fit: BoxFit.cover, // Cover image to fill the polygon shape
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'xyz',
                                style: GoogleFonts.abel(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: products.map((product) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: ClipPolygon(
                                      sides: widget.sides,
                                      borderRadius: widget.borderRadius,
                                      rotate: widget.rotate,
                                      boxShadows: [
                                        PolygonBoxShadow(
                                          color: Colors.black,
                                          elevation: 1.0,
                                        ),
                                        PolygonBoxShadow(
                                          color: Colors.grey,
                                          elevation: 5.0,
                                        ),
                                      ],
                                      child: ClipPath(
                                        clipper: PolygonClipper(sides: widget.sides),
                                        child: Image.network(
                                          product['imageProduct'],
                                          fit: BoxFit.cover, // Cover image to fit into polygon
                                          // width: 100,
                                          // height: 100,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    product['productName'].length > 6
                                        ? '${product['productName'].substring(0, 6)}...'
                                        : product['productName'],
                                    style: GoogleFonts.abel(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
            ],
          ),
        );
      },
    );
  }

  // Function to fetch two random products from a Vendor's ProductCollection
  Future<List<Map<String, dynamic>>?> fetchRandomProducts(String franchiseId) async {
    try {
      var productCollection = FirebaseFirestore.instance
          .collection('Franchise')
          .doc(franchiseId)
          .collection('ProductCollection');

      // Fetch all products for the vendor
      var productsSnapshot = await productCollection.get();

      if (productsSnapshot.docs.isEmpty) {
        print("No products found in ProductCollection for Franchise ID: $franchiseId");
        return null; // Return null if no products exist
      }

      // Use Dart's Random class for better randomness
      var random = Random();
      var randomProductDocs = <Map<String, dynamic>>[];

      // List to keep track of already selected product IDs to avoid duplicates
      var selectedProductIds = <String>[];

      // Fetch two unique random products
      while (randomProductDocs.length < 2 && randomProductDocs.length < productsSnapshot.docs.length) {
        var randomProductDoc = productsSnapshot.docs[random.nextInt(productsSnapshot.docs.length)];
        var productData = randomProductDoc.data() as Map<String, dynamic>;

        // Ensure the necessary fields exist and the product ID is not already selected
        if (productData['imageProduct'] != null &&
            productData['productName'] != null &&
            !selectedProductIds.contains(randomProductDoc.id)) {
          randomProductDocs.add(productData);
          selectedProductIds.add(randomProductDoc.id); // Add the ID to the selected list
        }
      }

      return randomProductDocs.isEmpty ? null : randomProductDocs;
    } catch (e) {
      print('Error fetching random products: $e');
      return null;
    }
  }
}

class PolygonClipper extends CustomClipper<Path> {
  final int sides;

  PolygonClipper({required this.sides});

  @override
  Path getClip(Size size) {
    final path = Path();
    final double angle = (2 * pi) / sides; // Angle between each vertex of the polygon

    for (int i = 0; i < sides; i++) {
      double x = size.width / 2 + (size.width / 2) * cos(i * angle);
      double y = size.height / 2 + (size.height / 2) * sin(i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper is PolygonClipper && oldClipper.sides != sides;
  }
}
