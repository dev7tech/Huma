// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:hookup4u_admin/constants/constants.dart';

import '../../../constants/responsive.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _isSending = false;

  Future<void> _sendMessageToAllUsers(BuildContext context) async {
    final String message = _messageController.text.toString();
    final String title = _titleController.text.toString();
    if (message.trim().isEmpty || title.trim().isEmpty) {
      // If the message is empty or contains only spaces, show an error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Please enter a valid message."),
          actions: [
            ElevatedButton(
               style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Okay",
               
              ),
            ),
          ],
        ),
      );
      return;
    }

    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendNotificationToAllUsers');

    try {
      await callable.call({"message": message, "title": title});
      Navigator.pop(context);

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Notification Sent"),
          content: const Text("Notification sent successfully to all users."),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint("Error sending notification: $e");
      // Handle the error and show an error dialog if necessary
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Notification Error"),
          content: Text(e.toString()),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SizedBox(
        width: Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.width * 0.35
            : MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Push Notification",
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  Text(
                    "Broadcast messages to all users.",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: textColor.withOpacity(0.5)),
                  ),
                  Card(
                    margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                    elevation: 8,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      controller: _titleController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.title,
                            color: Colors.black26,
                          ),
                          hintText: "Enter notification title here",
                          hintStyle: TextStyle(color: Colors.black26),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16.0)),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                    elevation: 8,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      controller: _messageController,
                      maxLines: 4,
                      minLines: 1,
                      maxLength: 300,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.black26,
                        ),
                        hintText: "Enter notification text here",
                        hintStyle: TextStyle(color: Colors.black26),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      const SizedBox(width: 30.0),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor),
                        ),
                        onPressed: _isSending
                            ? null // Disable button while sending
                            : () async {
                                setState(() {
                                  _isSending = true;
                                });
                                await _sendMessageToAllUsers(context);
                                setState(() {
                                  _isSending = false;
                                });
                              },
                        child: Text(
                          _isSending ? "Sending.." : "Send",
                          style: TextStyle(color: secondryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
