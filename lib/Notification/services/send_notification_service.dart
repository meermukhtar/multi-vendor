import 'dart:convert';

import 'package:multivendor/Notification/services/get_service_key.dart';
import 'package:http/http.dart' as http;
class SendNotification{
  static Future<void> sendNotification({required String ?token,required String ?title,required String ? body,
    required Map<String,dynamic>? data
  }) async {
    String serverKey=await GetServerKey().getServerKeyToken();
    String url="https://fcm.googleapis.com/v1/projects/login-form-97707/messages:send";
    var header=<String,String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey'
    };
    Map<String,dynamic> message={

        "message":{
          "token":token,
         // "token":"e6LQJOHTRlGSlgo9J8raVV:APA91bGWSpwP-Xt-DfkMuXrwrqyZR5uR_f1G0sg0TdDwrY8PaNd89e29pw_TVvpUlI9NVHv2ui6lBjy3devQ99OO8ORfIqrWCH4Admz5l84sHrImrZ2Tn_4",
          "notification":{
           // "body":"Body of the fcm notification",
            //"title":"FCM"
            "body":body,
            "title":title
          },
          "data":data
        }
    };
    //hti api
    final http.Response response=await http.post(
    Uri.parse(url),headers: header,body: jsonEncode(message),
    );
    if(response.statusCode==200){
      print("notification send successfully");
    }
    else{
      print("notification not send ");
    }
  }
}