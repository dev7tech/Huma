import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../providers/selected_item_provider.dart';

class SearchField extends StatefulWidget {
  final String hintText;
  const SearchField({Key? key, required this.hintText}) : super(key: key);

  @override
  SearchFieldState createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  TextEditingController textEditingController = TextEditingController();

  void _handleSearchTextChanged(String searchText) {
    final lowerCaseSearchText = searchText.toLowerCase();

    if (lowerCaseSearchText.contains('report') ||
        lowerCaseSearchText.contains('rep') ||
        lowerCaseSearchText.startsWith('r') ||
        lowerCaseSearchText.startsWith('R')) {
      // Navigate to the "ReportPage"
      Provider.of<SelectedMenuItemProvider>(context, listen: false)
          .setSelectedMenuItem('Reportuser');
    } else if (lowerCaseSearchText.contains('users') ||
        lowerCaseSearchText.contains('us') ||
        lowerCaseSearchText.startsWith('u') ||
        lowerCaseSearchText.startsWith('U')) {
      // Navigate to the "UsersPage"
      Provider.of<SelectedMenuItemProvider>(context, listen: false)
          .setSelectedMenuItem('Users');
    } else if (lowerCaseSearchText.contains('password') ||
        lowerCaseSearchText.contains('change') ||
        lowerCaseSearchText.startsWith('c') ||
        lowerCaseSearchText.startsWith('p')) {
      // Navigate to the "UsersPage"
      Provider.of<SelectedMenuItemProvider>(context, listen: false)
          .setSelectedMenuItem('Changepassword');
    } else if (lowerCaseSearchText.contains('setting') ||
        lowerCaseSearchText.startsWith('se') ||
        lowerCaseSearchText.endsWith('g')) {
      // Navigate to the "UsersPage"
      Provider.of<SelectedMenuItemProvider>(context, listen: false)
          .setSelectedMenuItem('Settings');
    } else if (lowerCaseSearchText.contains('package') ||
        lowerCaseSearchText.startsWith('pac')) {
      // Navigate to the "UsersPage"
      Provider.of<SelectedMenuItemProvider>(context, listen: false)
          .setSelectedMenuItem('Packages');
    } else if (lowerCaseSearchText.contains('subscription') ||
        lowerCaseSearchText.startsWith('sub')) {
      // Navigate to the "UsersPage"
      Provider.of<SelectedMenuItemProvider>(context, listen: false)
          .setSelectedMenuItem('SubscriptionSettings');
    } else {
      // Handling the case when no match is found
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid Search"),
          content: const Text(
              "Please search by correct action like reported ,users,package,settings,change password,subscription etc"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "OK",
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _handleSearchSubmitted(String searchText) {
    // Call the search handler when the user submits the text
    _handleSearchTextChanged(searchText);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      onSubmitted:
          _handleSearchSubmitted, // Redirect when user completes typing
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
        prefixIcon: Icon(
          Icons.search,
          color: textColor.withOpacity(0.5),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.clear();
    textEditingController.dispose();

    super.dispose();
  }
}
