import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//for each new user

class FireStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserProfile(User user, String franchiseName, double latitude, double longitude, String role, String DeviceToke) async {
    // Create the base user profile in the 'Franchise' collection
    await _db.collection('Franchise').doc(user.uid).set({
      'email': user.email,
      'storeName': franchiseName,
      'latitude': latitude,
      'longitude': longitude,
      'role': role,
      'DeviceToke': DeviceToke
    });

    // Only create 'ProductCollection' and 'OrderCollection' if the role is 'Vendor'
    if (role == 'Vendor') {
      await _db
          .collection('Franchise')
          .doc(user.uid)
          .collection('ProductCollection')
          .add({});
      await _db
          .collection('Franchise')
          .doc(user.uid)
          .collection('OrderCollection')
          .add({});

      await _db.collection("User_chat").doc().set(
        {
        'email':user.email,
        'storeName':franchiseName,
        'user_id':user.uid
        }
      );
    }
  }
}
class ProductUploadService {
  Future<String> uploadProduct(String productName, String price,
      String description, String imageProduct) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference productRef = await _db
          .collection('Franchise')
          .doc(user.uid)
          .collection('ProductCollection')
          .add({
        'productName': productName,
        'price': price,
        'description': description,
        'imageProduct': imageProduct,
      });

      // Update the productId field with the document ID
      await productRef.update({'productId': productRef.id});
      return productRef.id;
    }
    return '';
  }
}

class ProductFetchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Product>> getUserProducts() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _db
          .collection('Franchise')
          .doc(user.uid)
          .collection('ProductCollection')
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList());

    } else {
      return Stream.empty();
    }
  }
}
class Product{
  final String productName;
  final String imageProduct;
  final String price;
  final String description;
  final String productId;
  final String id;
  Product(
      {required this.productName,
        required this.imageProduct,
        required this.price,
        required this.description,
        required this.productId,
        required this.id

      });
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Product(
      id: doc.id, // Get the document ID
      productName: data['productName'] ?? '',
      imageProduct: data['imageProduct'] ?? '',
      price: data['price'] ?? '',
      description: data['description'] ?? '',
      productId: 'productId' ?? '',
    );
  }
}
//user auth service
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteProduct(User user) async {
    await FirebaseFirestore.instance
        .collection('Franchise')
        .doc(user.uid)
        .collection('ProductCollection')
        .doc(user.uid)
        .delete();
  }
}
