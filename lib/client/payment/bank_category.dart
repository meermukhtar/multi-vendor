import 'package:flutter/material.dart';

class BankCategory extends StatefulWidget {
  final String title;
  final VoidCallback press;
  final String imagePath;
  final bool isSelected; // New property to track selection state

  const BankCategory({
    Key? key,
    required this.title,
    required this.press,
    required this.imagePath,
    required this.isSelected, // Pass isSelected as a parameter
  }) : super(key: key);

  @override
  State<BankCategory> createState() => _BankCategoryState();
}

class _BankCategoryState extends State<BankCategory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: widget.press,
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(100),
          color: widget.isSelected ? Color(0xff234F68) : Colors.white, // Change color based on isSelected
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Image.asset(
                    widget.imagePath,
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.isSelected ? Colors.white : Colors.black, // Change text color based on isSelected
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}