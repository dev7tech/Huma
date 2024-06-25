import 'package:flutter/material.dart';
import 'package:hookup4u_admin/constants/constants.dart';

class CapitalizedAvatar extends StatelessWidget {
  final String displayName;
  final String imageUrl;
  final double radius;
  final bool googleUser;

  const CapitalizedAvatar(
      {super.key,
      required this.displayName,
      this.radius = 20.0,
      required this.googleUser,
      required this.imageUrl});

  String getFirstName(String fullName) {
    final names = fullName.split(' ');
    if (names.isNotEmpty) {
      return names[0][0];
    } else {
      // by default returning Admin first letter
      return 'A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstName = getFirstName(displayName);
    return CircleAvatar(
      radius: radius,
      backgroundColor: googleUser ? transparent : primaryColor.withOpacity(0.7),
      child: googleUser
          ? ClipRRect(
              borderRadius: BorderRadius.circular(38),
              child: Image.network(
                imageUrl,
                height: 35,
                width: 35,
                fit: BoxFit.cover,
              ),
            )
          : Text(
              firstName.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: radius * 0.9,
              ),
            ),
    );
  }
}
