import 'package:flutter/material.dart';
import 'package:hookup4u_admin/dashboard/components/widgets/user_search_field.dart';

class CustomAppbarSecond extends StatelessWidget {
  final String text;
  final VoidCallback prefixtap;
  final VoidCallback sufixtap;
  final TextEditingController searchcontroller;
  final Function(String) submittap;
  final bool isIconShow;
  const CustomAppbarSecond(
      {Key? key,
      required this.text,
      required this.prefixtap,
      required this.sufixtap,
      required this.searchcontroller,
      required this.submittap,
      required this.isIconShow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // if (!Responsive.isDesktop(context))
        //   IconButton(
        //     onPressed: context.read<DrawersController>().controlMenu,
        //     icon: Icon(
        //       Icons.menu,
        //       color: textColor.withOpacity(0.5),
        //     ),
        //   ),
        Expanded(
            child: UserSearchField(
          hintText: text,
          prefixtap: prefixtap,
          sufixtap: sufixtap,
          isIconShow: isIconShow,
          submittap: submittap,
          searchcontroller: searchcontroller,
        )),
      ],
    );
  }
}
