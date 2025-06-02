import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimpleElevatedButtonWidget extends StatefulWidget {
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback callback;
  const SimpleElevatedButtonWidget(
      {super.key,
        required this.title,
        required this.color,
        required this.textColor,
        required this.callback});

  @override
  State<SimpleElevatedButtonWidget> createState() =>
      _SimpleElevatedButtonWidgetState();
}

class _SimpleElevatedButtonWidgetState
    extends State<SimpleElevatedButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle button press
        widget.callback();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners with radius of 10
        ),
        minimumSize: Size(MediaQuery.of(context).size.width*4, 48), // Set the horizontal length and height of the button
      ),
      child: Text(
        widget.title,
        style: TextStyle(
          color: widget.textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
