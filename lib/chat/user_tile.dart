import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              color: Colors.white,
            ),
            const SizedBox(width: 20), // Space between the icon and the text
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ), // Takes up available space
            ),
            const SizedBox(
                width: 20), // Space between the text and the message icon
            const Icon(Icons.message, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
