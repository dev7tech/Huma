import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  showError(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
  }
}
