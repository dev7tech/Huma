import 'package:flutter/material.dart';
import 'package:hookup4u_admin/constants/constants.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key,
      required this.title,
      required this.icon,
      required this.tap,
      required this.isSelected})
      : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback tap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tap,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        color: primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? primaryColor : textColor),
      ),
    );
  }
}
