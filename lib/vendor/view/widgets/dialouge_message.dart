import 'package:flutter/cupertino.dart';

class DialogMessageWidget extends StatelessWidget {
  String title;
  String finalMessage;
  DialogMessageWidget({super.key,required this.title,required this.finalMessage});

  @override
  Widget build(BuildContext context) {

    return CupertinoAlertDialog(
      title: Text(title),
      actions: [
        CupertinoDialogAction(onPressed: (){
          Navigator.of(context).pop();
        }, child: const Text("Back")),
        CupertinoDialogAction(onPressed: (){
        }, child: const Text("Next")),
      ],
      content:  Text(finalMessage),
    );
  }
}
