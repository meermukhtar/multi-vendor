import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:multivendor/client/pages/shopping_screen.dart';

import '../widgets/simple_elevated_button.dart';
import 'home_page.dart';

class ClientReview extends StatefulWidget {
  const ClientReview({Key? key}) : super(key: key);

  @override
  _ClientReviewState createState() => _ClientReviewState();
}

class _ClientReviewState extends State<ClientReview> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 0.0;
  TextEditingController _feedbackController = TextEditingController();

  // Function to handle feedback submission
  void _submitFeedback() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Show Cupertino dialog for confirmation
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Submit Review"),
            content: const Text("Are you sure you want to submit your review?"),
            actions: [
              CupertinoDialogAction(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              CupertinoDialogAction(
                child: const Text("Submit"),
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  await _saveReviewToFirebase();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Function to save review to Firestore
  Future<void> _saveReviewToFirebase() async {
    try {
      // Get current user ID (ensure user is authenticated)
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If user is not logged in, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("You must be logged in to submit a review")),
        );
        return;
      }

      final reviewData = {
        'uid': user.uid,
        'rating': _rating,
        'feedback': _feedbackController.text,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save review data in the "reviews" collection in Firestore
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(user.uid)
          .set(reviewData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for submitting your review!')),
      );

      // Clear the form
      _feedbackController.clear();
      setState(() {
        _rating = 0.0;
      });
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAE4DD),
      appBar: AppBar(
        title: const Text(
          "Leave a Review",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff304a62),
        leading: IconButton(onPressed:() {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const ShoppingCartScreen()));
        },icon:const Icon(Icons.arrow_back_outlined,color: Colors.white,),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "How would you rate your experience?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Star rating widget
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 40.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 20),

              // Feedback text field
              const Text(
                "Share your feedback:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Write your feedback here...",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Feedback cannot be empty'),
                  MinLengthValidator(10,
                      errorText:
                      'Feedback must be at least 10 characters long'),
                ]).call,
              ),
              const SizedBox(height: 20),

              // Submit button
              Center(
                  child:
                  SimpleElevatedButtonWidget(title: 'Submit Feedback', color:Color(0xff304a62), textColor: Colors.white ,callback: _submitFeedback,)
                // ElevatedButton(
                //   onPressed: _submitFeedback,
                //   child: const Text("Submit Feedback"),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
