
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_user_available.dart';


class FloatingChatingButton extends StatelessWidget {
  const FloatingChatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return
      FloatingActionButton(
        onPressed: () async {
          Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>  ChatUserAvailable(),
                      transitionDuration: Duration.zero, // No animation
                    ),
                  );
        },
        backgroundColor: const Color(0xffEAE4DD),
        shape: const CircleBorder(),
        elevation: 10,
        child: const ClipOval(
          child: SizedBox(
            child: Image(
             image: AssetImage("assets/images/chat.png"),width: 50,height: 50
              // color: Colors.white,
              // size: 30,
            ),
          ),
        ),
      );

  }
}
