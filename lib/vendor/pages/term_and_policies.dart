import 'package:flutter/material.dart';
import 'package:multivendor/vendor/view/screen/dashbord.dart';
class TermAndPolicies extends StatefulWidget {
  const TermAndPolicies({super.key});

  @override
  State<TermAndPolicies> createState() => _TermAndPoliciesState();
}

class _TermAndPoliciesState extends State<TermAndPolicies> {
  @override
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: const Color(0xffEAE4DD),
      appBar: AppBar(
        title:const Text('Terms & Conditions',
          style: TextStyle(color: Colors.white),),
        backgroundColor:  Color(0xff304a62),
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>DashBoardScreen()));
        },icon:const Icon(Icons.arrow_back,color: Colors.white,),),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [Colors.teal.shade200, Colors.white],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            // Terms and Conditions Text
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  "Please read these terms and conditions carefully before using our application. By agreeing to these terms, you accept that:\n\n"
                      "1. You are solely responsible for maintaining the confidentiality of your account.\n"
                      "2. Unauthorized use of the app is strictly prohibited.\n"
                      "3. All transactions must comply with applicable laws and regulations.\n"
                      "4. We reserve the right to modify these terms at any time.\n\n"
                      "5. You agree to use the application only for lawful purposes and in compliance with all relevant local, state, and international laws. Unauthorized use of the app, including fraudulent activities, hacking, or any actions that compromise the security and functionality of the app, is strictly prohibited.\n\n"
                      "6. We value your privacy and are committed to protecting your personal data. By using our application, you consent to the collection, processing, and storage of your personal information in accordance with our Privacy Policy. Please review the Privacy Policy for details on how we handle your data.\n\n"
                      "7. To the fullest extent permitted by law, [Company Name] is not responsible for any direct, indirect, incidental, or consequential damages resulting from your use of the app, including but not limited to data loss, service interruptions, or financial loss.\n\n"
                      "8. We reserve the right to suspend or terminate your access to the application at our discretion if we believe you have violated any of these terms or if there is any misuse of the application.\n\n"
                      "If you do not agree to these terms, you may not use the application.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    height: 1.8,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.justify,
                )
              ),
            ),
            const SizedBox(height: 10),

            // Checkbox

            Row(
              children: [
                Checkbox(
                  activeColor: Colors.teal,
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'I have read and agree to the terms and conditions.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Buttons
            Row(
              children: [
                // Disagree Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isChecked ? Colors.grey:Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Action Denied'),
                          content: const Text(
                            'You must agree to the terms and conditions to use the application.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Disagree',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Agree Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: _isChecked
                        ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'You have agreed to the terms and conditions!',
                          ),
                        ),
                      );
                    }
                        : null,
                    child: const Text(
                      'Agree',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Checkbox


          ],
        ),
      ),
    );
  }
}
