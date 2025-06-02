import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Add padding around the search bar
      // padding: const EdgeInsets.symmetric(horizontal: 8.0),
      // Use a Material design search bar
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon:const Icon(Icons.search, color: Colors.black),
          hintText: 'Search...',
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black), // Set border color here
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
