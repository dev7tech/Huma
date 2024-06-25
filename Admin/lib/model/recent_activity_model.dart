// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:hookup4u_admin/model/user_model.dart';

class RecentActivityModel {
  String userId;
  String userName;
  String imageUrl;
  String timestamp;
  String activity;
  User userIndex;

  RecentActivityModel({
    required this.userId,
    required this.userName,
    required this.imageUrl,
    required this.timestamp,
    required this.userIndex,
    required this.activity,
  });
}
