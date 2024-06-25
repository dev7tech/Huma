import 'package:flutter/material.dart';

class SelectedMenuItemProvider extends ChangeNotifier {
  String _selectedMenuItem = 'Dash';

  String get selectedMenuItem => _selectedMenuItem;

  void setSelectedMenuItem(String menuItem) {
    _selectedMenuItem = menuItem;
    notifyListeners();
  }
}
