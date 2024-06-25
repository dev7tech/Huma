import 'dart:io';

class Message {
  String senderName, senderId, selectedUserId, text, photoUrl;
  File photo;
  dynamic timestamp;

  Message({
    required this.senderName,
    required this.senderId,
    required this.selectedUserId,
    required this.text,
    required this.photoUrl,
    required this.photo,
    required this.timestamp,
  });
}
