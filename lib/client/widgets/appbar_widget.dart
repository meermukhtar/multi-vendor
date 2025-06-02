import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class AppbarWidget extends StatefulWidget {
  String title;
  IconData iconData;
  IconData icons;
  final bool showPopButton;
  final VoidCallback? actionCallback;
  AppbarWidget(
      {super.key,
        required this.title,
        required this.iconData,
        this.showPopButton = true,
        required this.icons,
        this.actionCallback});

  @override
  State<AppbarWidget> createState() => _AppbarWidgetState();
}

class _AppbarWidgetState extends State<AppbarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color( 0xff304a62),
      automaticallyImplyLeading: false,
      title: Text(
        widget.title,
        style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      leading: widget.showPopButton
          ? IconButton(
        onPressed: () {
          widget.actionCallback;
        },
        icon: Icon(widget.iconData),
      )
          : null,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
      ),

    );
  }
}
