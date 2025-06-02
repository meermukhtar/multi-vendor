import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../model/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //get user stream

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("User_chat").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        //return user
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverId, message,) async {
    //get current user
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();
    if (kDebugMode) {
      print(currentUserEmail);
    }
    //create a message
    Message newMessage = Message(
        senderId: currentUserID,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);
    //construct chat room
    List<String> ids = [currentUserID, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    //add new message  to chat room
    await _firestore
        .collection('Chating')
        .doc(chatRoomId)
        .collection('message')
        .add(newMessage.toMap());
  }

  //get message


  Stream<QuerySnapshot> getMessage(String userId, otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('Chating')
        .doc(chatRoomId)
        .collection('message')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

