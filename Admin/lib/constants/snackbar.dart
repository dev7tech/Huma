import 'package:flutter/material.dart';

snackbar(
    String text,
    //GlobalKey<ScaffoldState> _scaffoldKey,
    BuildContext context) {
  final snackBar = SnackBar(
    backgroundColor: const Color(0xffff3a5a),
    content: Text('$text '),
    duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
