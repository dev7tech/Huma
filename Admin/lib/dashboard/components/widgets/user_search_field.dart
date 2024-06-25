import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class UserSearchField extends StatefulWidget {
  final String hintText;
  final VoidCallback prefixtap;
  final VoidCallback sufixtap;
  final TextEditingController searchcontroller;
  final Function(String) submittap;
  final bool isIconShow;
  const UserSearchField(
      {Key? key,
      required this.hintText,
      required this.prefixtap,
      required this.sufixtap,
      required this.submittap,
      required this.searchcontroller,
      required this.isIconShow})
      : super(key: key);

  @override
  UserSearchFieldState createState() => UserSearchFieldState();
}

class UserSearchFieldState extends State<UserSearchField> {
  @override
  Widget build(BuildContext context) {
    return widget.isIconShow
        ? TextFormField(
            controller: widget.searchcontroller,
            onFieldSubmitted: widget.submittap,
            // Redirect when user completes typing
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
                hintText: widget.hintText,
                helperStyle: TextStyle(
                  color: textColor.withOpacity(0.5),
                  fontSize: 15,
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: IconButton(
                    color: textColor.withOpacity(0.5),
                    icon: const Icon(Icons.search),
                    onPressed: widget.prefixtap),
                suffixIcon: IconButton(
                    color: textColor.withOpacity(0.5),
                    icon: const Icon(Icons.clear),
                    onPressed: widget.sufixtap)),
          )
        : Card(
            elevation: 0,
            color: bgColor.withOpacity(0.7),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  widget.hintText,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    widget.searchcontroller.clear();
    widget.searchcontroller.dispose();

    super.dispose();
  }
}
