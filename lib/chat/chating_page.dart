import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multivendor/chat/service/auth_service.dart';
import 'package:multivendor/chat/service/chat_service.dart';
import 'package:uuid/uuid.dart';

import 'chat_user_available.dart';

class ChatingPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const ChatingPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  @override
  _ChatingPageState createState() => _ChatingPageState();
}

class _ChatingPageState extends State<ChatingPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthServices _authService = AuthServices();

  bool _isButtonEnabled = false;
  File? imgFile;
  File? video;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();
    super.dispose();
  }


  Future<void> uploadVideo() async {
    String fileNameVideo = const Uuid().v1();
    var ref = FirebaseStorage.instance
        .ref()
        .child('messageVideos')
        .child('$fileNameVideo.mp4');
    var uploadVideo = await ref.putFile(video!);
    String videoUrl = await uploadVideo.ref.getDownloadURL();
    await _chatService.sendMessage(widget.receiverId, videoUrl);
    print('This is the video send Url  $videoUrl');
  }

  Future<void> imagePicker() async {
    ImagePicker picker = ImagePicker();
    // XFile? xFile = await picker.pickVideo(source: ImageSource.gallery);
    XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      setState(() {
        imgFile = File(xFile.path);
        _showImagePreview(); // Show image preview
      });
    }
  }

  Future<void> _showImagePreview() async {
    if (imgFile != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Preview Image'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(
                  imgFile!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                TextButton(
                  child: const Text('Send'),
                  onPressed: () {
                    senderMessage();
                    Navigator.of(context).pop(); // Close the preview dialog
                    _onMessageChanged(); // Update button state
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      imgFile = null; // Discard the selected image
                      _onMessageChanged(); // Update button state
                    });
                    Navigator.of(context).pop(); // Close the preview dialog
                  },
                ),
              ],
            ),
          );
        },
      );
    } else if (video != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Preview Video'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                TextButton(
                  child: const Text('Send'),
                  onPressed: () {
                    senderMessage();
                    Navigator.of(context).pop(); // Close the preview dialog
                    _onMessageChanged(); // Update button state
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> uploadImage() async {
    String filename = const Uuid().v1();
    var ref = FirebaseStorage.instance
        .ref()
        .child('messageImages')
        .child('$filename.jpg');
    var uploadTask = await ref.putFile(imgFile!);
    String imgUrl = await uploadTask.ref.getDownloadURL();
    await _chatService.sendMessage(widget.receiverId, imgUrl);
    print("This is the img url $imgUrl");
  }

  void _onMessageChanged() {
    setState(() {
      _isButtonEnabled = _messageController.text.isNotEmpty ||
          imgFile != null ||
          video != null;
    });
  }

  Future<void> senderMessage() async {
    if (_messageController.text.isNotEmpty ||
        imgFile != null ||
        video != null) {
      try {
        String message = _messageController.text;
        if (imgFile != null) {
          // Upload image and get its URL
          await uploadImage();
          // Clear the text message if an image is sent
          message = '';
        } else if (video != null) {
          await uploadVideo();
          message = '';
        }
        if (message.isNotEmpty) {
          await _chatService.sendMessage(widget.receiverId, message);
        }
        setState(() {
          imgFile = null; // Reset the image after sending
          _messageController.clear();
          video = null; // Reset the video after sending
        });
        _onMessageChanged(); // Update button state
      } on FirebaseException catch (e) {
        if (kDebugMode) {
          print("FirebaseException: ${e.code}");
          print("Error message: ${e.message}");
          print("Stack trace: ${e.stackTrace}");
        }
      } catch (e, stackTrace) {
        if (kDebugMode) {
          print("Error sending message: $e");
          print("Stack trace: $stackTrace");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xffEAE4DD),
      appBar: AppBar(
        backgroundColor: const Color(0xff304a62),
        title: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('User_chat') // Access the 'User_chat' collection
              .snapshots(),  // Listen to the changes in the collection
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...', style: TextStyle(color: Colors.white));
            }

            if (snapshot.hasError) {
              return const Text('Error loading data', style: TextStyle(color: Colors.white));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No users found', style: TextStyle(color: Colors.white));
            }

            // Find the user document with the matching user_id
            final matchingDoc = snapshot.data!.docs.firstWhere(
                  (doc) => doc['user_id'] == widget.receiverId,
               // Return null if no matching document is found
            );

            if (matchingDoc == null) {
              return const Text('User not found', style: TextStyle(color: Colors.white));
            }

            // Get the storeName from the matched document
            final storeName = matchingDoc['storeName'] as String?;

            // Capitalize the store name if it's not null or empty
            final capitalizedStoreName = storeName != null && storeName.isNotEmpty
                ? '${storeName[0].toUpperCase()}${storeName.substring(1)}'
                : 'Unknown';

            return Text(capitalizedStoreName, style: const TextStyle(color: Colors.white));
          },
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);  // Go back to the previous screen
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      )

      ,
        // AppBar(
      //   backgroundColor:const Color( 0xff304a62),
      //   title: StreamBuilder<DocumentSnapshot>(
      //     stream: FirebaseFirestore.instance
      //         .collection('User_chat')
      //         .doc(widget.receiverId)
      //         .snapshots(),
      //     builder: (context, snapshot) {
      //
      //       if (!snapshot.hasData || !snapshot.data!.exists) {
      //         return const Text('No occupation');
      //       }
      //
      //       final data = snapshot.data!.data() as Map<String, dynamic>;
      //       final occupation = data['storeName'] as String?;
      //       final capitalizedOccupation = occupation != null && occupation.isNotEmpty
      //           ? '${occupation[0].toUpperCase()}${occupation.substring(1)}'
      //           : 'Unknown';
      //
      //       return Text(capitalizedOccupation ?? 'Unknown',style:const TextStyle(color: Colors.white));
      //     },
      //   ),
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pushReplacement(context,
      //           MaterialPageRoute(builder: (_) => ChatUserAvailable()));
      //     },
      //     icon: const Icon(Icons.arrow_back,color: Colors.white,),
      //   ),
      // ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUserEmail()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessage(widget.receiverId, senderID),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<DocumentSnapshot> docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = docs[index];
                bool showDateHeader = index == 0 ||
                    _shouldShowDateHeader(docs[index], docs[index - 1]);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showDateHeader) _buildDateHeader(docs[index]),
                    _buildMessageItem(doc),
                  ],
                );
              },
            );
          }
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser =
        data['receiverId'] != FirebaseAuth.instance.currentUser!.uid;

    Timestamp timestamp = data['timestamp'] as Timestamp;
    String formattedTime = _formatTimestamp(timestamp);

    final alignment =
    isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isCurrentUser ? Colors.green : Colors.black54;
    final textColor = isCurrentUser ? Colors.white : Colors.white;
    final crossAlignment =
    isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    // Check if the message is a URL
    bool isImage = data['message'] != null &&
        (data['message'] as String).startsWith('http');
    bool isVideo = data['message'] != null &&
        (data['message'] as String).startsWith('https');

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: crossAlignment,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: isImage ?Colors.grey : color,
              boxShadow:const [BoxShadow(color: Colors.grey,spreadRadius: 1)],
              borderRadius: isCurrentUser
                  ? const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              )
                  : const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: isImage
                ?
            // isVideo ? VideoPlayer(_videoPlayerController)
            Image.network(
              data['message'],
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            )
                : Text(
              data['message'] ?? 'No message content',
              style: TextStyle(color: textColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formattedTime,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowDateHeader(
      DocumentSnapshot currentDoc, DocumentSnapshot previousDoc) {
    Timestamp currentTimestamp = currentDoc['timestamp'] as Timestamp;
    Timestamp previousTimestamp = previousDoc['timestamp'] as Timestamp;

    DateTime currentDate = currentTimestamp.toDate();
    DateTime previousDate = previousTimestamp.toDate();

    return currentDate.day != previousDate.day ||
        currentDate.month != previousDate.month ||
        currentDate.year != previousDate.year;
  }

  Widget _buildDateHeader(DocumentSnapshot doc) {
    Timestamp timestamp = doc['timestamp'] as Timestamp;
    DateTime date = timestamp.toDate();
    String formattedDate = _formatDate(date);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            formattedDate,
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.hour}:${dateTime.minute}';
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: imagePicker,
          ),
          Expanded(
            child: Container(
              constraints:const BoxConstraints(
                maxHeight: 70, // Set a fixed height to prevent the TextField from growing indefinitely
              ),
              child: SingleChildScrollView(
                reverse: true, // Ensures the scroll starts from the bottom as you type
                child: TextField(
                  controller: _messageController, // Manage the text with a controller
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // Allows the TextField to take multiple lines
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Type your message here...',
                    contentPadding:const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                  style:const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  cursorColor: Colors.blue,
                ),
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.send),
            color: _isButtonEnabled ? Colors.blue : Colors.grey,
            onPressed: _isButtonEnabled ? senderMessage : null,
          ),
        ],
      ),
    );
  }
}
