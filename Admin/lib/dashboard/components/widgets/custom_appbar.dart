import 'package:flutter/material.dart';
import 'package:hookup4u_admin/dashboard/components/profile_info.dart';
import 'package:hookup4u_admin/dashboard/components/search_field.dart';

class CustomAppbar extends StatelessWidget {
  final String text;
  const CustomAppbar({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // if (!Responsive.isDesktop(context))
        // IconButton(
        //   onPressed: context.read<DrawersController>().controlMenu,
        //   icon: Icon(
        //     Icons.menu,
        //     color: textColor.withOpacity(0.5),
        //   ),
        // ),
        Expanded(child: SearchField(hintText: text)),
        const ProfileInfo()
      ],
    );
  }
}
