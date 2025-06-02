import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../vendor/view/themes/colors.dart';


class HomePageCards extends StatefulWidget {
  final String cardName;
  final IconData cardIcon;
  final IconData cardIconButton;
  final String cartTotalProduct;
  final VoidCallback myCallback;

  HomePageCards(
      {Key? key,
        required this.cardName,
        required this.cardIcon,
        required this.cardIconButton,
        required this.cartTotalProduct,
        required this.myCallback})
      : super(key: key);

  @override
  State<HomePageCards> createState() => _HomePageCardsState();
}

class _HomePageCardsState extends State<HomePageCards> {
  final ColorsList colorsList = ColorsList();
  final TextStyling style = TextStyling();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.myCallback,
        child: Container(
          height: MediaQuery.of(context).size.height * .31,
          width: MediaQuery.of(context).size.width * .43,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black54,width: 2), // border corner radius
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // color of shadow
                spreadRadius: 2, // spread radius
                blurRadius: 27, // blur radius
              ),
              // you can set more BoxShadow() here
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    //   widget.myCallback;
                  },
                  icon: Icon(
                    widget.cardIcon,
                    color: colorsList.iconsColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Icon(
                widget.cardIconButton,
                color: colorsList.iconsColor,
                size: 40,
              ),
              Text(
                widget.cardName,
                style: style.headingTextStyle,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(widget.cartTotalProduct, style: style.textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
